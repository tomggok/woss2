//
//  DYBCellForBanner.m
//  DYiBan
//
//  Created by Hyde.Xu on 13-8-20.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBCellForBanner.h"
#import "banner.h"
#import "bannerList.h"
#import "NSString+Count.h"
#import "UIImageView+WebCache.h"
#import "NSString+Count.h"
#import "DYBDynamicViewController.h"

@implementation DYBCellForBanner

DEF_SIGNAL(CLOSEBUTTON)

-(void)dealloc{
    RELEASEDICTARRAYOBJ(_arrBnerView);
    RELEASEDICTARRAYOBJ(_arrBnerData);
    
    [super dealloc];
}


#pragma mark- 设置整体Cell
-(void)setContent:(id)data indexPath:(NSIndexPath *)indexPath tbv:(UITableView *)tbv{
    if (data){
        _arrBnerView = [[NSMutableArray alloc] init];
        _arrBnerData = [[NSMutableArray alloc] init];
        bannerList *_bnerlist = data;
        bStop = NO;
        nCurViewTag = 0;
        
        for (banner *_bner in _bnerlist.banner) {
            MagicUIImageView *_bnerView = [self createBanner:_bner.banner_img url:_bner.url];
            [_arrBnerView addObject:_bnerView];
            [_arrBnerData addObject:_bner];
        }
        
        _btnClose= [[MagicUIButton alloc] initWithFrame:CGRectMake(280.0f, 18.0f, 30.0f, 30.0f)];
        [_btnClose setBackgroundImage:[UIImage imageNamed:@"adclose.png"] forState:UIControlStateNormal];
        [_btnClose setBackgroundImage:[UIImage imageNamed:@"adclose.png"] forState:UIControlStateHighlighted];
        [_btnClose addSignal:[DYBCellForBanner CLOSEBUTTON] forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnClose];
        RELEASE(_btnClose);
        
        if ([_arrBnerView count] > 0) {
            [((MagicUIImageView *)[_arrBnerView objectAtIndex:0]) setAlpha:1.0f];
            [self setFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 60)];
            
            _bannerQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            
            dispatch_async(_bannerQ, ^{
                [self startTheBackgroundJob];
                });
        }
    }
}

- (MagicUIImageView *)createBanner:(NSString *)strBnner url:(NSString *)strURL{
    MagicUIImageView *_Banner = [[MagicUIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 60) backgroundColor:[UIColor clearColor] image:nil isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:self Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
    [_Banner setAlpha:0.0f];
    [_Banner setTag:nCurViewTag];
    nCurViewTag++;
    
    [_Banner setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapLabelWithGesture:)];
    [_Banner addGestureRecognizer:tapGestureRecognizer];
    RELEASE(tapGestureRecognizer);
    
    NSString *encondeUrl= [strBnner stringByAddingPercentEscapesUsingEncoding];  
    
    if ([NSURL URLWithString:encondeUrl] == nil) {
        [_Banner setImage:[UIImage imageNamed:@"ad_blank.png"]];
    }else
    {
        _Banner._b_isShade=YES;
        [_Banner setImageWithURL:[NSURL URLWithString:encondeUrl] placeholderImage:[UIImage imageNamed:@"ad_blank.png"]];
        
    }
    
    [self addSubview:_Banner];
    RELEASE(_Banner);
    
    return _Banner;
}

- (void)didTapLabelWithGesture:(UITapGestureRecognizer *)tapGesture {
    @try {
        UIView *tappedView = [tapGesture.view hitTest:[tapGesture locationInView:tapGesture.view] withEvent:nil];
        DLogInfo(@"%d", tappedView.tag);
        DLogInfo(@"%@", ((banner *)[_arrBnerData objectAtIndex:tappedView.tag]).url);
        DLogInfo(@"%@", ((banner *)[_arrBnerData objectAtIndex:tappedView.tag]).banner_img);
        
        [self sendViewSignal:[DYBDynamicViewController OPENURL] withObject:((banner *)[_arrBnerData objectAtIndex:tappedView.tag]).url];
    }
    @catch (NSException *exception) {
        DLogInfo(@"main: Caught %@: %@", [exception name], [exception reason]);
    }
}

-(void)startTheBackgroundJob{
    [self RollBanner:_arrBnerView];
}

- (void)RollBanner:(NSArray *)arrBanner{
    int i = 0;
    
    while (!bStop && [_arrBnerView count] > 1) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:2];
            
            for (MagicUIImageView *imgBnr in arrBanner) {
                [imgBnr setAlpha:0.0f];
            }
            
            [self bringSubviewToFront:((MagicUIImageView *)[_arrBnerView objectAtIndex:i])];         

            [((MagicUIImageView *)[_arrBnerView objectAtIndex:i]) setAlpha:1.0f];
            [UIView commitAnimations];
            
            [self bringSubviewToFront:_btnClose];
            
        }); 

        i++;
        
        [NSThread sleepForTimeInterval:5];
        
        if (i == [arrBanner count]) {
            i = 0;
        }

    } 
}

- (void)handleViewSignal_DYBCellForBanner:(MagicViewSignal *)signal{
    if ([signal is:[DYBCellForBanner CLOSEBUTTON]]){
        DLogInfo(@"close");
        bStop = YES;
        
        dispatch_release(_bannerQ);
        
        [self sendViewSignal:[DYBDynamicViewController CLOSEAD]];
    }
}

@end
