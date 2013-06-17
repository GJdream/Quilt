//
//  FriendsViewController.h
//  Quilt
//
//  Created by Thomas, Anna E on 13/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FriendsDataController;

@interface FriendsViewController : UICollectionViewController

@property NSMutableArray *selectedItems;
@property (strong, nonatomic) FriendsDataController *dataController;
@property BOOL shareEnabled;

@end
