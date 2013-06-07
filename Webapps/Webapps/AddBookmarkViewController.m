//
//  AddBookmarkViewController.m
//  Webapps
//
//  Created by Richard on 06/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import "AddBookmarkViewController.h"
#import "UIBookmark.h"

@interface AddBookmarkViewController ()

@end

@implementation AddBookmarkViewController

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ((textField == self.titleInput) || (textField == self.urlInput) || (textField == self.tagsInput))
    {
        [textField resignFirstResponder];
    }
    return YES;
}

/*
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.urlInput.text = self.url;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ReturnInput"])
    {
        if ([self.titleInput.text length] || [self.urlInput.text length] || [self.tagsInput.text length])
        {
            NSMutableArray *tags = [[NSMutableArray alloc] init];
            NSCharacterSet *chars = [NSCharacterSet characterSetWithCharactersInString:@", "];
            [tags addObjectsFromArray:([self.tagsInput.text componentsSeparatedByCharactersInSet:chars])];
            UIBookmark *bookmark = [[UIBookmark alloc] initWithTitle:self.titleInput.text URL:self.urlInput.text Tags:tags Width:1 Height:1];
            self.bookmark = bookmark;
        }
    }
}

@end
