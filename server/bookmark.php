<?php
  function createBookmark()
    {
      global $db;
      global $json_return;

      $owner   = $_SESSION[user_id];
      $link    = $_POST[url];
      $pheight = $_POST[p_height];
      $pwidth  = $_POST[p_width];
      $title   = $_POST[title];

      // discover user's id
      $query    = "SELECT user_id FROM \"Users\" " .
                  "WHERE user_name = '$owner'";
      $result   = pg_query($db, $query);
      $owner_id = pg_fetch_result($result, 0);

      // inserting bookmark
      $query   = "INSERT INTO \"Bookmarks\" (owner_id, url, p_height, p_width, title) " .
                 "VALUES ('$owner_id', '$link', '$pheight', '$pwidth', '$title') " .
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
        
        $json_return = array_merge($json_return, array("create_bookmark" => true, "b_id" => $post_id));
    }
    
  function destroyBookmark()
    {
      global $db;
      global $json_return;
      
      $success = true;

      $post_id = $_POST[post_id];
      $owner   = $_SESSION[user_id];

      // discover user's id
      $query    = "SELECT user_id FROM \"Users\" " .
                  "WHERE user_name = '$owner'";
      $result   = pg_query($db, $query);
      $owner_id = pg_fetch_result($result, 0);

      // must remove all referrences to given post from the following tables:
      //   - Bookmarks
      //   - Tags

      $query  = "DELETE FROM \"Bookmarks\" " .
                "WHERE owner_id = '$owner_id' AND post_id = '$post_id'";
      $result = pg_query($db, $query);
      
      if(!result)
      	$success = false;
      
      $query  = "DELETE FROM \"Tags\" " .
                "WHERE post_id = '$post_id'";
      $result = pg_query($db, $query);
      
      if(!result)
      	$success = false;
      
      $json_return = array_merge($json_return, array("delete_bookmark" => $success));
    }

  function resizeBookmark()
    {
      global $db;
      global $json_return;

      $postid  = $_POST[post_id];
      $owner   = $_SESSION[user_id];
      $link    = $_POST[url];
      $pheight = $_POST[p_height];
      $pwidth  = $_POST[p_width];

      // fetch the user's id
      $query     = "SELECT user_id FROM \"Users\" " .
                   "WHERE user_name = '$owner'";
      $result    = pg_query($db, $query);
      $owner_id  = pg_fetch_result($result, 0);

      $query   = "UPDATE \"Bookmarks\" " .
                 "SET p_height = 'pheight', p_width = 'pwidth' " .
                 "WHERE owner_id = '$owner_id' AND post_id = '$postid'";
      $result  = pg_query($db, $query);
      $success = pg_fetch_all($result);

      $json_return = array_merge($json_return, array("resize_bookmark" => !$success));
    }

  function getBookmarks()
    {
      global $db;
      global $json_return;

      $owner = $_SESSION[user_id];

      // fetch the user's id
      $query     = "SELECT user_id FROM \"Users\" " .
                   "WHERE user_name = '$owner'";
      $result    = pg_query($db, $query);
      $owner_id  = pg_fetch_result($result, 0);

      $query     = "SELECT * FROM \"Bookmarks\" " .
                   "WHERE owner_id = '$owner_id'";
      $result    = pg_query($db, $query);
      $bookmarks = pg_fetch_all($result);

      if($bookmarks)
        {
          $json_return = array_merge($json_return, array("bookmarks" => $bookmarks));
          
          foreach($bookmarks as $bm)
            getTagsForID($bm["post_id"]);
        }
    }

  // tag functionality is implemented here because 
  // it is so closely linked with bookmarks
  function createTag()
    {
      global $db;
      global $json_return;

      $post_id = $_POST[post_id];
      $tag     = $_POST[tag];

      $query   = "INSERT INTO \"Tags\" (post_id, tag) " .
                 "VALUES ('$post_id', '$tag')";
      $result  = pg_query($db, $result);
      $update  = pg_fetch_all($result);

      $json_return = array_merge($json_return, array("create_tag" => ($update == NULL)));
    }

  function destroyTag()
    {
      global $db;
      global $json_return;

      $username = $_SESSION[user_id];
      $post_id  = $_POST[post_id];
      $tag      = $_POST[tag];

      // fetch the user's id
      $query   = "SELECT user_id FROM \"Users\" " .
                 "WHERE user_name = '$username'";
      $result  = pg_query($db, $query);
      $user_id = pg_fetch_result($result, 0);

      // fetch tag's id
      $query   = "SELECT tag_id FROM \"Tags\" " .
                 "WHERE post_id = '$post_id' AND tag = '$tag'";
      $result  = pg_query($db, $query);
      $tag_id  = pg_fetch_result($result, 0);

      // delete the tag visibility
      $query   = "DELETE FROM \"Tag_Visibility\" " .
                 "WHERE tag_id = '$tag_id'";
      $result  = pg_query($db, $query);

      // delete the tag
      $query   = "DELETE FROM \"Tags\" " .
                 "WHERE post_id = '$post_id' AND tag = '$tag'";
      $result  = pg_query($db, $query);
      $update  = pg_fetch_all($result);
 
      $json_return = array_merge($json_return, array("destroy_tag" => ($update == NULL)));
    }

  function getTagsForID($post_id)
    {
      global $db;
      global $json_return;

      $query  = "SELECT tag FROM \"Tags\" " .
                "WHERE post_id = '$post_id'";
      $result = pg_query($db, $query);
      $tags   = pg_fetch_all_columns($result);

      if($tags)
        $json_return = array_merge_recursive($json_return, array("tags" => array($post_id => $tags)));
    }

  function getTags()
    {
      global $db;
      global $json_return;

      $post_id = $_GET[post_id];

      $query  = "SELECT tag FROM \"Tags\" " .
                "WHERE post_id = '$post_id'";
      $result = pg_query($db, $query);
      $tags   = pg_fetch_all_columns($result);

      if($tags)
        $json_return = array_merge_recursive($json_return, array("tags" => array($post_id => $tags)));
    }

  function getTagVisibility()
    {
      global $db;
      global $json_return;

      $tag_id = $_GET[tad_id];

      $query     = "SELECT visibile_to FROM \"Tag_Visibility\" " .
                   "WHERE tag_id = '$tag_id'";
      $result    = pg_query($db, $query);
      $visbility = pg_fetch_all_columns($result);

      if($visbility)
        $json_return = array_merge_recursive($json_return, array("get_tag_visibility" => array($tag_id => $visbility)));
    }

  function updateBookmarkPicture()
    {
      global $db;
      global $json_return;

      $username = $_SESSION[user_id];
      $picture  = file_get_contents($_FILES['picture']['tmp_name']);
      $picturesize = $_FILES['picture']['size'];

      // fetch id of user
      $query   = "SELECT user_id FROM \"Users\" " .
                 "WHERE user_name = '$username'";
      $result  = pg_query($db, $query);
      $user_id = pg_fetch_result($result, 0);
      
      $success = true;

      $query   = "SELECT bookmark_picture FROM \"Bookmarks\" " .
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

      $query   = "UPDATE \"Bookmarks\" " .
                 "SET bookmark_picture = '$$lo_id', bookmark_picture_size = '$picturesize' " .
                 "WHERE owner_id = '$user_id'";
      $result  = pg_query($db, $query);
      $update  = pg_fetch_all($result);
      $success = $success && ($update == NULL);
      
      $json_return = array_merge($json_return, array("update_bookmark_picture" => $success));
    }

  function getBookmarkPicture()
    {
      global $db;

      $username = $_SESSION[user_id];

      // fetch id of user
      $query    = "SELECT user_id FROM \"Users\" " .
                  "WHERE user_name = '$username'";
      $result   = pg_query($db, $query);
      $user_id  = pg_fetch_result($result, 0);

      $query    = "SELECT bookmark_picture FROM \"Bookmarks\" " .
                  "WHERE owner_id = '$user_id'";
      $result   = pg_query($db, $query);
      $lo_id    = pg_fetch_result($result, 0);
      $filesize = pg_fetch_result($result, 1);
      
      pg_query($db, "begin");
      $fd   = pg_lo_open($lo_id,"r");
      $data = pg_lo_read($fd, $filesize);
      pg_lo_close($fd);
      pg_query($db, "commit");

      header('Content-Type: image/png');
      echo $data;
    }
?>
