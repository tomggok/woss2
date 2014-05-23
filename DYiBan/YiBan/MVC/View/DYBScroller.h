//
//  DYBScroller.h
//  DYiBan
//
//  Created by Song on 13-8-21.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseView.h"
#import "DYBScrollerView.h"
#import "Magic_ViewSignal.h"
@interface DYBScroller : DYBBaseView {
    MagicUIButton *selectDoneBtn;
    MagicUIButton *selectBtn;
    DYBBoxView *boxScrolEndView;
    
    int typeBox;
}
AS_SIGNAL(SELECTED);//发送确定选择
AS_SIGNAL(PICKERCLICKEEND);//点击确定按钮
AS_SIGNAL(PICKERCLICK);//点击cell消息
@property(nonatomic,retain)DYBScrollerView *scrollView;
@property(nonatomic,assign)NSInteger indexRow;
@property(nonatomic,retain)id receiveObj;
- (id)initWithFrame:(CGRect)frame setArr:(NSArray *)arr;
- (id)initWithFrame:(CGRect)frame setArr:(NSMutableArray *)arr receive:(id)receive;
- (void)setBtnHid:(int)type;
@end
