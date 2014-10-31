<?php
/**
 * iHistory backend simple script
 * This example script receives the data from iHistory and post it to a mysql database.
 *
 * @author Waldir Bertazzi Junior
 */

$host			= "";
$user			= "";
$pass			= "";
$database		= "";
$mysqli = new mysqli($host, $user, $pass, $database);

/* check connection */
if ($mysqli->connect_errno) {
    printf("Connect failed: %s\n", $mysqli->connect_error);
    exit();
}

if (!isset($_POST['datetime'])) {
	die("No data received.");
}
$name = $mysqli->real_escape_string($_POST['tname']);
$artist = $mysqli->real_escape_string($_POST['tartist']);
$album = $mysqli->real_escape_string($_POST['talbum']);
$year = $mysqli->real_escape_string($_POST['tyear']);
$date = $mysqli->real_escape_string($_POST['datetime']);

if (!$mysqli->query("INSERT INTO registers VALUES (NULL, '{$name}', '{$artist}', '{$album}', '{$year}', '{$date}')")) {
    printf("Errormessage: %s\n", $mysqli->error);
}

/* close connection */
$mysqli->close();

?>