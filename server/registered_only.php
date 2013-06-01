
<?php
  
  function checker()
    {
      global $db;

      echo "inside checker";
      if(!isLoggedIn())
        {
          echo "You should log in to view this section";
          // redirect
        }

      echo "You are still logged in";
    }


