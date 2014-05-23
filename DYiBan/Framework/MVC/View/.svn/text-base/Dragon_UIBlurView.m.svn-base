//
//  Dragon_UIBlurView.m
//  DragonFramework
//
//  Created by NewM on 13-8-14.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "Dragon_UIBlurView.h"
#import "UIImage+DragonCategory.h"

@interface DragonUIBlurView ()
{
    UIImage *cutImg;
    
}
@property (nonatomic, copy)UIImage *sViewImg;
@end

@implementation DragonUIBlurView
@synthesize blurView = _blurView;
@synthesize blurLevel = _blurLevel;
@synthesize sViewImg = _sViewImg;

- (void)dealloc
{
    RELEASEOBJ(_sViewImg)
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _blurLevel = kDefaultBlurLevel;
        
    }
    return self;
}

- (void)setBlurLevel:(CGFloat)blurLevel
{
    _blurLevel = blurLevel;
    
    if (_blurView)
    {
        _blurView = [self superview];
        [self renderLayerWithView:_blurView];
    }
}

- (void)setBlurView:(UIView *)blurView
{
    if (_blurView == blurView)
    {
        return;
    }
    
    RELEASEOBJ(_blurView);
    _blurView = [blurView retain];
    
    [self renderLayerWithView:_blurView];
    
}

//读取缓存中superview
- (UIImage *)cutBlurImg:(CGRect)frame
{
    return [self cutBlurImg:nil withRect:frame];
}

bool needSetFrame;
//截取view为图片
- (UIImage *)cutBlurImg:(UIView *)superView withRect:(CGRect)frame
{
    CGRect newFrame = frame;
    newFrame.origin.y *= 2;
    newFrame.size.height *= 2;
    newFrame.size.width *= 2;
    
    if (frame.origin.y == 0)
    {
        frame.origin.y += 20;
        frame.size.height -= 20;
        [self setFrame:frame];
    }else
    {
        needSetFrame = YES;
    }
    if (superView) {
        cutImg = [UIImage cutScreenImg:superView];
        self.sViewImg = cutImg;

    }else{
        cutImg = _sViewImg;
    }
    NSString *aPath=[NSString stringWithFormat:@"%@/Documents/%@.jpg",NSHomeDirectory(),@"test"];
    NSData *imgData = UIImageJPEGRepresentation(cutImg,0);
    [imgData writeToFile:aPath atomically:YES];
    cutImg = [cutImg cutImgWithRect:newFrame];
    cutImg = [cutImg retain];
    UIGraphicsEndImageContext();
    
    return cutImg;
}

- (void)renderLayerWithView:(UIView *)superView
{
    __block UIImage *image = cutImg;
    if (!cutImg)
    {
        image = [self cutBlurImg:superView withRect:self.frame];
    }
    //容错
    if (!image) {
        return;
    }
    
    /*测试代码
    NSString *aPath=[NSString stringWithFormat:@"%@/Documents/%@.jpg",NSHomeDirectory(),@"test"];
    NSData *imgData = UIImageJPEGRepresentation(image,0);
    [imgData writeToFile:aPath atomically:YES];*/
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        //让截取该范围的图片在当前屏幕虚化
        //调整图片的质量
        NSData *imageData = UIImageJPEGRepresentation(image, kDTimeBlurViewScreenshotCompression);
        RELEASEOBJ(image);
        image = [[UIImage imageWithData:imageData] boxblurImageWithBlur:_blurLevel];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            //更新图层
            self.layer.contents = (id)image.CGImage;
            if (needSetFrame)
            {
                [self setFrame:self.bounds];
                needSetFrame = NO;
            }

        });
    });
    
    
    
}



@end
