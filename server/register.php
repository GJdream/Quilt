
<?php
  
  function register()
    {
      global $db;

      $username = $_POST['username'];
      $password = sha1($_POST['password']);
        // md5 and sha1 are not good hash functions to use {md5 moreso}
        // the system does not seem to support better given functions, however
        // a salt will improve security 
        //   -> once other basic functions have been implemented I will add this

        // a preferred hash algorithm is blowfish 
        //   -> once everything is in place I may look to make this worth appropriately

      $query  = "INSERT INTO \"Users\" (user_name, password) " . 
                "VALUES ('$username', '$password')"; 
      pg_send_query($db, $query); 
      $result = pg_get_result($db); 
      
      // pg_send_query and pg_get_result stop the warning 
      // generated from adding a duplicate key being thrown as output to the form
      // the following if statement allows us to deal with the result as we wish
      if(pg_result_error_field($result, PGSQL_DIAG_SQLSTATE) == '23505') 
        {
          // the user is a duplicate
          // redirect back to register screen with suitable information
          echo 'ERROR';
        }

      // insert successful
    }

?>