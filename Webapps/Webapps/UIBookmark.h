//
//  UIBookmark.h
//  Webapps
//
//  Created by Richard Jones on 31/05/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBookmark : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *label;
@property NSString *title;
@property NSString *url;
@property NSMutableArray *tags;
@property NSInteger width;
@property NSInteger height;
@property uint64_t b_id;

-(UIBookmark *)initWithTitle:(NSString *)label URL:(NSString *)url Tags:(NSMutableArray *)tags Width:(NSInteger)width Height:(NSInteger)height ID:(uint64_t)id;

@end
