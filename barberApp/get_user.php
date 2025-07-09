<?php
// Enable error reporting for debugging purposes
ini_set('display_errors', 1);
error_reporting(E_ALL);

// CORS Headers - Allow requests from any origin (you can restrict to specific domains if needed)
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
header('Content-Type: application/json');

// Database credentials
$servername = "localhost"; // Database host (typically localhost)
$username = "root"; // MySQL username
$password = ""; // MySQL password (empty by default in XAMPP/WAMP)
$dbname = "barber_app_db"; // Database name

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Check if the request method is POST
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Retrieve the posted data
    $mobile = mysqli_real_escape_string($conn, $_POST['mobile']);  // Assuming you're using mobile as the identifier

    // SQL query to get the full name of the user
    $sql = "SELECT full_name FROM users WHERE mobile = '$mobile' LIMIT 1";
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        // Fetch the result and send as JSON response
        $row = $result->fetch_assoc();
        echo json_encode(["status" => "success", "full_name" => $row['full_name']]);
    } else {
        // No matching user found
        echo json_encode(["status" => "error", "message" => "User not found"]);
    }

    // Close the connection
    $conn->close();
}
?>
