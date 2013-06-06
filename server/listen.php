#!/usr/bin/php
<?php 
  ob_start(); 
  session_start();
    // the session must be initialized before any headers are set {ie; before anything is outputted}
    // this way each user has a session which can then be validated to keep the system secure
    // ob_start() clears the output from #!/usr/bin/php 
    // which would set a header otherwise, which has been making session_start() unuseable

  global $db;
  global $json_return;
  $json_return = array();

  require_once('db_connect.php');
  require('validation.php');
  require('register.php');
  require('login.php');
  require('user_connections.php');
  require('bookmark.php');
  require('registered_only.php');

  if(function_exists('get_magic_quotes_gpc') && get_magic_quotes_gpc())
    {
      function undo_magic_quotes_gpc($arr)
        {
          foreach($arr as &$value)
            {
              if(is_array($value))
                {
                  undo_magic_quotes_gpc($value);
                }
              else
                {
                  $value = stripslashes($value);
                }
            }
        }

      undo_magic_quotes_gpc($_POST);
      undo_magic_quotes_gpc($_GET);
      undo_magic_quotes_gpc($_COOKIE);
    }

  if($_SERVER[REQUEST_METHOD] === "POST")
    {
      if($_POST['action'] === "new_account")
        register();
      else if($_POST['action'] === "remove_account")
        unregister();
      else if($_POST['action'] === "attempt_login")
        attemptUserLogin();
      else if($_POST['action'] === "logout_user")
        logoutUser();
      else if($_POST['action'] === "new_bookmark")
        createBookmark();
      else if($_POST['action'] === "remove_bookmark")
        destroyBookmark();
      else if($_POST['action'] === "new_tag")
        createTag();
      else if($_POST['action'] === "remove_tag")  
        destroyTag();
      else if($_POST['action'] === "new_friend")
        createFriend();
      else if($_POST['action'] === "remove_friend")
        destroyFriend();
      else if($_POST['action'] === "new_group")
        createGroup();
      else if($_POST['action'] === "add_group_member")
        addGroupMember($_POST[group_id]);
      else if($_POST['action'] === "remove_group")
        destroyGroup();
    }
  else if($_SERVER[REQUEST_METHOD] === "GET")
    {
      // Return JSON representation of queries
      // This allows us to use pre-existing iOS libraries to parse it
      // This is good because I'm lazy
      if($_GET['action'] === "get_bookmarks")
        getBookmarks();
      else if($_GET['action'] === "get_tags")
        getTags();
      else if($_GET['action'] === "get_friends")
        getFriends();
      else if($_GET['action'] === "get_group")
        getGroupMembers();
    }
  
  echo json_encode($json_return);
?>