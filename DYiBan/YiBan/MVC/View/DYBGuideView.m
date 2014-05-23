//
//  DYBGuideView.m
//  DYiBan
//
//  Created by zhangchao on 13-10-22.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBGuideView.h"
#import "UIView+MagicCategory.h"
#import "NSObject+MagicTypeConversion.h"
#import "Magic_Device.h"

@interface DYBGuideView ()
{
NSMutableArray *_muA_img;
}
@end


@implementation DYBGuideView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        [self addSignal:[UIView TAP] object:Nil target:Nil];
        
    }
    return self;
}

#pragma mark- 添加要展示的图,最后一张在视图最上面显示
- (DYBGuideViewImg)AddImgByName
{
    DYBGuideViewImg block = ^DYBGuideView * (id first,...)
    {
        va_list args;
        va_start(args, first);
        
        NSMutableString *imgName = [[NSMutableString alloc]initWithString:[first asNSString]];
        
        CGRect frame = CGRectMake(0, 0, 320, 460);
        if ([MagicDevice boundSizeType]==1) {
            [imgName appendString:@"-568h@2x"];
            frame.size.height = 548;
            
        }

        UIImageView *img=[[UIImageView alloc]initWithFrame:frame];
        [img setImage:[UIImage imageNamed:imgName]];

        
//        UIImage *img=[UIImage imageNamed:imgName];
        
//        if (!_muA_img) {
//            _muA_img=[NSMutableArray arrayWithObject:img];
//            [_muA_img retain];
//        }else if(![_muA_img containsObject:img]){
//            [_muA_img addObject:img];
//        }
        
        [self addSubview:img];
        RELEASE(img);

        while (imgName)
        {
            NSString *str=(NSString *)[va_arg(args, NSString *) asNSString];
            if (!str) {
                break ;
            }
            imgName =[[NSMutableString alloc]initWithString:str];
            if ([MagicDevice boundSizeType]==1) {
                [imgName appendString:@"-568h@2x"];
            }
            
            if (!imgName){
                break;
            }else{
//                img=[UIImage imageNamed:imgName];
                img=[[UIImageView alloc]initWithFrame:frame];
                [img setImage:[UIImage imageNamed:imgName]];
                

//                [_muA_img addObject:img];
                [self addSubview:img];
                RELEASE(img);
            }
            
        } 
        va_end(args);
        
        
//        [self setNeedsDisplay];

        return self;
        
    };
    return [[block copy] autorelease];
}


#pragma mark- 接受UIView信号
- (void)handleViewSignal_UIView:(MagicViewSignal *)signal{
    if ([signal is:[UIView TAP]]) {
      
//        [_muA_img removeLastObject];
//        
//        if (_muA_img.count==0) {
//            [self releaseSelf];
//            return;
//        }
//        [self setNeedsDisplay];
        
        [[self.subviews lastObject]removeFromSuperview];
        if (self.subviews.count==0) {
            [self releaseSelf];
            return;
        }
    }
}

//-(void)drawRect:(CGRect)rect
//{
//    [super drawRect:rect];
//    
//    
////    UIGraphicsPushContext( context );
////    [uiImage drawInRect:CGRectMake(0, 0, width, height)];
////    UIGraphicsPopContext();
//    
////    CGContextRef context = UIGraphicsGetCurrentContext();
////    CGContextSaveGState(context);//保存图层
//
////    self.alpha=1;
////    
////    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
////        self.alpha=0;
////    }completion:^(BOOL b){
////        if (b) {
////        }
////    }];
//    
////    [((UIImage *)[_muA_img lastObject]) drawInRect:rect];
//    
////    CGContextRestoreGState(context);//恢复图层
//
//    
////    [self addSubview:[_muA_img lastObject]];
//    
//}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    
//    [super touchesBegan:touches withEvent:event];
//    
//    {
//        
//        [_muA_img removeLastObject];
//        if (_muA_img.count==0) {
//            [self releaseSelf];
//            return;
//        }
//        [self setNeedsDisplay];
//    }
//}

-(void)releaseSelf
{
    RELEASE(_muA_img);
    REMOVEFROMSUPERVIEW(self);
}

-(void)dealloc
{
    [super dealloc];
}

@end
