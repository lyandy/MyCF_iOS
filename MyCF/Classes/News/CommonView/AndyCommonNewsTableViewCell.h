//
//  AndyCommonNewsTableViewCell.h
//  MyCF
//
//  Created by 李扬 on 15/12/15.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AndyNewsCommonFrame;

@interface AndyCommonNewsTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) AndyNewsCommonFrame *newsCommonFrame;

@end
