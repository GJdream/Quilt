//
//  BookmarkViewController.h
//  Webapps
//
//  Created by Thomas, Anna E on 05/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BookmarkDataController;

@interface BookmarkViewController : UICollectionViewController

@property (strong, nonatomic) IBOutlet UIPinchGestureRecognizer *pinchGestureRecogniser;
@property (strong, nonatomic) BookmarkDataController *dataController;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *deleteButton;
- (IBAction)pinchDetected:(id)sender;
- (IBAction)shareButtonClicked:(id)sender;

@end