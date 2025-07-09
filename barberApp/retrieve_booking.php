<?php
header('Content-Type: application/json; charset=utf-8');

// 4.1 Connect to barber_app_db
$db = new PDO(
  'mysql:host=localhost;dbname=barber_app_db;charset=utf8',
  'your_db_user',
  'your_db_pass',
  [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]
);

$bookingId = $_GET['booking_id'] ?? '';
if (!$bookingId) {
  http_response_code(400);
  echo json_encode(['status'=>'error','message'=>'booking_id is required']);
  exit;
}

// 4.2 Fetch booking header
$stmt = $db->prepare(
  "SELECT mobile, booking_date, booking_time
     FROM bookings
    WHERE id = :id"
);
$stmt->execute([':id'=>$bookingId]);
$booking = $stmt->fetch(PDO::FETCH_ASSOC);
if (!$booking) {
  http_response_code(404);
  echo json_encode(['status'=>'error','message'=>'Booking not found']);
  exit;
}

// 4.3 Fetch its services
$stmt2 = $db->prepare(
  "SELECT service_name, price
     FROM booking_services
    WHERE booking_id = :id"
);
$stmt2->execute([':id'=>$bookingId]);
$services = $stmt2->fetchAll(PDO::FETCH_ASSOC);

// 4.4 Return combined JSON
echo json_encode([
  'status'   => 'success',
  'booking'  => $booking,
  'services' => $services
]);
