//
//  NSArray+MagicCategory.h
//  MagicFramework
//
//  Created by NewM on 13-5-6.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (MagicCategory)

@end

@interface NSMutableArray (MagicCategory)

+ (NSMutableArray *)nonRetainingArray;

@end