//
//  NSObject+MathCount.m
//  MagicFramework
//
//  Created by zhangchao on 13-4-11.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "NSObject+MathCount.h"

@implementation NSObject (MathCount)


#pragma mark-把一个float值四舍五入成一个Int值
+(int)roundingFloatToInt:(float)f
{
    return (int)roundf(f);
}

#pragma mark-在[from to]之间随即一个数
+(int)creatAnRandomNumberFrom:(int)from to:(int)to
{
    return ((int)(from + ((arc4random()) % ((to-from) + 1))));
}

#pragma mark-得到一个int值的个位
+(NSInteger)getTenDigitFromInteger:(NSInteger)Integer
{
    return Integer/10%10;
}

#pragma mark-角度转化成弧度
+(double)radians:(float)degress
{
        //    LogFloat(LogClassName, @"", (degress*3.14159265)/180.0, Nil);
    return (degress*3.14159265)/180.0;
}


@end
