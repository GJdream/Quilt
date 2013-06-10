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
#import <QuartzCore/QuartzCore.h>

@implementation BookmarkViewController

- (IBAction)menuButtonClicked:(id)sender {
    UINavigationController *navController = self.navigationController;
    
    [UIView animateWithDuration:0.5 animations:^{
        UIView *view = navController.view;
        //Drop shadow (to simulate the nav view lifting up off the menu for sliding?)
        view.layer.masksToBounds = NO;
        view.layer.cornerRadius = 8; // if you like rounded corners
        view.layer.shadowOffset = CGSizeMake(-15, 20);
        view.layer.shadowRadius = 5;
        view.layer.shadowOpacity = 0.5;
        CGRect frame = view.frame;
        frame.origin = CGPointMake(frame.origin.x + 100, frame.origin.y);
        navController.view.frame = frame;
    }];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.dataController = [[BookmarkDataController alloc] initWithViewController:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
        WebViewController *webViewController = segue.destinationViewController;
        webViewController.url = sender;
        webViewController.dataController = self.dataController;
    }
}

@end
