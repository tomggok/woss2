//
//  file_list.h
//  DYiBan
//
//  Created by zhangchao on 13-11-6.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "Magic_JSONReflection.h"

@interface file_list : MagicJSONReflection

@property (nonatomic, retain) NSString *author;
@property (nonatomic, retain) NSString *createdTime;//内容
@property (nonatomic, retain) NSString *file_type;//1.图片 2.音频
@property (nonatomic, retain) NSString *location;//即可能是url地址,也可能是本地路径
@property (nonatomic, retain) NSString *nm;//内容
@property (nonatomic, retain) NSString *readerGroupId;
@property (nonatomic, retain) NSString *size;
@property (nonatomic, assign) int type;// -6:音频cell  -7:图片cell
//@property (nonatomic, retain) UIImage *img;//
@property (nonatomic, assign) int state;// 0:正常状态  1:编辑状态
@property (nonatomic, retain) NSString *duration;//时长
//@property (nonatomic, retain) NSString *str_filePath;//音频|图片文件的本地路径
@property (nonatomic, retain) NSString *fid;//文件ID

@end
