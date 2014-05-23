//
//  DYBUnreadMsgView.m
//  DYiBan
//
//  Created by zhangchao on 13-8-20.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBUnreadMsgView.h"
#import "UIView+MagicCategory.h"
#import "NSObject+KVO.h"
#import "Magic_UITabBar.h"

@implementation DYBUnreadMsgView

- (id)initWithFrame:(CGRect)frame/*宽高可以随便传*/ img:(UIImage *)img nums:(NSString *)nums arrowDirect:(int)arrowDirect  /*箭头朝向,1:上(_lb_nums.frame.origin.y+3); 2:下(_lb_nums.frame.origin.y-3); 3:左(_lb_nums.frame.origin.x-3); 右:(_lb_nums.frame.origin.x+3); -1:无箭头*/
{
    self = [super initWithFrame:frame];
    if (self) {
        self.hidden=NO;
        self.backgroundColor=[UIColor clearColor];
        
        if (!_imgV_back) {
            _imgV_back=[[MagicUIImageView alloc]initWithFrame:CGRectMake(0,0, img.size.width/2,img.size.height/2) backgroundColor:[UIColor clearColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:self Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
            RELEASE(_imgV_back);
        }
        
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, _imgV_back.frame.size.width, _imgV_back.frame.size.height)];
        
        if (!_lb_nums) {
            _lb_nums=[[MagicUILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
            _lb_nums.backgroundColor=[UIColor clearColor];
            _lb_nums.textAlignment=NSTextAlignmentCenter;
            _lb_nums.font=[DYBShareinstaceDelegate DYBFoutStyle:15];
            _lb_nums.text=([nums intValue]>9999)?(@"N"):(nums);
            [_lb_nums setNeedCoretext:NO];
            _lb_nums.textColor=[UIColor whiteColor];
            _lb_nums.numberOfLines=1;
            _lb_nums.lineBreakMode=NSLineBreakByCharWrapping;
            [_lb_nums sizeToFitByconstrainedSize:CGSizeMake(_imgV_back.frame.size.width, _imgV_back.frame.size.height)];
            [_imgV_back addSubview:_lb_nums];
            [_lb_nums changePosInSuperViewWithAlignment:2];
            RELEASE(_lb_nums);
        }
        
        switch (arrowDirect) {
            case 1://上
            {
                    [_lb_nums setFrame:CGRectMake(_lb_nums.frame.origin.x, _lb_nums.frame.origin.y+3, _lb_nums.frame.size.width, _lb_nums.frame.size.height)];
            }
                break;
            case 2://下
            {
                [_lb_nums setFrame:CGRectMake(_lb_nums.frame.origin.x, _lb_nums.frame.origin.y, _lb_nums.frame.size.width, _lb_nums.frame.size.height)];
            }
                break;
            case 3://左
            {
                [_lb_nums setFrame:CGRectMake(_lb_nums.frame.origin.x-3, _lb_nums.frame.origin.y, _lb_nums.frame.size.width, _lb_nums.frame.size.height)];
            }
                break;
            case 4://右
            {
                [_lb_nums setFrame:CGRectMake(_lb_nums.frame.origin.x+3, _lb_nums.frame.origin.y, _lb_nums.frame.size.width, _lb_nums.frame.size.height)];
            }
                break;
            default:
            {
                [_lb_nums setFrame:CGRectMake(_lb_nums.frame.origin.x, _lb_nums.frame.origin.y+2, _lb_nums.frame.size.width, _lb_nums.frame.size.height)];
            }
                break;
        }
    }
    return self;
}

-(void)refreshByimg:(UIImage *)img nums:(NSString *)nums
{
    _imgV_back.image=img;
    
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, _imgV_back.frame.size.width, _imgV_back.frame.size.height)];
    
    _lb_nums.text=nums;
    
}

//观察者要实现此响应方法
- (void) observeValueForKeyPath:(NSString *)keyPath
					   ofObject:(id)object/*被观察者*/
						 change:(NSDictionary *)change
						context:(void *)context/*观察者class*/{
  Class class=(Class)context;
  NSString *className=[NSString stringWithCString:object_getClassName(class) encoding:NSUTF8StringEncoding];

    if ([className isEqualToString:[NSString stringWithCString:object_getClassName([MagicUITabBar class]) encoding:NSUTF8StringEncoding]]) {
//        self._b_canDragBack=[[change objectForKey:@"new"] boolValue];
        self.frame=CGRectMake(self.frame.origin.x, [[change objectForKey:@"new"] CGRectValue].origin.y-10, self.frame.size.width, self.frame.size.height);
        
//        if (self.frame.origin.y>=((MagicUITabBar *)object).frame.size.height) {//下移完毕后,再往下移几像素,避免漏出来
//            self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y+10, self.frame.size.width, self.frame.size.height);
//        }
    }else{//将不能处理的 key 转发给 super 的 observeValueForKeyPath 来处理
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
    
}

@end
