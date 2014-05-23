//
//  UITableViewCell+MagicCategory.m
//  DYiBan
//
//  Created by zhangchao on 13-8-27.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "UITableViewCell+MagicCategory.h"
#import <objc/runtime.h>

@implementation UITableViewCell (MagicCategory)

@dynamic index,i_type,tbv,model;

static char c_index;
-(NSIndexPath *)index
{
    return objc_getAssociatedObject(self, &c_index);
    
}
-(void)setIndex:(NSIndexPath *)index
{
    objc_setAssociatedObject(self, &c_index, index, OBJC_ASSOCIATION_ASSIGN);
}

static char c_i_type;
-(int)i_type
{
    return [objc_getAssociatedObject(self, &c_i_type) intValue];
    
}
-(void)setI_type:(int)type
{
    objc_setAssociatedObject(self, &c_i_type, [[NSNumber numberWithInt:type] retain]/*避免释放*/, OBJC_ASSOCIATION_ASSIGN);
}

static char c_tbv;
-(UITableView *)tbv
{
    return objc_getAssociatedObject(self, &c_tbv);
    
}
-(void)setTbv:(UITableView *)_tbv
{
    objc_setAssociatedObject(self, &c_tbv, _tbv, OBJC_ASSOCIATION_ASSIGN);
}

static char c_model;
-(MagicJSONReflection *)model
{
    return objc_getAssociatedObject(self, &c_model);
    
}
-(void)setModel:(MagicJSONReflection *)m
{
    objc_setAssociatedObject(self, &c_model, m, OBJC_ASSOCIATION_ASSIGN);
}

@end
