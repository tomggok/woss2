//
//  UIColor+Custom.m
//  MagicFramework
//
//  Created by zhangchao on 13-4-11.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "UIColor+Custom.h"

@implementation UIColor (Custom)

#pragma mark-得到一个UIColor里的RGB值和Alpha值
-(const CGFloat *)getUIColorsAttribute/*:(UIColor *)color*/
{
    CGColorRef colorRef=self.CGColor;
    const CGFloat *array/*CGFloat类型的数组*/=CGColorGetComponents(colorRef);//此函数返回一个数组的首地址
                                                                        //    NSLog(@"%f", array[0]);R
                                                                        //    NSLog(@"%f", array[1]);G
                                                                        //     NSLog(@"%f", array[2]);B
                                                                        //     NSLog(@"%f", array[3]);Alpha
    return array;
    
        //return CGColorGetComponents(color.CGColor);//返回一个CGFloat类型的数组的首地址
}

@end
