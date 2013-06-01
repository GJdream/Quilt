
<?php
  
  function validateUser()
    {
      session_regenerate_id();
      $_SESSION['active']  = true;
      $_SESSION['user_id'] = $username;
    }

  function isLoggedIn()
    {
      echo 'checking log status';

      if(isset($_SESSION['active']) && $_SESSION['active'])
        return true;

      return false;
    }

?>