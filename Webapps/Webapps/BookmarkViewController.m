//
//  BookmarkViewController.m
//  Webapps
//
//  Created by Thomas, Anna E on 05/06/2013.
//  Copyright (c) 2013 Team Awesome. All rights reserved.
//

#import "BookmarkViewController.h"
#import "BookmarkDataController.h"

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
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellID forIndexPath:indexPath];
    UILabel *label = (UILabel *)[cell viewWithTag:100];
    
    UIBookmark *bookmarkAtIndex = [self.dataController bookmarkInListAtIndex:indexPath.row];
    [label setText:bookmarkAtIndex.label.text];
    [label setText:bookmarkAtIndex.url];
    
    return cell;
}

@end
