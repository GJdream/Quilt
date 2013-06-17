//
//  BookmarkDataController.m
//  Webapps
//
//  Created by Thomas, Anna E on 05/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights

#import "BookmarkDataController.h"
#import "NetworkClient.h"
#import "UIBookmark.h"
#import "BookmarkViewController.h"
#import "NDTrie.h"
#import "NavigationBarViewController.h"

@interface BookmarkDataController ()
@property NSMutableArray *updatedBookmarks;
@property (readwrite) NSMutableDictionary *tagToBookmark;
@property NSMutableArray *watchingMethods;
@end

@implementation BookmarkDataController

static BookmarkDataController *instance = nil;
static BookmarkViewController *staticVC = nil;

+ (void)setViewController:(BookmarkViewController*)newVC
{
    staticVC = newVC;
    if(instance)
        instance.bookmarkVC = newVC;
}

+ (BookmarkDataController*)instantiate
{
    if(!instance)
        instance = [[BookmarkDataController alloc] initWithViewController:staticVC];
    
    return instance;
}

+ (void)deleteInstance
{
    instance = nil;
}

- (void)registerUpdate:(void (^)(void))updateMethod
{
    [self.watchingMethods addObject:updateMethod];
}

- (void)setBookmarksArray:(NSMutableArray *)newArray
{
    if(_bookmarksArray != newArray)
    {
        _bookmarksArray = [newArray mutableCopy];
        _tagTrie = [[NDMutableTrie alloc] init];
    }
}

- (id)init
{
    if (self = [super init])
    {
        _bookmarksArray = [[NSMutableArray alloc] init];
        _bookmarkDisplayArray = _bookmarksArray;
        _tagTrie = [[NDMutableTrie alloc] init];
        _tagToBookmark = [[NSMutableDictionary alloc] init];
        _updatedBookmarks = [[NSMutableArray alloc] init];
        _watchingMethods = [[NSMutableArray alloc] init];
        [NetworkClient getNewBookmarks];
    }
    return self;
}

- (BookmarkDataController*)initWithViewController:(BookmarkViewController*)bookmarkVC
{
    if(self = [super init])
    {
        _bookmarksArray = [[NSMutableArray alloc] init];
        _bookmarkDisplayArray = _bookmarksArray;
        _updatedBookmarks = [[NSMutableArray alloc] init];
        _tagTrie = [[NDMutableTrie alloc] init];
        _tagToBookmark = [[NSMutableDictionary alloc] init];
        _watchingMethods = [[NSMutableArray alloc] init];
        _bookmarkVC = bookmarkVC;
        [NetworkClient getNewBookmarks];
    }
    
    return self;
}

- (NSUInteger)countOfBookmarks
{
    if(self.bookmarkDisplayArray)
        return [self.bookmarkDisplayArray count];
    return 0;
}

- (UIBookmark *)bookmarkInListAtIndex:(NSUInteger)index
{
    return [self.bookmarkDisplayArray objectAtIndex:index];
}

- (void)addBookmark:(UIBookmark *)bookmark
{
    [self.bookmarksArray addObject:bookmark];
    if(self.bookmarkDisplayArray != self.bookmarksArray)
        [self.bookmarkDisplayArray addObject:bookmark];
    NSUInteger index = [self.bookmarkDisplayArray indexOfObject:bookmark];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.updatedBookmarks addObject:indexPath];
    [self.tagTrie addArray:bookmark.tags];
    
    for (NSString *tag in bookmark.tags)
    {
        NSMutableSet *bookmarkSet = [self.tagToBookmark objectForKey:tag];
        if(!bookmarkSet)
        {
            bookmarkSet = [[NSMutableSet alloc] initWithObjects:bookmark, nil];
            [self.tagToBookmark setObject:bookmarkSet forKey:tag];
        }
        else
            [bookmarkSet addObject:bookmark];
    }
}

- (void)deleteBookmark:(UIBookmark *)viewBookmark
{
    UIBookmark *bookmark = viewBookmark.dataBookmark;
    NSUInteger index = [self.bookmarkDisplayArray indexOfObject:bookmark];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    [self.bookmarksArray removeObject:bookmark];
    if (self.bookmarksArray != self.bookmarkDisplayArray)
        [self.bookmarkDisplayArray removeObject:bookmark];

    if ([self.updatedBookmarks containsObject:bookmark])
        [self.updatedBookmarks removeObject:bookmark];
    else
        [self updateOnBookmarkDeletion:indexPath];

    // Remove from tagTrie and tagToBookmark if tag not used elsewhere
    for (NSString *tag in bookmark.tags)
    {
        NSMutableSet *bookmarkSet = [self.tagToBookmark objectForKey:tag];
        [bookmarkSet removeObject:bookmark];
        
        if ([bookmarkSet count] == 0)
        {
            [self.tagToBookmark removeObjectForKey:tag];
            [self.tagTrie removeObjectForKey:tag];
        }
    }
    [NetworkClient deleteBookmark:bookmark];
}

- (void)updateOnBookmarkInsertion
{
    if (self.updatedBookmarks && self.updatedBookmarks.count > 0)
        [self.bookmarkVC.collectionView insertItemsAtIndexPaths:(NSArray*)self.updatedBookmarks];
    [self.updatedBookmarks removeAllObjects];
    
    for (void (^f)(void) in self.watchingMethods)
        f();
}

- (void)updateOnBookmarkDeletion:(NSIndexPath *)indexPath
{
    NSArray *indexArray = [[NSArray alloc] initWithObjects:indexPath, nil];
    NSLog(@"%@", indexArray);
    [self.bookmarkVC.collectionView deleteItemsAtIndexPaths:indexArray];
    [self.updatedBookmarks removeAllObjects];
}

- (void)emptyBookmarkArray
{
    NSUInteger prevCount = self.bookmarkDisplayArray.count;
    
    [self.updatedBookmarks removeAllObjects];
    for (NSUInteger i = 0; i < prevCount; ++i) {
        [self.updatedBookmarks addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    self.bookmarkDisplayArray = nil;
    
    [self.bookmarkVC.collectionView deleteItemsAtIndexPaths:self.updatedBookmarks];
    
    [self.updatedBookmarks removeAllObjects];
    
    self.bookmarkDisplayArray = self.bookmarksArray;
}

- (void)emptyTagTrie
{
    [self.tagTrie removeAllObjects];
}

- (void)showAll
{
    [self emptyBookmarkArray];
    //self.bookmarkDisplayArray = self.bookmarksArray;
    
    for (NSUInteger i = 0; i < [self countOfBookmarks]; ++i) {
        [self.updatedBookmarks addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    [self updateOnBookmarkInsertion];
}

- (void)showTag:(NSString*)tag
{
    [self emptyBookmarkArray];
    self.bookmarkDisplayArray = [[[self.tagToBookmark objectForKey:tag] allObjects] mutableCopy];
    
    for (NSUInteger i = 0; i < self.bookmarkDisplayArray.count; ++i) {
        [self.updatedBookmarks addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    [self updateOnBookmarkInsertion];
}

@end
