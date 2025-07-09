<?php
// Enable error reporting for debugging purposes
ini_set('display_errors', 1);
error_reporting(E_ALL);

// CORS Headers - Allow requests from any origin
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
header('Content-Type: application/json');

// Database credentials
$servername = "localhost"; // Database host
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
    $fullName = mysqli_real_escape_string($conn, $_POST['full_name']);
    $email = mysqli_real_escape_string($conn, $_POST['email']);
    $mobile = mysqli_real_escape_string($conn, $_POST['mobile']);
    $password = mysqli_real_escape_string($conn, $_POST['password']);

    // Handle image upload
    $targetDir = "uploads/"; // Directory to save uploaded images
    $targetFile = $targetDir . basename($_FILES["image"]["name"]); // Get the file name
    $uploadOk = 1;
    $imageFileType = strtolower(pathinfo($targetFile, PATHINFO_EXTENSION));

    // Check if the file is a real image
    if (isset($_FILES["image"])) {
        $check = getimagesize($_FILES["image"]["tmp_name"]);
        if ($check !== false) {
            echo json_encode(["status" => "success", "message" => "File is an image"]);
            $uploadOk = 1;
        } else {
            echo json_encode(["status" => "error", "message" => "File is not an image"]);
            $uploadOk = 0;
        }
    }

    // Check file size (e.g., 5MB max)
    if ($_FILES["image"]["size"] > 5000000) {
        echo json_encode(["status" => "error", "message" => "File is too large"]);
        $uploadOk = 0;
    }

    // Allow certain file formats
    if ($imageFileType != "jpg" && $imageFileType != "png" && $imageFileType != "jpeg" && $imageFileType != "gif") {
        echo json_encode(["status" => "error", "message" => "Only JPG, JPEG, PNG, and GIF files are allowed"]);
        $uploadOk = 0;
    }

    // Check if $uploadOk is set to 0 by an error
    if ($uploadOk == 0) {
        echo json_encode(["status" => "error", "message" => "Sorry, your file was not uploaded"]);
    } else {
        if (move_uploaded_file($_FILES["image"]["tmp_name"], $targetFile)) {
            // File is uploaded, insert the image path into the database
            $profileImage = $targetFile;  // Path of the uploaded image

            // SQL query to insert the data into the users table
            $sql = "INSERT INTO users (full_name, email, mobile, password, profile_image) 
                    VALUES ('$fullName', '$email', '$mobile', '$password', '$profileImage')";

            if ($conn->query($sql) === TRUE) {
                echo json_encode(["status" => "success", "message" => "Registration successful"]);
            } else {
                echo json_encode(["status" => "error", "message" => "Error: " . $conn->error]);
            }
        } else {
            echo json_encode(["status" => "error", "message" => "Sorry, there was an error uploading your file"]);
        }
    }

    // Close the connection
    $conn->close();
}
?>
