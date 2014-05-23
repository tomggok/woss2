//
//  Dragon_UILabel.h
//  DragonFramework
//
//  Created by NewM on 13-4-18.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Dragon_ViewSignal.h"

@class DragonUILabel;

typedef DragonUILabel*(^DragonUILabelC)(id key,...);
typedef DragonUILabel*(^DragonUILabelF)(id key,...);
typedef DragonUILabel*(^DragonUILabelI)(id key,...);
typedef DragonUILabel*(^DragonUILabelAI)(id key,...);
typedef DragonUILabel*(^DragonUILabelCl)(id key,...);

@interface DragonUILabel : UILabel
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


- (DragonUILabelC)COLOR;//loc,lenght,color
- (DragonUILabelF)FONT;//loc,lenght,size
- (DragonUILabelI)IMG;//name,x,y,width,height
- (DragonUILabelAI)IMGA;//name,loc,width,height
- (DragonUILabelCl)CLICK;//loc,lenght,color,value(暂时是string)

//外部调用要在needcortext之后
- (void)autoFrame;

@end

