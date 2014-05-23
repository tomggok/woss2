//
//  DYBXinHualistViewController.m
//  DYiBan
//
//  Created by Song on 13-9-11.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBXinHualistViewController.h"
#import "news.h"
#import "DYBXinhuaNewsCellView.h"
#import "UITableView+property.h"
#import "DYBNewsDetailViewController.h"
@interface DYBXinHualistViewController ()

@end

@implementation DYBXinHualistViewController

- (void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal
{
    if ([signal is:[MagicViewController WILL_APPEAR]])
    {
        
        [self.rightButton setHidden:YES];
        [self.headview setTitle:@"今日易头条"];
    }else if ([signal is:[MagicViewController CREATE_VIEWS]])
    {
        items = [[NSMutableArray alloc] init];
        
        _tableView = [[MagicUITableView alloc] initWithFrame:CGRectMake(0, self.headHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-self.headHeight-20)];
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

#pragma mark - UITableViewDataSource
- (void)handleViewSignal_MagicUITableView:(MagicViewSignal *)signal
{
    if ([signal is:[MagicUITableView TABLENUMROWINSEC]])/*numberOfRowsInSection*/{
        
        NSNumber *s= [NSNumber numberWithInteger:[items count]];
        
        [signal setReturnValue:s];
        
    }else if([signal is:[MagicUITableView TABLENUMOFSEC]])/*numberOfSectionsInTableView*/{
        NSNumber *s = [NSNumber numberWithInteger:1];
        [signal setReturnValue:s];
        
    }else if([signal is:[MagicUITableView TABLEHEIGHTFORROW]])/*heightForRowAtIndexPath*/{
        
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        //这里控制值的大小
        news_list *news_one = (news_list *)[items objectAtIndex:[indexPath row]];
        
        NSNumber *s;
        if ([news_one.pics count] > 0) {
            s = [NSNumber numberWithInteger:107.0];
        }else {
            s = [NSNumber numberWithInteger:97.0];
        }
        
        [signal setReturnValue:s];
        
    }else if([signal is:[MagicUITableView TABLECELLFORROW]])/*cell*/{
        
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        
        static NSString *CellIdentifier = @"Cell";
        
        UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
            
            NSUInteger row = [indexPath row];
            
            UIImageView *imageSeparator = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
            [imageSeparator setImage:[UIImage imageNamed:@"cellLineSmall.png"]];
            [imageSeparator setBackgroundColor:[UIColor clearColor]];
            
            if (row > 0) {
                [cell addSubview:imageSeparator];
            }
            
            [imageSeparator release];
            
            news_list *news_one = (news_list *)[items objectAtIndex:[indexPath row]];
            
            DYBXinhuaNewsCellView *cellDetail = [[DYBXinhuaNewsCellView alloc] initWithFrame:cell.frame news_info:news_one];
            [cell addSubview:cellDetail];
            [cellDetail release];
        }
        
        
        [signal setReturnValue:cell];
        
        
    }else if([signal is:[MagicUITableView TABLEDIDSELECT]])/*选中cell*/{
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        news *news_one = (news *)[items objectAtIndex:[indexPath row]];

        DYBNewsDetailViewController *vc = [[DYBNewsDetailViewController alloc] init];
        [vc initNewsDetail:news_one];
        [self.drNavigationController pushViewController:vc animated:YES];
        RELEASE(vc);
        

        
    }
    else if([signal is:[MagicUITableView TABLEVIEWFORHEADERINSECTION]])/*viewForHeaderInSection*/{
        
        [signal setReturnValue:nil];
    }else if ([signal is:[MagicUITableView TABLEVIEWUPDATA]])//刷新
    {
        
        MagicUITableView *tableView = (MagicUITableView *)[signal source];
        
        {//HTTP请求
            MagicRequest *request = [DYBHttpMethod xinhuanews_list:info.id num:@"10" page:@"1" category_id:info.category_id isAlert:YES receive:self];
            [request setTag:1];
            
            if (!request) {//无网路
                [tableView reloadData:NO];
            }
        }
    }
    else if ([signal is:[MagicUITableView TAbLEVIEWLODATA]])//加载更多
    {
        
        MagicRequest *request = [DYBHttpMethod xinhuanews_list:info.id num:@"10" page:[@"" stringByAppendingFormat:@"%d",++_tableView._page] category_id:info.category_id isAlert:YES receive:self];
        [request setTag:2];
        if (!request) {//无网路
            [_tableView reloadData:NO];
        }
    }
}



- (void)initNewsList:(news_list *)news_info
{
    info = news_info;
    MagicRequest *request = [DYBHttpMethod xinhuanews_list:news_info.id num:@"10" page:@"1" category_id:news_info.category_id isAlert:YES receive:self];
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
                if (items.count > 0) {
                    [items removeAllObjects];
                }
                
                news_list *list = [news_list JSONReflection:[response data]];
                if (items.count > 0 && list.content > 0) {
                    [items removeAllObjects];
                }
                self.havenext =  list.havenext;
                
                
                
                for (news *dic in list.news_list) {
                    [items addObject:dic];
                }
                
                if ([self.havenext isEqualToString:@"1"]) {
                    [_tableView reloadData:NO];
                }else {
                    [_tableView reloadData:YES];
                }
                
                
                
            }
            if ([response response] ==khttpfailCode)
            {
                
                
            }
        }
        
        if (request.tag == 2)//加载更多
        {
            JsonResponse *response = (JsonResponse *)receiveObj;
            
            if ([response response] ==khttpsucceedCode)
            {
                news_list *list = [news_list JSONReflection:[response data]];
                self.havenext =  list.havenext;
                
                for (news *dic in list.news_list) {
                    [items addObject:dic];
                }
                
                if ([self.havenext isEqualToString:@"1"]) {
                    [_tableView reloadData:NO];
                }else {
                    [_tableView reloadData:YES];
                }
                
                
            }else if ([response response] ==khttpfailCode)
            {
                
            }
        }

        
    }
}

@end
