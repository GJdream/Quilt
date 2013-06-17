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
- (IBAction)pinchDetected:(id)sender;

@end