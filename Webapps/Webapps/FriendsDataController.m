//
//  FriendsDataController.m
//  Quilt
//
//  Created by Thomas, Anna E on 14/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import "FriendsDataController.h"
#import "FriendsViewController.h"
#import "NetworkClient.h"

@interface FriendsDataController ()
@property NSMutableArray *updatedFriends;
@property NSMutableArray *watchingMethods;
@end

@implementation FriendsDataController

static FriendsDataController *instance = nil;
static FriendsViewController *staticVC = nil;

- (FriendsDataController *)initWithViewController:(FriendsViewController *)friendsVC
{
    if(self = [super init])
    {
        _friendsArray = [[NSMutableArray alloc] init];
        _friendsDisplayArray = _friendsArray;
        _updatedFriends = [[NSMutableArray alloc] init];
        _watchingMethods = [[NSMutableArray alloc] init];
        _friendsVC = friendsVC;
        [NetworkClient getNewFriends];
    }
    return self;
}

+ (void)setViewController:(FriendsViewController *)newVC
{
    staticVC = newVC;
    if (instance)
        instance.friendsVC = newVC;
}

+ (FriendsDataController *)instantiate
{
    if (!instance)
        instance = [[FriendsDataController alloc] initWithViewController:staticVC];
    return instance;
}

- (void)registerUpdate:(void (^)(void))updateMethod
{
    [self.watchingMethods addObject:updateMethod];
}

- (void)setFriendsArray:(NSMutableArray *)newArray
{
    if(_friendsArray != newArray)
    {
        _friendsArray = [newArray mutableCopy];
    }
}

- (id)init
{
    if (self = [super init])
    {
        _friendsArray = [[NSMutableArray alloc] init];
        _friendsDisplayArray = _friendsArray;
        _updatedFriends = [[NSMutableArray alloc] init];
        _watchingMethods = [[NSMutableArray alloc] init];
        [NetworkClient getNewFriends];
    }
    return self;
}

- (NSUInteger)countOfFriends
{
    return 0;
}

- (Friend *)friendInListAtIndex:(NSUInteger)index
{
    return [self.friendsDisplayArray objectAtIndex:index];
}

- (void)addFriend:(NSString *)friend
{
    [self.friendsArray addObject:friend];
    NSUInteger index = [self.friendsArray indexOfObject:friend];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.updatedFriends addObject:indexPath];
}

- (void)deleteFriend:(Friend *)friend
{
    // TODO
}

- (void)updateOnFriendInsertion
{
    if (self.updatedFriends && self.updatedFriends.count > 0)
        [self.friendsVC.collectionView insertItemsAtIndexPaths:(NSArray *)self.updatedFriends];
    [self.updatedFriends removeAllObjects];
    
    for (void (^f)(void) in self.watchingMethods)
        f();
}

- (void)updateOnFriendDeletion:(NSIndexPath *)indexPath
{
    // TODO
}

- (void)showFriend:(NSString *)friend
{
    // Not sure if needed
}

- (void)showAll
{
    NSUInteger prevCount = self.friendsDisplayArray.count;
    [self.updatedFriends removeAllObjects];
    for (NSUInteger i = 0; i < prevCount; ++i)
    {
        [self.updatedFriends addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    self.friendsDisplayArray = nil;
    
    [self.friendsVC.collectionView deleteItemsAtIndexPaths:self.updatedFriends];
    
    [self.updatedFriends removeAllObjects];
    
    self.friendsDisplayArray = self.friendsArray;
    
    for (NSUInteger i = 0; i < [self countOfFriends]; ++i)
    {
        [self.updatedFriends addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    [self.friendsVC.collectionView insertItemsAtIndexPaths:(NSArray*)self.updatedFriends];
}


@end
