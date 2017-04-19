//
//  AndyVideoCollectionViewCell.h
//  MyCF
//
//  Created by 李扬 on 15/12/17.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AndyTXorAipaiVideoModel;

@interface AndyVideoCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) UIImageView *imageFocusView;

@property (nonatomic, strong) AndyTXorAipaiVideoModel *txorAipaiVideoModel;

@end
