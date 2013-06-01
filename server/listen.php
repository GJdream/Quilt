#!/usr/bin/php
<?php 
  ob_start(); 
  session_start();
    // the session must be initialized before any headers are set {ie; before anything is outputted}
    // this way each user has a session which can then be validated to keep the system secure
    // ob_start() clears the output from #!/usr/bin/php 
    // which would set a header otherwise, which has been making session_start() unuseable
?>

<html>
  <body>

    <?php

      global $db;

      require_once('connect.php');
      require('validation.php');
      require('register.php');
      require('login.php');
      require('bookmark.php');
      require('registered_only.php');

      if(function_exists('get_magic_quotes_gpc') && get_magic_quotes_gpc())
        {
          function undo_magic_quotes_gpc($arr)
            {
              foreach($arr as &$value)
                {
                  if(is_array($value))
                    {
                      undo_magic_quotes_gpc($value);
                    }
                  else
                    {
                      $value = stripslashes($value);
                    }
                }
            }

          undo_magic_quotes_gpc($_POST);
          undo_magic_quotes_gpc($_GET);
          undo_magic_quotes_gpc($_COOKIE);
        }

        isLoggedIn();

      if($_SERVER[REQUEST_METHOD] === "POST")
        {
          echo $_POST['action'];

          if($_POST['action'] === "new_account")
            register();
          if($_POST['action'] === "new_bookmark")
            createBookmark();
          if($_POST['action'] === "attempt_login")
            attemptUserLogin();
          if($_POST['action'] === "checking")
            {
              echo "listen side checker\n";
              checker();
            }
          if($_POST['action'] === "logout_user")
            logoutUser();
        }

    ?>

  </body>
</html>
