//
//  ViewDeckController.h
//  Webapps
//
//  Created by Richard Jones on 10/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import "IIViewDeckController.h"
#import <UIKit/UIKit.h>

@interface ViewDeckController : IIViewDeckController

@property (nonatomic, retain) UINavigationController *navController;
@property (nonatomic, retain) IBOutlet UIView *bookmarkView;

@end
