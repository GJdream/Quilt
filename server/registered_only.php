
<?php
  
  function checker()
    {
      echo 'inside checker';
      if(!isLoggedIn())
        {
          echo 'You should log in to view this section.';
          // redirect
        }
    }

?>