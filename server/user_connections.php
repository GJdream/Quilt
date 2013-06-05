<?php
  global $db;

  function createFriend()
    {
      $userid   = $_POST[user_id];
      $friendid = $_post[friend_id];

      $query  = "INSERT INTO \"Friends\" (user_id, friend_id) " .
                "VALUES ('$userid', '$friendid')";
      $result = pg_query($db, $result);
    }

  function destroyFriend()
    {
      $userid   = $_POST[user_id];
      $friendid = $_post[friend_id];

      $query  = "DELETE FROM \"Friends\" " .
                "WHERE user_id = '$userid' AND friend_id = '$friendid'";
      $result = pg_query($db, $query);
    }

  function createGroup()
    {
      $owner    = $_POST[owner];
      $ownerid  = $_POST[owner_id];

      $query    = "INSERT INTO \"Groups\" (group_owner, group_owner_id) " .
                  "VALUES ('$owner', '$ownerid') " .
                  "RETURNING group_id";
      $result   = pg_query($db, $result);
      $group_id = pg_fetch_result($result, 0);

      if($_POST[members])
        {
          addGroupMember($group_id);
        }
    }

  // this implementation assumes that there will usually be multiple
  // members being added to the group at once
  function addGroupMember($group_id)
    {
      // building array of members
      $members   = implode("','", $_POST[members]);
      $memberarr = "ARRAY['" . $members . "']"; // not used?

      foreach($members as $member)
        {
          $query  = "INSERT INTO \"Group_Members\" (group_id, member_id) " .
                    "VALUES ('$group_id', '$member')";
          $result = pg_query($db, $query);
          echo $result;
        }
    }

  function destroyGroup()
    {
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
    }

  function getFriends()
    {

    }

  function getGroupMembers()
    {

    }
?>