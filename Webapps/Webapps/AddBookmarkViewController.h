//
//  AddBookmarkViewController.h
//  Webapps
//
//  Created by Richard on 06/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIBookmark.h"

@interface AddBookmarkViewController : UITableViewController <UIPopoverControllerDelegate, UITextFieldDelegate, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleInput;
@property (weak, nonatomic) IBOutlet UITextField *urlInput;
@property (weak, nonatomic) IBOutlet UITextField *tagsInput;

@property (strong, nonatomic) UIBookmark *bookmark;
@property (strong, nonatomic) NSString *url;

@property (weak, nonatomic) IBOutlet UIButton *infoButton;

- (IBAction)infoButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;

@end
