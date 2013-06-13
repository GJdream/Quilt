//
//  WebViewController.m
//  Webapps
//
//  Created by Thomas, Anna E on 06/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import "WebViewController.h"
#import "AddBookmarkViewController.h"
#import "UIBookmark.h"
#import "NetworkClient.h"
#import "ViewDeckController.h"
#import "BookmarkDataController.h"
#import "AddBookmarkPopoverController.h"
#import "ScreenshotSelectionView.h"

@interface WebViewController ()
@property AddBookmarkPopoverController *addBookmarkPopover;
@end

@implementation WebViewController

@synthesize viewWeb;

- (IBAction)search {
    [viewWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString: [searchBar text]]]];
    self.url = [searchBar text];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    if(self.addBookmarkPopover.popoverVisible)
        [self.addBookmarkPopover dismissPopoverAnimated:YES];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString *fullURL = self.url;
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [viewWeb loadRequest:requestObj];
    viewWeb.scalesPageToFit = YES;
    searchBar.text = fullURL;
    
    [self takeScreenshot];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)addBookmarkClick:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:nil];
    AddBookmarkViewController *addBookmarkVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"addBookmarkViewController"];
    
    addBookmarkVC.url = self.url;
    
    if(!self.addBookmarkPopover)
        self.addBookmarkPopover = [[AddBookmarkPopoverController alloc] initWithContentViewController:addBookmarkVC];
    
    if(self.addBookmarkPopover.popoverVisible)
        [self.addBookmarkPopover dismissPopoverAnimated:YES];
    
    self.addBookmarkPopover.passthroughViews = nil;
    
    self.addBookmarkPopover.addBookmarkButton = self.addBookmarkButton;
    [self.addBookmarkPopover presentPopoverFromBarButtonItem:self.addBookmarkButton permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

- (IBAction)done:(UIStoryboardSegue *)segue
{
    if ([[segue identifier] isEqualToString:@"ReturnInput"])
    {
        AddBookmarkViewController *addController = [segue sourceViewController];
        if (addController.bookmark)
        {
            [[BookmarkDataController instantiate] addBookmark:addController.bookmark];
            // Call function to reload bookmarkDataController
            [[BookmarkDataController instantiate] updateOnBookmarkInsertion];
            [NetworkClient createBookmark:addController.bookmark];
            
        }
        [self.addBookmarkPopover dismissPopoverAnimated:YES];
        //self.addBookmarkButton.enabled = YES;
    }
}

- (void)takeScreenshot
{
    ScreenshotSelectionView *shotView = [[ScreenshotSelectionView alloc] initWithFrame:self.viewWeb.frame];
    [self.view addSubview:shotView];
    [self.view bringSubviewToFront:shotView];
}

- (IBAction)cancel:(UIStoryboardSegue *)segue
{
    if ([[segue identifier] isEqualToString:@"CancelInput"])
    {
        [self.addBookmarkPopover dismissPopoverAnimated:YES];
        //NSLog(@"Dismissed");
        //self.addBookmarkButton.enabled = YES;
    }
}
/*
- (IBAction)addBookmarkClick:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:nil];
    AddBookmarkViewController *addBookmarkViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"addBookmarkViewController"];
    addBookmarkViewController.url = self.url;
    IIViewDeckController *vdc = self.viewDeckController;
    [addBookmarkViewController removeFromParentViewController];
    [vdc addChildViewController:addBookmarkViewController];
    vdc.topSize = 500;
    vdc.topController = addBookmarkViewController;
    [vdc openTopViewAnimated:YES];
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}



@end
