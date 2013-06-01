
<?php

  function attemptUserLogin()
    {
      global $db;

      $submittedUsername = $_POST['username'];
      $submittedPassword = sha1($_POST['password']);
        // md5 and sha1 are not good hash functions to use
        // see 'register.php' for full comment

        // hashing will likely be pulled into a common function somewhere

      $query  = "SELECT * FROM \"Users\"" . 
                "WHERE user_name = '$submittedUsername' " .
                "AND password = '$submittedPassword'";
      $result = pg_query($db, $query);

      if(pg_num_rows($result) < 1)
        {
          // this user does not exist -> reattempt login
        }

      // user may login -> setup their session
      validateUser();

      // to be safe, check login was completed successfully
      return isLoggedIn();
    }

  function logoutUser()
    {
      $_SESSION['active']  = false;
      unset($_SESSION['user_id']);

      session_defaults();
    }

?>