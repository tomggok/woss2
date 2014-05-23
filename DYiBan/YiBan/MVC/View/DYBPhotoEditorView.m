//
//  DYBPhotoEditorView.m
//  DYiBan
//
//  Created by Hyde.Xu on 13-9-13.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBPhotoEditorView.h"
#import "DYBImageUtil.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+MagicCategory.h"
#import "DYBPublishViewController.h"

@implementation DYBPhotoEditorView
@synthesize imgRootView = _imgRootView;
@synthesize curImage = _curImage;
@synthesize ntype = _ntype;

DEF_SIGNAL(DOSELECT)
DEF_SIGNAL(DOSAVE)
DEF_SIGNAL(DOBACK)
DEF_SIGNAL(DORIGHT)

DEF_NOTIFICATION(DOSAVEIMAGE)

//LOMO
const float DYBcolormatrix_lomo[] = {
    1.7f,  0.1f, 0.1f, 0, -73.1f,
    0,  1.7f, 0.1f, 0, -73.1f,
    0,  0.1f, 1.6f, 0, -73.1f,
    0,  0, 0, 1.0f, 0 };

//黑白
const float DYBcolormatrix_heibai[] = {
    0.8f,  1.6f, 0.2f, 0, -163.9f,
    0.8f,  1.6f, 0.2f, 0, -163.9f,
    0.8f,  1.6f, 0.2f, 0, -163.9f,
    0,  0, 0, 1.0f, 0 };
//复古
const float DYBcolormatrix_huajiu[] = {
    0.2f,0.5f, 0.1f, 0, 40.8f,
    0.2f, 0.5f, 0.1f, 0, 40.8f,
    0.2f,0.5f, 0.1f, 0, 40.8f,
    0, 0, 0, 1, 0 };

//哥特
const float DYBcolormatrix_gete[] = {
    1.9f,-0.3f, -0.2f, 0,-87.0f,
    -0.2f, 1.7f, -0.1f, 0, -87.0f,
    -0.1f,-0.6f, 2.0f, 0, -87.0f,
    0, 0, 0, 1.0f, 0 };

//锐化
const float DYBcolormatrix_ruise[] = {
    4.8f,-1.0f, -0.1f, 0,-388.4f,
    -0.5f,4.4f, -0.1f, 0,-388.4f,
    -0.5f,-1.0f, 5.2f, 0,-388.4f,
    0, 0, 0, 1.0f, 0 };


//淡雅
const float DYBcolormatrix_danya[] = {
    0.6f,0.3f, 0.1f, 0,73.3f,
    0.2f,0.7f, 0.1f, 0,73.3f,
    0.2f,0.3f, 0.4f, 0,73.3f,
    0, 0, 0, 1.0f, 0 };

//酒红
const float DYBcolormatrix_jiuhong[] = {
    1.2f,0.0f, 0.0f, 0.0f,0.0f,
    0.0f,0.9f, 0.0f, 0.0f,0.0f,
    0.0f,0.0f, 0.8f, 0.0f,0.0f,
    0, 0, 0, 1.0f, 0 };

//清宁
const float DYBcolormatrix_qingning[] = {
    0.9f, 0, 0, 0, 0,
    0, 1.1f,0, 0, 0,
    0, 0, 0.9f, 0, 0,
    0, 0, 0, 1.0f, 0 };

//浪漫
const float DYBcolormatrix_langman[] = {
    0.9f, 0, 0, 0, 63.0f,
    0, 0.9f,0, 0, 63.0f,
    0, 0, 0.9f, 0, 63.0f,
    0, 0, 0, 1.0f, 0 };

//光晕
const float DYBcolormatrix_guangyun[] = {
    0.9f, 0, 0,  0, 64.9f,
    0, 0.9f,0,  0, 64.9f,
    0, 0, 0.9f,  0, 64.9f,
    0, 0, 0, 1.0f, 0 };

//蓝调
const float DYBcolormatrix_landiao[] = {
    2.1f, -1.4f, 0.6f, 0.0f, -31.0f,
    -0.3f, 2.0f, -0.3f, 0.0f, -31.0f,
    -1.1f, -0.2f, 2.6f, 0.0f, -31.0f,
    0.0f, 0.0f, 0.0f, 1.0f, 0.0f
};

//梦幻
const float DYBcolormatrix_menghuan[] = {
    0.8f, 0.3f, 0.1f, 0.0f, 46.5f,
    0.1f, 0.9f, 0.0f, 0.0f, 46.5f,
    0.1f, 0.3f, 0.7f, 0.0f, 46.5f,
    0.0f, 0.0f, 0.0f, 1.0f, 0.0f
};

//夜色
const float DYBcolormatrix_yese[] = {
    1.0f, 0.0f, 0.0f, 0.0f, -66.6f,
    0.0f, 1.1f, 0.0f, 0.0f, -66.6f,
    0.0f, 0.0f, 1.0f, 0.0f, -66.6f,
    0.0f, 0.0f, 0.0f, 1.0f, 0.0f
};

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initInterface];
        _rotation = 0;
    }
    return self;
}

- (void)initInterface{
    [self setBackgroundColor:[UIColor blackColor]];
    
    _imgRootView = [[MagicUIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.frame)-50)];
    [_imgRootView setBackgroundColor:[UIColor clearColor]];
    [_imgRootView setImage:_curImage];
    [self addSubview:_imgRootView];
    RELEASE(_imgRootView);
    
    _scrollView = [[MagicUIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds)-150, CGRectGetWidth(self.frame), 100)];
    [_scrollView setBackgroundColor:[UIColor clearColor]];
    [_scrollView setIndicatorStyle:UIScrollViewIndicatorStyleBlack];
    [_scrollView setBounces:NO];
    [_scrollView setPagingEnabled:NO];
    [_scrollView setContentSize:CGSizeMake(640+70, 30)];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    [_scrollView setShowsVerticalScrollIndicator:NO];
    [self addSubview:_scrollView];
    RELEASE(_scrollView);
    
    MagicUIImageView *bg_scroll = [[MagicUIImageView alloc]initWithImage:[UIImage imageNamed:@"filtermask.png"]];
    [bg_scroll setFrame:CGRectMake(0, 0, 640+70, 100)];
    [bg_scroll setBackgroundColor:[UIColor clearColor]];
    [_scrollView addSubview:bg_scroll];
    RELEASE(bg_scroll);
    
    _imgFilter = [[MagicUIImageView alloc] initWithImage:[UIImage imageNamed:@"filterbox.png"]];
    [_imgFilter setFrame:CGRectMake(12.5f, 12.5f, 65.0f, 65.0f)];
    [_scrollView addSubview:_imgFilter];
    RELEASEVIEW(_imgFilter);

    [self creatButton:CGRectMake(20.0f,  20.0f, 50.0f, 50.0f) tag:1 text:@"原图" image:@"filter_demo_default.png"];
    [self creatButton:CGRectMake(100.0f, 20.0f, 50.0f, 50.0f) tag:2 text:@"lomo" image:@"filter_demo_lomo.png"];
    [self creatButton:CGRectMake(175.0f, 20.0f, 50.0f, 50.0f) tag:3 text:@"黑白" image:@"filter_demo_bw.png"];
    [self creatButton:CGRectMake(255.0f, 20.0f, 50.0f, 50.0f) tag:4 text:@"鲜艳" image:@"filter_demo_focus.png"];
    [self creatButton:CGRectMake(330.0f, 20.0f, 50.0f, 50.0f) tag:5 text:@"淡雅" image:@"filter_demo_lite.png"];
    [self creatButton:CGRectMake(408.0f, 20.0f, 50.0f, 50.0f) tag:6 text:@"梦幻" image:@"filter_demo_dream.png"];
    [self creatButton:CGRectMake(485.0f, 20.0f, 50.0f, 50.0f) tag:7 text:@"酒红" image:@"filter_demo_wine.png"];
    [self creatButton:CGRectMake(560.0f, 20.0f, 50.0f, 50.0f) tag:8 text:@"青柠" image:@"filter_demo_lemo.png"];
    [self creatButton:CGRectMake(635.0f, 20.0f, 50.0f, 50.0f) tag:9 text:@"夜色" image:@"filter_demo_lemo.png"];
    
    MagicUIImageView *bar = [[MagicUIImageView alloc]initWithImage:[UIImage imageNamed:@"filterbar.png"]];
    [bar setFrame:CGRectMake(0.0f, _scrollView.frame.origin.y + _scrollView.frame.size.height - 4, 320.0f, 54)];
    [self addSubview:bar];
    RELEASE(bar);
    
    MagicUIButton *send = [[MagicUIButton alloc]initWithFrame:CGRectMake(230.0f, self.bounds.size.height-44, 40.0f, 35.0f)];
    [send addSignal:[DYBPhotoEditorView DOSAVE] forControlEvents:UIControlEventTouchUpInside];
    [send setBackgroundImage:[UIImage imageNamed:@"filter_yes_a.png"] forState:UIControlStateNormal];
    [send setBackgroundImage:[UIImage imageNamed:@"filter_yes_b.png"] forState:UIControlStateHighlighted];
    [send setBackgroundColor:[UIColor clearColor]];
    [self addSubview:send];
    RELEASE(send);
    
    MagicUIButton *save = [[MagicUIButton alloc]initWithFrame:CGRectMake(50.0f, self.bounds.size.height-44, 40.0f, 35.0f)];
    [save addSignal:[DYBPhotoEditorView DOBACK] forControlEvents:UIControlEventTouchUpInside];
    [save setBackgroundImage:[UIImage imageNamed:@"filter_close_a.png"] forState:UIControlStateNormal];
    [save setBackgroundImage:[UIImage imageNamed:@"filter_close_b.png"] forState:UIControlStateHighlighted];
    [save setBackgroundColor:[UIColor clearColor]];
    [self addSubview:save];
    RELEASE(save);
    
    MagicUIButton *right = [[MagicUIButton alloc]initWithFrame:CGRectMake(140.0f, self.bounds.size.height-44, 40.0f, 35.0f)];
    [right addSignal:[DYBPhotoEditorView DORIGHT] forControlEvents:UIControlEventTouchUpInside];
    [right setBackgroundImage:[UIImage imageNamed:@"filter_rotate_a.png"] forState:UIControlStateNormal];
    [right setBackgroundImage:[UIImage imageNamed:@"filter_rotate_b.png"] forState:UIControlStateHighlighted];
    [right setBackgroundColor:[UIColor clearColor]];
    [self addSubview:right];
    RELEASE(right);
    
}

-(void)creatButton:(CGRect)rect tag:(int)tag text:(NSString*)text image:(NSString*)strImage{
    MagicUIImageView *shadow = [[MagicUIImageView alloc]initWithImage:[UIImage imageNamed:@"filtershadow.png"]];
    [shadow setFrame:CGRectMake(rect.origin.x-2.5, rect.origin.y-2.5, 55, 55)];
    [_scrollView addSubview:shadow];
    RELEASE(shadow);
    
    MagicUIButton *btn = [[MagicUIButton alloc]initWithFrame:rect];
    [btn setTag:tag];
    [btn setBackgroundColor:[UIColor clearColor]];
    [btn addSignal:[DYBPhotoEditorView DOSELECT] forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:btn];
    [btn setImage:[UIImage imageNamed:strImage] forState:UIControlStateNormal];
    RELEASE(btn);
    
    MagicUILabel *label = [[MagicUILabel alloc]initWithFrame:CGRectMake(rect.origin.x, rect.origin.y+40, rect.size.width, rect.size.height)];
    [label setText:text];
    [label setTextColor:[UIColor whiteColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setBackgroundColor:[UIColor clearColor]];
    [_scrollView addSubview:label];
    RELEASE(label);
}

- (void)addSubview:(UIView *)view
{
    [super addSubview:view];
    [DYBUITabbarViewController sharedInstace].containerView.tabBar.hidden = YES;
    [DYBUITabbarViewController sharedInstace].v_totalNumOfUnreadMsg.hidden = YES;
}

- (void)removeFromSuperview
{
    [super removeFromSuperview];
    [DYBUITabbarViewController sharedInstace].containerView.tabBar.hidden = NO;
    [DYBUITabbarViewController sharedInstace].v_totalNumOfUnreadMsg.hidden = NO;
    
}
#pragma mark- 接受其他信号
- (void)handleViewSignal_DYBPhotoEditorView:(MagicViewSignal *)signal
{  
    if ([signal is:[DYBPhotoEditorView DOSELECT]]){
        MagicUIButton *bt = (MagicUIButton *)signal.source;
        
        switch (bt.tag) {
            case 0:
            {
                _imgRootView.image = _curImage;
                
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDelay:0.3];
                [UIView commitAnimations];
            }
                break;
            case 1:
            {
                
                _imgRootView.image = _curImage;
                [_imgRootView setBackgroundColor:[UIColor grayColor]];
                
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDelay:0.3];
                _imgFilter.frame = CGRectMake(12.5f, 12.5f, 65.0f, 65.0f);
                [UIView commitAnimations];
                
            }
                break;
            case 2:
            {
                _imgRootView.image = [DYBImageUtil imageWithImage:_curImage withColorMatrix:DYBcolormatrix_lomo];
                
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDelay:0.3];
                _imgFilter.frame = CGRectMake(12.5f+80, 12.5f, 65.0f, 65.0f);
                [UIView commitAnimations];
            }
                break;
            case 3:
            {
                _imgRootView.image = [DYBImageUtil imageWithImage:_curImage withColorMatrix:DYBcolormatrix_heibai];
                
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDelay:0.3];
                _imgFilter.frame = CGRectMake(92.5f+75, 12.5f, 65.0f, 65.0f);
                [UIView commitAnimations];
                
            }
                break;
            case 4:
            {
                _imgRootView.image = [DYBImageUtil imageWithImage:_curImage withColorMatrix:DYBcolormatrix_gete];
                
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDelay:0.3];
                _imgFilter.frame = CGRectMake(167.5f+80, 12.5f, 65.0f, 65.0f);
                [UIView commitAnimations];
            }
                break;
            case 5:
            {
                _imgRootView.image = [DYBImageUtil imageWithImage:_curImage withColorMatrix:DYBcolormatrix_danya];
                
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDelay:0.3];
                _imgFilter.frame = CGRectMake(277.5f+45, 12.5f, 65.0f, 65.0f);
                [UIView commitAnimations];
            }
                break;
            case 6:
            {
                _imgRootView.image = [DYBImageUtil imageWithImage:_curImage withColorMatrix:DYBcolormatrix_menghuan];
                
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDelay:0.3];
                _imgFilter.frame = CGRectMake(362.5f+38, 12.5f, 65.0f, 65.0f);
                [UIView commitAnimations];
            }
                break;
            case 7:
            {
                _imgRootView.image = [DYBImageUtil imageWithImage:_curImage withColorMatrix:DYBcolormatrix_jiuhong];
                
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDelay:0.3];
                _imgFilter.frame = CGRectMake(432.5f+45, 12.5f, 65.0f, 65.0f);
                [UIView commitAnimations];
            }
                break;
            case 8:
            {
                 _imgRootView.image = [DYBImageUtil imageWithImage:_curImage withColorMatrix:DYBcolormatrix_qingning];
                
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDelay:0.3];
                _imgFilter.frame = CGRectMake(477.5f+80-5, 12.5f, 65.0f, 65.0f);
                [UIView commitAnimations];
            }
                break;
            case 9:
            {
                 _imgRootView.image = [DYBImageUtil imageWithImage:_curImage withColorMatrix:DYBcolormatrix_yese];
                
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDelay:0.3];
                _imgFilter.frame = CGRectMake(477.5f+80-5+75, 12.5f, 65.0f, 65.0f);
                [UIView commitAnimations];
            }
                break;
            case 10:
            {
                _imgRootView.image = [DYBImageUtil imageWithImage:_curImage withColorMatrix:DYBcolormatrix_yese];
                
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDelay:0.3];
                _imgFilter.frame = CGRectMake(477.5f+80-5+75+75, 12.5f, 65.0f, 65.0f);
                [UIView commitAnimations];
            }
                break;
        }
    }else if ([signal is:[DYBPhotoEditorView DOSAVE]]){
//        UIImage *smallImage = [_imgRootView.image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(_imgRootView.frame.size.width, _imgRootView.frame.size.height) interpolationQuality:kCGInterpolationDefault];
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d", _ntype], @"type", nil];

        NSData *data;
        if (UIImagePNGRepresentation(_imgRootView.image) == nil) {
            
            data = UIImageJPEGRepresentation(_imgRootView.image, 1);
            
        } else {
            
            data = UIImagePNGRepresentation(_imgRootView.image);
        }
        
        UIImage *img=[UIImage imageWithData:data];
        
        [self postNotification:[DYBPhotoEditorView DOSAVEIMAGE] withObject:/*_imgRootView.image*/img userInfo:dic];
        [self sendViewSignal:[DYBPhotoEditorView DOBACK]];
        
        RELEASE(dic);
                
    }else if ([signal is:[DYBPhotoEditorView DOBACK]]){
        
        REMOVEFROMSUPERVIEW(self);
        
        [DYBImageUtil freeImgPixel];

    }else if ([signal is:[DYBPhotoEditorView DORIGHT]]){
        
        if (_rotation < -4)
            _rotation = 4 - abs(_rotation);
        if (_rotation > 4)
            _rotation = _rotation - 4;
        
        [UIView animateWithDuration:0.5f animations:^{
            CGAffineTransform rotationTransform = CGAffineTransformMakeRotation(_rotation * M_PI / 2);
            _imgRootView.image = [self scaleAndRotateImage:_imgRootView.image transform:rotationTransform];
        } completion:^(BOOL finished) {
            if (finished)
            {
                [UIView animateWithDuration:0.5f animations:^{
                    _imgRootView.alpha = 1.0f;
                }];
            }
        }];
        
    }
}

- (UIImage *)scaleAndRotateImage:(UIImage *)image transform:(CGAffineTransform) transformTest{
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    
    CGFloat boundHeight;
    
    boundHeight = bounds.size.height;
    bounds.size.height = bounds.size.width;
    bounds.size.width = boundHeight;
    transform = CGAffineTransformMakeScale(-1.0, 1.0);
    transform = CGAffineTransformRotate(transform, M_PI / 2.0); //use angle/360 *MPI
    
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
    
}

@end
