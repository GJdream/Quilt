//
//  FriendsDataController.h
//  Quilt
//
//  Created by Thomas, Anna E on 14/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NDMutableTrie;
@class FriendsViewController;
@class Friend;

@interface FriendsDataController : NSObject

@property (nonatomic, copy) NSMutableArray *friendsArray;
@property (nonatomic, copy) NSMutableArray *friendsDisplayArray;
@property FriendsViewController *friendsVC;
@property NDMutableTrie *friendTrie;

+ (void)setViewController:(FriendsViewController *)newVC;
+ (FriendsViewController *)instantiate;

- (FriendsDataController *)initWithViewController:(FriendsViewController *)bookmarkVC;
- (void)registerUpdate:(void (^)(void))updateMethod;
- (NSUInteger)countOfBookmarks;
- (Friend *)friendInListAtIndex:(NSUInteger)index;
+ (void)addFriend:(NSString *)friend;
- (void)updateOnFriendInsertion;
- (void)showFriend:(NSString *)friend;
- (void)showAll;

@end
