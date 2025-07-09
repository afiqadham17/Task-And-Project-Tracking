<?php
// Database connection
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "barber_app_db";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Handle POST request
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $mobile = $_POST['mobile'];
    $full_name = $_POST['full_name'];
    $email = $_POST['email'];

    // Check if image is provided
    if (isset($_FILES['image'])) {
        $image = $_FILES['image'];
        $target_dir = "uploads/"; // Define a folder to upload the image
        $target_file = $target_dir . basename($image["name"]);
        move_uploaded_file($image["tmp_name"], $target_file);  // Move image to folder
        $image_path = $target_file;  // Store the file path
    } else {
        $image_path = '';  // No image uploaded
    }

    // Query to update user data
    $sql = "UPDATE users SET full_name = '$full_name', email = '$email', profile_image = '$image_path' WHERE mobile = '$mobile'";

    if ($conn->query($sql) === TRUE) {
        echo json_encode(["status" => "success", "message" => "Profile updated successfully"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Error updating profile: " . $conn->error]);
    }
}

$conn->close();
?>
