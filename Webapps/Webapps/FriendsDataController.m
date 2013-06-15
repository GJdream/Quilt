//
//  FriendsDataController.m
//  Quilt
//
//  Created by Thomas, Anna E on 14/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import "FriendsDataController.h"

@interface FriendsDataController ()
@property NSMutableArray *updatedFriends;
@property (readwrite) NSMutableDictionary *nameToFriend;
@end

@implementation FriendsDataController

- (FriendsDataController *)initWithViewController:(FriendsViewController *)bookmarkVC
{
    
}

+ (void)setViewController:(FriendsViewController *)newVC
{
    
}

+ (FriendsViewController *)instantiate
{
    
}

- (void)registerUpdate:(void (^)(void))updateMethod
{
    
}

- (NSUInteger)countOfBookmarks
{
    
}

- (Friend *)friendInListAtIndex:(NSUInteger)index
{
    
}

- (void)addFriend:(NSString *)friend
{
    
}

- (void)updateOnFriendInsertion
{
    
}

- (void)showFriend:(NSString *)friend
{
    
}

- (void)showAll
{
    
}


@end
