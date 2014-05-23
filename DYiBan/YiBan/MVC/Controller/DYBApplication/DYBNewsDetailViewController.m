//
//  DYBNewsDetailViewController.m
//  DYiBan
//
//  Created by Song on 13-9-11.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBNewsDetailViewController.h"
#import "DYBXinhuaNewsTopicCellView.h"
#import "DYBXinhuaNewsContentCellView.h"
#import "news_detail_info.h"
#import "DYBPersonlPageImgSeeViewController.h"
#import "pics.h"
@interface DYBNewsDetailViewController ()

@end

@implementation DYBNewsDetailViewController
@synthesize items;
- (void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal
{
    if ([signal is:[MagicViewController WILL_APPEAR]])
    {
        
        [self.rightButton setHidden:YES];
        [self.headview setTitle:@"新闻详情"];
        [self backImgType:0];
    }else if ([signal is:[MagicViewController CREATE_VIEWS]])
    {
        _tableView = [[MagicUITableView alloc] initWithFrame:CGRectMake(0, self.headHeight, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-self.headHeight-20)];
        [_tableView setShowsHorizontalScrollIndicator:NO];
        [_tableView setShowsVerticalScrollIndicator:NO];
        [_tableView setBackgroundColor:[UIColor clearColor]];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [[_tableView footerView] setHidden:YES];
//        [_tableView.footerView changeState:PULLSTATEEND];
        [_tableView setTableViewType:DTableViewSlime];
        
        [self.view addSubview:_tableView];
        [_tableView release];
        
        
    }
}

- (void)viewBigPic{
    
}

#pragma mark - UITableViewDataSource
- (void)handleViewSignal_MagicUITableView:(MagicViewSignal *)signal
{
    if ([signal is:[MagicUITableView TABLENUMROWINSEC]])/*numberOfRowsInSection*/{
        
        NSNumber *s= [NSNumber numberWithInteger:2];
        
        [signal setReturnValue:s];
        
    }else if([signal is:[MagicUITableView TABLENUMOFSEC]])/*numberOfSectionsInTableView*/{
        NSNumber *s = [NSNumber numberWithInteger:1];
        [signal setReturnValue:s];
        
    }else if([signal is:[MagicUITableView TABLEHEIGHTFORROW]])/*heightForRowAtIndexPath*/{
        
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        NSNumber *s;
        if ([indexPath row] == 0)
            s =  [NSNumber numberWithInteger:[DYBXinhuaNewsTopicCellView getHeightByNewsModel:items]];
        else if ([indexPath row]  == 1)
            s =  [NSNumber numberWithInteger:[DYBXinhuaNewsContentCellView getHeightByNewsModel:items]];
        else
            s =  [NSNumber numberWithInteger:0];
        
        [signal setReturnValue:s];
        
    }else if([signal is:[MagicUITableView TABLECELLFORROW]])/*cell*/{
        
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        
        static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
        
        UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableSampleIdentifier] autorelease];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            if ([indexPath row] == 0) {
                DYBXinhuaNewsTopicCellView *cellDetail = [[[DYBXinhuaNewsTopicCellView alloc] initWithFrame:cell.frame news_info:items] autorelease];
                [cell addSubview:cellDetail];
            }
            else if([indexPath row] == 1){
                float cellheight = [_tableView rectForRowAtIndexPath:indexPath].size.height;
                
                DYBXinhuaNewsContentCellView *cellContent = [[[DYBXinhuaNewsContentCellView alloc] initWithFrame:CGRectMake(0, 0, 320, cellheight) news_info:items] autorelease];
                [cell addSubview:cellContent];
            }
            
        }        
        
        [signal setReturnValue:cell];
        
        
    }else if([signal is:[MagicUITableView TABLEDIDSELECT]])/*选中cell*/{
        
        
    }
    else if([signal is:[MagicUITableView TABLEVIEWFORHEADERINSECTION]])/*viewForHeaderInSection*/{
        
        [signal setReturnValue:nil];
    }else if ([signal is:[MagicUITableView TABLEVIEWUPDATA]])//刷新
    {
        
        MagicUITableView *tableView = (MagicUITableView *)[signal source];
        
        {//HTTP请求
            MagicRequest *request = [DYBHttpMethod xinhuanews_detail:info.id category_id:info.category_id isAlert:YES receive:self];
            [request setTag:1];
            
            if (!request) {//无网路
                [tableView reloadData:NO];
            }
        }
    }
}

- (void)handleViewSignal_DYBXinhuaNewsContentCellView:(MagicViewSignal *)signal {
    
    if ([signal is:[DYBXinhuaNewsContentCellView IMAGECLICKEEND]]) {
        
        NSMutableArray *array = [[NSMutableArray alloc]init];
        for (int i = 0 ; i <[self.items.pics count] ; i++) {
            [array addObject:[self.items.pics objectAtIndex:i]];
        }
        
        DYBPersonlPageImgSeeViewController *detail = [[DYBPersonlPageImgSeeViewController alloc] init];
        [detail setGetInObjectl:[self.items.pics objectAtIndex:0]];
        [detail setIswillred:NO];
        [detail setAllImgCount:1];
        [detail setImgArray:array];
        [detail setType:1];
        [self.drNavigationController pushViewController:detail animated:YES];
        RELEASE(detail);


        
    }
    
}

- (void)initNewsDetail:(news *)news_info
{
    info = news_info;
    NSLog(@"=======%@",news_info.id);
    MagicRequest *request = [DYBHttpMethod xinhuanews_detail:news_info.id category_id:news_info.category_id isAlert:YES receive:self];
    [request setTag:1];
}

#pragma mark- HTTP
- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj
{
    
    if ([request succeed])
    {
        
        //登陆
        if (request.tag == 1) {
            
            JsonResponse *response = (JsonResponse *)receiveObj;
            if ([response response] ==khttpsucceedCode)
            {
                self.items = [news JSONReflection:[[response data] objectForKey:@"news"]];
//                news_detail_info *list = [news_detail_info JSONReflection:[[response data] objectForKey:@"news"]];
//                self.items = list.news;
                
                
                [_tableView reloadData:YES];
                
                
            }
            if ([response response] ==khttpfailCode)
            {
                
                
            }
        }
        
        
    }
}



@end
