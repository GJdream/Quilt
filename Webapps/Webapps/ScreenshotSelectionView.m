//
//  ScreenshotSelectionView.m
//  Quilt
//
//  Created by Richard Jones on 13/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import "ScreenshotSelectionView.h"

@implementation ScreenshotSelectionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect innerRect = CGRectInset(rect, 5, 5);
    CGContextSetStrokeColorWithColor(context, [[UIColor redColor] CGColor]);
    CGContextSetLineWidth(context, 10);
    CGContextMoveToPoint(context, CGRectGetMinX(innerRect), CGRectGetMinY(innerRect));
    CGContextAddLineToPoint(context, CGRectGetMaxX(innerRect), CGRectGetMinY(innerRect));
    CGContextAddLineToPoint(context, CGRectGetMaxX(innerRect), CGRectGetMaxY(innerRect));
    CGContextAddLineToPoint(context, CGRectGetMinX(innerRect), CGRectGetMaxY(innerRect));
    CGContextClosePath(context);
    CGContextStrokePath(context);
}

@end
