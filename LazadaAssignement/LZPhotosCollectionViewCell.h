//
//  PhotosCollectionViewCell.h
//  LazadaAssignement
//
//  Created by abhijeet upadhyay on 26/11/16.
//  Copyright © 2016 lazada. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZPhotosCollectionViewCell : UICollectionViewCell

//Collection Cell data properties.
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *photoTitle;
@property (weak, nonatomic) IBOutlet UILabel *photoAuthor;

@end
