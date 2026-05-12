<?php
require_once '../config/database.php';

$database = new Database();
$db = $database->getConnection();

$action = isset($_GET['action']) ? $_GET['action'] : '';

switch($action) {
    case 'get_wishlist':
        getWishlist();
        break;
    case 'toggle':
        toggleWishlist();
        break;
    default:
        echo json_encode(["success" => false, "message" => "Invalid action"]);
        break;
}

function getWishlist() {
    global $db;
    $user_id = isset($_GET['user_id']) ? $_GET['user_id'] : die(json_encode(["success" => false, "message" => "user_id is required"]));

    $query = "SELECT p.*, c.name as category_name 
              FROM products p 
              JOIN wishlists w ON p.id = w.product_id 
              LEFT JOIN categories c ON p.category_id = c.id
              WHERE w.user_id = ?";
    
    $stmt = $db->prepare($query);
    $stmt->execute([$user_id]);
    
    $products = [];
    while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        // Cast types appropriately
        $row['id'] = (int)$row['id'];
        $row['category_id'] = $row['category_id'] ? (int)$row['category_id'] : null;
        $row['price'] = (double)$row['price'];
        $row['stock'] = (int)$row['stock'];
        $row['is_available'] = (bool)$row['is_available'];
        $products[] = $row;
    }
    
    echo json_encode([
        "success" => true,
        "data" => $products
    ]);
}

function toggleWishlist() {
    global $db;
    $data = json_decode(file_get_contents("php://input"));
    
    if(!isset($data->user_id) || !isset($data->product_id)) {
        echo json_encode(["success" => false, "message" => "Incomplete data"]);
        return;
    }

    // Check if exists
    $check_query = "SELECT id FROM wishlists WHERE user_id = ? AND product_id = ?";
    $check_stmt = $db->prepare($check_query);
    $check_stmt->execute([$data->user_id, $data->product_id]);

    if ($check_stmt->rowCount() > 0) {
        // Remove
        $query = "DELETE FROM wishlists WHERE user_id = ? AND product_id = ?";
        $stmt = $db->prepare($query);
        if($stmt->execute([$data->user_id, $data->product_id])) {
            echo json_encode(["success" => true, "message" => "Removed from wishlist", "is_favorite" => false]);
        } else {
            echo json_encode(["success" => false, "message" => "Failed to remove from wishlist"]);
        }
    } else {
        // Add
        $query = "INSERT INTO wishlists (user_id, product_id) VALUES (?, ?)";
        $stmt = $db->prepare($query);
        if($stmt->execute([$data->user_id, $data->product_id])) {
            echo json_encode(["success" => true, "message" => "Added to wishlist", "is_favorite" => true]);
        } else {
            echo json_encode(["success" => false, "message" => "Failed to add to wishlist"]);
        }
    }
}
?>
