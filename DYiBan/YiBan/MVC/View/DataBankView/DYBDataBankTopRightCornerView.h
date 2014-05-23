//
//  DYBDataBankTopRightCornerView.h
//  DYiBan
//
//  Created by tom zeng on 13-9-4.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseView.h"

@interface DYBDataBankTopRightCornerView : DYBBaseView
@property (nonatomic,retain)NSArray *arrayResult;
@property (nonatomic,retain)id targetObj;

- (id)initWithFrame:(CGRect)frame arrayResult:(NSArray *)result target:(id)target;
-(void)setFirstBtn;

AS_SIGNAL(TOUCHBTN)
AS_SIGNAL(TOUCHSINGLEBTN)
@end
