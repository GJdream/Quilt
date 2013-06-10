//
//  ViewDeckController.m
//  Webapps
//
//  Created by Richard Jones on 10/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import "ViewDeckController.h"

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
        self.leftSize = 500.0f;
        self.centerhiddenInteractivity = IIViewDeckCenterHiddenNotUserInteractiveWithTapToClose;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
