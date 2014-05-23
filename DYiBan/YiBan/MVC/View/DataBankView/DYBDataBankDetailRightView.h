//
//  DYBDataBankDetailRightView.h
//  DYiBan
//
//  Created by tom zeng on 13-11-15.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DYBDataBankDetailRightView : NSObject

@property (nonatomic,retain)NSDictionary *dictFileInfo;
@property (nonatomic,retain)UIView *viewRight;


-(void)creatBTNMyShare:(UIView *)BGview;
-(void)creatBTNShareSomethingForMe:(UIView *)BGview;
-(void)creatBTNPublicSomething:(UIView *)BGview;
-(void)creatBTNCommentView:(UIView *)view;
@end
