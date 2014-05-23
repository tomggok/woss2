//
//  DYBPersonalLetterCheckRecordViewController.m
//  DYiBan
//
//  Created by zhangchao on 13-8-28.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBPersonalLetterCheckRecordViewController.h"
#import "UITableView+property.h"

@interface DYBPersonalLetterCheckRecordViewController ()

@end

@implementation DYBPersonalLetterCheckRecordViewController

@synthesize d_model=_d_model;

#pragma mark- ViewController信号
- (void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal
{
    [super handleViewSignal:signal];
    
    if ([signal is:MagicViewController.CREATE_VIEWS]) {
        
//        if(!_muA_data)
        {//HTTP请求,班级详情
            [self.view setUserInteractionEnabled:NO];
            
            MagicRequest *request = [DYBHttpMethod message_chat_sixin:1 pageNum:10 type:@"0" userid:[_d_model objectForKey:@"userid"] maxid:@"0" last_id:@"0" isAlert:YES receive:self];
            [request setTag:1];
            
            if (!request) {//无网路
//                [_tbv.footerView changeState:VIEWTYPEFOOTER];
            }
        }
        
        
    }else if ([signal is:MagicViewController.WILL_APPEAR]){
        [self.headview setTitle:[_d_model objectForKey:@"name"]];
        [self backImgType:0];
        self.rightButton.hidden=YES;
        
    }else if ([signal is:MagicViewController.DID_DISAPPEAR]){
        //        RELEASEVIEW(_tbv);//界面不显示时彻底释放TBV,已释放cell
        
    }else if ([signal is:[MagicViewController LAYOUT_VIEWS]])
    {
        
    }else if ([signal is:[MagicViewController FREE_DATAS]])//dealloc时回调,先释放数据
    {
        [_tbv releaseDataResource];
        
//        RELEASE(_muA_data);
        
    }else if ([signal is:[MagicViewController DELETE_VIEWS]]){//dealloc时回调,再释放视图
        
        [_tbv release_muA_differHeightCellView];
        
        RELEASEVIEW(_tbv);//界面不显示时彻底释放TBV,已释放cell
        
    }
    
}

#pragma mark- 只接受HTTP信号
- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj
{
    if ([request succeed])
    {
        switch (request.tag) {
            case 1://获取|刷新
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                if ([response response] ==khttpsucceedCode)
                {
//                    NSArray *list=[response.data objectForKey:@"reqlist"];
                    
//                    if (_tbv.muA_singelSectionData.count>0 && list.count>0) {
//                        [_tbv.muA_singelSectionData removeAllObjects];
//                        
//                        [_tbv release_muA_differHeightCellView];
//                    }
                    
//                    for (NSDictionary *d in list) {
//                        reqlist *model = [reqlist JSONReflection:d];
//                        if (!_tbv.muA_singelSectionData) {
//                            [self creatTbv];
//                            
//                            _tbv.muA_singelSectionData=[NSMutableArray arrayWithObject:model];
//                            [_tbv.muA_singelSectionData retain];
//                        }else{
//                            [_tbv.muA_singelSectionData addObject:model];
//                        }
//                    }
                    
//                    {
//                        if (_tbv.muA_singelSectionData.count>0 && list.count>0) {
//                            [_tbv._muA_differHeightCellView removeAllObjects];
//                            
//                            if ([[response.data objectForKey:@"havenext"] isEqualToString:@"1"]) {
//                                [_tbv reloadData:NO];
//                            }else{
//                                [_tbv reloadData:YES];
//                            }
//                        }else{//没获取到数据,恢复headerView
//                            [_tbv reloadData:YES];
//                        }
//                        
//                    }
                    
                }else if ([response response] ==khttpfailCode){
                    
                }
                
                [self.view setUserInteractionEnabled:YES];
                
            }
                
                break;
                
            case 2://加载更多
//            {
//                JsonResponse *response = (JsonResponse *)receiveObj;
//                
//                if ([response response] ==khttpsucceedCode)
//                {
//                    NSArray *list=[response.data objectForKey:@"reqlist"];
//                    for (NSDictionary *d in list) {
//                        reqlist *model = [reqlist JSONReflection:d];
//                        if (!_tbv.muA_singelSectionData) {
//                            _tbv.muA_singelSectionData=[NSMutableArray arrayWithObject:model];
//                            [_tbv.muA_singelSectionData retain];
//                        }else{
//                            [_tbv.muA_singelSectionData addObject:model];
//                        }
//                    }
//                    
//                    //                    if (list.count>0) {
//                    //                        [_tbv reloadData:NO];
//                    //                    }else{
//                    //                        [_tbv.footerView changeState:PULLSTATEEND];
//                    //                    }
//                    
//                    {//加载更多
//                        if (_tbv.muA_singelSectionData.count>0 && list.count>0) {
//                            
//                            if ([[response.data objectForKey:@"havenext"] isEqualToString:@"1"]) {
//                                [_tbv reloadData:NO];
//                            }else{
//                                [_tbv reloadData:YES];
//                            }
//                        }else{//没获取到数据,恢复headerView
//                            [_tbv reloadData:YES];
//                        }
//                        
//                    }
//                    
//                    [self.view setUserInteractionEnabled:YES];
//                    return;
//                    
//                }else if ([response response] ==khttpfailCode)
//                {
//                    
//                }
//                
//                [self.view setUserInteractionEnabled:YES];
//                [_tbv.footerView changeState:PULLSTATEEND];
//                
//                
//            }
                break;
                
            default:
                break;
        }
    }
}

@end
