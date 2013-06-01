
<?php
  
  function validateUser()
    {
      session_regenerate_id();
      $_SESSION['active']  = true;
      $_SESSION['user_id'] = $username;
    }

  function isLoggedIn()
    {
      echo "checking log status\n";

      if(isset($_SESSION['active']) && $_SESSION['active'])
        {
          echo $_SESSION['user_id'];
          echo " You are logged in\n";
          return true;
        }

      echo "You are not logged in\n";
      return false;
    }


