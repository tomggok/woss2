//
//  UIImage+Create.m
//  DragonFramework
//
//  Created by zhangchao on 13-4-12.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "UIImage+Create.h"

@implementation UIImage (Create)

+(UIImage *)imageNamed:(NSString *)name fileType:(NSString *)fileType/*文件后缀*/ isBigOrUnSameByOtherImg/*此图片是否是大图片或者 和数据源里的其他图片不一样 http://www.cnblogs.com/pengyingh/articles/2355033.html*/ :(BOOL)isBigOrUnSameByOtherImg
{
    if(isBigOrUnSameByOtherImg){
        return [self imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:fileType]];
    }else{
        return [self imageNamed:name];
    }
}


@end
