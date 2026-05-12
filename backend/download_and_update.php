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

// Ignore SSL warnings to ensure download succeeds
$context = stream_context_create([
    'ssl' => [
        'verify_peer' => false,
        'verify_peer_name' => false,
    ],
    'http' => [
        'header' => "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64)\r\n"
    ]
]);

$products = [
    'Kue Ulang Tahun Coklat' => 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c9/Chocolate_cake_with_chocolate_frosting.jpg/800px-Chocolate_cake_with_chocolate_frosting.jpg',
    'Kue Ulang Tahun Red Velvet' => 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b2/Red_Velvet_Cake_Waldorf_Astoria.jpg/800px-Red_Velvet_Cake_Waldorf_Astoria.jpg',
    'Kue Ulang Tahun Vanilla Fruit' => 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Vanilla_Cake_with_Fruit.jpg/800px-Vanilla_Cake_with_Fruit.jpg',
    'Klepon' => 'https://upload.wikimedia.org/wikipedia/commons/4/4b/Klepon_snack.jpg',
    'Lemper' => 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/cd/Lemper_ayam.JPG/800px-Lemper_ayam.JPG',
    'Kue Lapis' => 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/07/Kue_Lapis_Legit.jpg/800px-Kue_Lapis_Legit.jpg',
    'Dadar Gulung' => 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/54/Dadar_gulung_snack.jpg/800px-Dadar_gulung_snack.jpg',
    'Nastar Premium' => 'https://upload.wikimedia.org/wikipedia/commons/thumb/9/91/Nastar_pineapple_tart.jpg/800px-Nastar_pineapple_tart.jpg',
    'Kastengel Keju' => 'https://upload.wikimedia.org/wikipedia/commons/thumb/7/77/Kastengel_cheese_cookie.jpg/800px-Kastengel_cheese_cookie.jpg',
    'Putri Salju' => 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e0/Putri_salju.jpg/800px-Putri_salju.jpg',
    'Lidah Kucing' => 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e6/Kattentongen.jpg/800px-Kattentongen.jpg',
    'Croissant Butter' => 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/28/Croissant_by_Sip_and_Gulp_Diner.jpg/800px-Croissant_by_Sip_and_Gulp_Diner.jpg',
    'Roti Sobek Coklat' => 'https://upload.wikimedia.org/wikipedia/commons/thumb/7/7b/Japanese_Milk_Bread.jpg/800px-Japanese_Milk_Bread.jpg',
    'Cinnamon Roll' => 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1a/Cinnamon_Roll.jpg/800px-Cinnamon_Roll.jpg',
    'Baguette' => 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f5/Baguettes_-_boulangerie_Babel_-_12_rue_de_la_Jonqui%C3%A8re%2C_Paris_17.jpg/800px-Baguettes_-_boulangerie_Babel_-_12_rue_de_la_Jonqui%C3%A8re%2C_Paris_17.jpg',
    'Wedding Cake 3 Tiers' => 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/ea/Wedding_cake_with_flowers.jpg/800px-Wedding_cake_with_flowers.jpg',
    'Custom Character Cake' => 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/04/Cake_decorated_with_icing.jpg/800px-Cake_decorated_with_icing.jpg',
    'Cupcake Set Custom' => 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1b/Cupcakes_with_buttercream_frosting.jpg/800px-Cupcakes_with_buttercream_frosting.jpg'
];

$stmt = $conn->prepare("UPDATE products SET image_url = ? WHERE name = ?");

foreach($products as $name => $url) {
    // Generate safe filename
    $filename = preg_replace('/[^a-z0-9]/i', '_', strtolower($name)) . '.jpg';
    $filepath = $images_dir . '/' . $filename;
    
    // Download image
    echo "Downloading image for $name...\n";
    $image_data = @file_get_contents($url, false, $context);
    
    if ($image_data !== false) {
        file_put_contents($filepath, $image_data);
        
        // Use local Laragon URL
        // In Flutter api_config: baseUrl = 'http://localhost/sweetbake/backend/api'
        // So image url will be: 'http://localhost/sweetbake/backend/images/filename.jpg'
        $local_url = 'http://localhost/sweetbake/backend/images/' . $filename;
        
        $stmt->execute([$local_url, $name]);
        echo "Successfully updated $name with local URL\n";
    } else {
        echo "Failed to download image for $name\n";
    }
}

echo "All done!\n";
?>
