
<?php

  function createBookmark()
    {
      global $db;

      $owner   = $_POST[owner];
      $link    = $_POST[url];
      $pheight = $_POST[p_height];
      $pwidth  = $_POST[p_width];

      // building array of tags
      $tags   = implode("','", $_POST[tags]);
      $tagarr = "ARRAY['" . $tags . "']";

      $query  = "INSERT INTO \"Bookmarks\" (owner, url, p_height, p_width, tags) " .
                "VALUES ('$owner', '$link', '$pheight', '$pwidth', ARRAY['$tags'])";
      echo $query;

      $result = pg_query($db, $query);
      echo $result;
    }

?>