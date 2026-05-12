<?php
$url = 'http://localhost/sweetbake/backend/images/klepon_hd.png';
$headers = @get_headers($url);
if ($headers) {
    echo "Headers for $url:\n";
    print_r($headers);
} else {
    echo "Failed to connect to $url\n";
}

$url_api = 'http://127.0.0.1/sweetbake/backend/images/klepon_hd.png';
$headers_api = @get_headers($url_api);
if ($headers_api) {
    echo "\nHeaders for $url_api:\n";
    print_r($headers_api);
} else {
    echo "Failed to connect to $url_api\n";
}
?>
