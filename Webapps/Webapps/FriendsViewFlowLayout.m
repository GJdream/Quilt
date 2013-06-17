//
//  FriendsViewFlowLayout.m
//  Quilt
//
//  Created by Goldsack, Briony on 17/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import "FriendsViewFlowLayout.h"

@interface FriendsViewFlowLayout ()
;
@end

@implementation FriendsViewFlowLayout

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
    self.itemSize = CGSizeMake(150, 170);
    self.minimumInteritemSpacing = 10;
    self.minimumLineSpacing = 10;
    self.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
}

@end
