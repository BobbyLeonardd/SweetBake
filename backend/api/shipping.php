<?php
include_once '../config/database.php';

$database = new Database();
$db = $database->getConnection();

$method = $_SERVER['REQUEST_METHOD'];

if ($method == 'GET') {
    if (isset($_GET['city'])) {
        $city = $_GET['city'];
        $query = "SELECT * FROM shipping_costs WHERE city = :city";
        $stmt = $db->prepare($query);
        $stmt->bindParam(":city", $city);
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
                "message" => "Shipping cost not found for this city"
            ]);
        }
    } else {
        $query = "SELECT * FROM shipping_costs ORDER BY city ASC";
        $stmt = $db->prepare($query);
        $stmt->execute();
        
        $shipping = $stmt->fetchAll(PDO::FETCH_ASSOC);
        echo json_encode([
            "success" => true,
            "data" => $shipping
        ]);
    }
}

if ($method == 'POST') {
    $data = json_decode(file_get_contents("php://input"));
    
    $query = "INSERT INTO shipping_costs (city, cost, estimated_days) 
              VALUES (:city, :cost, :estimated_days)";
    $stmt = $db->prepare($query);
    
    $stmt->bindParam(":city", $data->city);
    $stmt->bindParam(":cost", $data->cost);
    $stmt->bindParam(":estimated_days", $data->estimated_days);
    
    if ($stmt->execute()) {
        echo json_encode([
            "success" => true,
            "message" => "Shipping cost created successfully"
        ]);
    } else {
        echo json_encode([
            "success" => false,
            "message" => "Failed to create shipping cost"
        ]);
    }
}

if ($method == 'PUT') {
    $data = json_decode(file_get_contents("php://input"));
    
    $query = "UPDATE shipping_costs SET 
              city = :city,
              cost = :cost,
              estimated_days = :estimated_days
              WHERE id = :id";
    $stmt = $db->prepare($query);
    
    $stmt->bindParam(":id", $data->id);
    $stmt->bindParam(":city", $data->city);
    $stmt->bindParam(":cost", $data->cost);
    $stmt->bindParam(":estimated_days", $data->estimated_days);
    
    if ($stmt->execute()) {
        echo json_encode([
            "success" => true,
            "message" => "Shipping cost updated successfully"
        ]);
    } else {
        echo json_encode([
            "success" => false,
            "message" => "Failed to update shipping cost"
        ]);
    }
}

if ($method == 'DELETE') {
    $id = $_GET['id'] ?? null;
    
    if ($id) {
        $query = "DELETE FROM shipping_costs WHERE id = :id";
        $stmt = $db->prepare($query);
        $stmt->bindParam(":id", $id);
        
        if ($stmt->execute()) {
            echo json_encode([
                "success" => true,
                "message" => "Shipping cost deleted successfully"
            ]);
        } else {
            echo json_encode([
                "success" => false,
                "message" => "Failed to delete shipping cost"
            ]);
        }
    }
}
?>
