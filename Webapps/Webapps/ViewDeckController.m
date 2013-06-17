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
        
        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
            self.leftSize = size.width - 268.0f;
        else
            self.leftSize = size.height - 268.0f;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
            selector:@selector(handleDidChangeStatusBarOrientationNotification:)
            name:UIApplicationDidChangeStatusBarOrientationNotification
            object:nil];
        
        self.centerhiddenInteractivity = IIViewDeckCenterHiddenNotUserInteractiveWithTapToClose;
        
        self.panningCancelsTouchesInView = NO;
    }
    return self;
}

- (void)handleDidChangeStatusBarOrientationNotification:(NSNotification *)notification;
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
        self.leftSize = size.width - 268.0f;
    else
        self.leftSize = size.height - 268.0f;
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
