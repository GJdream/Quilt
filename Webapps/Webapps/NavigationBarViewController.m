//
//  NavigationBarViewController.m
//  Webapps
//
//  Created by Richard Jones on 10/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import "NavigationBarViewController.h"

@implementation NavigationBarViewController

#define NUMBER_OF_STATIC_CELLS 2
NSMutableArray *tableData;

/*
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navBarTexture.png"]];
    }
    return self;
}
*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Initialize table data
    tableData = [NSMutableArray arrayWithObjects:@"Social", @"Twitter", @"Cats", @"Funny", @"Videos", nil];
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
        {
            staticCellID = @"TableSearch";
        } else if (cellNum == 1)
        {
            staticCellID = @"TableName";
        }
        
        cell = [tableView dequeueReusableCellWithIdentifier:staticCellID];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:staticCellID];
        }
        
        //cell.textLabel.text = staticCellID;
        
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
