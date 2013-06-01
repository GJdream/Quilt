
<?php

    $username = "g1227105_u";
    $password = "4TVIDKYHVZ";
    $host     = "db.doc.ic.ac.uk";
    $port     = "5432";
    $dbname   = "g1227105_u";

    $db = pg_connect("host=$host port=$port dbname=$dbname user=$username password=$password");

?>