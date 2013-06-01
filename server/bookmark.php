
<?php

  function createBookmark()
    {
      global $db;

      $postid  = $_POST[post_id];
      $owner   = $_POST[owner];
      $link    = $_POST[url];
      $pheight = $_POST[p_height];
      $pwidth  = $_POST[p_width];

      // building array of tags
      $tags   = implode("','", $_POST[tags]);
      $tagarr = "ARRAY['" . $tags . "']";

      $query  = "INSERT INTO \"Bookmarks\" (post_id, owner, url, p_height, p_width, tags) " .
                "VALUES ('$postid', '$owner', '$link', '$pheight', '$pwidth', ARRAY['$tags'])";
      echo $query;

      $result = pg_query($db, $query);
      echo $result;
    }

  function resizeBookmark()
    {
      global $db;

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

?>