//
//  orderModel.h
//  DYiBan
//
//  Created by tom zeng on 13-12-2.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "Magic_JSONReflection.h"

@interface orderModel : MagicJSONReflection

@property (nonatomic,assign)int num; //订单数
@property (nonatomic,retain)NSString *name; //菜名
@property (nonatomic,assign)float price; //单价
@end
