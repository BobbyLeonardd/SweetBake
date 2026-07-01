<?php
include_once '../config/database.php';

$database = new Database();
$db = $database->getConnection();

$method = $_SERVER['REQUEST_METHOD'];
$data = json_decode(file_get_contents("php://input"));

if ($method == 'GET') {
    $query = "SELECT * FROM categories ORDER BY name ASC";
    $stmt = $db->prepare($query);
    $stmt->execute();
    
    $categories = $stmt->fetchAll(PDO::FETCH_ASSOC);
    echo json_encode([
        "success" => true,
        "data" => $categories
    ]);
}

if ($method == 'POST') {
    if (!empty($data->name)) {
        $query = "INSERT INTO categories (name, description) VALUES (:name, :description)";
        $stmt = $db->prepare($query);
        
        $stmt->bindParam(':name', $data->name);
        $desc = isset($data->description) ? $data->description : '';
        $stmt->bindParam(':description', $desc);
        
        if ($stmt->execute()) {
            echo json_encode(["success" => true, "message" => "Kategori berhasil ditambahkan."]);
        } else {
            echo json_encode(["success" => false, "message" => "Gagal menambahkan kategori."]);
        }
    } else {
        echo json_encode(["success" => false, "message" => "Nama kategori wajib diisi."]);
    }
}

if ($method == 'PUT') {
    if (!empty($data->id) && !empty($data->name)) {
        $query = "UPDATE categories SET name = :name, description = :description WHERE id = :id";
        $stmt = $db->prepare($query);
        
        $stmt->bindParam(':id', $data->id);
        $stmt->bindParam(':name', $data->name);
        $desc = isset($data->description) ? $data->description : '';
        $stmt->bindParam(':description', $desc);
        
        if ($stmt->execute()) {
            echo json_encode(["success" => true, "message" => "Kategori berhasil diubah."]);
        } else {
            echo json_encode(["success" => false, "message" => "Gagal mengubah kategori."]);
        }
    } else {
        echo json_encode(["success" => false, "message" => "ID dan Nama kategori wajib diisi."]);
    }
}

if ($method == 'DELETE') {
    $id = isset($_GET['id']) ? $_GET['id'] : null;
    
    if ($id) {
        $checkQuery = "SELECT id FROM products WHERE category_id = :id LIMIT 1";
        $checkStmt = $db->prepare($checkQuery);
        $checkStmt->bindParam(':id', $id);
        $checkStmt->execute();
        
        if ($checkStmt->rowCount() > 0) {
            echo json_encode(["success" => false, "message" => "Kategori tidak bisa dihapus karena masih ada produk di dalamnya."]);
            exit();
        }
        
        $query = "DELETE FROM categories WHERE id = :id";
        $stmt = $db->prepare($query);
        $stmt->bindParam(':id', $id);
        
        if ($stmt->execute()) {
            echo json_encode(["success" => true, "message" => "Kategori berhasil dihapus."]);
        } else {
            echo json_encode(["success" => false, "message" => "Gagal menghapus kategori."]);
        }
    } else {
        echo json_encode(["success" => false, "message" => "ID kategori tidak ditemukan."]);
    }
}
?>
