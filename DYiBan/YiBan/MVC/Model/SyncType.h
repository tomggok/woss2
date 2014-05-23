//
//  SyncType.h
//  DYiBan
//
//  Created by Song on 13-8-21.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SyncType : MagicJSONReflection
{
    BOOL isSyncTenct;//是否同步腾讯
    BOOL isSyncRenren;//是否同步人人
    BOOL isSyncSina;//是否同步新浪
    BOOL isSyncDouban;//是否同步豆瓣
    
    
    
}
@property (nonatomic, assign)BOOL isSyncTenct,isSyncRenren,isSyncSina,isSyncDouban;
@property (nonatomic, assign)NSInteger canShowNum;
- (id)init:(NSInteger)sysTagCount;
@end
