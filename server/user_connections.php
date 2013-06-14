<?php
  function createFriend()
    {
      global $db;
      global $json_return;

      $user_id   = $_POST[user_id];
      $friend_id = $_post[friend_id];

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
      $result = pg_query($db, $result);

      $query  = "INSERT INTO \"Friends\" (user_id, friend_id) " .
                "VALUES ('$user_id', '$friend_id')";
      $result = pg_query($db, $result);
      $update = pg_fetch_all($result);
      
      $json_return = array_merge($json_return, array("create_friend" => ($update == NULL)));
    }

  function destroyFriend()
    {
      global $db;
      global $json_return;

      $user_id   = $_POST[user_id];
      $friend_id = $_post[friend_id];

      // OR is used within the SQL query so that any instance of the user is removed
      // since users are registered in the database as both having and being friends
      $query  = "DELETE FROM \"Friends\" " .
                "WHERE user_id = '$user_id' OR friend_id = '$friend_id'";
      $result = pg_query($db, $query);
      $update = pg_fetch_all($result);
      
      $json_return = array_merge($json_return, array("remove_friend" => ($update == NULL)));
    }

  function getFriends()
    {
      global $db;
      global $json_return;

      $owner = $_GET[username];

      // discover user's id
      $query    = "SELECT user_id FROM \"Users\" " .
                  "WHERE user_name = '$owner'";
      $result   = pg_query($db, $query);
      $owner_id = pg_fetch_result($result, 0);

      $query    = "SELECT * FROM \"Friends\" " .
                  "WHERE owner_id = '$owner_id'";
      $result   = pg_query($db, $query);
      $friends  = pg_fetch_all($result);

      if($friends)
        $json_return = array_merge_recursive($json_return, array("friends" => array($owner => $friends)));
    }

  function createGroup()
    {
      global $db;
      global $json_return;

      $owner    = $_POST[username];
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

  function updatePicture()
    {
      global $db;
      global $json_return;

      $username = $_SESSION[user_id];
      $picture = $_POST[picture];

      $query   = "SELECT user_id FROM \"Users\" " .
                 "WHERE user_name = '$username'";
      $result  = pg_query($db, $query);
      $user_id = pg_fetch_result($result, 0);

      $query  = "UPDATE \"Users\" " .
                "SET picture = '$picture' " .
                "WHERE user_id = '$user_id'";
      $result = pg_query($db, $query);
      $update = pg_fetch_all($result);
      
      $json_return = array_merge($json_return, array("update_picture" => ($update == NULL)));
    }

  function getPicture()
    {
      global $db;
      global $json_return;

      $username = $_SESSION[user_id];

      $query   = "SELECT user_id FROM \"Users\" " .
                 "WHERE user_name = '$username'";
      $result  = pg_query($db, $query);
      $user_id = pg_fetch_result($result, 0);

      $query = "SELECT user_picture FROM \"Users\" " .
               "WHERE user_id = '$user_id'";
      $results = pg_query($db, $query);
      $picture = pg_fetch_all($result);

      if($picture)
        $json_return = array_merge_recursive($json_return, array("user_picture" => $picture));
    }
?>