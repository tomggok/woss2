//
//  DYBDataBankShotView.h
//  DYiBan
//
//  Created by tom zeng on 13-8-19.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseView.h"
#import "DYBBoxView.h"
#import "Magic_UITextView.h"
@interface DYBDataBankShotView : DYBBaseView
AS_SIGNAL(LEFT)
AS_SIGNAL(RIGHT)
AS_SIGNAL(INPUTWORD)
AS_SIGNAL(SINGLEBTN)

@property (nonatomic,retain) NSString *type;
@property (nonatomic,retain) NSNumber *rowNum;
@property (nonatomic,retain) MagicUILabel *labelText;
@property (nonatomic,retain) MagicUITextView *labelTextView;
@property (nonatomic,retain) NSString *strTitlt;
@property (nonatomic,retain) NSString *strMsg;
@property (nonatomic,retain) NSMutableDictionary *userInfo;//传参数
@property (nonatomic,assign) BOOL noNeedRemove;//不移除view
@property (nonatomic,assign) int selectIndex;//判断是不是强制更新
@property (nonatomic,retain) NSIndexPath *indexPath;

- (id)initWithFrame:(CGRect)frame type:(NSUInteger)_type;
- (id)initWithFrame:(CGRect)frame type:(NSUInteger)_nType title:(NSString *)title MSG:(NSString *)MSG;
-(void)setMessage:(NSString *)message;
-(void)setReceive:(id)obj;
//修改placeText文字
-(void)changePlaceText:(NSString *)placeText;
@end
