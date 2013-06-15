//
//  UIBookmark.h
//  Webapps
//
//  Created by Richard Jones on 31/05/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBookmark : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UIButton *firstTag;
@property NSString *title;
@property NSString *url;
@property NSMutableArray *tags;
@property NSInteger width;
@property NSInteger height;
@property uint64_t b_id;
@property UIImage *image;
@property UIImageView *imageView;
@property UIBookmark *dataBookmark;
@property UIBookmark *viewBookmark;

- (UIBookmark *)initWithTitle:(NSString *)title URL:(NSString *)url Tags:(NSMutableArray *)tags Width:(NSInteger)width Height:(NSInteger)height ID:(uint64_t)id Image:(UIImage*)image;
- (IBAction)tagClicked:(id)sender;
- (IBAction)deleteClicked:(id)sender;
- (void)setPicture:(UIImage*)picture;

@end
