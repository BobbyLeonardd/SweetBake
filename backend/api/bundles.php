<?php
header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE');
header('Access-Control-Allow-Headers: Content-Type');

require_once '../config/database.php';

$database = new Database();
$db = $database->getConnection();

$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'OPTIONS') {
    http_response_code(200);
    exit();
}

try {
    switch ($method) {
        case 'GET':
            handleGet($db);
            break;
        case 'POST':
            handlePost($db);
            break;
        case 'PUT':
            handlePut($db);
            break;
        case 'DELETE':
            handleDelete($db);
            break;
        default:
            http_response_code(405);
            echo json_encode(['success' => false, 'message' => 'Method not allowed']);
    }
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => 'Server error: ' . $e->getMessage()]);
}

function handleGet($db) {
    $action = $_GET['action'] ?? null;
    
    if ($action === 'remove_item') {
        handleDelete($db);
        return;
    }
    
    if (isset($_GET['id'])) {
        $id = $_GET['id'];
        
        $query = "SELECT b.*, 
                  (SELECT COUNT(*) FROM bundle_items WHERE bundle_id = b.id) as item_count
                  FROM bundles b 
                  WHERE b.id = :id";
        
        $stmt = $db->prepare($query);
        $stmt->bindParam(':id', $id);
        $stmt->execute();
        
        $bundle = $stmt->fetch(PDO::FETCH_ASSOC);
        
        if ($bundle) {
            $itemQuery = "SELECT bi.*, p.name as product_name, p.image_url as product_image, p.price as product_price
                         FROM bundle_items bi
                         LEFT JOIN products p ON bi.product_id = p.id
                         WHERE bi.bundle_id = :bundle_id
                         ORDER BY bi.id";
            
            $itemStmt = $db->prepare($itemQuery);
            $itemStmt->bindParam(':bundle_id', $id);
            $itemStmt->execute();
            
            $bundle['items'] = $itemStmt->fetchAll(PDO::FETCH_ASSOC);
            
            echo json_encode(['success' => true, 'data' => $bundle]);
        } else {
            http_response_code(404);
            echo json_encode(['success' => false, 'message' => 'Bundle tidak ditemukan']);
        }
    } else {
        $query = "SELECT b.*, 
                  (SELECT COUNT(*) FROM bundle_items WHERE bundle_id = b.id) as item_count
                  FROM bundles b 
                  ORDER BY b.created_at DESC";
        
        $stmt = $db->prepare($query);
        $stmt->execute();
        
        $bundles = $stmt->fetchAll(PDO::FETCH_ASSOC);
        
        foreach ($bundles as &$bundle) {
            $itemQuery = "SELECT bi.*, p.name as product_name, p.image_url as product_image, p.price as product_price
                         FROM bundle_items bi
                         LEFT JOIN products p ON bi.product_id = p.id
                         WHERE bi.bundle_id = :bundle_id
                         ORDER BY bi.id";
            
            $itemStmt = $db->prepare($itemQuery);
            $itemStmt->bindParam(':bundle_id', $bundle['id']);
            $itemStmt->execute();
            
            $bundle['items'] = $itemStmt->fetchAll(PDO::FETCH_ASSOC);
        }
        
        echo json_encode(['success' => true, 'data' => $bundles]);
    }
}

function handlePost($db) {
    $action = $_GET['action'] ?? null;
    $data = json_decode(file_get_contents('php://input'), true);
    
    if ($action === 'add_item') {
        if (!isset($data['bundle_id']) || !isset($data['product_id']) || !isset($data['quantity'])) {
            http_response_code(400);
            echo json_encode(['success' => false, 'message' => 'Data tidak lengkap']);
            return;
        }
        
        $checkQuery = "SELECT id FROM bundle_items WHERE bundle_id = :bundle_id AND product_id = :product_id";
        $checkStmt = $db->prepare($checkQuery);
        $checkStmt->bindParam(':bundle_id', $data['bundle_id']);
        $checkStmt->bindParam(':product_id', $data['product_id']);
        $checkStmt->execute();
        
        if ($checkStmt->fetch()) {
            http_response_code(400);
            echo json_encode(['success' => false, 'message' => 'Produk sudah ada di bundle ini']);
            return;
        }
        
        $query = "INSERT INTO bundle_items (bundle_id, product_id, quantity) 
                  VALUES (:bundle_id, :product_id, :quantity)";
        
        $stmt = $db->prepare($query);
        $stmt->bindParam(':bundle_id', $data['bundle_id']);
        $stmt->bindParam(':product_id', $data['product_id']);
        $stmt->bindParam(':quantity', $data['quantity']);
        
        if ($stmt->execute()) {
            echo json_encode(['success' => true, 'message' => 'Produk berhasil ditambahkan ke bundle']);
        } else {
            http_response_code(500);
            echo json_encode(['success' => false, 'message' => 'Gagal menambahkan produk ke bundle']);
        }
    } else {
        if (!isset($data['name']) || !isset($data['original_price']) || !isset($data['promo_price'])) {
            http_response_code(400);
            echo json_encode(['success' => false, 'message' => 'Data tidak lengkap']);
            return;
        }
        
        $query = "INSERT INTO bundles (name, description, original_price, promo_price, image_url, is_available) 
                  VALUES (:name, :description, :original_price, :promo_price, :image_url, :is_available)";
        
        $stmt = $db->prepare($query);
        $stmt->bindParam(':name', $data['name']);
        $stmt->bindParam(':description', $data['description']);
        $stmt->bindParam(':original_price', $data['original_price']);
        $stmt->bindParam(':promo_price', $data['promo_price']);
        $stmt->bindParam(':image_url', $data['image_url']);
        $is_available = $data['is_available'] ?? 1;
        $stmt->bindParam(':is_available', $is_available);
        
        if ($stmt->execute()) {
            $bundle_id = $db->lastInsertId();
            echo json_encode([
                'success' => true, 
                'message' => 'Paket bundling berhasil ditambahkan',
                'data' => ['id' => $bundle_id]
            ]);
        } else {
            http_response_code(500);
            echo json_encode(['success' => false, 'message' => 'Gagal menambahkan paket bundling']);
        }
    }
}

function handlePut($db) {
    $data = json_decode(file_get_contents('php://input'), true);
    
    if (!isset($data['id'])) {
        http_response_code(400);
        echo json_encode(['success' => false, 'message' => 'ID bundle tidak ditemukan']);
        return;
    }
    
    $query = "UPDATE bundles SET 
              name = :name,
              description = :description,
              original_price = :original_price,
              promo_price = :promo_price,
              image_url = :image_url,
              is_available = :is_available
              WHERE id = :id";
    
    $stmt = $db->prepare($query);
    $stmt->bindParam(':id', $data['id']);
    $stmt->bindParam(':name', $data['name']);
    $stmt->bindParam(':description', $data['description']);
    $stmt->bindParam(':original_price', $data['original_price']);
    $stmt->bindParam(':promo_price', $data['promo_price']);
    $stmt->bindParam(':image_url', $data['image_url']);
    $is_available = $data['is_available'] ?? 1;
    $stmt->bindParam(':is_available', $is_available);
    
    if ($stmt->execute()) {
        echo json_encode(['success' => true, 'message' => 'Paket bundling berhasil diupdate']);
    } else {
        http_response_code(500);
        echo json_encode(['success' => false, 'message' => 'Gagal mengupdate paket bundling']);
    }
}

function handleDelete($db) {
    $action = $_GET['action'] ?? null;
    
    if ($action === 'remove_item') {
        if (!isset($_GET['item_id'])) {
            http_response_code(400);
            echo json_encode(['success' => false, 'message' => 'ID item tidak ditemukan']);
            return;
        }
        
        $query = "DELETE FROM bundle_items WHERE id = :id";
        $stmt = $db->prepare($query);
        $stmt->bindParam(':id', $_GET['item_id']);
        
        if ($stmt->execute()) {
            echo json_encode(['success' => true, 'message' => 'Produk berhasil dihapus dari bundle']);
        } else {
            http_response_code(500);
            echo json_encode(['success' => false, 'message' => 'Gagal menghapus produk dari bundle']);
        }
    } else {
        if (!isset($_GET['id'])) {
            http_response_code(400);
            echo json_encode(['success' => false, 'message' => 'ID bundle tidak ditemukan']);
            return;
        }
        
        $id = $_GET['id'];
        
        $deleteItemsQuery = "DELETE FROM bundle_items WHERE bundle_id = :id";
        $deleteItemsStmt = $db->prepare($deleteItemsQuery);
        $deleteItemsStmt->bindParam(':id', $id);
        $deleteItemsStmt->execute();
        
        $query = "DELETE FROM bundles WHERE id = :id";
        $stmt = $db->prepare($query);
        $stmt->bindParam(':id', $id);
        
        if ($stmt->execute()) {
            echo json_encode(['success' => true, 'message' => 'Paket bundling berhasil dihapus']);
        } else {
            http_response_code(500);
            echo json_encode(['success' => false, 'message' => 'Gagal menghapus paket bundling']);
        }
    }
}
?>
