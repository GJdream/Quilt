<?php
  global $db;

  function createBookmark()
    {
      $owner   = $_POST[owner];
      $link    = $_POST[url];
      $pheight = $_POST[p_height];
      $pwidth  = $_POST[p_width];

      $query  = "INSERT INTO \"Bookmarks\" (owner, url, p_height, p_width) " .
                "VALUES ('$owner', '$link', '$pheight', '$pwidth') " .
                "RETURNING post_id";
      echo $query;

      $result = pg_query($db, $query);
      echo $result;
      
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
              echo $result;
            }
        }
    }
    
  function removeBookmark()
    {
      $postid = $_POST[post_id];
      $owner  = $_POST[owner];

      // must remove all referrences to given post from the following tables:
      //   - Bookmarks
      //   - Bookmark_Visibility
      //   - Tags

      $query  = "DELETE FROM \"Bookmarks\"" .
                "WHERE owner_id = '$owner' AND post_id = '$post_id'";
      $result = pg_query($db, $query);

      $query  = "DELETE FROM \"Bookmark_Visibility\"" .
                "WHERE post_id = '$post_id'";
      $result = pg_query($db, $query);

      $query  = "DELETE FROM \"Tags\"" .
                "WHERE post_id = '$post_id'";
      $result = pg_query($db, $query);
    }

  function resizeBookmark()
    {
      $postid  = $_POST[post_id];
      $owner   = $_POST[owner];
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

    }

  // tag functionality is implemented here because 
  // it is so closely linked with bookmarks

  // will this be called on a per tag basis or always on arrays of tags?
  function createTag()
    {
      $postid = $_POST[post_id];
      $tag    = $_post[tag];

      $query  = "INSERT INTO \"Tags\" (post_id, tag) " .
                "VALUES ('$postid', '$tag')";
      $result = pg_query($db, $result);
    }

  function destroyTag()
    {
      $postid = $_POST[post_id];
      $tag    = $_post[tag];

      $query  = "DELETE FROM \"Tags\" " .
                "WHERE post_id = '$post_id' AND tag = '$tag'";
      $result = pg_query($db, $query);
    }

  function getTags()
    {

    }
?>
