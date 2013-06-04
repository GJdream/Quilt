<?php
  
  function checker()
    {
      global $db;

      if(!isLoggedIn())
        {
          echo "You should log in to view this section\n";
          // redirect
          return;
        }

      echo "You are still logged in\n";
    }

?>