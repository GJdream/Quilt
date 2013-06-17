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

    cell.friendName.text = friendAtIndex.name;
    cell.friendPhoto.frame = cell.contentView.bounds;
    [cell addSubview:cell.friendPhoto];
    
    [cell.layer setMasksToBounds:YES];
    [cell.layer setCornerRadius:15];
    [cell.layer setRasterizationScale:[[UIScreen mainScreen] scale]];
    cell.layer.shouldRasterize = YES;
    cell.layer.opaque = YES;
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.shareEnabled) {
        Friend *friendAtIndex = [[FriendsDataController instantiate] friendInListAtIndex:indexPath.row];
        UIView *overlay = [[UIView alloc] initWithFrame:friendAtIndex.contentView.bounds];
        overlay.backgroundColor = [UIColor blackColor];
        overlay.alpha = 0.5f;
        [friendAtIndex addSubview:overlay];
        [self.selectedItems addObject:friendAtIndex];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.shareEnabled)
    {
        Friend *friendAtIndex = [[FriendsDataController instantiate] friendInListAtIndex:indexPath.row];
        [self.selectedItems removeObject:friendAtIndex];
    }
}

@end
