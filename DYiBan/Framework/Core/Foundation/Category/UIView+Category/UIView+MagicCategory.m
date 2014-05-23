//
//  UIView+MagicCategory.m
//  MagicFramework
//
//  Created by NewM on 13-3-6.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "UIView+MagicCategory.h"
#import "UIView+Gesture.h"
#import <objc/runtime.h>

@implementation UIView(MagicCategory)

DEF_SIGNAL(TAP)       //单击消息
DEF_SIGNAL(PAN)       //拖动消息


@dynamic _originFrame,b_isStretchingUp,v_footerVForHide,v_headerVForHide,muA_signal,initialTouchPositionX,b_isStretching,v_expandGestureArea,moveDir,moveMax_x;

static char _c_originFrame;
-(CGRect)_originFrame
{
    return [objc_getAssociatedObject(self, &_c_originFrame) CGRectValue];
    
}

-(void)set_originFrame:(CGRect)frame
{
    objc_setAssociatedObject(self, &_c_originFrame, [NSValue valueWithCGRect:frame], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark- 设置初始的_originFrame
-(void)setOriginFrame
{
    self._originFrame=CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}

static char c_b_isStretchingUp;
-(BOOL)b_isStretchingUp
{
    return [objc_getAssociatedObject(self, &c_b_isStretchingUp) boolValue];
    
}
-(void)setB_isStretchingUp:(BOOL)b
{
    objc_setAssociatedObject(self, &c_b_isStretchingUp, [NSNumber numberWithBool:b], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static char c_b_isStretching;
-(BOOL)b_isStretching
{
    return [objc_getAssociatedObject(self, &c_b_isStretching) boolValue];
    
}
-(void)setB_isStretching:(BOOL)b
{
    objc_setAssociatedObject(self, &c_b_isStretching, [NSNumber numberWithBool:b], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static char c_v_footerVForHide;
-(UIView *)v_footerVForHide
{
    return objc_getAssociatedObject(self, &c_v_footerVForHide);
    
}
-(void)setV_footerVForHide:(UIView *)v
{
    objc_setAssociatedObject(self, &c_v_footerVForHide, v, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static char c_v_headerVForHide;
-(UIView *)v_headerVForHide
{
    return objc_getAssociatedObject(self, &c_v_headerVForHide);
    
}
-(void)setV_headerVForHide:(UIView *)v
{
    objc_setAssociatedObject(self, &c_v_headerVForHide, v, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static char c_muA_signal;
-(NSMutableArray *)muA_signal
{
    return objc_getAssociatedObject(self, &c_muA_signal);
    
}
-(void)setMuA_signal:(NSMutableArray *)mua
{
    objc_setAssociatedObject(self, &c_muA_signal, mua, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static char c_initialTouchPositionX;
-(CGFloat)initialTouchPositionX
{
    return [objc_getAssociatedObject(self, &c_initialTouchPositionX) floatValue];
    
}

-(void)setInitialTouchPositionX:(CGFloat)x
{
    objc_setAssociatedObject(self, &c_initialTouchPositionX, [NSNumber numberWithFloat:x], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


static char c_moveDir;
-(CGFloat)moveDir
{
    return [objc_getAssociatedObject(self, &c_moveDir) floatValue];
    
}

-(void)setMoveDir:(CGFloat)x
{
    objc_setAssociatedObject(self, &c_moveDir, [NSNumber numberWithFloat:x], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static char c_moveMax_x;
-(CGFloat)moveMax_x
{
    return [objc_getAssociatedObject(self, &c_moveMax_x) floatValue];
    
}

-(void)setMoveMax_x:(CGFloat)x
{
    objc_setAssociatedObject(self, &c_moveMax_x, [NSNumber numberWithFloat:x], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


static char c_v_expandGestureArea;
-(UIView *)v_expandGestureArea
{
    return objc_getAssociatedObject(self, &c_v_expandGestureArea);
    
}
-(void)setV_expandGestureArea:(UIView *)v
{
    objc_setAssociatedObject(self, &c_v_expandGestureArea, v, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


//获得
- (UIViewController *)viewController
{
	if (self.superview)
    {
		return nil;
    }
    
	id nextResponder = [self nextResponder];
	if ( [nextResponder isKindOfClass:[UIViewController class]] )
	{
		return (UIViewController *)nextResponder;
	}else
	{
		return nil;
	}
}

#define mark-递归找自己父视图的viewCon
-(UIViewController *)superCon
{
    if (!self.superview)
    {
        return nil;
    }
    
    id nextResponder = [self nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return nextResponder;
    } else if ([nextResponder isKindOfClass:[UIView class]]) {
        return [nextResponder traverseResponderChainForUIViewController];
    } else {
        return nil;
    }
}


//递归找自己父视图的viewCon
- (id) traverseResponderChainForUIViewController {
    id nextResponder = [self nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return nextResponder;
    } else if ([nextResponder isKindOfClass:[UIView class]]) {
        return [nextResponder traverseResponderChainForUIViewController];
    } else {
        return nil;
    }
}

//在父视图的位置
-(void)changePosInSuperViewWithAlignment:(NSUInteger)Alignment
{
    switch (Alignment) {
        case 0://左右居中
        {
            [self setFrame:CGRectMake(self.superview.frame.size.width/2-self.frame.size.width/2, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
        }
            break;
        case 1://上下居中
        {
            [self setFrame:CGRectMake(self.frame.origin.x, self.superview.frame.size.height/2-self.frame.size.height/2, self.frame.size.width, self.frame.size.height)];
        }
            break;
        case 2://中心
        {
            [self setFrame:CGRectMake(self.superview.frame.size.width/2-self.frame.size.width/2, self.superview.frame.size.height/2-self.frame.size.height/2, self.frame.size.width, self.frame.size.height)];
        }
            break;
        default:
            break;
    }
    
}

#pragma mark-添加某信号,此view释放前要删除所有添加过的信号
- (void)addSignal:(NSString *)signal object:(NSObject *)object
{

    [self addSignal:signal object:object target:nil];
}

#pragma mark-添加某信号,此view释放前要删除所有添加过的信号
- (void)addSignal:(NSString *)signal object:(NSObject *)object target:(id)target
{
    if (!self.muA_signal) {
        self.muA_signal = [[[NSMutableArray alloc] init] autorelease];
    }
    
    if (!signal) {
        signal = @"";
    }
    
    if ([signal isEqualToString:[UIView TAP]]) {//单击
        UITapGestureRecognizer *gesture=(UITapGestureRecognizer *)[self CreatTapGeture:self selector:@selector(handleEvent:) numberOfTouchesRequired:1 numberOfTapsRequired:1];
        [self.muA_signal addObject:[NSMutableArray arrayWithObjects:gesture, signal, object,target, nil]];//注册消息包
    }else if ([signal isEqualToString:[UIView PAN]]){//拖动
        UIPanGestureRecognizer *gesture=(UIPanGestureRecognizer *)[self CreatPanGestureRecognizer:self action:@selector(handleEvent:)];
        [self.muA_signal addObject:[NSMutableArray arrayWithObjects:gesture, signal, object,target, nil]];//注册消息包
        
    }
    
}

- (void)handleEvent:(UIGestureRecognizer *)sender
{
    for (NSArray *action in self.muA_signal) {
        NSString *gesture = [[[action objectAtIndex:0] class]description];
        if ([gesture isEqualToString:[[sender class] description]]) {//检测到注册过的消息包
            NSString *signal = [action objectAtIndex:1];
            NSObject *object = ([action count] >= 3) ? [action objectAtIndex:2] : nil;
            id target = ([action count] >= 4) ? [action objectAtIndex:3] : nil;
            [self sendViewSignal:signal withObject:[NSDictionary dictionaryWithObjectsAndKeys:object,@"object",sender,@"sender", nil] from:self target:target];
            break;
        }
    }
}

#pragma mark-删除某信号
-(void)removeSignal:(NSString *)signal
{
    for (NSArray *arr in self.muA_signal) {
        if (arr.count>1 && [[arr objectAtIndex:1] isEqualToString:signal]) {
            [self removeGestureRecognizer:[arr objectAtIndex:0]];
            [self.muA_signal removeObject:arr];
            break;
        }
    }
}

#pragma mark-删除全部信号
-(void)removeAllSignal
{    
    if (self.muA_signal) {
        for (int i=self.muA_signal.count; --i>=0;) {//++模式遍历不完数组
            NSMutableArray *arr=[self.muA_signal objectAtIndex:i];
            if (arr.count>1) {
                [self removeGestureRecognizer:[arr objectAtIndex:0]];
//                [arr removeAllObjects];
                [self.muA_signal removeObjectAtIndex:i];
            }
        }
    }
}

#pragma mark-上下滑动时自动隐藏自己上下需要隐藏的view
-(void)StretchingUpOrDown:(int)upOrDown/*0:up  1:down*/
{
    switch (upOrDown) {
        case 0:
        {
            if (!self.b_isStretchingUp && !self.b_isStretching) {
                self.b_isStretchingUp=YES;
                self.b_isStretching=YES;
                [UIView animateWithDuration:0.3 animations:^{
                    [self.v_headerVForHide setFrame:CGRectMake(self.v_headerVForHide.frame.origin.x, self.v_headerVForHide.frame.origin.y-self.v_headerVForHide.frame.size.height, self.v_headerVForHide.frame.size.width, self.v_headerVForHide.frame.size.height)];
                    
                    [self.v_footerVForHide setFrame:CGRectMake(self.v_footerVForHide.frame.origin.x, self.v_footerVForHide.frame.origin.y+self.v_footerVForHide.frame.size.height, self.v_footerVForHide.frame.size.width, self.v_footerVForHide.frame.size.height)];
                    
                    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y-self.v_headerVForHide.frame.size.height, self.frame.size.width, self.frame.size.height+self.v_headerVForHide.frame.size.height)];
                }completion:^(BOOL b){
                    if (b) {
                        self.b_isStretching=NO;
                    }
                }];
            }
        }
            break;
        case 1:
        {
            if (self.b_isStretchingUp&& !self.b_isStretching) {
                self.b_isStretchingUp=NO;
                self.b_isStretching=YES;
                [UIView animateWithDuration:0.3 animations:^{
                    if (!CGRectEqualToRect(self.v_headerVForHide.frame, self.v_headerVForHide._originFrame)) {//避免下移过多
                        [self.v_headerVForHide setFrame:CGRectMake(self.v_headerVForHide.frame.origin.x, self.v_headerVForHide.frame.origin.y+self.v_headerVForHide.frame.size.height, self.v_headerVForHide.frame.size.width, self.v_headerVForHide.frame.size.height)];
                    }
                    [self.v_footerVForHide setFrame:CGRectMake(self.v_footerVForHide.frame.origin.x, self.v_footerVForHide.frame.origin.y-self.v_footerVForHide.frame.size.height, self.v_footerVForHide.frame.size.width, self.v_footerVForHide.frame.size.height)];
                    
                    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y+self.v_headerVForHide.frame.size.height, self.frame.size.width, self.frame.size.height-self.v_headerVForHide.frame.size.height)];
                }completion:^(BOOL b){
                    if (b) {
                        self.b_isStretching=NO;
                    }
                }];
            }
        }
            break;
        default:
            break;
    }
    
}

#pragma mark- 创建扩展触摸区域视图
-(void)creatExpandGestureAreaView
{
    if (!self.v_expandGestureArea) {
        self.v_expandGestureArea=[[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.frame)-CGRectGetWidth(self.frame)/2, CGRectGetMinY(self.frame)-CGRectGetHeight(self.frame)/2, CGRectGetWidth(self.frame)*2, CGRectGetHeight(self.frame)*2)];//宽高各扩展一倍
        [self.superview addSubview:self.v_expandGestureArea];
        self.v_expandGestureArea.backgroundColor=[UIColor clearColor];
        self.v_expandGestureArea.alpha=0.5;
        RELEASE(self.v_expandGestureArea);
    }
}

@end
