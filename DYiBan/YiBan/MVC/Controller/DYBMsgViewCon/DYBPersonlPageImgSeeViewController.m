//
//  DYBPersonlPageImgSeeViewController.m
//  DYiBan
//
//  Created by Song on 13-9-13.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBPersonlPageImgSeeViewController.h"
#import "album_piclist.h"
@interface DYBPersonlPageImgSeeViewController ()

@end

@implementation DYBPersonlPageImgSeeViewController
@synthesize imgArray = _imgArray;
@synthesize getInObjectl = _getInObjectl;
@synthesize albumId,ifReadOne,userId,allImgCount=_allImgCount,iswillred = _iswillred,type = _type;
- (void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal
{
    if ([signal is:[MagicViewController WILL_APPEAR]])
    {
        [self backImgType:7];

//        [self setButtonImage:self.leftButton setImage:@"btn_back_def"];
        [self.headview setTitle:[@"" stringByAppendingFormat:@"%d/%d",[_imgArray indexOfObject:_getInObjectl]+1,_allImgCount]];
        [self.headview setTitleColor:[UIColor whiteColor]];
        self.headview.backgroundColor=[MagicCommentMethod color:0 green:0 blue:0 alpha:0.2];
        self.headview.lineView.hidden=YES;
        [self backImgType:10];
        
        
        [self.rightButton setImage:[UIImage imageNamed:@"btn_savetolocal_def"] forState:UIControlStateNormal];
        [self.rightButton setImage:[UIImage imageNamed:@"btn_savetolocal_hlt"] forState:UIControlStateHighlighted];
        
    }else if ([signal is:[MagicViewController CREATE_VIEWS]])
    {
        array = [[NSMutableArray alloc]init];;
        for (int i = 0; i < [_imgArray count]; i++) {
            NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[[_imgArray objectAtIndex:i] pic_b], kSHOWIMGKEY, @"no_pic_50.png", kDEFAULTIMGKEY ,nil];
            [array addObject:dict];
        }
        
        scroller = [[MagicUIScrollListView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT-20)];
        scroller.backgroundColor = [UIColor blackColor];
        [self.view addSubview:scroller];
        [scroller setImgArr:array];
        [scroller setSelectIndex:[_imgArray indexOfObject:_getInObjectl]];
        RELEASE(scroller);
    }
}

- (void)handleViewSignal_MagicUIScrollListView:(MagicViewSignal *)signal
{
    NSDictionary *dict = (NSDictionary *)[signal object];
    NSString *index= [dict objectForKey:@"index"];
    currentImg = [index intValue];
    
    [self.headview setTitle:[@"" stringByAppendingFormat:@"%d/%d",[index intValue]+1,_allImgCount]];
    if ([signal is:[MagicUIScrollListView SCROLLVIEWNUM]]) {
        
        if ([array count] - [index intValue] <= 10) {
            
            if (_type == 0) {
                [self getNewImgList];
            }
        
        }
        
        
    }
    
//    DLogInfo(@"sView == %f", sView.contentOffset.x);
    
}


#pragma mark- 
- (void)handleViewSignal_DYBBaseViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBBaseViewController BACKBUTTON]])
    {
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
    if ([signal is:[DYBBaseViewController NEXTSTEPBUTTON]])
    {

        [self didPressSaveButton];
    }
    
}

- (UIImage *)currentImg{//当前img
    
    NSDictionary *imgDict = [array objectAtIndex:currentImg];
    MagicUIImageView *i = [[MagicUIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-20)];
    [i setImgWithUrl:[imgDict objectForKey:kSHOWIMGKEY] defaultImg:[imgDict objectForKey:kDEFAULTIMGKEY]];
    UIImage *img = [[i image] retain];
    return img;
}


//保存图片
- (void)didPressSaveButton
{
    UIImage *pic = [self currentImg];
	if (pic!=nil)
	{
        @try
        {
            UIImageWriteToSavedPhotosAlbum(pic, nil, nil, nil);
        }
        @catch (NSException *exception) {
        }
        
        
		[DYBShareinstaceDelegate loadFinishAlertView:@"照片已保存" target:self];
	}
}


- (void)getNewImgList{
    
        NSInteger readPage = ([array count])/24+1;
    DLogInfo(@"=============请求第几页数据%d",readPage);
    
        MagicRequest *request = [DYBHttpMethod albumList:userId albumId:albumId num:24 page:readPage isAlert:NO receive:self];
        [request setTag:1];

}

#pragma mark- 只接受HTTP信号
- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj
{
    if ([request succeed])
    {
        switch (request.tag) {
            case 1://加载
            {
                JsonResponse *response = (JsonResponse *)receiveObj;
                if ([response response] ==khttpsucceedCode)
                {
                    album_piclist *albumlist = [album_piclist JSONReflection:response.data];
//                    _iswillred = albumlist.havenext;
                    
                    DLogInfo(@"======是否======%@",albumlist.havenext);
                    DLogInfo(@"======是否加载下一页======%d",_iswillred);
                    
                    DLogInfo(@"======获得的数组个数======%d",[albumlist.albums count]);
                    
                    if (_iswillred) {
                        
                        DLogInfo(@"========正在加载下一页");
                        
                        
                        for (int i = 0; i < [albumlist.albums count]; i++) {
                            NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[[albumlist.albums objectAtIndex:i] pic_b], kSHOWIMGKEY, @"demo1.png", kDEFAULTIMGKEY ,nil];
                            [array addObject:dict];
                        }
                        
                        [scroller setImgArr:array];
                    }
                    
                    if ([albumlist.havenext isEqualToString:@"1"]) {
                        _iswillred = YES;
                        
                        
                    }else{
                        _iswillred = NO;
                    }
                    
                }
                if ([response response] ==khttpfailCode)
                {
                    
                    
                }
            }
                break;
                
        }
    }
}



//
////保存图片
//- (void)didPressSaveButton:(id)sender
//{
//    //	UIImage *pic = [self.picArray objectAtIndex:self.lastPage];
//    UIImage *pic = [scrollView currentImg];
//	if (pic!=nil)
//	{
//        @try
//        {
//            UIImageWriteToSavedPhotosAlbum(pic, nil, nil, nil);
//        }
//        @catch (NSException *exception) {
//        }
//		
//		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
//														message:NSLocalizedString(@"照片已保存", @"")
//													   delegate:nil
//											  cancelButtonTitle:NSLocalizedString(@"确定", @"title")
//											  otherButtonTitles:nil];
//		[alert show];
//		[alert release];
//	}
//}



@end
