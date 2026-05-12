<?php
include_once '../config/database.php';

$database = new Database();
$db = $database->getConnection();

$method = $_SERVER['REQUEST_METHOD'];
$data = json_decode(file_get_contents("php://input"));

// GET - Get all categories
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

// POST - Create category
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

// PUT - Update category
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

// DELETE - Delete category
if ($method == 'DELETE') {
    $id = isset($_GET['id']) ? $_GET['id'] : null;
    
    if ($id) {
        // Pengecekan: Apakah kategori ini sedang dipakai oleh produk?
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
