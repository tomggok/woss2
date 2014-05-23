//
//  DYBScroller.m
//  DYiBan
//
//  Created by Song on 13-8-21.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBScroller.h"
#import "DYBBoxView.h"
#import "scrollerData.h"
@implementation DYBScroller

@synthesize scrollView = _scrollView ,receiveObj = _receiveObj,indexRow = _indexRow;
DEF_SIGNAL(SELECTED);
DEF_SIGNAL(PICKERCLICKEEND);
DEF_SIGNAL(PICKERCLICK);
- (void)addSelectButton {
    
    int orginy = 0;
    
    if (SCREEN_HEIGHT == 480) {
        
        orginy = 191;
        
    }else {
        
        orginy = 232;
    }
    
    
    typeBox = 0;
    
    //两条黑色线条
    MagicUILabel *lab = [[MagicUILabel alloc]initWithFrame:CGRectMake(0, orginy-10, 320, 1)];
    lab.backgroundColor = [UIColor blackColor];
    [self addSubview:lab];
    RELEASE(lab);
    
    MagicUILabel *lab1 = [[MagicUILabel alloc]initWithFrame:CGRectMake(0, orginy+45, 320, 1)];
    lab1.backgroundColor = [UIColor blackColor];
    [self addSubview:lab1];
    RELEASE(lab1);
    
    
    //按钮上得选择按钮
    UIImage *switchDoneImage = [UIImage imageNamed:@"select_no"];
    selectDoneBtn = [[MagicUIButton alloc]initWithFrame:CGRectMake(5, orginy-10 + (55-switchDoneImage.size.height/2)/2, switchDoneImage.size.width/2, switchDoneImage.size.height/2)];
    [selectDoneBtn setImage:switchDoneImage forState:UIControlStateNormal];
    [selectDoneBtn addSignal:[DYBScroller SELECTED] forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:selectDoneBtn];
    RELEASE(selectDoneBtn);
    
    //按钮上得选择按钮
    UIImage *switchImage = [UIImage imageNamed:@"select_yes"];
    selectBtn = [[MagicUIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-switchImage.size.width/2-5, selectDoneBtn.frame.origin.y, switchImage.size.width/2, switchImage.size.height/2)];
    [selectBtn setImage:switchImage forState:UIControlStateNormal];
    [self addSubview:selectBtn];
    RELEASE(selectBtn);
    
    
    
}

// 设置选择框属性 传0 是默认有确定按钮  传1 是点击cell事件触发消息
- (void)setBtnHid:(int)type {
    
    
    typeBox = type;
    selectDoneBtn.hidden = YES;
    selectBtn.hidden = YES;
    
}

//初始化选择框
- (id)initWithFrame:(CGRect)frame setArr:(NSArray *)arr{

    self = [super initWithFrame:frame];
    if (self) {
        
        _scrollView  = [[DYBScrollerView alloc] initWithFrame:frame];
        _scrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:_scrollView];
        
        for (int i = 0; i < [arr count]; i++) {
            
            scrollerData *scdata = [arr objectAtIndex:i];
            
            DYBBoxView* boxView = [[DYBBoxView alloc] init];
            [boxView.textLabel setText:[NSString stringWithFormat:@"%@",scdata.name]];
            boxView.id = scdata.id;
            
            [_scrollView addUserView:boxView];
        }
        
        [_scrollView bringViewAtIndexToFront:0 animated:YES];
        
        [self addSelectButton];
        
    }
    return self;

}

//接受者
- (id)initWithFrame:(CGRect)frame setArr:(NSMutableArray *)arr receive:(id)receive
{
    _receiveObj = receive;
    id obj = [self initWithFrame:frame setArr:arr];
    return obj;
}

//发送点击确定按钮消息
- (void)handleViewSignal_DYBScroller:(MagicViewSignal *)signal
{
    if ([signal is:[DYBScroller SELECTED]])
    {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:boxScrolEndView, @"boxview",self,@"scroller", nil];
        [self sendViewSignal:[DYBScroller PICKERCLICKEEND] withObject:dict from:self target:_receiveObj];
        
    }
}

#pragma mark- DYBScrollerView
- (void)handleViewSignal_DYBScrollerView:(MagicViewSignal *)signal
{
    //0 是带两个按钮的选择框
    if (typeBox == 0) {
        
        //获取滑动结束的消息
        if ([signal is:[DYBScrollerView PICKERDIDEND]])
        {
            NSDictionary *dict = (NSDictionary *)[signal object];
            boxScrolEndView = [dict objectForKey:@"boxview"];
            
            
            
            selectDoneBtn.hidden = NO;
            selectBtn.hidden = NO;
            
        }
        //获取将要滑动的消息
        if ([signal is:[DYBScrollerView PICKERBEGIN]])
        {
            selectDoneBtn.hidden = YES;
            selectBtn.hidden = YES;
            
        }
    }
    // 1 是没有按钮 直接点击cell的选择框
    if (typeBox == 1) {
        
        if ([signal is:[DYBScrollerView PICKERDIDEND]])
        {
            NSDictionary *dict = (NSDictionary *)[signal object];
            boxScrolEndView = [dict objectForKey:@"boxview"];
            
        }
        
        
        if ([signal is:[DYBScrollerView PICKERTOUCH]])
        {
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:boxScrolEndView, @"boxview",self,@"scroller", nil];
            [self sendViewSignal:[DYBScroller PICKERCLICK] withObject:dict from:self target:_receiveObj];
            
        }
        
    }
    
    
    
    
}


- (void)dealloc {
    
    REMOVEFROMSUPERVIEW(_scrollView);
    REMOVEFROMSUPERVIEW(selectDoneBtn);
    REMOVEFROMSUPERVIEW(selectBtn);
    [super dealloc];
}



@end
