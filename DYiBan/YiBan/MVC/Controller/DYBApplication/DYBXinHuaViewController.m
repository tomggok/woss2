//
//  DYBXinHuaViewController.m
//  DYiBan
//
//  Created by Song on 13-9-11.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBXinHuaViewController.h"
#import "news_list.h"
#import "DYBXinhuaNewsCellView.h"
#import "DYBXinHualistViewController.h"
#import "news.h"
#import "DYBNewsDetailViewController.h"
@interface DYBXinHuaViewController ()

@end

@implementation DYBXinHuaViewController
@synthesize items,arrayDict,arrayIndexKey;

- (void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal
{
    if ([signal is:[MagicViewController WILL_APPEAR]])
    {
        
        [self.rightButton setHidden:YES];
        [self.headview setTitle:@"新华e讯"];
        [self backImgType:0];
    }else if ([signal is:[MagicViewController CREATE_VIEWS]])
    {
        items = [[NSMutableArray alloc] init];
        arrayDict = [[NSMutableDictionary alloc] init];
        arrayIndexKey = [[NSMutableArray alloc] init];
        
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
        
//        if ([[SHARED cacheDataDict] objectForKey:CACHEDATAKEYXINHUA]) {//缓存中有数据就读缓存
//            [self cacheLoadDict];
//        }else{
        
        MagicRequest *request = [DYBHttpMethod xinhunews_index:@"2" isAlert:YES receive:self];
        [request setTag:1];
        
//        }

        
    }
}

#pragma mark - UITableViewDataSource


- (void)handleViewSignal_MagicUITableView:(MagicViewSignal *)signal
{
    if ([signal is:[MagicUITableView TABLENUMROWINSEC]])/*numberOfRowsInSection*/{
        
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSString *section = [dict objectForKey:@"section"];
        
        NSNumber *s;
        if ([arrayIndexKey count] == 0) {
            s = [NSNumber numberWithInteger:0];
        }else {
            
            NSString *key = [arrayIndexKey objectAtIndex:[section intValue]];
            NSArray *nameSection = [arrayDict objectForKey:key];
            s = [NSNumber numberWithInteger:[nameSection count]];
        }
        
        [signal setReturnValue:s];
        
    }else if([signal is:[MagicUITableView TABLENUMOFSEC]])/*numberOfSectionsInTableView*/{
        NSNumber *s = [NSNumber numberWithInteger:([arrayIndexKey count] > 0) ? [arrayIndexKey count] : 0];
        [signal setReturnValue:s];
        
    }else if([signal is:[MagicUITableView TABLEHEIGHTFORROW]])/*heightForRowAtIndexPath*/{
        
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        //这里控制值的大小
        NSArray *arrNews = [arrayDict objectForKey:[arrayIndexKey objectAtIndex:[indexPath section]]];
        
        news_list *news_one = (news_list *)[arrNews objectAtIndex:[indexPath row]];
        
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
            
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
            NSUInteger row = [indexPath row];
            
            UIImageView *imageSeparator = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
            [imageSeparator setImage:[UIImage imageNamed:@"cellLineSmall.png"]];
            [imageSeparator setBackgroundColor:[UIColor clearColor]];
            
            if (row > 0) {
                [cell addSubview:imageSeparator];
            }
            
            [imageSeparator release];
            
            NSArray *arrNews = [arrayDict objectForKey:[arrayIndexKey objectAtIndex:[indexPath section]]];
            news_list *news_one = (news_list *)[arrNews objectAtIndex:[indexPath row]];
            
            DYBXinhuaNewsCellView *cellDetail = [[DYBXinhuaNewsCellView alloc] initWithFrame:cell.frame news_info:news_one];
            [cell addSubview:cellDetail];
            [cellDetail release];
        }
    
        
        [signal setReturnValue:cell];
        
        
    }else if([signal is:[MagicUITableView TABLEDIDSELECT]])/*选中cell*/{
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        NSArray *arrNews = [arrayDict objectForKey:[arrayIndexKey objectAtIndex:[indexPath section]]];
        news *news_one = (news *)[arrNews objectAtIndex:[indexPath row]];
        
        DYBNewsDetailViewController *vc = [[DYBNewsDetailViewController alloc] init];
        [vc initNewsDetail:news_one];
        [self.drNavigationController pushViewController:vc animated:YES];
        RELEASE(vc);

    }
    else if([signal is:[MagicUITableView TABLEVIEWFORHEADERINSECTION]])/*viewForHeaderInSection*/{
        
        
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSString *section = [dict objectForKey:@"section"];
        
        UIImage *imageBKG = [UIImage imageNamed:@"newsTitle.png"];
        UIImage *imageButBKG = [UIImage imageNamed:@"newsTitleAn.png"];
        UIImage *imageArrow = [UIImage imageNamed:@"rightArrow.png"];
        
        MagicUIImageView *headerView = [[MagicUIImageView alloc] initWithFrame:CGRectMake(0, 0, imageBKG.size.width/2, imageBKG.size.height/2)];
        [headerView setBackgroundColor:[UIColor redColor]];
        [headerView setImage:imageBKG];
        [headerView setUserInteractionEnabled:YES];
        
        
        MagicUIButton *titButton = [[MagicUIButton alloc] initWithFrame:CGRectMake(0, 0, imageBKG.size.width/2, imageBKG.size.height/2)];
        titButton.titleEdgeInsets = UIEdgeInsetsMake(2, 200, 0, 0);
        [titButton setTitle:@"查看更多" forState:UIControlStateNormal];
        [titButton setTitleColor:[UIColor colorWithRed:0/255.0 green:85/255.0 blue:113/255.0 alpha:1] forState:UIControlStateNormal];
        [titButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
        [titButton setBackgroundImage:imageBKG forState:UIControlStateNormal];
        [titButton setBackgroundImage:imageButBKG forState:UIControlStateHighlighted];
        [titButton addTarget:self action:@selector(preesTitleButton:) forControlEvents:UIControlEventTouchUpInside];
        titButton.tag = [section intValue];
        
        UIImageView *imageviewArrow =[[[UIImageView alloc] initWithFrame:CGRectMake(295, 8, 9, 14)] autorelease];
        [imageviewArrow setImage:imageArrow];
        
        UILabel *titNeiName = [[[UILabel alloc] initWithFrame:CGRectMake(15, -2, 80, imageBKG.size.height/2)] autorelease];
        titNeiName.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        titNeiName.textColor = [UIColor colorWithRed:10/255.0 green:10/255.0 blue:10/255.0 alpha:1];
        titNeiName.textAlignment = UITextAlignmentLeft;
        titNeiName.backgroundColor = [UIColor clearColor];
        
        [headerView addSubview:titButton];
        if ([section intValue] > [self.arrayIndexKey count]-1) {
            [signal setReturnValue:nil];
        }
        else if ([section intValue] < [self.arrayIndexKey count])
        {
            news_list *newListModel = [items objectAtIndex:[section intValue]];
            titNeiName.text = newListModel.category;
            if ([newListModel.havemore isEqualToString:@"1"]) {
                titButton.userInteractionEnabled = YES;
                [titButton addSubview:imageviewArrow];
            }else {
                [titButton setTitle:@"" forState:UIControlStateNormal];
                titButton.userInteractionEnabled = NO;
            }
            
            [headerView addSubview:titNeiName];
            [headerView bringSubviewToFront:titNeiName];
            [signal setReturnValue:headerView];
        }
    }
    else if ([signal is:[MagicUITableView TABLETHEIGHTFORHEADERINSECTION]])//heightForHeaderInSection
    {
        [signal setReturnValue:[NSNumber numberWithFloat:33]];
        
    }else if ([signal is:[MagicUITableView TABLEVIEWUPDATA]])//刷新
    {
        
        MagicUITableView *tableView = (MagicUITableView *)[signal source];
        
        {//HTTP请求
            MagicRequest *request = [DYBHttpMethod xinhunews_index:@"2" isAlert:YES receive:self];
            [request setTag:1];
            
            if (!request) {//无网路
                [tableView reloadData:NO];
            }
        }
    }
}


-(void)preesTitleButton:(id)sender{
    UIButton *btn = (UIButton *)sender;
    
    NSArray *arrNews = [arrayDict objectForKey:[arrayIndexKey objectAtIndex:btn.tag]];
    news_list *news_one = (news_list *)[arrNews objectAtIndex:0];
    
    
    DYBXinHualistViewController *vc = [[DYBXinHualistViewController alloc] init];
    [vc initNewsList:news_one];
    [self.drNavigationController pushViewController:vc animated:YES];
    RELEASE(vc);
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
                
                NSArray *list = [[response data] objectForKey:@"news_list"];
                
                if (arrayIndexKey.count>0 && list.count>0) {
                    [arrayIndexKey removeAllObjects];
                    
                }
                
                for (NSDictionary *d in list) {
                    news_list *model = [news_list JSONReflection:d];
                    [items addObject:model];
                }
                
                
                NSMutableArray *sectionsToRemove = [[NSMutableArray alloc] init];
                
                for (news_list *dic in items) {
                    if ([dic.news_list count] > 0) {
                        [arrayIndexKey addObject:dic.category];
                        //            [arrayDict setValue:[dic.news retain] forKey:dic.category];
                        [arrayDict setValue:dic.news_list forKey:dic.category];
                    }
                    else{
                        [sectionsToRemove addObject:dic];
                    }
                }
                
                [items removeObjectsInArray:sectionsToRemove];
                [sectionsToRemove release];

                [_tableView reloadData:YES];
                
            }
            if ([response response] ==khttpfailCode)
            {
                
                
            }
        }
    }
    
}

@end
