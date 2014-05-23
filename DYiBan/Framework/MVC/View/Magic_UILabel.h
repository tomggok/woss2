//
//  Magic_UILabel.h
//  MagicFramework
//
//  Created by NewM on 13-4-18.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Magic_ViewSignal.h"

@class MagicUILabel;

typedef MagicUILabel*(^MagicUILabelC)(id key,...);
typedef MagicUILabel*(^MagicUILabelF)(id key,...);
typedef MagicUILabel*(^MagicUILabelI)(id key,...);
typedef MagicUILabel*(^MagicUILabelAI)(id key,...);
typedef MagicUILabel*(^MagicUILabelCl)(id key,...);

@interface MagicUILabel : UILabel
{
    long    _chartSpacing;//字间距
    CGFloat _linesSpacing;//行间距
    NSMutableAttributedString *_str_AttributedString;
    
}
AS_SIGNAL(TOUCHESBEGAN)
AS_SIGNAL(TOUCHESMOVED)
AS_SIGNAL(TOUCHESENDED)
AS_SIGNAL(TOUCHESCANCEL)

@property (nonatomic, assign)CGFloat   linesSpacing;
@property (nonatomic, assign)long      chartSpacing;
@property (nonatomic, assign)BOOL      needCoretext;//是否需要coretext
@property (nonatomic, assign)NSInteger   maxLineNum;//允许的最大行数
@property (nonatomic, readonly)NSInteger realLineNum;//真正的行数
@property (nonatomic, assign)CGSize    fontFitToSize;//设置uilabel自适配高度宽度


- (MagicUILabelC)COLOR;//loc,lenght,color
- (MagicUILabelF)FONT;//loc,lenght,size
- (MagicUILabelI)IMG;//name,x,y,width,height
- (MagicUILabelAI)IMGA;//name,loc,width,height
- (MagicUILabelCl)CLICK;//loc,lenght,color,value(暂时是string)

//外部调用要在needcortext之后
- (void)autoFrame;

@end

