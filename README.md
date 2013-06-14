# WebApps 2013

  
## TODO

 - Set-up Database {Complete}  
 - Server side code to get commands from network to serve DB  
    - Link DB with PHP {Complete}
    - Need to be able to listen on network and return requested data {Complete}  
    - Change password code {FIXED}  
    - Change profile picture code {FIXED}  
    - Friend addition/deletion/sharing {In Progress}  

 - GUI: {In Progress}
    - Bookmark view {In progress}
        - Friend share button on dynamic cells
        - Tag buttons
    - Friend view and data controller

 - Networking Code
    - Add logout functionality
    - Send images to and from database
    - Friends

 - Graphics
    - Background colour/image
    - Quilt logo resized in photoshop to fit login/nav bar

#### Current Plan:  
Postgres DB as provided by CSG + PHP server  
{self-hosted -> intergration with DoC will come later if required}  
Output queries in JSON {Working - has been merged into master by Richard}



###### Functions to implement:
All functions aside from get requests are currently implemented. Once this is done application functionality will be pulled out to a seperate .md file for ease of reading.
  

  
  
## Database Notes

 - Storage of User information
 - Height and Width of each bookmark panel
 - Bookmark URLs
 - Associated tags  

Since we are unaware how many tags people want to associate/how many people will be in a group we have split the tables. There is a seperate table for tags which has two columns. Each row has the post_id that this particular tag belongs to. When querying for tags they are all returned in an array. Friends work in a similar fashion.


## Meetings Schedule

 - Past Meetings  
    - Tuesday 21st May  
    - Friday 24th May  
    - Monday 27th May  
    - Wednesday 29th May  
    - Thursday 30th May  
    - Tuesday 4th June 
    
 - Next Meetings  
    - Monday 10th June  
    - Wednesday 12th June  
