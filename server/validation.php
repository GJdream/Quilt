<?php  
  function validateUser($username)
    {
      session_regenerate_id();
      $_SESSION[active]  = true;
      $_SESSION[user_id] = $username;
    }

  function isLoggedIn()
    {
      global $json_return;
        
      $loginStatus = isset($_SESSION[active]) && $_SESSION[active];
	    $json_return = array_merge($json_return, array("login" => $loginStatus));

      return $loginStatus;
    }
?>