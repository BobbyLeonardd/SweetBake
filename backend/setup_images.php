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

// Copy the generated HD images
$source_dir = 'C:/Users/Bobby Leonardo/.gemini/antigravity/brain/a20a1bda-4509-4d7e-a1c0-9ff9d83560a7/';
copy($source_dir . 'klepon_hd_1778571036028.png', $images_dir . '/klepon_hd.png');
copy($source_dir . 'lemper_hd_1778571054643.png', $images_dir . '/lemper_hd.png');
copy($source_dir . 'croissant_hd_1778571072258.png', $images_dir . '/croissant_hd.png');
copy($source_dir . 'baguette_hd_1778571089186.png', $images_dir . '/baguette_hd.png');
copy($source_dir . 'character_cake_hd_1778571106138.png', $images_dir . '/character_cake_hd.png');

$updates = [
    // The 5 specific ones with HD local images
    ['Klepon', 'http://localhost/sweetbake/backend/images/klepon_hd.png'],
    ['Lemper', 'http://localhost/sweetbake/backend/images/lemper_hd.png'],
    ['Croissant Butter', 'http://localhost/sweetbake/backend/images/croissant_hd.png'],
    ['Baguette', 'http://localhost/sweetbake/backend/images/baguette_hd.png'],
    ['Custom Character Cake', 'http://localhost/sweetbake/backend/images/character_cake_hd.png'],
    
    // The rest with working Unsplash images
    ['Kue Ulang Tahun Coklat', 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?auto=format&fit=crop&w=800&q=80'],
    ['Kue Ulang Tahun Red Velvet', 'https://images.unsplash.com/photo-1616541823729-00fe0aacd32c?auto=format&fit=crop&w=800&q=80'],
    ['Kue Ulang Tahun Vanilla Fruit', 'https://images.unsplash.com/photo-1464349095431-e9a21285b5f3?auto=format&fit=crop&w=800&q=80'],
    ['Kue Lapis', 'https://images.unsplash.com/photo-1600289031464-74d374b64991?auto=format&fit=crop&w=800&q=80'],
    ['Dadar Gulung', 'https://images.unsplash.com/photo-1590080874088-eec64895b423?auto=format&fit=crop&w=800&q=80'],
    ['Nastar Premium', 'https://images.unsplash.com/photo-1509365465985-25d11c17e812?auto=format&fit=crop&w=800&q=80'],
    ['Kastengel Keju', 'https://images.unsplash.com/photo-1605807646983-377bc5a76493?auto=format&fit=crop&w=800&q=80'],
    ['Putri Salju', 'https://images.unsplash.com/photo-1558961363-fa8fdf82db35?auto=format&fit=crop&w=800&q=80'],
    ['Lidah Kucing', 'https://images.unsplash.com/photo-1599599810769-bcde5a160d32?auto=format&fit=crop&w=800&q=80'],
    ['Roti Sobek Coklat', 'https://images.unsplash.com/photo-1598373182133-52452f7691ef?auto=format&fit=crop&w=800&q=80'],
    ['Cinnamon Roll', 'https://images.unsplash.com/photo-1550617931-e17a7b70dce2?auto=format&fit=crop&w=800&q=80'],
    ['Wedding Cake 3 Tiers', 'https://images.unsplash.com/photo-1535254973040-607b474cb50d?auto=format&fit=crop&w=800&q=80'],
    ['Cupcake Set Custom', 'https://images.unsplash.com/photo-1587668178277-295251f900ce?auto=format&fit=crop&w=800&q=80']
];

$stmt = $conn->prepare("UPDATE products SET image_url = ? WHERE name = ?");

foreach($updates as $u) {
    $stmt->execute([$u[1], $u[0]]);
}

echo "Successfully copied 5 local HD images and reverted the rest to Unsplash!\n";
?>
