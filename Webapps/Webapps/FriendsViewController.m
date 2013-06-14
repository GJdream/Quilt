//
//  FriendsViewController.m
//  Quilt
//
//  Created by Thomas, Anna E on 13/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import "FriendsViewController.h"
#import "FriendsDataController.h"
#import "NDTrie.h"

@interface FriendsViewController ()

@end

@implementation FriendsViewController

NSArray *tableData;

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
    self.searchBar.delegate = (id)self;
    /*
    tableData = [[FriendsDataController instantiate].friendTrie everyObject];
    [[FriendsDataController instantiate]registerUpdate:^(void)
     {
         tableData = [[FriendsDataController instantiate].friendTrie everyObject];
         [self.collectionView reloadData];
     }];
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
