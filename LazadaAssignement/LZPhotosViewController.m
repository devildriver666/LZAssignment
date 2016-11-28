//
//  LZPhotosViewController.m
//  LazadaAssignement
//
//  Created by abhijeet upadhyay on 26/11/16.
//  Copyright © 2016 lazada. All rights reserved.
//

#import "LZPhotosViewController.h"
#import "LZNetworkingFactory.h"
#import "PhotosCollectionViewCell.h"

#import <AFNetworking/UIImageView+AFNetworking.h>

@interface LZPhotosViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)NSMutableArray *photoList;

@end

@implementation LZPhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.testImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
//    self.testImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    [self.view addSubview:self.testImageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [[LZNetworkingFactory sharedManager] getImages:@"Landscapes" page:0 pageSize:10 completionHandler:^(BOOL error, _Nullable id data) {
        if (!error) {
            NSString *imageUrl = data[@"photos"][0][@"image_url"];
            UIImage *testImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]];
            [self.testImageView setImage:testImage];
        } else {
            // Show error?
        }
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.photoList.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

  PhotosCollectionViewCell *cell =  (PhotosCollectionViewCell*) [collectionView dequeueReusableCellWithReuseIdentifier:@"LZPhotoCollectionCell" forIndexPath:indexPath];
    
    //cell.photoImageView.image = [_photoList objectAtIndex:indexPath.row];
    cell.photoTitle.text = @"Hello";
    cell.photoAuthor.text = @"1";
    
    return cell;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
