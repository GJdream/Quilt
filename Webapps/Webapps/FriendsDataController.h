//
//  FriendsDataController.h
//  Quilt
//
//  Created by Thomas, Anna E on 14/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FriendsViewController;
@class Friend;

@interface FriendsDataController : NSObject

@property (nonatomic) NSMutableArray *friendsArray;
@property (nonatomic) NSMutableArray *friendsDisplayArray;
@property FriendsViewController *friendsVC;

+ (void)setViewController:(FriendsViewController *)newVC;
+ (FriendsDataController *)instantiate;

- (FriendsDataController *)initWithViewController:(FriendsViewController *)friendsVC;
- (void)registerUpdate:(void (^)(void))updateMethod;
- (NSUInteger)countOfFriends;
- (Friend *)friendInListAtIndex:(NSUInteger)index;
- (void)addFriend:(NSString *)friend;
- (void)updateOnFriendInsertion;
- (void)updateOnFriendDeletion:(NSIndexPath *)indexPath;

- (void)showFriend:(NSString *)friend;
- (void)showAll;

@end
