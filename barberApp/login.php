<?php
// Example of PHP code to verify login credentials
header("Content-Type: application/json");

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "barber_app_db";  // Your database name

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Retrieve data
    $mobile = $_POST['mobile'];
    $password = $_POST['password'];

    // SQL query to check if mobile and password match
    $sql = "SELECT * FROM users WHERE mobile = '$mobile' AND password = '$password'";
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        // User found, send success response
        echo json_encode(["status" => "success", "message" => "Login successful"]);
    } else {
        // No user found, send error response
        echo json_encode(["status" => "error", "message" => "Invalid mobile number or password"]);
    }
}

$conn->close();
?>
