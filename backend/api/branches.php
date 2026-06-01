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
            echo json_encode(['success' => false, 'message' => 'Method tidak diizinkan']);
    }
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => 'Server error: ' . $e->getMessage()]);
}

// GET - Ambil semua cabang atau satu cabang by ID
function handleGet($db) {
    if (isset($_GET['id'])) {
        $id = $_GET['id'];
        $stmt = $db->prepare("SELECT * FROM branches WHERE id = :id");
        $stmt->bindParam(':id', $id);
        $stmt->execute();
        $branch = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($branch) {
            echo json_encode(['success' => true, 'data' => $branch]);
        } else {
            http_response_code(404);
            echo json_encode(['success' => false, 'message' => 'Cabang tidak ditemukan']);
        }
    } else {
        $active = isset($_GET['active']) ? (int)$_GET['active'] : null;

        if ($active !== null) {
            $stmt = $db->prepare("SELECT * FROM branches WHERE is_active = :active ORDER BY name ASC");
            $stmt->bindParam(':active', $active);
        } else {
            $stmt = $db->prepare("SELECT * FROM branches ORDER BY name ASC");
        }

        $stmt->execute();
        $branches = $stmt->fetchAll(PDO::FETCH_ASSOC);
        echo json_encode(['success' => true, 'data' => $branches]);
    }
}

// POST - Tambah cabang baru
function handlePost($db) {
    $data = json_decode(file_get_contents('php://input'), true);

    if (!isset($data['name']) || empty(trim($data['name']))) {
        http_response_code(400);
        echo json_encode(['success' => false, 'message' => 'Nama cabang tidak boleh kosong']);
        return;
    }

    $stmt = $db->prepare(
        "INSERT INTO branches (name, address, phone, delivery_cost, is_active)
         VALUES (:name, :address, :phone, :delivery_cost, :is_active)"
    );
    $stmt->bindParam(':name', $data['name']);
    $stmt->bindParam(':address', $data['address']);
    $stmt->bindParam(':phone', $data['phone']);
    $deliveryCost = $data['delivery_cost'] ?? 0;
    $stmt->bindParam(':delivery_cost', $deliveryCost);
    $isActive = $data['is_active'] ?? 1;
    $stmt->bindParam(':is_active', $isActive);

    if ($stmt->execute()) {
        echo json_encode([
            'success' => true,
            'message' => 'Cabang berhasil ditambahkan',
            'data' => ['id' => $db->lastInsertId()]
        ]);
    } else {
        http_response_code(500);
        echo json_encode(['success' => false, 'message' => 'Gagal menambahkan cabang']);
    }
}

// PUT - Update cabang
function handlePut($db) {
    $data = json_decode(file_get_contents('php://input'), true);

    if (!isset($data['id'])) {
        http_response_code(400);
        echo json_encode(['success' => false, 'message' => 'ID cabang tidak ditemukan']);
        return;
    }

    $stmt = $db->prepare(
        "UPDATE branches SET
            name          = :name,
            address       = :address,
            phone         = :phone,
            delivery_cost = :delivery_cost,
            is_active     = :is_active
         WHERE id = :id"
    );
    $stmt->bindParam(':id', $data['id']);
    $stmt->bindParam(':name', $data['name']);
    $stmt->bindParam(':address', $data['address']);
    $stmt->bindParam(':phone', $data['phone']);
    $deliveryCost = $data['delivery_cost'] ?? 0;
    $stmt->bindParam(':delivery_cost', $deliveryCost);
    $isActive = $data['is_active'] ?? 1;
    $stmt->bindParam(':is_active', $isActive);

    if ($stmt->execute()) {
        echo json_encode(['success' => true, 'message' => 'Cabang berhasil diupdate']);
    } else {
        http_response_code(500);
        echo json_encode(['success' => false, 'message' => 'Gagal mengupdate cabang']);
    }
}

// DELETE - Hapus cabang
function handleDelete($db) {
    if (!isset($_GET['id'])) {
        http_response_code(400);
        echo json_encode(['success' => false, 'message' => 'ID cabang tidak ditemukan']);
        return;
    }

    $stmt = $db->prepare("DELETE FROM branches WHERE id = :id");
    $stmt->bindParam(':id', $_GET['id']);

    if ($stmt->execute()) {
        echo json_encode(['success' => true, 'message' => 'Cabang berhasil dihapus']);
    } else {
        http_response_code(500);
        echo json_encode(['success' => false, 'message' => 'Gagal menghapus cabang']);
    }
}
?>
