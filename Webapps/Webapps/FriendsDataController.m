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
#import "Friend.h"
#import "NDTrie.h"

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
        _friendTrie = [[NDMutableTrie alloc] init];
        _friendsDictionary = [[NSMutableDictionary alloc] init];
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

+ (void)deleteInstance
{
    instance = nil;
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
    return self.friendsDisplayArray.count;
}

- (Friend *)friendInListAtIndex:(NSUInteger)index
{
    return [self.friendsDisplayArray objectAtIndex:index];
}

- (BOOL)containsFriend:(NSString *)name
{
    return [self.friendTrie containsObjectForKey:name];
}

- (void)addFriend:(NSString *)friendName
{
    if (![self containsFriend:friendName])
    {
        Friend *friend = [[Friend alloc] initWithUsername:friendName Image:nil];
        [self.friendsArray addObject:friend];
        [self.friendTrie addString:friendName];
        [self.friendsDictionary setObject:friend forKey:friendName];
        NSUInteger index = [self.friendsArray indexOfObject:friend];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self.updatedFriends addObject:indexPath];
    }
}

- (void)deleteFriend:(Friend *)friend
{
    NSUInteger index = [self.friendsArray indexOfObject:friend];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.friendsArray removeObject:friend];
    [self.friendsDictionary removeObjectForKey:friend.name];
    [self.updatedFriends removeObject:indexPath];
    [NetworkClient removeFriend:friend.name];
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

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    if(text.length == 0)
        [self showAll];
    else
    {
        NSString *searchItem;
        NDTrie *friendTrie = self.friendTrie;
        
        NSMutableArray *searchItems = [[NSMutableArray alloc] init];
        
        if([friendTrie containsObjectForKeyWithPrefix:text])
        {
            NSEnumerator *itemsEnumerator = [friendTrie objectEnumeratorForKeyWithPrefix:text];
            
            while ((searchItem = [self.friendsDictionary objectForKey:[itemsEnumerator nextObject]]))
                [searchItems addObject:searchItem];
        }
        
        NSUInteger prevCount = self.friendsDisplayArray.count;
        [self.updatedFriends removeAllObjects];
        for (NSUInteger i = 0; i < prevCount; ++i) {
            [self.updatedFriends addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        
        self.friendsDisplayArray = nil;
        
        [self.friendsVC.collectionView deleteItemsAtIndexPaths:self.updatedFriends];
        
        [self.updatedFriends removeAllObjects];
        
        self.friendsDisplayArray = searchItems;
        
        for (NSUInteger i = 0; i < self.friendsDisplayArray.count; ++i) {
            [self.updatedFriends addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        
        [self updateOnFriendInsertion];
    }
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
