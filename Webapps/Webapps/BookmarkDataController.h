//
//  BookmarkDataController.h
//  Webapps
//
//  Created by Thomas, Anna E on 05/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIBookmark.h"
#import "BookmarkViewController.h"
#import "NDTrie.h"

@interface BookmarkDataController : NSObject

@property (nonatomic, copy) NSMutableArray *bookmarksArray;
@property (nonatomic, copy) NSMutableArray *bookmarkDisplayArray;
@property BookmarkViewController *bookmarkVC;
@property NSMutableOrderedSet *mostUsedTags;
@property NDMutableTrie *tagTrie;

- (BookmarkDataController*)initWithViewController:(BookmarkViewController*)bookmarkVC;
- (NSUInteger)countOfBookmarks;
- (UIBookmark *)bookmarkInListAtIndex:(NSUInteger)index;
- (void)addBookmark:(UIBookmark *)bookmark;
- (void)updateOnBookmarkInsertion;
- (void)showTag:(NSString*)tag;

@end
