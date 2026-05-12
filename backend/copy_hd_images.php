<?php
require_once 'config/database.php';

$database = new Database();
$conn = $database->getConnection();

if(!$conn) {
    die("Database connection failed");
}

$images_dir = __DIR__ . '/images';
if (!file_exists($images_dir)) {
    mkdir($images_dir, 0777, true);
}

// Absolute paths to the generated HD images on your disk
$source_dir = 'C:/Users/Bobby Leonardo/.gemini/antigravity/brain/a20a1bda-4509-4d7e-a1c0-9ff9d83560a7/';

$files_to_copy = [
    'Klepon' => ['src' => 'klepon_hd_1778571036028.png', 'dst' => 'klepon_hd.png'],
    'Lemper' => ['src' => 'lemper_hd_1778571054643.png', 'dst' => 'lemper_hd.png'],
    'Croissant Butter' => ['src' => 'croissant_hd_1778571072258.png', 'dst' => 'croissant_hd.png'],
    'Baguette' => ['src' => 'baguette_hd_1778571089186.png', 'dst' => 'baguette_hd.png'],
    'Custom Character Cake' => ['src' => 'character_cake_hd_1778571106138.png', 'dst' => 'character_cake_hd.png']
];

$stmt = $conn->prepare("UPDATE products SET image_url = ? WHERE name = ?");

foreach ($files_to_copy as $product_name => $file_info) {
    $src_path = $source_dir . $file_info['src'];
    $dst_path = $images_dir . '/' . $file_info['dst'];
    
    if (file_exists($src_path)) {
        if (copy($src_path, $dst_path)) {
            $local_url = 'http://localhost/sweetbake/backend/images/' . $file_info['dst'];
            $stmt->execute([$local_url, $product_name]);
            echo "Success: Updated $product_name with HD image!\n";
        } else {
            echo "Error: Failed to copy image for $product_name.\n";
        }
    } else {
        echo "Error: Source file not found for $product_name ($src_path).\n";
    }
}

echo "All 5 HD images have been processed!\n";
?>
