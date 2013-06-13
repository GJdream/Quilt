# Functions recognised by listen.php

###### POST

action: new_account  
 -username  
 -password  

action: remove_account  
 -username  
 -password  

action: attempt_login  
 -username  
 -password  

action: logout_user  

action: new_bookmark  
 -username  
 -url  
 -p_height  
 -p_width  
 -tags {optional -> example format: tag1,tag2,tag3 }  

action: remove_bookmark  
 -post_id  
 -username  

action: new_tag  
 -post_id  
 -tag  

action: remove_tag  
 -post_id  
 -tag  

action: new_friend  
 -user_id  
 -friend_id  

action: remove_friend  
 -user_id  
 -friend_id  

action: new_group  
 -username  

action: add_group_member  
 -group_id  
 -members {example format: member1,member2,member3 }  

action: remove_group  
 -group_id  

action: new_picture  
 -username  
  
  
###### GET

action: get_bookmarks   

action: get_tags  
 -post_id  

action: get_friends  
  
action: get_group  
 -group_id

action: get_picture  
  