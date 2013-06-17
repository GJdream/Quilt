//
//  ShareViewController.h
//  Quilt
//
//  Created by Richard Jones on 16/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FriendsViewController;

@interface ShareViewController : UIViewController

@property FriendsViewController *friendsViewController;
@property NSString *tag;
@property (weak, nonatomic) IBOutlet UIView *friendViewContainer;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
- (IBAction)shareButtonClick:(id)sender;

@end