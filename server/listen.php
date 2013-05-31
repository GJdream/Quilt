#!/usr/bin/php

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

      if($_SERVER[REQUEST_METHOD] === "POST")
        {
          if($_POST['action'] === "new_account")
            register();
          if($_POST['action'] === "new_bookmark")
            createBookmark();
          if($_POST['action'] === "attempt_login")
            attemptUserLogin();
          if($_POST['action'] === "checker")
            checker();
        }

    ?>

  </body>
</html>
