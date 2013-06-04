# WebApps 2013

  
## TODO

 - Set-up Database {Complete}  
 - Server side code to get commands from network to serve DB  
    - Link DB with PHP {Complete}
    - Need to be able to listen on network and return requested data {In Progress}  
      - Fill DB with junk data for testing throughout  

 - every request from app needs ID in it  
    - hash request with hash of user password  

 - Client-side code: {In Progress}  
    - junk data in DB to test app drawing  
    - networking code on iPad also  

#### Current Plan:  
Postgres DB as provided by CSG + PHP server  
{self-hosted -> intergration with DoC will come later if required}  




###### Functions to implement:

 - remove bookmarks
 - update bookmarks
 - create group
 - get all bookmarks
 - get all tags {from specific user}
 - share tags
 - remove account
 - remove groups
 - edit groups
 - add friends
 - remove friends
 - {if you think of more, feel free to add to this list}
  

  
  
## Database Notes

 - Storage of User information
 - Height and Width of each bookmark panel
 - Bookmark URLs
 - Associated tags  

Since we are unaware how many tags people want to associate/how many people will be in a group we have split the tables. There is a seperate table for tags which has two columns. Each row has the post_id that this particular tag belongs to. When querying for tags all responces can be collated with a JOIN.


## Meetings Schedule

 - Past Meetings  
    - Tuesday 21st May  
    - Friday 24th May  
    - Monday 27th May  
    - Wednesday 29th May  
    - Thursday 30th May  
   
 - Next Meetings  
    - Tuesday 4th June  
    - Friday 7th June  
    - Monday 10th June  
    - Wednesday 12th June  
