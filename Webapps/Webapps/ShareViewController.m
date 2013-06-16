//
//  ShareViewController.m
//  Quilt
//
//  Created by Richard Jones on 16/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import "ShareViewController.h"
#import "FriendsViewController.h"
#import "NetworkClient.h"
#import "BookmarkDataController.h";

@interface ShareViewController ()

@end

@implementation ShareViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.friendsViewController.collectionView.allowsMultipleSelection = YES;
    self.friendsViewController.shareEnabled = YES;
    self.tag = @"web";
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.friendsViewController.collectionView.allowsMultipleSelection = NO;
    self.friendsViewController.shareEnabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)shareButtonClick:(id)sender {
    NSArray *selectedFriends = (NSArray*)self.friendsViewController.selectedItems;
    [NetworkClient shareTag:[BookmarkDataController instantiate].sharingTag WithFriends:selectedFriends];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"friendEmbedSegue"]) {
        self.friendsViewController = (FriendsViewController*)[segue destinationViewController];
    }
}

@end
