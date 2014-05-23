//
//  DYBDataBankListCell.h
//  DYiBan
//
//  Created by tom zeng on 13-8-9.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYBSideSwipeTableViewCell.h"
#import "PDColoredProgressView.h"
#import "DYBDataBankSelectBtn.h"
#import "DYBProgressView.h"
@interface DYBDataBankListCell : DYBSideSwipeTableViewCell

@property (nonatomic,retain) UIView *cellBackground;
@property (nonatomic,retain) UITableView *tb;
@property (nonatomic,retain) NSIndexPath *indexPath;
@property (nonatomic,retain) id sendMegTarget;
@property (nonatomic,assign) int cellType; // 0 默认 1，分享，2，----
@property (nonatomic,retain) NSString *bSwip;
@property (nonatomic,assign) int btnType;
@property (nonatomic,retain) DYBProgressView *progressView;
@property (nonatomic,retain) UIImageView *imageViewStats;
@property (nonatomic,retain) UILabel *labelProgress;
@property (nonatomic,retain) UILabel *labelGood;
@property (nonatomic,retain) MagicUILabel *labelName;
@property (nonatomic,retain) UILabel *labelBad;
@property (nonatomic, readonly) DYBDataBankSelectBtn* btnBottom;
@property (nonatomic, assign)BOOL beginOrPause;//暂停或开始 为了DYBDataBankSelectBtn* btnBottom（ begin:YES pause:NO）
@property (nonatomic,retain) UIImageView *imageViewDown;
@property (nonatomic,retain) NSString *strTag; //cell 设置Tag

AS_SIGNAL(FINISHSWIP)
AS_SIGNAL(CANCEL)

- (void)setBackgroundColor:(UIColor *)backgroundColor;
-(void)resetContentView;

-(DYBDataBankListCell *)initViewCell_dict:(NSDictionary *)dict;
-(DYBDataBankListCell *)initViewCell_dict:(NSDictionary *)dict target:(id)_target;
- (id)initWithFrame:(CGRect)frame object:(id)object;

- (void)closeCell;
-(void)setSwipViewBackColor:(UIColor *)color;
-(NSString *)setPublicString:(NSString *)perm;
@end
