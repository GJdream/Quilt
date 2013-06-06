<?php
  function createBookmark()
    {
      global $json_return;
      global $db;

      $owner   = $_POST[username];
      $link    = $_POST[url];
      $pheight = $_POST[p_height];
      $pwidth  = $_POST[p_width];

      // discover user's id
      $query    = "SELECT user_id FROM \"Users\" " .
                  "WHERE user_name = '$owner'";
      $result   = pg_query($db, $query);
      $owner_id = pg_fetch_result($result, 0);

      // inserting bookmark
      $query   = "INSERT INTO \"Bookmarks\" (owner_id, url, p_height, p_width) " .
                 "VALUES ('$owner_id', '$link', '$pheight', '$pwidth') " .
                 "RETURNING post_id";
      $result  = pg_query($db, $query);     
      $post_id = pg_fetch_result($result, 0);
      
      if($_POST[tags])
        {
          // building array of tags
          $tags   = implode("','", $_POST[tags]);
          $tagarr = "ARRAY['" . $tags . "']";

          foreach($tags as $tag)
            {
              $query  = "INSERT INTO \"Tags\" (post_id, tag) " .
                        "VALUES ('$post_id', '$tag')";
              $result = pg_query($db, $query);
            }
        }
        
        $json_return = array_merge($json_return, array("create_bookmark" => true));
    }
    
  function destroyBookmark()
    {
      global $db;
      global $json_return;
      
      $success = true;

      $post_id = $_POST[post_id];
      $owner   = $_POST[username];


      // discover user's id
      $query    = "SELECT user_id FROM \"Users\" " .
                  "WHERE user_name = '$owner'";
      $result   = pg_query($db, $query);
      $owner_id = pg_fetch_result($result, 0);

      // must remove all referrences to given post from the following tables:
      //   - Bookmarks
      //   - Bookmark_Visibility
      //   - Tags

      $query  = "DELETE FROM \"Bookmarks\" " .
                "WHERE owner_id = '$owner_id' AND post_id = '$post_id'";
      $result = pg_query($db, $query);
      
      if(!result)
      	$success = false;

      $query  = "DELETE FROM \"Bookmark_Visibility\" " .
                "WHERE post_id = '$post_id'";
      $result = pg_query($db, $query);
      
      if(!result)
      	$success = false;
      
      $query  = "DELETE FROM \"Tags\" " .
                "WHERE post_id = '$post_id'";
      $result = pg_query($db, $query);
      
      if(!result)
      	$success = false;
      
      $json_return = array_merge($json_return, array("delete_bookmark" => success));
    }

  function resizeBookmark()
    {
      global $db;

      $postid  = $_POST[post_id];
      $owner   = $_POST[username];
      $link    = $_POST[url];
      $pheight = $_POST[p_height];
      $pwidth  = $_POST[p_width];

      $query  = "UPDATE \"Bookmarks\" " .
                "SET p_height = 'pheight', p_width = 'pwidth' " .
                "WHERE owner = '$owner' AND post_id = '$postid'";
      $result = pg_query($db, $query);
    }

  function getBookmarks()
    {
      global $db;
      global $json_return;

      $owner = $_GET[username];

      // discover user's id
      $query    = "SELECT user_id FROM \"Users\" " .
                  "WHERE user_name = '$owner'";
      $result   = pg_query($db, $query);
      $owner_id = pg_fetch_result($result, 0);

      $query  = "SELECT * FROM \"Bookmarks\" " .
                "WHERE owner_id = '$owner_id'";
      $result = pg_query($db, $query);
      $bookmarks = pg_fetch_all($result);

      $json_return = array_merge($json_return, array("bookmarks" => $bookmarks));
    }

  // tag functionality is implemented here because 
  // it is so closely linked with bookmarks

  // will this be called on a per tag basis or always on arrays of tags?
  function createTag()
    {
      global $db;

      $post_id = $_POST[post_id];
      $tag    = $_post[tag];

      $query  = "INSERT INTO \"Tags\" (post_id, tag) " .
                "VALUES ('$post_id', '$tag')";
      $result = pg_query($db, $result);
    }

  function destroyTag()
    {
      global $db;

      $post_id = $_POST[post_id];
      $tag    = $_post[tag];

      $query  = "DELETE FROM \"Tags\" " .
                "WHERE post_id = '$post_id' AND tag = '$tag'";
      $result = pg_query($db, $query);
    }

  function getTags()
    {
      global $db;
      global $json_return;

      $post_id = $_GET[post_id];

      $query  = "SELECT * FROM \"Tags\" " .
                "WHERE post_id = '$post_id'";
      $result = pg_query($db, $query);
      $tags   = pg_fetch_all($result);

      $json_return = array_merge($json_return, array("tags" => $tags));
    }
?>
