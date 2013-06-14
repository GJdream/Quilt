//
//  ViewDeckController.m
//  Webapps
//
//  Created by Richard Jones on 10/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import "ViewDeckController.h"
#import "NavigationBarViewController.h"
#import "BookmarkViewController.h"
#import "BookmarkDataController.h"

@interface ViewDeckController ()

@end

@implementation ViewDeckController
/*
@synthesize navController = _navController;
@synthesize bookmarkView = _bookmarkView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Override point for customization after appliaction launch
    //UIViewController *viewController = [[viewController alloc] initWithNibName:@"ViewController" bundle:nil];
    //self.navController = [[UINavigationController alloc] initWithRootViewController:<#(UIViewController *)#>]
}
*/

- (id)init
{
    self = [super init];
    if (self) {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:nil];
        self.navigationControllerBehavior = IIViewDeckNavigationControllerContained;
        self.centerController = [mainStoryboard instantiateViewControllerWithIdentifier:@"mainNavController"];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:nil];
        self.navigationControllerBehavior = IIViewDeckNavigationControllerContained;
        self.centerController = [mainStoryboard instantiateViewControllerWithIdentifier:@"mainNavController"];
        self.leftController = [mainStoryboard instantiateViewControllerWithIdentifier:@"sidebarViewController"];
        CGRect rect = [[UIScreen mainScreen] bounds];
        CGSize size = rect.size;
        self.leftSize = size.width - 268.0f;
        self.centerhiddenInteractivity = IIViewDeckCenterHiddenNotUserInteractiveWithTapToClose;
        
        self.panningCancelsTouchesInView = NO;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:nil];
        self.navigationControllerBehavior = IIViewDeckNavigationControllerContained;
        self.centerController = [mainStoryboard instantiateViewControllerWithIdentifier:@"mainNavController"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.enabled = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
