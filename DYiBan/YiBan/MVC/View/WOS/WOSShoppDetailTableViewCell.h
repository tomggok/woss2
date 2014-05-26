//
//  WOSShoppDetailTableViewCell.h
//  WOS
//
//  Created by apple on 14-5-21.
//  Copyright (c) 2014年 ZzL. All rights reserved.
//
@protocol WOSShoppDetailTableViewCellDelegate <NSObject>

-(void)shareOrderView:(NSDictionary *)dict;

@end
#import <UIKit/UIKit.h>

@interface WOSShoppDetailTableViewCell : UITableViewCell

@property(nonatomic,assign)id<WOSShoppDetailTableViewCellDelegate>delegate;

-(void)creatCell:(NSDictionary *)dict;
@end
