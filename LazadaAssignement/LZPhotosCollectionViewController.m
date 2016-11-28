//
//  LZPhotosCollectionViewController.m
//  LazadaAssignement
//
//  Created by abhijeet upadhyay on 26/11/16.
//  Copyright © 2016 lazada. All rights reserved.
//

#import "LZPhotosCollectionViewController.h"
#import "LZPhotoDetailViewController.h"

//Networking
#import "LZWebServiceClient.h"

//Custom Cell
#import "LZPhotosCollectionViewCell.h"

//Networking and Progress Indicator APIs
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface LZPhotosCollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) NSMutableArray *photoList;
@property (nonatomic,assign) int currentPage;
@property (nonatomic,assign) int totalPages;

@end

@implementation LZPhotosCollectionViewController

static NSString * const CellReuseIdentifier = @"LZPhotoCollectionCell";
static int const numColumns = 2;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.photoList = [NSMutableArray new];
    self.currentPage = 1;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.title = self.categoryName;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (self.photoList.count == 0) {
        [self getMorePhotos];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getMorePhotos {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"Loading...";
    
    [[LZWebServiceClient sharedManager] getImages:self.categoryName page:self.currentPage pageSize:10 completionHandler:^(BOOL error, _Nullable id data) {
        if (!error) {
            [hud hideAnimated:YES];
            
            self.currentPage++;
            self.totalPages = [data[@"total_pages"] intValue];
            [self.photoList addObjectsFromArray:data[@"photos"]];
            [self.collectionView reloadData];
        }
        else {
            [hud hideAnimated:YES];
            
            // Show error
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"Error";
            hud.detailsLabel.text = data;
            //[hud hideAnimated:YES afterDelay:1.5];
        }
    }];
}

#pragma mark - UICollectionViewDataSource


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.photoList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LZPhotosCollectionViewCell *cell =  (LZPhotosCollectionViewCell*) [collectionView dequeueReusableCellWithReuseIdentifier:CellReuseIdentifier forIndexPath:indexPath];
    
    NSDictionary *photoInfo = [self.photoList objectAtIndex:indexPath.row];
    NSURL *photoUrl = [NSURL URLWithString:photoInfo[@"image_url"]];
    
    cell.photoTitle.text = photoInfo[@"name"];
    cell.photoAuthor.text = photoInfo[@"user"][@"fullname"];
    [cell.photoImageView setImageWithURL:photoUrl];
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewFlowLayout *flowLayout = ((UICollectionViewFlowLayout *)collectionViewLayout);
    CGFloat cellSpacing = flowLayout.minimumInteritemSpacing;
    CGFloat leftMargin = flowLayout.sectionInset.left;
    CGFloat rightMargin = flowLayout.sectionInset.right;
    CGFloat frameWidth = CGRectGetWidth(self.view.frame);
    CGFloat cellWidth = (frameWidth - leftMargin - rightMargin - (numColumns - 1)*cellSpacing)/numColumns;
    
    return CGSizeMake(cellWidth, cellWidth * 4.0f/3.0f);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *photoInfo = [self.photoList objectAtIndex:indexPath.row];
    
    NSString *storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    
    LZPhotoDetailViewController *photoDetailViewController = (LZPhotoDetailViewController*)[storyboard instantiateViewControllerWithIdentifier:@"detail"];
    photoDetailViewController.photoId = [NSString stringWithFormat:@"%@", photoInfo[@"id"]];
    
    [self.navigationController pushViewController:photoDetailViewController animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetY = self.collectionView.contentOffset.y;
    CGFloat contentHeight = self.collectionView.contentSize.height;
    
    if (offsetY > contentHeight - self.collectionView.frame.size.height - 1) {
        // Load next page and check if it has not reached the end.
        if (self.currentPage <= self.totalPages) {
            [self getMorePhotos];
        }
    }
}

@end
