//
//  BookmarkViewFlowLayout.m
//  Quilt
//
//  Created by Richard Jones on 12/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import "BookmarkViewFlowLayout.h"

@implementation BookmarkViewFlowLayout

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    self.itemSize = CGSizeMake(150, 150);
    self.minimumInteritemSpacing = 10;
    self.minimumLineSpacing = 10;
}

@end
