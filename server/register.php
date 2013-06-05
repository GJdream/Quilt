<?php
  global $db;

  function register()
    {
      $username = $_POST['username'];
      $password = sha1($_POST['password']);
        // md5 and sha1 are not good hash functions to use {md5 moreso}
        // the system does not seem to support better given functions, however
        // a salt will improve security 
        //   -> once other basic functions have been implemented I will add this

        // a preferred hash algorithm is blowfish 
        //   -> once everything is in place I may look to make this worth appropriately

      $query  = "INSERT INTO \"Users\" (user_name, password) " . 
                "VALUES ('$username', '$password')"; 
      pg_send_query($db, $query); 
      $result = pg_get_result($db); 
      
      // pg_send_query and pg_get_result stop the warning 
      // generated from adding a duplicate key being thrown as output to the form
      // the following if statement allows us to deal with the result as we wish
      if(pg_result_error_field($result, PGSQL_DIAG_SQLSTATE) == '23505') 
        {
          // the user is a duplicate
          // redirect back to register screen with suitable information
          echo "ERROR";
        }

      // insert successful
    }

  function unregister()
    {
      $username = $_POST['username'];
      $password = sha1($_POST['password']);
        // ask the user for their password as insurance that they do want to unregister

      // if they are unregistering we want to remove all instances of them
      // from the rest of the database because it makes no sense to referrence
      // a user that no longer exists
      $query   = "DELETE FROM \"Users\"" .
                 "WHERE user_name = '$username' AND password = '$password'" . 
                 "RETURNING user_id";
      $result  = pg_query($db, $query);
      echo $result;
      $user_id = pg_fetch_result($result, 0);

      $grpmem_tbl = "\"Group_Members\"";
      $friend_tbl = "\"Friends\"";
      $bmarks_tbl = "\"Bookmarks\"";

      // run logout to clear session data before deleting information?

      if(removeUserFrom($grpmem_tbl, $user_id) 
         && removeUserFrom($friend_tbl, $user_id)
         && removeUserFrom($bmarks_tbl, $user_id))
        {
          // if everything worked, goodbye {and thanks for all the fish}
          return true;
        }

      return false;

      // have not decided how to deal with group ownership yet
      // the other members in the group might not want to lose group
      // offer them option to promote a member to group owner?
      // how to decide how to promote?
    }

  function removeUserFrom($table, $user_id)
    {
      if($table === "\"Group_Members\"")
        {
          // aliasing the correct column for use with common code at end of function
          $query  = "SELECT group_id AS user_id " .
                    "FROM $table";
          $result = pg_query($db, $query);
        }
      else if($table === "\"Friends\"")
        {
          // Friends has a user_id column and a friend_id column
          // we can't alias friend_id to user_id as the column exists already
          // here is the deletion case for friend_id
          $query  = "DELETE FROM $table" .
                    "WHERE friend_id = '$user_id'";
          $result = pg_query($db, $query);

          // the user_id deletion for Friends will occur correctly
          // using the common code at the end of the function since
          // the column exists as required
        }
      else if($table === "\"Bookmarks\"")
        {
          // as the user no longer exists we will be deleting all of their posts
          // this will require us to remove those entries from the Bookmark_Visibility table
          // and remove all associated tags for that post from the Tags table
          // as such, we must build an array of the post_ids affected by this
          $query   = "SELECT post_id FROM $table" .
                     "WHERE owner_id = '$user_id'";
          $result  = pg_query($db, $query);

          $post_ids = pg_fetch_array($result);

          // deleting post data
          foreach($post_ids as $post_id)
            {
              $query  = "DELETE FROM \"Bookmark_Visibility\"" .
                        "WHERE post_id = '$post_id'";
              $result = pg_query($db, $query);

              $query  = "DELETE FROM \"Tags\"" .
                        "WHERE post_id = '$post_id'";
              $result = pg_query($db, $query);
            }

          // here is the column alias for the common query deletion below
          $query   = "SELECT owner_id AS user_id " .
                     "FROM $table";
          $result  = pg_query($db, $query);
        }

      $query  = "DELETE FROM $table" .
                "WHERE user_id = '$user_id'";
      $result = pg_query($db, $query); 

      // work out better test for success
      // may require a common function for testing result success
      return true;     
    }
?>