//
//  databanklist.h
//  DYiBan
//
//  Created by tom zeng on 13-8-16.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface databanklist : MagicJSONReflection

@property (nonatomic,assign) int  count;
@property (nonatomic,retain) NSString *type;
@property (nonatomic,retain) NSString *title;

@end
