//
//  LZPhotoDetailViewController.h
//  LazadaAssignement
//
//  Created by abhijeet upadhyay on 27/11/16.
//  Copyright © 2016 lazada. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZPhotoDetailViewController : UIViewController

@property (nonatomic,strong) NSString *photoId;

//UI Properties.
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;

@end
