//
//  orderModel.m
//  DYiBan
//
//  Created by tom zeng on 13-12-2.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "orderModel.h"

@implementation orderModel
@synthesize name,price;
@synthesize num;
- (void)dealloc
{
    [name release];
    [super dealloc];
}
@end
