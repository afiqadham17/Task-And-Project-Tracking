<?php
header('Content-Type: application/json; charset=utf-8');

try {
    // 2.1 Connect to barber_app_db
    $db = new PDO(
      'mysql:host=localhost;dbname=barber_app_db;charset=utf8',
      'your_db_user',
      'your_db_pass',
      array(PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION)
    );
} catch (PDOException $e) {
    echo json_encode(['status'=>'error','message'=>'DB Connection failed']);
    exit;
}

// 2.2 Read POST inputs safely
$mobile   = isset($_POST['mobile'])   ? $_POST['mobile']   : '';
$date     = isset($_POST['date'])     ? $_POST['date']     : '';
$time     = isset($_POST['time'])     ? $_POST['time']     : '';
$services = isset($_POST['services']) ? json_decode($_POST['services'], true) : array();

if (empty($mobile) || empty($date) || empty($time) || !is_array($services)) {
    echo json_encode(['status'=>'error','message'=>'Invalid input']);
    exit;
}

try {
    // 2.3 Insert booking header
    $stmt = $db->prepare(
      "INSERT INTO bookings (mobile, booking_date, booking_time)
       VALUES (:mobile, :date, :time)"
    );
    $stmt->execute([
      ':mobile' => $mobile,
      ':date'   => $date,
      ':time'   => $time
    ]);
    $bookingId = $db->lastInsertId();

    // 2.4 Insert each selected service
    $stmtSvc = $db->prepare(
      "INSERT INTO booking_services
         (booking_id, service_name, price)
       VALUES (:bid, :name, :price)"
    );
    foreach ($services as $svc) {
        $stmtSvc->execute([
          ':bid'   => $bookingId,
          ':name'  => $svc['name'],
          ':price' => $svc['price']
        ]);
    }

    // 2.5 Return success + booking ID
    echo json_encode(['status'=>'success','booking_id'=>$bookingId]);

} catch (PDOException $e) {
    echo json_encode(['status'=>'error','message'=>$e->getMessage()]);
}
