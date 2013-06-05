//
//  UIBookmark.h
//  Webapps
//
//  Created by Richard Jones on 31/05/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBookmark : UICollectionViewCell

@property UILabel *label;
@property NSString *url;
@property NSMutableArray *tags;
@property NSInteger width;
@property NSInteger height;

-(UIBookmark *)initWithTitle:(UILabel *)label URL:(NSString *)url Tags:(NSMutableArray *)tags Width:(NSInteger)width Height:(NSInteger)height;

@end
