<?php
  function register()
    {
      global $db;
      global $json_return;

      $username = $_POST[username];
      $password = sha1($_POST[password]);
        // md5 and sha1 are not good hash functions to use {md5 moreso}
        // the system does not seem to support better given functions, however
        // a salt will improve security 
        //   -> once other basic functions have been implemented I will add this

        // a preferred hash algorithm is blowfish 
        //   -> once everything is in place I may look to make this work appropriately

      $query   = "INSERT INTO \"Users\" (user_name, password) " . 
                 "VALUES ('$username', '$password')"; 
      pg_send_query($db, $query); 
      $result  = pg_get_result($db);
      
      $success = true;
      
      // pg_send_query and pg_get_result stop the warning 
      // generated from adding a duplicate key being thrown as output to the form
      // the following if statement allows us to deal with the result as we wish
      if(pg_result_error_field($result, PGSQL_DIAG_SQLSTATE) == '23505') 
        {
          // the user is a duplicate
          // redirect back to register screen with suitable information
          $success = false;
        }
      
      // setting the default user picture
      $fd = fopen("../Mock-Ups/DefaultUserPicture.png", "w");
      $picture = fread($fd);
      $picturesize = filesize("../Mock-Ups/DefaultUserPicture.png");
      fclose($fd);

      $query   = "SELECT user_picture FROM \"Users\" " .
                 "WHERE user_name = '$username'";
      $result  = pg_query($db, $query);
      $lo_id   = pg_fetch_result($result, 0);
      
      pg_query($db, "begin");
      
      if($oid === NULL)
        $lo_id = pg_lo_create();

      $lo_fp   = pg_lo_open($lo_id, "w");
      $byteswritten = pg_lo_write($lo_fp, $picture);
      $success = $success && ($byteswritten >= $picturesize);
      pg_lo_close($lo_fp);
      pg_query($db, "commit");

      $query   = "UPDATE \"Users\" " .
                 "SET user_picture = '$lo_id', picture_size = '$picturesize' " .
                 "WHERE user_name = '$username'";
      $result  = pg_query($db, $query);
      $update  = pg_fetch_all($result);
      $success = $success && ($update == NULL);
      
      $json_return = array_merge($json_return, array("account_ready" => $success));
    }

  function checkUsername()
    {
      global $db;
      global $json_return;

      $username = $_GET[username];

      // pull the user_id for later deletion use
      $query    = "SELECT user_id FROM \"Users\" " .
                  "WHERE user_name = '$username'";
      $result   = pg_query($db, $query);
      $users    = pg_fetch_all($result);

      $json_return = array_merge($json_return, array("username_valid" => ($users == NULL)));
    }

  function updatePassword()
    {
      global $db;
      global $json_return;
      
      $username     = $_SESSION[user_id];
      $new_password = sha1($_POST[password]);

      $query   = "SELECT user_id FROM \"Users\" " .
                 "WHERE user_name = '$username'";
      $result  = pg_query($db, $query);
      $user_id = pg_fetch_result($result, 0);

      $query  = "UPDATE \"Users\" " .
                "SET password = '$new_password' " .
                "WHERE user_id = '$user_id'";
      $result = pg_query($db, $query);
      $update = pg_fetch_all($result);

      $json_return = array_merge($json_return, array("change_password" => ($update == NULL)));
    }

  function unregister()
    {
      global $db;
      global $json_return;

      $username = $_POST[username];
      $password = sha1($_POST[password]);
        // ask the user for their password as insurance that they do want to unregister

      // pull the user_id for later deletion use
      $query    = "SELECT user_id FROM \"Users\" " .
                  "WHERE user_name = '$username'";
      $result   = pg_query($db, $query);
      $id_value = pg_fetch_result($result, 0);

      // if they are unregistering we want to remove all instances of them
      // from the rest of the database because it makes no sense to referrence
      // a user that no longer exists
      $query   = "DELETE FROM \"Users\" " .
                 "WHERE user_name = '$username' AND password = '$password'";
      $result  = pg_query($db, $query);

      $grpmem_tbl = "\"Group_Members\"";
      $friend_tbl = "\"Friends\"";
      $bmarks_tbl = "\"Bookmarks\"";

      // run logout to clear session data before deleting information?

      $success = (removeUserFrom($grpmem_tbl, $id_value) &&
                  removeUserFrom($friend_tbl, $id_value) &&
                  removeUserFrom($bmarks_tbl, $id_value));
         
      // if everything worked, goodbye {and thanks for all the fish}
      $json_return = array_merge($json_return, array("unregister" => $success));

      // have not decided how to deal with group ownership yet
      // the other members in the group might not want to lose group
      // offer them option to promote a member to group owner?
      // how to decide how to promote?
    }

  function removeUserFrom($table, $user_id)
    {
      global $db;

      if($table === "\"Group_Members\"")
        {
          echo $user_id;

          // delete user lines in table
          $query  = "DELETE FROM $table" .
                    "WHERE member_id = '$user_id'";
          $result = pg_query($db, $query);
        }
      else if($table === "\"Friends\"")
        {
          // Friends has a user_id column and a friend_id column
          // we require to delete the user from other member's friends lists
          // as well as the users own list
          $query  = "DELETE FROM $table" .
                    "WHERE friend_id = '$user_id' OR user_id = '$user_id'";
          $result = pg_query($db, $query);
        }
      else if($table === "\"Bookmarks\"")
        {
          // as the user no longer exists we will be deleting all of their posts
          // this will require us to remove those entries from the Bookmark_Visibility table
          // and remove all associated tags for that post from the Tags table
          // as such, we must build an array of the post_ids affected by this
          $query    = "SELECT post_id FROM $table" .
                      "WHERE owner_id = '$user_id'";
          $result   = pg_query($db, $query);
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

          // delete user lines in table
          $query  = "DELETE FROM $table" .
                    "WHERE owner_id = '$user_id'";
          $result = pg_query($db, $query);
        }

      // work out better test for success
      // may require a common function for testing result success
      return true;     
    }
?>