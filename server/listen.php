#!/usr/bin/php
<html>
<head/>
<body>
<?php

$db     = pg_connect("host=db.doc.ic.ac.uk port=5432 dbname=g1227105_u user=g1227105_u password=4TVIDKYHVZ");

if($_SERVER[REQUEST_METHOD] === "POST")
{
    if($_POST["action"] === "new_account")
    {
        if($_POST["user_name"] && $_POST["password"])
            $query  = "INSERT INTO \"Users\" (user_name, password) VALUES ('$_POST[username]', '$_POST[password]')";
    }
    else if($_POST["action"] === "new_bookmark")
    {
        $query  = "INSERT INTO \"Bookmarks\" (owner, url, p_height, p_width, tags) VALUES ('$_POST[owner]', '$_POST[url]', '$_POST[p_height]', '$_POST[p_width]', ARRAY['" . implode($_POST[tags], "','") . "'])";
        echo $query;
        $result = pg_query($db, $query);
        echo $result;
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
