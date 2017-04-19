//
//  AndyLiveCollectionViewCell.h
//  MyCF
//
//  Created by 李扬 on 15/12/18.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AndyLiveItemModel.h"

@interface AndyLiveCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) UIImageView *imageFocusView;

@property (nonatomic, strong) AndyLiveItemModel *liveItemModel;

@end
