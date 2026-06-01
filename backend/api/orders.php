<?php
include_once '../config/database.php';

$database = new Database();
$db = $database->getConnection();

$method = $_SERVER['REQUEST_METHOD'];

// get data pesanan
if ($method == 'GET') {
    if (isset($_GET['id'])) {
        // ambil order + items
        $id = $_GET['id'];
        $query = "SELECT o.*, u.name as customer_name, u.email as customer_email, u.phone as customer_phone
                  FROM orders o 
                  LEFT JOIN users u ON o.customer_id = u.id 
                  WHERE o.id = :id";
        $stmt = $db->prepare($query);
        $stmt->bindParam(":id", $id);
        $stmt->execute();
        
        if ($stmt->rowCount() > 0) {
            $order = $stmt->fetch(PDO::FETCH_ASSOC);
            
            $itemQuery = "SELECT oi.*, p.name as product_name, p.image_url 
                          FROM order_items oi 
                          LEFT JOIN products p ON oi.product_id = p.id 
                          WHERE oi.order_id = :order_id";
            $itemStmt = $db->prepare($itemQuery);
            $itemStmt->bindParam(":order_id", $id);
            $itemStmt->execute();
            $order['items'] = $itemStmt->fetchAll(PDO::FETCH_ASSOC);
            
            $trackQuery = "SELECT * FROM order_tracking WHERE order_id = :order_id ORDER BY created_at DESC";
            $trackStmt = $db->prepare($trackQuery);
            $trackStmt->bindParam(":order_id", $id);
            $trackStmt->execute();
            $order['tracking'] = $trackStmt->fetchAll(PDO::FETCH_ASSOC);
            
            echo json_encode([
                "success" => true,
                "data" => $order
            ]);
        } else {
            echo json_encode([
                "success" => false,
                "message" => "Order not found"
            ]);
        }
    } elseif (isset($_GET['customer_id'])) {
        // get order per customer
        $customer_id = $_GET['customer_id'];
        $query = "SELECT * FROM orders WHERE customer_id = :customer_id ORDER BY created_at DESC";
        $stmt = $db->prepare($query);
        $stmt->bindParam(":customer_id", $customer_id);
        $stmt->execute();
        
        $orders = $stmt->fetchAll(PDO::FETCH_ASSOC);
        echo json_encode([
            "success" => true,
            "data" => $orders
        ]);
    } else {
        // get semua order buat admin
        $query = "SELECT o.*, u.name as customer_name 
                  FROM orders o 
                  LEFT JOIN users u ON o.customer_id = u.id 
                  ORDER BY o.created_at DESC";
        $stmt = $db->prepare($query);
        $stmt->execute();
        
        $orders = $stmt->fetchAll(PDO::FETCH_ASSOC);
        echo json_encode([
            "success" => true,
            "data" => $orders
        ]);
    }
}

// buat pesanan baru
if ($method == 'POST') {
    $data = json_decode(file_get_contents("php://input"));
    
    try {
        $db->beginTransaction();
        
        // bikin nomor resi
        $orderNumber = 'SB' . date('Ymd') . rand(1000, 9999);
        
        $query = "INSERT INTO orders (customer_id, order_number, total_amount, shipping_cost, shipping_address, shipping_city, branch_id, branch_name, delivery_method, payment_method, notes) 
                  VALUES (:customer_id, :order_number, :total_amount, :shipping_cost, :shipping_address, :shipping_city, :branch_id, :branch_name, :delivery_method, :payment_method, :notes)";
        $stmt = $db->prepare($query);
        
        $stmt->bindParam(":customer_id", $data->customer_id);
        $stmt->bindParam(":order_number", $orderNumber);
        $stmt->bindParam(":total_amount", $data->total_amount);
        $stmt->bindParam(":shipping_cost", $data->shipping_cost);
        $stmt->bindParam(":shipping_address", $data->shipping_address);
        $stmt->bindParam(":shipping_city", $data->shipping_city);
        $branchId       = $data->branch_id      ?? null;
        $branchName     = $data->branch_name    ?? null;
        $deliveryMethod = $data->delivery_method ?? 'delivery';
        $paymentMethod  = $data->payment_method  ?? 'cash';
        $stmt->bindParam(":branch_id",       $branchId);
        $stmt->bindParam(":branch_name",     $branchName);
        $stmt->bindParam(":delivery_method", $deliveryMethod);
        $stmt->bindParam(":payment_method",  $paymentMethod);
        $stmt->bindParam(":notes", $data->notes);
        
        $stmt->execute();
        $orderId = $db->lastInsertId();
        
        foreach ($data->items as $item) {
            $itemType = isset($item->type) ? $item->type : 'product';

            if ($itemType === 'bundle') {
                // Expand bundle → ambil produk-produk dari bundle_items
                $bundleQty = (int)$item->quantity;
                $bundleQuery = "SELECT bi.product_id, bi.quantity AS item_qty, p.price AS product_price
                                FROM bundle_items bi
                                JOIN products p ON bi.product_id = p.id
                                WHERE bi.bundle_id = :bundle_id";
                $bStmt = $db->prepare($bundleQuery);
                $bStmt->bindParam(":bundle_id", $item->bundle_id);
                $bStmt->execute();
                $bundleProducts = $bStmt->fetchAll(PDO::FETCH_ASSOC);

                foreach ($bundleProducts as $bp) {
                    $actualQty     = (int)$bp['item_qty'] * $bundleQty;
                    $productPrice  = (float)$bp['product_price'];
                    $productSub    = $productPrice * $actualQty;
                    $productId     = (int)$bp['product_id'];

                    $iStmt = $db->prepare(
                        "INSERT INTO order_items (order_id, product_id, quantity, price, subtotal)
                         VALUES (:order_id, :product_id, :quantity, :price, :subtotal)"
                    );
                    $iStmt->bindParam(":order_id",   $orderId);
                    $iStmt->bindParam(":product_id", $productId);
                    $iStmt->bindParam(":quantity",   $actualQty);
                    $iStmt->bindParam(":price",      $productPrice);
                    $iStmt->bindParam(":subtotal",   $productSub);
                    $iStmt->execute();

                    // Kurangi stok setiap produk dalam bundle
                    $uStmt = $db->prepare(
                        "UPDATE products SET stock = stock - :qty WHERE id = :pid"
                    );
                    $uStmt->bindParam(":qty", $actualQty);
                    $uStmt->bindParam(":pid", $productId);
                    $uStmt->execute();
                }
            } else {
                // Produk biasa
                $itemQuery = "INSERT INTO order_items (order_id, product_id, quantity, price, subtotal) 
                              VALUES (:order_id, :product_id, :quantity, :price, :subtotal)";
                $itemStmt = $db->prepare($itemQuery);

                $itemStmt->bindParam(":order_id",   $orderId);
                $itemStmt->bindParam(":product_id", $item->product_id);
                $itemStmt->bindParam(":quantity",   $item->quantity);
                $itemStmt->bindParam(":price",      $item->price);
                $itemStmt->bindParam(":subtotal",   $item->subtotal);
                $itemStmt->execute();

                // Kurangi stok produk
                $updateStock = "UPDATE products SET stock = stock - :quantity WHERE id = :product_id";
                $updateStmt  = $db->prepare($updateStock);
                $updateStmt->bindParam(":quantity",   $item->quantity);
                $updateStmt->bindParam(":product_id", $item->product_id);
                $updateStmt->execute();
            }
        }
        
        $trackQuery = "INSERT INTO order_tracking (order_id, status, description) 
                       VALUES (:order_id, 'pending', 'Pesanan dibuat')";
        $trackStmt = $db->prepare($trackQuery);
        $trackStmt->bindParam(":order_id", $orderId);
        $trackStmt->execute();
        
        $db->commit();
        
        echo json_encode([
            "success" => true,
            "message" => "Order created successfully",
            "order_id" => $orderId,
            "order_number" => $orderNumber
        ]);
    } catch (Exception $e) {
        $db->rollBack();
        echo json_encode([
            "success" => false,
            "message" => "Failed to create order: " . $e->getMessage()
        ]);
    }
}

// update status order
if ($method == 'PUT') {
    $data = json_decode(file_get_contents("php://input"));
    
    try {
        $db->beginTransaction();

        $query = "UPDATE orders SET status = :status WHERE id = :id";
        $stmt = $db->prepare($query);
        
        $stmt->bindParam(":id", $data->id);
        $stmt->bindParam(":status", $data->status);
        
        if ($stmt->execute()) {
            $trackQuery = "INSERT INTO order_tracking (order_id, status, description) 
                           VALUES (:order_id, :status, :description)";
            $trackStmt = $db->prepare($trackQuery);
            $trackStmt->bindParam(":order_id", $data->id);
            $trackStmt->bindParam(":status", $data->status);
            $trackStmt->bindParam(":description", $data->description);
            $trackStmt->execute();

            // balikin stok kalo cancel
            if ($data->status === 'cancelled') {
                $itemQuery = "SELECT product_id, quantity FROM order_items WHERE order_id = :order_id";
                $itemStmt = $db->prepare($itemQuery);
                $itemStmt->bindParam(":order_id", $data->id);
                $itemStmt->execute();
                $items = $itemStmt->fetchAll(PDO::FETCH_ASSOC);

                foreach ($items as $item) {
                    $updateStock = "UPDATE products SET stock = stock + :quantity WHERE id = :product_id";
                    $updateStmt = $db->prepare($updateStock);
                    $updateStmt->bindParam(":quantity", $item['quantity']);
                    $updateStmt->bindParam(":product_id", $item['product_id']);
                    $updateStmt->execute();
                }
            }

            $db->commit();
            
            echo json_encode([
                "success" => true,
                "message" => "Order status updated successfully"
            ]);
        } else {
            $db->rollBack();
            echo json_encode([
                "success" => false,
                "message" => "Failed to update order status"
            ]);
        }
    } catch (Exception $e) {
        $db->rollBack();
        echo json_encode([
            "success" => false,
            "message" => "Failed to update order status: " . $e->getMessage()
        ]);
    }
}
?>
