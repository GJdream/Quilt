#!/usr/bin/php

<html>
<head/>
<body>
<?php
$db     = pg_connect("host=db.doc.ic.ac.uk port=5432 dbname=g1227105_u user=g1227105_u password=4TVIDKYHVZ");

$query  = "INSERT INTO \"Users\" (user_name) VALUES ('$_POST[username]')";
$result = pg_query($db, $query);
$query  = "SELECT * FROM \"Users\"";
$result = pg_query($db, $query);

while($row    = pg_fetch_array($result))
{
    echo $row[0] . "<br />";
}

?>

</body>
</html>
