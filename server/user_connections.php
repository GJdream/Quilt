<?php
  function createFriend()
    {
      global $db;

      $user_id   = $_POST[user_id];
      $friend_id = $_post[friend_id];

      $query  = "INSERT INTO \"Friends\" (user_id, friend_id) " .
                "VALUES ('$user_id', '$friend_id')";
      $result = pg_query($db, $result);
      
      echo json_encode($result);
    }

  function destroyFriend()
    {
      global $db;

      $user_id   = $_POST[user_id];
      $friend_id = $_post[friend_id];

      $query  = "DELETE FROM \"Friends\" " .
                "WHERE user_id = '$user_id' AND friend_id = '$friend_id'";
      $result = pg_query($db, $query);
      
      echo json_encode($result);
    }

  function getFriends()
    {
      global $db;

      $owner = $_GET[username];

      // discover user's id
      $query    = "SELECT user_id FROM \"Users\" " .
                  "WHERE user_name = '$owner'";
      $result   = pg_query($db, $query);
      $owner_id = pg_fetch_result($result, 0);

      $query   = "SELECT * FROM \"Friends\" " .
                 "WHERE owner_id = '$owner_id'";
      $result  = pg_query($db, $query);
      $friends = pg_fetch_all($result);

      echo json_encode($friends);
    }

  function createGroup()
    {
      global $db;

      $owner    = $_POST[username];
      $owner_id  = $_POST[user_id];

      $query    = "INSERT INTO \"Groups\" (group_owner, group_owner_id) " .
                  "VALUES ('$owner', '$owner_id') " .
                  "RETURNING group_id";
      $result   = pg_query($db, $result);
      $group_id = pg_fetch_result($result, 0);

      if($_POST[members])
        {
          if(!addGroupMember($group_id))
          	echo json_encode(false);
          	return;
        }
      
      echo json_encode($result);
    }

  // this implementation assumes that there will usually be multiple
  // members being added to the group at once
  function addGroupMember($group_id)
    {
      global $db;

      // building array of members
      $members   = implode("','", $_POST[members]);
      $memberarr = "ARRAY['" . $members . "']"; // not used?

      foreach($members as $member)
        {
          $query  = "INSERT INTO \"Group_Members\" (group_id, member_id) " .
                    "VALUES ('$group_id', '$member')";
          $result = pg_query($db, $query);
          //echo $result;
          if(!$result)
          {
          	echo json_encode(false);
          	return;
          }
        }
    }

  function destroyGroup()
    {
      global $db;

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
      
      echo json_encode($result);   
    }

  function getGroupMembers()
    {
      global $db;

      $group_id = $_GET[group_id];

      $query   = "SELECT * FROM \"Group_Members\" " .
                 "WHERE group_id = '$group_id'";
      $result  = pg_query($db, $query);
      $members = pg_fetch_all($result);

      echo json_encode($members);
    }
?>