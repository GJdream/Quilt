<?php
  function checker()
    {
      if(!isLoggedIn())
          echo json_encode("require_login");
    }
?>