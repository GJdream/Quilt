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
#import "Account.h"

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
        
        if (cellNum == 0)
            staticCellID = @"TableName";
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
        cell.detailTextLabel.text = @"";
        [Account getTagOwner:cell];
        //cell.detailTextLabel.text = [tableData objectAtIndex:cellNum - NUMBER_OF_STATIC_CELLS];
        cell.indentationWidth = 10;
        
        UIImage *image = [UIImage imageNamed:@"share_arrow.png"] ;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
        button.frame = frame;	// match the button's size with the image size
        
        [button setBackgroundImage:image forState:UIControlStateNormal];
        
        // set the button's target to this table view controller so we can interpret touch events and map that to a NSIndexSet
        [button addTarget:self action:@selector(arrowButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor clearColor];
        cell.accessoryView = button;
    

                
    }
    return cell;
}

- (void)arrowButtonTapped:(id)sender event:(id)event
{
	NSSet *touches = [event allTouches];
	UITouch *touch = [touches anyObject];
	CGPoint currentTouchPosition = [touch locationInView:self.tableView];
	NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
	if (indexPath != nil)
	{
		[self tableView: self.tableView accessoryButtonTappedForRowWithIndexPath: indexPath];
	}
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger cellNum = indexPath.row;
    CGFloat customTableCellHeight = 44.0;
    
    if (cellNum < NUMBER_OF_STATIC_CELLS)
    {
        if (cellNum == 0) 
            customTableCellHeight = 160;
        if (cellNum == 1)
            customTableCellHeight = 44;
        if (cellNum == 2)
            customTableCellHeight = 44;
        if (cellNum == 3)
            customTableCellHeight = 60;
    }
    return customTableCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *selectedCell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.row == 0)
    {
        BookmarkDataController *bookmarkDC = [BookmarkDataController instantiate];
        [bookmarkDC showAll];
        bookmarkDC.bookmarkVC.navigationItem.title = @"Quilt";
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
        [Account logoutUser];
    }
    
    else {
        BookmarkDataController *bookmarkDC = [BookmarkDataController instantiate];
        [bookmarkDC showTag:selectedCell.textLabel.text];
        NSArray *title = [[NSArray alloc] initWithObjects:@"Quilt - ", selectedCell.textLabel.text, nil];
        bookmarkDC.bookmarkVC.navigationItem.title = [title componentsJoinedByString:@""];
        //[self tableView: self.tableView accessoryButtonTappedForRowWithIndexPath: indexPath];
    }
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *selectedCell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
	BookmarkDataController *bookmarkDC = [BookmarkDataController instantiate];
    bookmarkDC.sharingTag = selectedCell.textLabel.text;
    NSLog(@"%@", bookmarkDC.sharingTag);
	[bookmarkDC.bookmarkVC performSegueWithIdentifier:@"shareSegue" sender:self];
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
