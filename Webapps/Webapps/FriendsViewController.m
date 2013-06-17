//
//  FriendsViewController.m
//  Quilt
//
//  Created by Thomas, Anna E on 13/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import "FriendsViewController.h"
#import "FriendsDataController.h"
#import <QuartzCore/QuartzCore.h>
#import "NDTrie.h"
#import "Friend.h"
#import "NetworkClient.h"
#import "FriendsViewFlowLayout.h"

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

- (void)awakeFromNib
{
    [super awakeFromNib];
    [FriendsDataController setViewController:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.selectedItems = [[NSMutableArray alloc] init];
    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"QuiltTexture.png"]];
    if(!(self.shareEnabled || self.editEnabled))
        self.collectionView.allowsSelection = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[FriendsDataController instantiate] countOfFriends];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellID = @"FriendCell";

    Friend *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellID forIndexPath:indexPath];
    
    if(cell.dataFriend)
        cell.dataFriend.viewFriend = nil;
    
    cell.friendPhoto.image = nil;
    
    Friend *friendAtIndex = [[FriendsDataController instantiate] friendInListAtIndex:indexPath.row];
    
    cell.dataFriend = friendAtIndex;
    friendAtIndex.viewFriend = cell;
    
    if(friendAtIndex.image == nil)
        [NetworkClient getFriendPhoto:friendAtIndex];
    else
        cell.friendPhoto.image = friendAtIndex.image;
    
    CGRect frame = cell.friendPhoto.frame;
    
    cell.friendPhoto.frame = CGRectMake(5.0f, 5.0f, frame.size.width, frame.size.height);
    
    cell.friendName.text = friendAtIndex.name;
    //cell.friendPhoto.frame = cell.contentView.bounds;
    //[cell addSubview:cell.friendPhoto];
    
    [cell.friendPhoto.layer setMasksToBounds:YES];
    [cell.friendPhoto.layer setCornerRadius:15];
    [cell.friendPhoto.layer setRasterizationScale:[[UIScreen mainScreen] scale]];
    cell.friendPhoto.layer.shouldRasterize = YES;
    cell.friendPhoto.layer.opaque = YES;
    cell.friendPhoto.backgroundColor = [UIColor whiteColor];

    if(!cell.selectedBackgroundView)
        cell.selectedBackgroundView = [[UIView alloc] init];
    
    [cell.selectedBackgroundView.layer setMasksToBounds:YES];
    [cell.selectedBackgroundView.layer setCornerRadius:15];
    [cell.selectedBackgroundView.layer setRasterizationScale:[[UIScreen mainScreen] scale]];
    cell.selectedBackgroundView.layer.shouldRasterize = YES;
    cell.selectedBackgroundView.layer.opaque = YES;
    cell.selectedBackgroundView.backgroundColor = [UIColor lightGrayColor];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Friend *friendAtIndex = [[FriendsDataController instantiate] friendInListAtIndex:indexPath.row];
    friendAtIndex.viewFriend.selectedBackgroundView.layer.opaque = YES;
    
    if (self.shareEnabled)
        [self.selectedItems addObject:friendAtIndex];
    else if(self.editEnabled)
        [self.selectedItems addObject:friendAtIndex];
    else
        friendAtIndex.viewFriend.selectedBackgroundView.layer.opaque = NO;

}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Friend *friendAtIndex = [[FriendsDataController instantiate] friendInListAtIndex:indexPath.row];
    
    if(self.shareEnabled)
        [self.selectedItems removeObject:friendAtIndex];
    else if(self.editEnabled)
        [self.selectedItems removeObject:friendAtIndex];

}

- (IBAction)editFriendsClicked:(id)sender{
    if (self.editEnabled) {
        self.editEnabled = NO;
        self.deleteFriendsButton.enabled = NO;
        self.collectionView.allowsSelection = NO;
    }
    else
    {
        self.editEnabled = YES;
        self.deleteFriendsButton.enabled = YES;
        self.collectionView.allowsMultipleSelection = YES;
        self.collectionView.allowsSelection = YES;
    }
}

- (IBAction)deleteFriendsClicked:(id)sender {
    NSArray *selectedFriends = (NSArray*)self.selectedItems;
    NSLog(@"selectedFriends: %@", selectedFriends);
    for (NSString *badFriend in selectedFriends) {
        [NetworkClient removeFriend:badFriend];
    }
    self.deleteFriendsButton.enabled = NO;
    //self.collectionView.allowsSelection = NO;
}

@end
