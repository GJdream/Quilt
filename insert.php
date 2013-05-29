<!DOCTYPE html>
<head>
<title>Insert data to PostgreSQL with php - creating a simple web application</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<style>
li {
list-style: none;
}
</style>
</head>
<body>
<h2>Enter username</h2>
<ul>
<form name="insert" action="insert.php" method="POST" >

<li>Username:</li><li><input type="text" name="username" /></li>

<li><input type="submit" /></li>
</form>
</ul>
</body>
</html>


<?php
$db = pg_connect("host=db.doc.ic.ac.uk port=5432 dbname=g1227105_u user=g1227105_u password=4TVIDKYHVZ");
$query = "INSERT INTO Users VALUES ('$_POST[username]','$_POST[user_name]'";
$result = pg_query($query);
?> 