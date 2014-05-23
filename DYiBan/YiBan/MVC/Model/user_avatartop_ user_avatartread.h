//
//  user_avatartop_ user_avatartread.h
//  DYiBan
//
//  Created by zhangchao on 13-9-15.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "Magic_JSONReflection.h"

//user_avatartread踩和user_avatartop顶接口返回的数据
@interface user_avatartop__user_avatartread : MagicJSONReflection

@property (nonatomic, retain)NSString *content;//供页面显示的信息
@property (nonatomic, retain)NSString *foot;//清除多少脚印
@property (nonatomic, retain)NSString *foot2;//清除多少脚印（文字描述）
@property (nonatomic, retain)NSString *message;//对被顶的人发消息（逻辑类已发送，不用客户端再发）
@property (nonatomic, retain)NSString *name;
@property (nonatomic, retain)NSString *news;//对顶的人及好友发动态（逻辑类已发送，不用客户端再发）
@property (nonatomic, retain)NSString *type;//标示清除脚印的类型：1: 1/4个，2: 1/2个，3: 1个
@property (nonatomic, retain)NSString *content4c;//提示框显示内容
@end
