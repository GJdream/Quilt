<?php
  function createFriend()
    {
      global $db;
      global $json_return;

      $user_name   = $_SESSION[user_id];
      $friend_name = $_POST[friend_name];

      // first check if the friend exists
      $query  = "SELECT user_name FROM \"Users\" " .
                "WHERE user_name = '$friend_name'";
      $result = pg_query($db, $query);
      $exists = pg_fetch_all($result);

      if(!$exist)
        {
          $json_return = array_merge($json_return, array("create_friend" => $exists));
          return;
        }
        
      // all is fine, create the friend as normal
      $query   = "SELECT user_id FROM \"Users\" " .
                 "WHERE user_name = '$user_name'";
      $result  = pg_query($db, $query);
      $user_id = pg_fetch_result($result, 0);
      
      $query     = "SELECT user_id FROM \"Users\" " .
                   "WHERE user_name = '$friend_name'";
      $result    = pg_query($db, $query);
      $friend_id = pg_fetch_result($result, 0);

      // must add friendship in both directions
      // example:

      // user-1 is friends with user-2
      // so the database must record as such

      //   | user_id (bigint) | friend_id (bigint) |
      //   | ================ | ================== |
      //   |        2         |         1          |
      //   | ---------------- | ------------------ |
      //   |        1         |         2          |

      $query  = "INSERT INTO \"Friends\" (user_id, friend_id) " .
                "VALUES ('$friend_id', '$user_id')";
      $result = pg_query($db, $query);

      $query  = "INSERT INTO \"Friends\" (user_id, friend_id) " .
                "VALUES ('$user_id', '$friend_id')";
      $result = pg_query($db, $query);
      $update = pg_fetch_all($result);
      
      $json_return = array_merge($json_return, array("create_friend" => ($update == NULL)));
    }

  function destroyFriend()
    {
      global $db;
      global $json_return;

      $user_name   = $_SESSION[user_id];
      $friend_name = $_POST[friend_name];
      
      $query    = "SELECT user_id FROM \"Users\" " .
                  "WHERE user_name = '$user_name'";
      $result   = pg_query($db, $query);
      $user_id = pg_fetch_result($result, 0);
      
      $query    = "SELECT user_id FROM \"Users\" " .
                  "WHERE user_name = '$friend_name'";
      $result   = pg_query($db, $query);
      $friend_id = pg_fetch_result($result, 0);

      // OR is used within the SQL query so that any instance of the user is removed
      // since users are registered in the database as both having and being friends
      $query  = "DELETE FROM \"Friends\" " .
                "WHERE (user_id = '$user_id' AND friend_id = '$friend_id') " .
                "OR (user_id = '$friend_id' AND friend_id = '$user_id')";
      $result = pg_query($db, $query);
      $update = pg_fetch_all($result);
      
      $json_return = array_merge($json_return, array("remove_friend" => ($update == NULL)));
    }

  function getFriends()
    {
      global $db;
      global $json_return;

      $owner = $_SESSION[user_id];

      // discover user's id
      $query    = "SELECT user_id FROM \"Users\" " .
                  "WHERE user_name = '$owner'";
      $result   = pg_query($db, $query);
      $user_id = pg_fetch_result($result, 0);

      $query    = "SELECT friend_id FROM \"Friends\" " .
                  "WHERE user_id = '$user_id'";
      $result   = pg_query($db, $query);
      $friend_ids  = pg_fetch_all_columns($result, 0);

	  $json_return = array_merge_recursive($json_return, array("friends" => array()));

	  foreach($friend_ids as $id)
	  {
	  	$query	= "SELECT user_name FROM \"Users\" " .
	  			  "WHERE user_id = '$id'";
	  	$result	 = pg_query($db, $query);
	  	$name = pg_fetch_result($result, 0);
	  	
	  	$json_return = array_merge_recursive($json_return, array("friends" => (string)$name));
	  }
    }
    
  function shareTag()
    {
      global $db;
    	
      $owner  	= $_SESSION[user_id];
      $tag		= $_POST[tag];
    	
	  $query    = "SELECT user_id FROM \"Users\" " .
                  "WHERE user_name = '$owner'";
      $result   = pg_query($db, $query);
      $user_id  = pg_fetch_result($result, 0);

      $query    = "SELECT tag_id FROM \"Tags\" " .
                  "WHERE owner_id = '$user_id' AND tag = '$tag'";
      $result   = pg_query($db, $query);
      $tag_id  = pg_fetch_result($result, 0);
      
      echo $tag;
      
      foreach($_POST[users] as $share_uname)
      {
		$query    = "SELECT user_id FROM \"Users\" " .
                    "WHERE user_name = '$share_uname'";
      	$result   = pg_query($db, $query);
      	$share_id  = pg_fetch_result($result, 0);

	    $query    = "INSERT INTO \"Tag_Visibility\" (tag_id, visible_to) " .
	                "VALUES ('$tag_id', '$share_id')";
	    $result   = pg_query($db, $query);
      }
    }

  function createGroup()
    {
      global $db;
      global $json_return;

      $owner    = $_SESSION[username];
      $owner_id = $_POST[user_id];

      $query    = "INSERT INTO \"Groups\" (group_owner, group_owner_id) " .
                  "VALUES ('$owner', '$owner_id') " .
                  "RETURNING group_id";
      $result   = pg_query($db, $result);
      $group_id = pg_fetch_result($result, 0);

      if($_POST[members])
        {
          if(!addGroupMember($group_id))
          	echo json_encode(array("create_group" => false));
          	return;
        }
      
      $json_return = array_merge($json_return, array("create_group" => true));
    }

  // this implementation assumes that there will usually be multiple
  // members being added to the group at once
  function addGroupMember($group_id)
    {
      global $db;
      global $json_return;

      // building array of members
      $members   = implode("','", $_POST[members]);
      $memberarr = "ARRAY['" . $members . "']"; // not used?

      foreach($members as $member)
        {
          $query  = "INSERT INTO \"Group_Members\" (group_id, member_id) " .
                    "VALUES ('$group_id', '$member')";
          $result = pg_query($db, $query);

          if(!$result)
          {
            echo json_encode(array("add_group_member" => false));
            return;
          }
        }

      $json_return = array_merge($json_return, array("add_group_member" => true));
    }

  function destroyGroup()
    {
      global $db;
      global $json_return;

      $groupid = $_POST[group_id];

      // must delete group listing from the following tables:
      //   - Groups
      //   - Group_Members

      $query  = "DELETE FROM \"Groups\" " .
                "WHERE group_id = '$groupid'";
      $result = pg_query($db, $query); 

      $query  = "DELETE FROM \"Group_Members\" " .
                "WHERE group_id = '$groupid'";
      $result = pg_query($db, $query);
      $update = pg_fetch_all($result);
      
      $json_return = array_merge($json_return, array("destroy_group" => ($update == NULL)));   
    }

  function getGroupMembers()
    {
      global $db;
      global $json_return;

      $group_id = $_GET[group_id];

      $query    = "SELECT * FROM \"Group_Members\" " .
                  "WHERE group_id = '$group_id'";
      $result   = pg_query($db, $query);
      $members  = pg_fetch_all($result);

      if($members)
        $json_return = array_merge_recursive($json_return, array("group_members" => array($group_id => $members)));
    }

  function updateUserPicture()
    {
      global $db;
      global $json_return;
      
      $username = $_SESSION[user_id];
      $picture  = file_get_contents($_FILES['picture']['tmp_name']);
      $picturesize = $_FILES['picture']['size'];
      
      $success = true;

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
      
      $json_return = array_merge($json_return, array("update_user_picture" => $success));
    }

  function getUserPicture()
    {
      global $db;

	  $username = $_GET[username];
	  
	  if($username === NULL)
      	$username = $_SESSION[user_id];

      $query    = "SELECT user_picture, picture_size FROM \"Users\" " .
                  "WHERE user_name = '$username'";
      $result   = pg_query($db, $query);
      	
      $lo_id    = pg_fetch_result($result, 0);
      $filesize = pg_fetch_result($result, 1);
      
      if($lo_id === NULL)
	      return;
      
      pg_query($db, "begin");
      $fd   = pg_lo_open($lo_id,"r");
      $data = pg_lo_read($fd, $filesize);
      pg_lo_close($fd);
      pg_query($db, "commit");

      header('Content-Type: image/png');
      echo $data;
    }
?>