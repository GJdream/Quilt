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

@interface WebViewController ()

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
        //AddBookmarkViewController *addBookmarkVC = [[AddBookmarkViewController alloc] init];
        //IIViewDeckController *deckController = [[IIViewDeckController alloc] initWithCenterViewController:self topViewController:addBookmarkVC];
        
    }
    return self;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)done:(UIStoryboardSegue *)segue
{
    if ([[segue identifier] isEqualToString:@"ReturnInput"])
    {
        AddBookmarkViewController *addController = [segue sourceViewController];
        if (addController.bookmark)
        {
            [self.dataController addBookmark:addController.bookmark];
            // Call function to reload bookmarkDataController
            [self.dataController updateOnBookmarkInsertion];
            [NetworkClient createBookmark:addController.bookmark];
            
        }
//        [self dismissViewControllerAnimated:YES completion:NULL];
        /*UINavigationController *navController = self.navigationController;
        [navController popViewControllerAnimated:YES];*/
        [self.viewDeckController closeTopViewAnimated:YES];
        self.viewDeckController.topController = nil;
    }
}

- (IBAction)cancel:(UIStoryboardSegue *)segue
{
    if ([[segue identifier] isEqualToString:@"CancelInput"])
    {
        UINavigationController *navController = self.navigationController;
        [navController popViewControllerAnimated:YES];
        //[self dismissViewControllerAnimated:YES completion:NULL];
        [self.viewDeckController closeTopViewAnimated:YES];
        self.viewDeckController.topController = nil;
    }
}
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

/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddBookmarkSegue"])
    {
        AddBookmarkViewController *addBookmarkViewController = segue.destinationViewController;
        addBookmarkViewController.url = self.url;
    }
}
*/
@end
