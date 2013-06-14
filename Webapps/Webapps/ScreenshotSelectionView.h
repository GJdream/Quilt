//
//  ScreenshotSelectionView.h
//  Quilt
//
//  Created by Richard Jones on 13/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScreenshotSelectionView : UIView
- (void)setScreenshotTakenFunction:(void (^)(UIImage*))screenshotTaken;
@end
