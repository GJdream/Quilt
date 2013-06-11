//
//  BookmarkDataController.h
//  Webapps
//
//  Created by Thomas, Anna E on 05/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIBookmark;
@class NDMutableTrie;
@class BookmarkViewController;

@interface BookmarkDataController : NSObject

@property (nonatomic, copy) NSMutableArray *bookmarksArray;
@property (nonatomic, copy) NSMutableArray *bookmarkDisplayArray;
@property BookmarkViewController *bookmarkVC;
@property NSMutableOrderedSet *mostUsedTags;
@property NDMutableTrie *tagTrie;

+ (void)setViewController:(BookmarkViewController*)newVC;
+ (BookmarkDataController*)instantiate;

- (BookmarkDataController*)initWithViewController:(BookmarkViewController*)bookmarkVC;
- (void)registerUpdate:(void (^)(void))updateMethod;
- (NSUInteger)countOfBookmarks;
- (UIBookmark *)bookmarkInListAtIndex:(NSUInteger)index;
- (void)addBookmark:(UIBookmark *)bookmark;
- (void)updateOnBookmarkInsertion;
- (void)showTag:(NSString*)tag;

@end
