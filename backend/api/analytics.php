<?php
include_once '../config/database.php';

$database = new Database();
$db = $database->getConnection();

$method = $_SERVER['REQUEST_METHOD'];

if ($method == 'GET') {
    try {
        // Get Total Revenue (from completed/paid orders, but for simplicity let's sum total_amount of non-cancelled orders)
        $revenueQuery = "SELECT SUM(total_amount) as total_revenue FROM orders WHERE status != 'cancelled'";
        $revStmt = $db->prepare($revenueQuery);
        $revStmt->execute();
        $revenue = $revStmt->fetch(PDO::FETCH_ASSOC)['total_revenue'] ?? 0;

        // Get count of orders by status
        $statusQuery = "SELECT status, COUNT(*) as count FROM orders GROUP BY status";
        $statusStmt = $db->prepare($statusQuery);
        $statusStmt->execute();
        $orderStats = $statusStmt->fetchAll(PDO::FETCH_ASSOC);

        // Get Top Selling Products
        $topProductsQuery = "SELECT p.name, p.image_url, SUM(oi.quantity) as total_sold 
                             FROM order_items oi 
                             JOIN products p ON oi.product_id = p.id 
                             JOIN orders o ON oi.order_id = o.id 
                             WHERE o.status != 'cancelled' 
                             GROUP BY p.id 
                             ORDER BY total_sold DESC 
                             LIMIT 5";
        $topProductsStmt = $db->prepare($topProductsQuery);
        $topProductsStmt->execute();
        $topProducts = $topProductsStmt->fetchAll(PDO::FETCH_ASSOC);

        // Overall stats
        $usersQuery = "SELECT COUNT(*) as total_users FROM users WHERE role = 'customer'";
        $usersStmt = $db->prepare($usersQuery);
        $usersStmt->execute();
        $totalUsers = $usersStmt->fetch(PDO::FETCH_ASSOC)['total_users'] ?? 0;

        echo json_encode([
            "success" => true,
            "data" => [
                "total_revenue" => (double)$revenue,
                "order_status_counts" => $orderStats,
                "top_selling_products" => $topProducts,
                "total_customers" => (int)$totalUsers
            ]
        ]);
    } catch (Exception $e) {
        echo json_encode([
            "success" => false,
            "message" => "Failed to get analytics: " . $e->getMessage()
        ]);
    }
}
?>
