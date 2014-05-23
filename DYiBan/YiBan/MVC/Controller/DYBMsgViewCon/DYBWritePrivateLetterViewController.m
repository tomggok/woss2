//
//  DYBWritePrivateLetterViewController.m
//  DYiBan
//
//  Created by zhangchao on 13-8-9.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBWritePrivateLetterViewController.h"
#import "UITableView+property.h"


@interface DYBWritePrivateLetterViewController ()

@end

@implementation DYBWritePrivateLetterViewController

-(void)creatTbv{
    if (!_tbv) {
        _tbv = [[MagicUITableView alloc] initWithFrame:CGRectMake(0, self.headHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-kH_StateBar-self.headHeight-kH_UITabBarController) isNeedUpdate:YES];
        //        _tbv._cellH=92;
        [self.view addSubview:_tbv];
        _tbv.backgroundColor=/*[UIColor colorWithRed:248 green:248 blue:255 alpha:1]*/ [UIColor clearColor];//248 248 255
        _tbv.tag=-1;
        _tbv._page=1;
        //            _tbv.separatorStyle=UITableViewCellSeparatorStyleNone;
    }
    
}

#pragma mark- ViewController信号
- (void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal
{
    [super handleViewSignal:signal];
    
    if ([signal is:MagicViewController.CREATE_VIEWS]) {
        
//        {//HTTP请求
//            [self.view setUserInteractionEnabled:NO];
//            MagicRequest *request = [DYBHttpMethod message_friendreqlist_yaoqing:1 pageNum:10 isAlert:YES receive:self];
//            [request setTag:1];
//            
//            if (!request) {//无网路
//                [_tbv.footerView changeState:VIEWTYPEFOOTER];
//            }
//        }
        
        
    }else if ([signal is:MagicViewController.WILL_APPEAR]){
        [self.headview setTitle:@"选择联系人"];
        [self backImgType:0];
        
    }else if ([signal is:MagicViewController.DID_DISAPPEAR]){
        //        RELEASEVIEW(_tbv);//界面不显示时彻底释放TBV,已释放cell
        
    }else if ([signal is:[MagicViewController LAYOUT_VIEWS]])
    {
        
    }else if ([signal is:[MagicViewController FREE_DATAS]])//dealloc时回调,先释放数据
    {
//        [_tbv_friends_myConcern_RecentContacts releaseDataResource];
//        
//        [_muA_data_friends removeAllObjects];
//        [_muA_data_friends release];
//        _muA_data_friends=nil;
//        
//        [_muA_data_MyConcern removeAllObjects];
//        [_muA_data_MyConcern release];
//        _muA_data_MyConcern=nil;
//        
//        [_muA_data_RecentContacts removeAllObjects];
//        [_muA_data_RecentContacts release];
//        _muA_data_RecentContacts=nil;
        
    }else if ([signal is:[MagicViewController DELETE_VIEWS]]){//dealloc时回调,再释放视图
        
//        [_tbv_friends_myConcern_RecentContacts release_muA_differHeightCellView];
//        
//        RELEASEVIEW(_tbv_friends_myConcern_RecentContacts);//界面不显示时彻底释放TBV,已释放cell
        
    }
    
}
@end
