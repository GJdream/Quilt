//
//  BookmarkDataController.h
//  Webapps
//
//  Created by Thomas, Anna E on 05/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIBookmark.h"

@class UIBookmark;

@interface BookmarkDataController : NSObject

@property (nonatomic, copy) NSMutableArray *bookmarksArray;

- (NSUInteger)countOfBookmarks;
- (UIBookmark *)bookmarkInListAtIndex:(NSUInteger)index;
- (void)addBookmark:(UIBookmark *)bookmark;

@end
