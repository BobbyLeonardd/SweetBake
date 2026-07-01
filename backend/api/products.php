<?php
include_once '../config/database.php';

$database = new Database();
$db = $database->getConnection();

$method = $_SERVER['REQUEST_METHOD'];

if ($method == 'GET') {
    if (isset($_GET['id'])) {
        $id = $_GET['id'];
        $query = "SELECT p.*, c.name as category_name 
                  FROM products p 
                  LEFT JOIN categories c ON p.category_id = c.id 
                  WHERE p.id = :id";
        $stmt = $db->prepare($query);
        $stmt->bindParam(":id", $id);
        $stmt->execute();
        
        if ($stmt->rowCount() > 0) {
            $row = $stmt->fetch(PDO::FETCH_ASSOC);
            echo json_encode([
                "success" => true,
                "data" => $row
            ]);
        } else {
            echo json_encode([
                "success" => false,
                "message" => "Product not found"
            ]);
        }
    } else {
        $query = "SELECT p.*, c.name as category_name 
                  FROM products p 
                  LEFT JOIN categories c ON p.category_id = c.id 
                  ORDER BY p.created_at DESC";
        $stmt = $db->prepare($query);
        $stmt->execute();
        
        $products = $stmt->fetchAll(PDO::FETCH_ASSOC);
        echo json_encode([
            "success" => true,
            "data" => $products
        ]);
    }
}

if ($method == 'POST') {
    $data = json_decode(file_get_contents("php://input"));
    
    $query = "INSERT INTO products (category_id, name, description, price, stock, image_url, is_available) 
              VALUES (:category_id, :name, :description, :price, :stock, :image_url, :is_available)";
    $stmt = $db->prepare($query);
    
    $stmt->bindParam(":category_id", $data->category_id);
    $stmt->bindParam(":name", $data->name);
    $stmt->bindParam(":description", $data->description);
    $stmt->bindParam(":price", $data->price);
    $stmt->bindParam(":stock", $data->stock);
    $stmt->bindParam(":image_url", $data->image_url);
    $stmt->bindParam(":is_available", $data->is_available);
    
    if ($stmt->execute()) {
        echo json_encode([
            "success" => true,
            "message" => "Product created successfully",
            "id" => $db->lastInsertId()
        ]);
    } else {
        echo json_encode([
            "success" => false,
            "message" => "Failed to create product"
        ]);
    }
}

if ($method == 'PUT') {
    $data = json_decode(file_get_contents("php://input"));
    
    $query = "UPDATE products SET 
              category_id = :category_id,
              name = :name,
              description = :description,
              price = :price,
              stock = :stock,
              image_url = :image_url,
              is_available = :is_available
              WHERE id = :id";
    $stmt = $db->prepare($query);
    
    $stmt->bindParam(":id", $data->id);
    $stmt->bindParam(":category_id", $data->category_id);
    $stmt->bindParam(":name", $data->name);
    $stmt->bindParam(":description", $data->description);
    $stmt->bindParam(":price", $data->price);
    $stmt->bindParam(":stock", $data->stock);
    $stmt->bindParam(":image_url", $data->image_url);
    $stmt->bindParam(":is_available", $data->is_available);
    
    if ($stmt->execute()) {
        echo json_encode([
            "success" => true,
            "message" => "Product updated successfully"
        ]);
    } else {
        echo json_encode([
            "success" => false,
            "message" => "Failed to update product"
        ]);
    }
}

if ($method == 'DELETE') {
    $id = $_GET['id'] ?? null;
    
    if ($id) {
        $query = "DELETE FROM products WHERE id = :id";
        $stmt = $db->prepare($query);
        $stmt->bindParam(":id", $id);
        
        if ($stmt->execute()) {
            echo json_encode([
                "success" => true,
                "message" => "Product deleted successfully"
            ]);
        } else {
            echo json_encode([
                "success" => false,
                "message" => "Failed to delete product"
            ]);
        }
    }
}
?>
