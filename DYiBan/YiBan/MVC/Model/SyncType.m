//
//  SyncType.m
//  DYiBan
//
//  Created by Song on 13-8-21.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "SyncType.h"

@implementation SyncType
@synthesize isSyncDouban,isSyncRenren,isSyncSina,isSyncTenct,canShowNum;

- (id)init:(NSInteger)sysTagCount
{
    self = [super init];
    if (self) {
        
        canShowNum = 0;
        
        if (sysTagCount == 1) {
            canShowNum ++;
            isSyncSina = YES;
        }else if(sysTagCount == 2){
            canShowNum ++;
            isSyncTenct = YES;
        }else if(sysTagCount == 4){
            canShowNum ++;
            isSyncRenren = YES;
        }else if (sysTagCount == 8){
            canShowNum ++;
            isSyncDouban = YES;
        }else if (sysTagCount == 3){
            canShowNum += 2;
            isSyncSina = YES;
            isSyncTenct = YES;
        }else if (sysTagCount == 5){
            canShowNum += 2;
            isSyncSina = YES;
            isSyncRenren = YES;
        }else if (sysTagCount == 9){
            canShowNum += 2;
            isSyncSina = YES;
            isSyncDouban = YES;
        }else if (sysTagCount == 6){
            canShowNum += 2;
            isSyncTenct = YES;
            isSyncRenren = YES;
        }else if (sysTagCount == 10){
            canShowNum += 2;
            isSyncTenct = YES;
            isSyncDouban = YES;
        }else if (sysTagCount == 12){
            canShowNum += 2;
            isSyncRenren = YES;
            isSyncDouban = YES;
        }else if (sysTagCount == 7){
            canShowNum += 3;
            isSyncSina = YES;
            isSyncTenct = YES;
            isSyncRenren = YES;
        }else if (sysTagCount == 11){
            canShowNum += 3;
            isSyncSina = YES;
            isSyncTenct = YES;
            isSyncDouban = YES;
        }else if (sysTagCount == 13){
            canShowNum += 3;
            isSyncSina = YES;
            isSyncRenren = YES;
            isSyncDouban = YES;
        }else if (sysTagCount == 14){
            canShowNum += 3;
            isSyncTenct = YES;
            isSyncRenren = YES;
            isSyncDouban = YES;
        }else if (sysTagCount == 15){
            canShowNum += 4;
            isSyncSina = YES;
            isSyncTenct = YES;
            isSyncRenren = YES;
            isSyncDouban = YES;
        }
    }
    return self;
}

@end
