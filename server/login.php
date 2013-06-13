<?php
  function attemptUserLogin()
    {
      global $db;
      global $json_return;

      $submittedUsername = $_POST[username];
      $submittedPassword = sha1($_POST[password]);
        // md5 and sha1 are not good hash functions to use
        // see 'register.php' for full comment

        // hashing will likely be pulled into a common function somewhere

      $query  = "SELECT password FROM \"Users\" " . 
                "WHERE user_name = '$submittedUsername'";
      $result = pg_query($db, $query);

      $user_exists = (pg_num_rows($result) == 1);

      if(!$user_exists)
        $json_return = array_merge($json_return, array("user_exists" => $user_exists));
      else
        {
          $result_array = pg_fetch_row($result, 0);
          if($result_array[0] === $submittedPassword)
            validateUser($submittedUsername);
          else
            $json_return = array_merge($json_return, array("password_correct" => false));
        }

      // to be safe, check login was completed successfully
      $loggedin = isLoggedIn();
      return $loggedin;
    }

  function logoutUser()
    {
      global $db;

      // unnecessary to double check the user in question has an active session
      // given the login validations the assumption is their session is genuine by this point

      $_SESSION[active] = false;
      unset($_SESSION[user_id]);

      session_unset();
      session_destroy();
      
      echo json_encode(array("logout" => true));
    }
?>