<?php
$src_dir = 'c:\\flutter\\kiro\\sweetbake\\backend\\images';
$dst_dir = 'c:\\laragon\\www\\sweetbake\\backend\\images';

if (!file_exists($dst_dir)) {
    mkdir($dst_dir, 0777, true);
}

$files = scandir($src_dir);
foreach ($files as $file) {
    if ($file != '.' && $file != '..') {
        copy($src_dir . '\\' . $file, $dst_dir . '\\' . $file);
        echo "Copied $file to Laragon web root.\n";
    }
}
echo "Sync complete!\n";
?>
