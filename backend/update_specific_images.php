<?php
require_once 'config/database.php';

$database = new Database();
$conn = $database->getConnection();

if(!$conn) {
    die("Database connection failed");
}

try {
    $updates = [
        ['Klepon', 'https://upload.wikimedia.org/wikipedia/commons/4/4b/Klepon_snack.jpg'],
        ['Lemper', 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/cd/Lemper_ayam.JPG/800px-Lemper_ayam.JPG'],
        ['Croissant Butter', 'https://images.unsplash.com/photo-1549931319-a545dcf3bc73?q=80&w=800'],
        ['Baguette', 'https://images.unsplash.com/photo-1509440159596-0249088772ff?q=80&w=800'],
        ['Custom Character Cake', 'https://images.unsplash.com/photo-1558301211-0d8c8ddee6ec?q=80&w=800']
    ];

    $stmt = $conn->prepare("UPDATE products SET image_url = ? WHERE name = ?");
    
    foreach($updates as $u) {
        $stmt->execute([$u[1], $u[0]]);
    }
    
    echo "Successfully updated specific product images!\n";
} catch(PDOException $e) {
    echo "Error: " . $e->getMessage() . "\n";
}
?>
