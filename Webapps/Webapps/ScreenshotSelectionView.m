//
//  ScreenshotSelectionView.m
//  Quilt
//
//  Created by Richard Jones on 13/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import "ScreenshotSelectionView.h"


@interface ScreenshotSelectionView ()
{
    void (^doneFunction)(CGRect rect);
}

@property CGPoint originalTouch;
@property CGPoint currentTouch;
@property bool dragging;
@end

@implementation ScreenshotSelectionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _dragging = NO;
    }
    return self;
}

- (void)setScreenshotTakenFunction:(void (^)(CGRect rect))screenshotTaken
{
    doneFunction = screenshotTaken;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect innerRect = CGRectMake(self.originalTouch.x, self.originalTouch.y, self.currentTouch.x - self.originalTouch.x, self.currentTouch.y - self.originalTouch.y);
    CGContextSetStrokeColorWithColor(context, [[UIColor redColor] CGColor]);
    CGContextSetLineWidth(context, 2);
    CGContextMoveToPoint(context, CGRectGetMinX(innerRect), CGRectGetMinY(innerRect));
    CGContextAddLineToPoint(context, CGRectGetMaxX(innerRect), CGRectGetMinY(innerRect));
    CGContextAddLineToPoint(context, CGRectGetMaxX(innerRect), CGRectGetMaxY(innerRect));
    CGContextAddLineToPoint(context, CGRectGetMinX(innerRect), CGRectGetMaxY(innerRect));
    CGContextClosePath(context);
    CGContextStrokePath(context);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    
    if (CGRectContainsPoint(self.window.frame, touchLocation)) {
        self.dragging = YES;
        self.originalTouch = touchLocation;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    
    if (CGRectContainsPoint(self.window.frame, touchLocation) && self.dragging)
        self.currentTouch = touchLocation;
    
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    self.dragging = NO;
    
    CGRect rect = CGRectMake(self.originalTouch.x, self.originalTouch.y, self.currentTouch.x - self.originalTouch.x, self.currentTouch.y - self.originalTouch.y);
    
    doneFunction(rect);
    [self removeFromSuperview];
}

@end
