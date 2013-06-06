<?php  
  function validateUser()
    {
      session_regenerate_id();
      $_SESSION[active]  = true;
      $_SESSION[user_id] = $username;
      //echo "validating log status";
    }

  function isLoggedIn()
    {
      global $json_return;
        
      $loginStatus = isset($_SESSION[active]) && $_SESSION[active];

      //echo "You are not logged in";
	  $json_return = array_merge($json_return, array("login" => $loginStatus));
      return $loginStatus;
    }
?>