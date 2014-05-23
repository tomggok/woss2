//
//  photoList.h
//  DYiBan
//
//  Created by Song on 13-9-12.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface photoList : MagicJSONReflection
@property(nonatomic,retain)NSString *access;//有没有权限访问
@property(nonatomic,retain)NSString *havenext;//有没有下页
@property(nonatomic,retain)NSArray *album_list;//微博动态详情
@property(nonatomic,retain)NSString *id;//相册id
@property(nonatomic,retain)NSString *name;//相册名
@property(nonatomic,retain)NSString *pic;//封面图片
@property(nonatomic,retain)NSString *pic_num;//照片数量
@end
