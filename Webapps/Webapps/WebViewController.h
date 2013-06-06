//
//  WebViewController.h
//  Webapps
//
//  Created by Thomas, Anna E on 06/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIWebView *viewWeb;
@property (strong, nonatomic) NSString *url;

@end
