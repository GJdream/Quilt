#!/usr/bin/php
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
