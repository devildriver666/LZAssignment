//
//  LZPhotoDetailViewController.m
//  LazadaAssignement
//
//  Created by abhijeet upadhyay on 27/11/16.
//  Copyright © 2016 lazada. All rights reserved.
//

#import "LZPhotoDetailViewController.h"

#import "LZWebServiceClient.h"

//Third Party.
#import <MBProgressHUD/MBProgressHUD.h>
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface LZPhotoDetailViewController () <UIScrollViewDelegate>

@end

@implementation LZPhotoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.scrollView.maximumZoomScale = 100.0;
    self.scrollView.delegate = self;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGRect viewFrame = self.scrollView.frame;
    self.scrollView.contentSize = viewFrame.size;
    self.imageView.frame = CGRectMake(0, 0, CGRectGetWidth(viewFrame), CGRectGetHeight(viewFrame));
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"Loading...";
    
    [[LZWebServiceClient sharedManager] getPhotoDetailWithId:self.photoId completionHandler:^(BOOL error, id  _Nullable data) {
        
        if (!error) {
            [hud hideAnimated:YES];
            
            NSDictionary *photoInfo = data[@"photo"];
            NSURL *photoUrl = [NSURL URLWithString:photoInfo[@"image_url"]];
            
            self.titleLabel.text = photoInfo[@"name"];
            self.authorLabel.text = photoInfo[@"user"][@"fullname"];
            [self.imageView setImageWithURL:photoUrl];
            
            [self adjustImage];
        }
        else {
            // Show error
            [hud hideAnimated:YES];
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"Error";
            hud.detailsLabel.text = data;
//            [hud hideAnimated:YES afterDelay:1.5];
        }
    }];
}

- (BOOL)automaticallyAdjustsScrollViewInsets {
    
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate
- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return self.imageView;
}

//Zoom functionality.
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    UIView* zoomView = [scrollView.delegate viewForZoomingInScrollView:scrollView];
    CGRect zoomViewFrame = zoomView.frame;
    
    if (zoomViewFrame.size.width < scrollView.bounds.size.width) {
        zoomViewFrame.origin.x = (scrollView.bounds.size.width - zoomViewFrame.size.width) / 2.0;
    } else {
        zoomViewFrame.origin.x = 0.0;
    }
    
    if (zoomViewFrame.size.height < scrollView.bounds.size.height) {
        zoomViewFrame.origin.y = (scrollView.bounds.size.height - zoomViewFrame.size.height) / 2.0;
    } else {
        zoomViewFrame.origin.y = 0.0;
    }
    
    zoomView.frame = zoomViewFrame;
}

- (void)adjustImage {
    
    UIImage *image = self.imageView.image;
    
    if (image.size.width > CGRectGetWidth(self.scrollView.frame)) {
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    } else {
        self.imageView.contentMode = UIViewContentModeCenter;
    }
}

@end
