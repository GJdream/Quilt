//
//  Friend.h
//  Quilt
//
//  Created by Thomas, Anna E on 14/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Friend : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *friendPhoto;
@property (weak, nonatomic) IBOutlet UILabel *friendName;

@property NSString *name;
@property NSMutableArray *sharedTags;
@property UIImage *image;
@property Friend *viewFriend;
@property Friend *dataFriend;

- (Friend *)initWithUsername:(NSString *)name Image:(UIImage *)image;
- (void)setPicture:(UIImage*)picture;

@end
