//
//  UILabel+Size.m
//  ShangJiaoYuXin
//
//  Created by zhangchao on 13-5-7.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "UILabel+ReSize.h"
#import "NSString+Count.h"
#import <objc/runtime.h>

@implementation UILabel (ReSize)

@dynamic _constrainedSize;

static char _c_constrainedSize;
-(CGSize)_constrainedSize
{
    return [objc_getAssociatedObject(self, &_c_constrainedSize) CGSizeValue];
    
}

-(void)set_constrainedSize:(CGSize)size
{
    objc_setAssociatedObject(self, &_c_constrainedSize, [NSValue valueWithCGSize:size], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//自适应宽高
-(void)sizeToFitByconstrainedSize{
    
    if ((self._constrainedSize.width==0||self._constrainedSize.height==0)) {//避免 &_c_constrainedSize和_c_constrainedSize判断不了self._constrainedSize是否已初始化
        self._constrainedSize = CGSizeMake(screenShows.size.width, 1000);
        
    }
    CGSize size=[self.text createActiveFrameByfontSize:self.font constrainedSize:self._constrainedSize lineBreakMode:self.lineBreakMode];
    
    if ( self.numberOfLines==0) {
        self.numberOfLines=ceil(size.height/[self.text sizeWithFont:self.font].height);
    }
    
    if (size.width>0&& size.height>0) {
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width, size.height)];
    }
}

//对sizeToFit方法的扩展,自适应宽高,调之前要先把 self.numberOfLines和self.text 设好 ,固定行数时要把 lineBreakMode 设好,self.numberOfLines=0时自己的w和h可以随意设
-(void)sizeToFitByconstrainedSize:(CGSize)constrainedSize
{   
    if (self.numberOfLines==0) {
        
        CGSize size=[self.text createActiveFrameByfontSize:self.font constrainedSize:constrainedSize lineBreakMode:self.lineBreakMode];

        if ([self.text sizeWithFont:self.font].height!=0) {
            self.numberOfLines=ceil(size.height/[self.text sizeWithFont:self.font].height);
        }
        
        if (size.width>0&& size.height>0) {
            [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width, size.height)];
        }
    }else{//根据 self.numberOfLines 计算有几行的高度
        constrainedSize.height=[self.text sizeWithFont:self.font].height*self.numberOfLines;
        CGSize size=[self.text createActiveFrameByfontSize:self.font constrainedSize:constrainedSize lineBreakMode:self.lineBreakMode];
        if (size.width>0&& size.height>0) {
            [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width, size.height)];
        }
    }
    
    
}

@end
