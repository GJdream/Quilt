//
//  UIBookmark.h
//  Webapps
//
//  Created by Richard Jones on 31/05/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBookmark : UIControl
    @property NSInteger height;
    @property NSInteger width;
    @property NSString *URL;

- (id)initWithFrame:(CGRect)frame Height:(NSInteger)initHeight Width:(NSInteger)initWidth URL:(NSString*)initURL;
@end
