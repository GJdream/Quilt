//
//  UIBookmark.m
//  Webapps
//
//  Created by Richard Jones on 31/05/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import "UIBookmark.h"

@implementation UIBookmark

- (id)initWithFrame:(CGRect)frame Height:(NSInteger)initHeight Width:(NSInteger)initWidth URL:(NSString*)initURL
{
    self = [super initWithFrame:frame];
    if (self) {
        self.height = initHeight;
        self.width = initWidth;
        self.URL = initURL;
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:frame];
        textLabel.text = initURL;
        [self addSubview:textLabel];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
