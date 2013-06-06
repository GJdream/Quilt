//
//  BookmarkViewController.m
//  Webapps
//
//  Created by Thomas, Anna E on 05/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import "BookmarkViewController.h"
#import "BookmarkDataController.h"
#import "WebViewController.h"

@implementation BookmarkViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.dataController = [[BookmarkDataController alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataController countOfBookmarks];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellID = @"BookmarkCell";
    
    UIBookmark *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellID forIndexPath:indexPath];
    
    UIBookmark *bookmarkAtIndex = [self.dataController bookmarkInListAtIndex:indexPath.row];
    
    cell.label.text = bookmarkAtIndex.label.text;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIBookmark *bookmark = [self.dataController bookmarkInListAtIndex:indexPath.row];
    NSString *url = bookmark.url;
    [self performSegueWithIdentifier:@"webSegue" sender:url];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"webSegue"])
    {
        WebViewController *bookmarkViewController = segue.destinationViewController;
        bookmarkViewController.url = sender;
    }
}

@end
