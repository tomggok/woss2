//
//  DYBCheckImageViewController.m
//  DYiBan
//
//  Created by Hyde.Xu on 13-8-23.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBCheckImageViewController.h"
#import "UIImageView+WebCache.h"
#import "NSString+Count.h"
#import "DYBPublishViewController.h"

@interface DYBCheckImageViewController ()

@end

@implementation DYBCheckImageViewController

@synthesize nInitYpe=_nInitYpe,bIsNeedDeleBt=_bIsNeedDeleBt;

DEF_NOTIFICATION(DELETEMAGE) //删除信号


- (id)initWithURL:(NSString *)imageURL
{
    self = [super init];
    if (self) {
         _strIMAGEurl = imageURL;
        _nInitYpe = 1;
    }
    return self;
}

- (id)initWithImage:(UIImage *)image{
    self = [super init];
    if (self) {
        _image = image;
        _nInitYpe = 2;
        _bIsNeedDeleBt=YES;
    }
    return self;
}

- (void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal
{
    
    if ([signal is:[MagicViewController CREATE_VIEWS]])
    {
        MagicUIImageView *imageView = nil;
        
        if (_nInitYpe == 1) {
            imageView = [[MagicUIImageView alloc] initWithImage:[UIImage imageNamed:@"info_at_new.png"]];//换背景图
            
            NSString *encondeUrl= [_strIMAGEurl stringByAddingPercentEscapesUsingEncoding];
            if ([NSURL URLWithString:encondeUrl] == nil) {
                [imageView setImage:[UIImage imageNamed:@"no_pic.png"]];
            }else{
                imageView._b_isShade=NO;
                [imageView setImageWithURL:[NSURL URLWithString:encondeUrl] placeholderImage:[UIImage imageNamed:@"no_pic.png"]];
            }
            
            [imageView setContentMode:UIViewContentModeScaleToFill];
        }else{
            if (_image) {
                 imageView = [[MagicUIImageView alloc] initWithImage:_image];
            }
        }
        
        MagicUIZoomView *zoomView = [[MagicUIZoomView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height - self.headHeight)];
        [zoomView setBackgroundColor:[UIColor blackColor]];
        [zoomView setContent:imageView animated:NO];
        [self.view addSubview:zoomView];
        RELEASE(imageView);
        RELEASE(zoomView);
    }else if([signal is:[MagicViewController WILL_APPEAR]])
    {
        [self.view setBackgroundColor:[UIColor blackColor]];
        [self.headview setBackgroundColor:[UIColor clearColor]];
        [self.headview setTitle:@"查看图片"];
        [self.headview setTitleColor:[UIColor whiteColor]];
        [self backImgType:7];
        self.headview.lineView.hidden=YES;
        if (_nInitYpe == 2 && _bIsNeedDeleBt) {
            [self backImgType:8];
        }
    }
    
}

#pragma mark - 返回Button处理
- (void)handleViewSignal_DYBBaseViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBBaseViewController NEXTSTEPBUTTON]]){
        if (!_bIsNeedDeleBt) {
            return;
        }
        if (_nInitYpe == 2) {
            for (UIViewController *vc in [self.drNavigationController allviewControllers]) {
                if ([vc isKindOfClass:[DYBPublishViewController class]]) {
                    [self sendViewSignal:[DYBPublishViewController DELETEMAGE] withObject:_image from:self target:(DYBPublishViewController *)vc];
                    break;
                }
            }
            
            [self postNotification:[DYBCheckImageViewController DELETEMAGE] withObject:_image];
        }
        
        
        [self.drNavigationController popVCAnimated:YES];
        [self sendViewSignal:[MagicViewController VCBACKSUCCESS]];
    }else if ([signal is:[DYBBaseViewController BACKBUTTON]]){
        [self.drNavigationController popVCAnimated:YES];
        [self sendViewSignal:[MagicViewController VCBACKSUCCESS]];
    }
    
}

@end
