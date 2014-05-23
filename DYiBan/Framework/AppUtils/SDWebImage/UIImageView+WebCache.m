/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImageView+WebCache.h"
#import <objc/runtime.h>

@implementation UIImageView (WebCache)
DEF_SIGNAL(SDWEBIMGDOWNSUCCESS)
DEF_SIGNAL(SDWEBIMGDOWNFAILURE)

@dynamic _b_isShade;

static char _c_b_isShade;
-(BOOL)_b_isShade
{
    return [objc_getAssociatedObject(self, &_c_b_isShade) boolValue];
    
}
-(void)set_b_isShade:(BOOL)b
{
    objc_setAssociatedObject(self, &_c_b_isShade, [NSNumber numberWithBool:b], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (void)setImageWithURL:(NSURL *)url
{
    [self setImageWithURL:url placeholderImage:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhiteLarge)];
    [activity startAnimating];
    [activity setFrame:CGRectMake((self.frame.size.width - 35)/2, (self.frame.size.height - 35)/2, 35, 35)];
    [self addSubview:activity];
    [activity release];
       
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    UIImage *cachedImage = [manager imageWithURL:url];
    
    if (cachedImage)
    {
        // the image is cached -> remove activityIndicator from view
        for (UIView *v in [self subviews])
        {
            if ([v isKindOfClass:[UIActivityIndicatorView class]])
            {
                [activity removeFromSuperview];
            }
        }
    }
    [self setImageWithURLNOActivity:url placeholderImage:placeholder];
}

//没有菊花的imgview
- (void)setImageWithURLNOActivity:(NSURL *)url{
    [self setImageWithURLNOActivity:url placeholderImage:nil];
}
//没有菊花的imgview
- (void)setImageWithURLNOActivity:(NSURL *)url placeholderImage:(UIImage *)placeholder{
    [self setImageWithURL:url placeholderImage:placeholder options:0];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];

    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];

    self.image = placeholder;

    if (url)
    {
        [manager downloadWithURL:url delegate:self options:options];
    }
}

#if NS_BLOCKS_AVAILABLE
- (void)setImageWithURL:(NSURL *)url success:(SDWebImageSuccessBlock)success failure:(SDWebImageFailureBlock)failure;
{
    [self setImageWithURL:url placeholderImage:nil success:success failure:failure];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder success:(SDWebImageSuccessBlock)success failure:(SDWebImageFailureBlock)failure;
{
    [self setImageWithURL:url placeholderImage:placeholder options:0 success:success failure:failure];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options success:(SDWebImageSuccessBlock)success failure:(SDWebImageFailureBlock)failure;
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];

    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];

    self.image = placeholder;

    if (url)
    {
        
        [manager downloadWithURL:url delegate:self options:options success:success failure:failure];
    }
}
#endif

- (void)cancelCurrentImageLoad
{
    [[SDWebImageManager sharedManager] cancelForDelegate:self];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didProgressWithPartialImage:(UIImage *)image forURL:(NSURL *)url
{
    self.image = image;
    [self setNeedsLayout];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFailWithError:(NSError *)error{
    for (UIView *v in [self subviews])
    {
        if ([v isKindOfClass:[UIActivityIndicatorView class]])
        {
            [((UIActivityIndicatorView*)v) stopAnimating];
            [v removeFromSuperview];
        }
    }

    [self sendViewSignal:[UIImageView SDWEBIMGDOWNFAILURE]];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    
    for (UIView *v in [self subviews])
    {
        if ([v isKindOfClass:[UIActivityIndicatorView class]])
        {
            [((UIActivityIndicatorView*)v) stopAnimating];
            [v removeFromSuperview];
        }
    }
    self.image = image;
    
    if (self._b_isShade) {
        [self setAlpha:0.f];
        [UIView animateWithDuration:0.5f animations:^{
            [self setAlpha:1.f];
        } completion:^(BOOL finished) {
            
        }];
    }
   
    [self setNeedsLayout];
    
    if (image.CGImage) {
        DLogInfo(@"123");
        [self sendViewSignal:[UIImageView SDWEBIMGDOWNSUCCESS]];
        
    }else
    {
        DLogInfo(@"456");
        [self sendViewSignal:[UIImageView SDWEBIMGDOWNFAILURE]];
    }
    
}

@end
