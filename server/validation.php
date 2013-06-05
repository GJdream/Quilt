<?php  
  function validateUser()
    {
      session_regenerate_id();
      $_SESSION[active]  = true;
      $_SESSION[user_id] = $username;
      echo "validating log status";
    }

  function isLoggedIn()
    {
      echo "checking log status";

      if(isset($_SESSION[active]) && $_SESSION[active])
        {
          echo $_SESSION[user_id];
          echo " You are logged in";
          return true;
        }

      echo "You are not logged in";
      return false;
    }
?>