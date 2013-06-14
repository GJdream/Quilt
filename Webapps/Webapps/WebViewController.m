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
@property UIPopoverController *addBookmarkPopover;
@property ScreenshotSelectionView *shotView;
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
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done:(UIStoryboardSegue *)segue
{
    if ([[segue identifier] isEqualToString:@"ReturnInput"])
    {
        NSLog(@"done");
        AddBookmarkViewController *addController = [segue sourceViewController];
        if (addController.bookmark)
        {
            NSLog(@"done");
            self.shotView = [[ScreenshotSelectionView alloc] init];
            
            [self.shotView setScreenshotTakenFunction:^(UIImage *image){
                addController.bookmark.imageView.image = image;
                [[BookmarkDataController instantiate] addBookmark:addController.bookmark];
                // Call function to reload bookmarkDataController
                [[BookmarkDataController instantiate] updateOnBookmarkInsertion];
                [NetworkClient createBookmark:addController.bookmark];
            }];
            
            self.shotView.frame = self.view.frame;
            [self.view addSubview:self.shotView];
            [self.view bringSubviewToFront:self.shotView];
            self.shotView.backgroundColor = [[UIColor alloc] initWithWhite:0.0f alpha:0.0f];
            self.viewDeckController.enabled = NO;
        }
        [self.addBookmarkPopover dismissPopoverAnimated:YES];
        
        //self.addBookmarkButton.enabled = YES;
    }
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
    if ([segue.identifier isEqualToString:@"addBookmarkSegue"])
    {
        if(self.addBookmarkPopover.popoverVisible)
            [self.addBookmarkPopover dismissPopoverAnimated:YES];

        AddBookmarkViewController *addBookmarkViewController = segue.destinationViewController;
        addBookmarkViewController.url = self.url;
        self.addBookmarkPopover = [(UIStoryboardPopoverSegue *)segue popoverController];
    }
}



@end
