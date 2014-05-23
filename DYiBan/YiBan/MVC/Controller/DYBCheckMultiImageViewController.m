//
//  DYBCheckMultiImageViewController.m
//  DYiBan
//
//  Created by Hyde.Xu on 13-9-13.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBCheckMultiImageViewController.h"
#import "NSString+Count.h"

@interface DYBCheckMultiImageViewController ()

@end

@implementation DYBCheckMultiImageViewController

-(void)dealloc{
    [super dealloc];
    
    RELEASE(_arrIMG);
}


- (id)initWithMultiImage:(NSArray *)arrIMG nCurSel:(NSInteger)nSel{
    self = [super init];
    if (self) {
        _arrIMG = [[NSArray alloc] initWithArray:arrIMG];
        _nSel = nSel;
    }
    return self;
}


- (void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal
{
    
    if ([signal is:[MagicViewController CREATE_VIEWS]])
    {
        NSMutableArray *array = [[NSMutableArray alloc]init];;
        for (int i = 0; i < [_arrIMG count]; i++) {
            NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[_arrIMG objectAtIndex:i], kSHOWIMGKEY, @"noface_64.png", kDEFAULTIMGKEY ,nil];
            [array addObject:dict];
            RELEASE(dict);
        }
        
        MagicUIScrollListView *scroller = [[MagicUIScrollListView alloc] initWithFrame:CGRectMake(0, self.headHeight,SCREEN_WIDTH, SCREEN_HEIGHT-self.headHeight-20)];
        [self.view addSubview:scroller];
        [scroller setImgArr:array];
        [scroller setSelectIndex:_nSel];
        RELEASE(scroller);
        RELEASE(array);

    }else if([signal is:[MagicViewController WILL_APPEAR]])
    {
        [self.view setBackgroundColor:[UIColor blackColor]];
        [self.headview setBackgroundColor:[UIColor clearColor]];
        [self.headview setTitle:@"查看图片"];
        [self.headview setTitleColor:[UIColor whiteColor]];
        [self backImgType:7];
        [self backImgType:11];
        self.headview.lineView.hidden=YES;
    }
    
}

#pragma mark - 返回Button处理
- (void)handleViewSignal_DYBBaseViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBBaseViewController NEXTSTEPBUTTON]]){
        
        UIImage *_curImage = nil;
        NSString *encondeUrl= [[_arrIMG objectAtIndex:_curSel] stringByAddingPercentEscapesUsingEncoding];
        
        if ([NSURL URLWithString:encondeUrl] != nil) {
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:encondeUrl]];
            _curImage = [[UIImage alloc] initWithData:data];
        }

        if (_curImage) {
             UIImageWriteToSavedPhotosAlbum(_curImage, nil, nil, nil);
            [DYBShareinstaceDelegate loadFinishAlertView:@"保存成功" target:self];
            
             RELEASE(_curImage);
        }

        [self.drNavigationController popVCAnimated:YES];
        [self sendViewSignal:[MagicViewController VCBACKSUCCESS]];
    }else if ([signal is:[DYBBaseViewController BACKBUTTON]]){
        [self.drNavigationController popVCAnimated:YES];
        [self sendViewSignal:[MagicViewController VCBACKSUCCESS]];
    }
    
}

- (void)handleViewSignal_MagicUIScrollListView:(MagicViewSignal *)signal
{
    if ([signal is:[MagicUIScrollListView SCROLLVIEWNUM]]) {
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSString *index= [dict objectForKey:@"index"];
        _curSel = [index intValue];
    }
    
}
@end
