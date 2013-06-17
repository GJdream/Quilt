//
//  WebViewController.h
//  Webapps
//
//  Created by Thomas, Anna E on 06/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate> {
    IBOutlet UIWebView *viewWeb;
    IBOutlet UITextField *searchBar;
}

@property (strong, nonatomic) IBOutlet UIWebView *viewWeb;
@property (strong, nonatomic) NSString *url;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addBookmarkButton;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forwardButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *reloadButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *stopButton;

- (IBAction)back;
- (IBAction)forward;
- (IBAction)reload;
- (IBAction)stop;

- (IBAction)done:(UIStoryboardSegue *)segue;
- (IBAction)cancel:(UIStoryboardSegue *)segue;
- (IBAction)search;

@end