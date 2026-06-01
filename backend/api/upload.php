<?php
include_once '../config/database.php';

$method = $_SERVER['REQUEST_METHOD'];

if ($method == 'POST') {
    if (!isset($_FILES['image']) || $_FILES['image']['error'] !== UPLOAD_ERR_OK) {
        echo json_encode([
            "success" => false,
            "message" => "Tidak ada file yang dikirim atau terjadi error upload"
        ]);
        exit;
    }

    $file = $_FILES['image'];
    $allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/webp', 'image/gif'];
    $allowedExts  = ['jpg', 'jpeg', 'png', 'webp', 'gif'];

    $finfo    = finfo_open(FILEINFO_MIME_TYPE);
    $mimeType = finfo_file($finfo, $file['tmp_name']);
    finfo_close($finfo);

    if (!in_array($mimeType, $allowedTypes)) {
        echo json_encode([
            "success" => false,
            "message" => "Tipe file tidak diizinkan. Hanya jpg, jpeg, png, webp, gif."
        ]);
        exit;
    }

    $ext      = strtolower(pathinfo($file['name'], PATHINFO_EXTENSION));
    if (!in_array($ext, $allowedExts)) {
        echo json_encode([
            "success" => false,
            "message" => "Ekstensi file tidak diizinkan."
        ]);
        exit;
    }

    $maxSize = 5 * 1024 * 1024; // 5 MB
    if ($file['size'] > $maxSize) {
        echo json_encode([
            "success" => false,
            "message" => "Ukuran file terlalu besar. Maksimal 5 MB."
        ]);
        exit;
    }

    $uploadDir = __DIR__ . '/../images/';
    if (!is_dir($uploadDir)) {
        mkdir($uploadDir, 0755, true);
    }

    $filename    = uniqid('img_', true) . '.' . $ext;
    $destination = $uploadDir . $filename;

    if (!move_uploaded_file($file['tmp_name'], $destination)) {
        echo json_encode([
            "success" => false,
            "message" => "Gagal menyimpan file di server"
        ]);
        exit;
    }

    $protocol  = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') ? 'https' : 'http';
    $host      = $_SERVER['HTTP_HOST'];
    $basePath  = dirname(dirname($_SERVER['SCRIPT_NAME']));
    $imageUrl  = $protocol . '://' . $host . $basePath . '/images/' . $filename;

    echo json_encode([
        "success"   => true,
        "message"   => "Gambar berhasil diupload",
        "image_url" => $imageUrl,
        "filename"  => $filename
    ]);
} else {
    echo json_encode([
        "success" => false,
        "message" => "Method tidak diizinkan. Gunakan POST."
    ]);
}
?>
