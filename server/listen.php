#!/usr/bin/php
<html>
<head/>
<body>
<?php

$db     = pg_connect("host=db.doc.ic.ac.uk port=5432 dbname=g1227105_u user=g1227105_u password=4TVIDKYHVZ");

echo $_SERVER[REQUEST_METHOD];
echo "<br/>";
if($_SERVER[REQUEST_METHOD] === "POST")
{
    echo "HERE";
    if($_POST["user_name"] || $_POST["password"])
    {
        echo $_POST['user_name'];
        echo "<br/>";
        echo $_POST['password'];
        echo "<br/>";
    }
}

if(false)
{

$query  = "INSERT INTO \"Users\" (user_name) VALUES ('$_POST[username]')";
$result = pg_query($db, $query);
$query  = "SELECT * FROM \"Users\"";
$result = pg_query($db, $query);

while($row    = pg_fetch_array($result))
{
    echo $row[0] . "<br />";
}
}

?>

</body>
</html>
