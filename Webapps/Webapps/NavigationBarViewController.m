//
//  NavigationBarViewController.m
//  Webapps
//
//  Created by Richard Jones on 10/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import "NavigationBarViewController.h"
#import "NDTrie.h"
#import "BookmarkDataController.h"
#import "BookmarkViewController.h"

@implementation NavigationBarViewController

#define NUMBER_OF_STATIC_CELLS 4
NSArray *tableData;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchBar.delegate = (id)self;
    tableData = [[BookmarkDataController instantiate].tagTrie everyObject];
    [[BookmarkDataController instantiate]registerUpdate:^(void)
        {
            tableData = [[BookmarkDataController instantiate].tagTrie everyObject];
            [self.tableView reloadData];
        }];
}

- (void)viewDidAppear:(BOOL)animated
{
    CGRect newRect = self.tableView.frame;
    newRect.size.width = 268;
    self.tableView.frame = newRect;
}

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    if(text.length == 0)
    {
        tableData = [[BookmarkDataController instantiate].tagTrie everyObject];
        [self.tableView reloadData];
    }
    else
    {
        NSString *searchItem;
        NDTrie *tagTrie = [BookmarkDataController instantiate].tagTrie;
        
        NSMutableArray *searchItems = [[NSMutableArray alloc] init];
        
        if([tagTrie containsObjectForKeyWithPrefix:text])
        {
            NSEnumerator *itemsEnumerator = [tagTrie objectEnumeratorForKeyWithPrefix:text];

            while (searchItem = [itemsEnumerator nextObject])
            {
                [searchItems addObject:searchItem];
            }
        }
        
        tableData = searchItems;
        [self.tableView reloadData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count] + NUMBER_OF_STATIC_CELLS;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger cellNum = indexPath.row;
    UITableViewCell *cell;
    
    if (cellNum < NUMBER_OF_STATIC_CELLS)
    {
        NSString *staticCellID;
        
        if (cellNum == 0) {
            staticCellID = @"TableName";
        }
        if (cellNum == 1)
            staticCellID = @"MyAccount";
        if (cellNum == 2)
            staticCellID = @"MyFriends";
        if (cellNum == 3)
            staticCellID = @"LogOut";
        
        cell = [tableView dequeueReusableCellWithIdentifier:staticCellID];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:staticCellID];
           
        }
    } else {
        NSString *dynamicCellID = @"TableItem";
        cell = [tableView dequeueReusableCellWithIdentifier:dynamicCellID];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:dynamicCellID];
        }
    
        cell.textLabel.text = [tableData objectAtIndex:cellNum - NUMBER_OF_STATIC_CELLS];
    }
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger cellNum = indexPath.row;
    CGFloat customTableCellHeight = 0.0;
    
    if (cellNum < NUMBER_OF_STATIC_CELLS)
    {
        if (cellNum == 0) 
            customTableCellHeight = 107;
        if (cellNum == 1)
            customTableCellHeight = 44;
        if (cellNum == 2)
            customTableCellHeight = 44;
        if (cellNum == 3)
            customTableCellHeight = 44;
    }
    return customTableCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *selectedCell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.row == 0)
    {
        [[BookmarkDataController instantiate] showAll];
    }
    
    else if (indexPath.row == 1)
    {
        [[BookmarkDataController instantiate].bookmarkVC performSegueWithIdentifier:@"myAccountSegue" sender:self];
    }
    else if (indexPath.row == 2)
    {
        [[BookmarkDataController instantiate].bookmarkVC performSegueWithIdentifier:@"friendsSegue" sender:self];
    }
    else if (indexPath.row == 3)
    {
        [[BookmarkDataController instantiate].bookmarkVC performSegueWithIdentifier:@"logOutSegue" sender:self];
        //Log out server
    }
    
    else [[BookmarkDataController instantiate] showTag:selectedCell.textLabel.text];
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
