<?php
include_once '../config/database.php';

$database = new Database();
$db = $database->getConnection();

$method = $_SERVER['REQUEST_METHOD'];
$data = json_decode(file_get_contents("php://input"));

if ($method == 'GET') {
    $id = isset($_GET['id']) ? $_GET['id'] : null;

    if ($id) {
        $query = "SELECT id, name, email, phone, address, role, created_at FROM users WHERE id = :id AND role = 'customer'";
        $stmt = $db->prepare($query);
        $stmt->bindParam(':id', $id);
        $stmt->execute();
        
        if ($stmt->rowCount() > 0) {
            $row = $stmt->fetch(PDO::FETCH_ASSOC);
            echo json_encode(["success" => true, "data" => $row]);
        } else {
            echo json_encode(["success" => false, "message" => "Customer not found"]);
        }
    } else {
        $query = "SELECT id, name, email, phone, address, role, created_at FROM users WHERE role = 'customer' ORDER BY id DESC";
        $stmt = $db->prepare($query);
        $stmt->execute();
        
        $users = [];
        while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
            $users[] = $row;
        }
        
        echo json_encode(["success" => true, "data" => $users]);
    }
}

if ($method == 'PUT') {
    if (isset($data->id)) {
        $query = "UPDATE users SET 
                  name = :name, 
                  email = :email, 
                  phone = :phone, 
                  address = :address 
                  WHERE id = :id AND role = 'customer'";
        
        $stmt = $db->prepare($query);
        
        $stmt->bindParam(":id", $data->id);
        $stmt->bindParam(":name", $data->name);
        $stmt->bindParam(":email", $data->email);
        $stmt->bindParam(":phone", $data->phone);
        $stmt->bindParam(":address", $data->address);
        
        if ($stmt->execute()) {
            echo json_encode(["success" => true, "message" => "Customer updated successfully"]);
        } else {
            echo json_encode(["success" => false, "message" => "Failed to update customer"]);
        }
    } else {
        echo json_encode(["success" => false, "message" => "Customer ID is required"]);
    }
}

if ($method == 'DELETE') {
    $id = isset($_GET['id']) ? $_GET['id'] : null;
    
    if ($id) {
        $query = "DELETE FROM users WHERE id = :id AND role = 'customer'";
        $stmt = $db->prepare($query);
        $stmt->bindParam(":id", $id);
        
        try {
            if ($stmt->execute()) {
                echo json_encode(["success" => true, "message" => "Customer deleted successfully"]);
            } else {
                echo json_encode(["success" => false, "message" => "Failed to delete customer"]);
            }
        } catch (PDOException $e) {
            echo json_encode(["success" => false, "message" => "Failed to delete customer. They might have active orders.", "error" => $e->getMessage()]);
        }
    } else {
        echo json_encode(["success" => false, "message" => "Customer ID is required"]);
    }
}
?>
