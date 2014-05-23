//
//  PhotoViewController.m
//  Magic
//
//  Created by tom zeng on 12-11-12.
//
//

#import "DYBPhotoView.h"
#import "DYBColorMatrix.h"
#import <QuartzCore/QuartzCore.h>
#import "DYBImageUtil.h"
//#import "AGSimpleImageEditorView.h"
#import "UIImage+MagicCategory.h"
#import "DYBSendPrivateLetterViewController.h"
@interface DYBPhotoView ()

@end

@implementation DYBPhotoView{
    UIScrollView *scrollerView;
    UIImage *rootImage;
    UIImageView *imageVeiwFilter;
//    AGSimpleImageEditorView *agsimaleImage;
    int rotation;
   }
@synthesize currentImage;
@synthesize rootImageView,father = _father;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self intiView];
        rotation = 0;
    }
    return self;
}
-(void)doSave{
    
//     UIImage *smallImage = [rootImageView.image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(rootImageView.frame.size.width, rootImageView.frame.size.height) interpolationQuality:kCGInterpolationDefault];
    
    [_father sendPhotoImage:rootImageView.image];
    
//      [[NSNotificationCenter defaultCenter]postNotificationName:@"doSaveImage" object:rootImageView.image];
    
//    UIImageWriteToSavedPhotosAlbum(rootImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);// 保存图片到相册中
    [self doBack];
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo
{
    if (error != NULL)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"保存失败,请重新保存" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        
    }
    else// 没有error
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"doSaveImage" object:rootImageView.image];
        [self removeFromSuperview];
    }
}

-(void)intiView{

    
    [self setBackgroundColor:[UIColor blackColor]];
    
    

    scrollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.bounds.size.height-150, 320, 100)];
    scrollerView.backgroundColor = [UIColor clearColor];
    scrollerView.indicatorStyle = UIScrollViewIndicatorStyleBlack;//滚动条样式
    //显示横向滚动条
    scrollerView.bounces = NO;//取消反弹效果
    scrollerView.pagingEnabled = NO;//划一屏
    scrollerView.contentSize = CGSizeMake(640+70, 30);
    [scrollerView setShowsVerticalScrollIndicator:NO];
     [scrollerView setShowsHorizontalScrollIndicator:NO];

    rootImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, self.bounds.size.height-50)];
    rootImageView.image = currentImage;
    [rootImageView setBackgroundColor:[UIColor clearColor]];

    [self addSubview:rootImageView];
    [self addSubview:scrollerView];
    UIImageView *bg_scroller = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"filtermask.png"]];
    [bg_scroller setFrame:CGRectMake(0, 0, 640+70, 100)];
    [bg_scroller setBackgroundColor:[UIColor clearColor]];
    [scrollerView addSubview:bg_scroller];
    [bg_scroller release];
    imageVeiwFilter = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"filterbox.png"]];
    [imageVeiwFilter setFrame:CGRectMake(12.5f, 12.5f, 65.0f, 65.0f)];
    [scrollerView addSubview:imageVeiwFilter];
    [scrollerView setBackgroundColor:[UIColor clearColor]];
    [self creatButton:CGRectMake(20.0f,  20.0f, 50.0f, 50.0f) tag:1 text:@"原图" image:@"filter_demo_default.png"];
    [self creatButton:CGRectMake(100.0f, 20.0f, 50.0f, 50.0f) tag:2 text:@"lomo" image:@"filter_demo_lomo.png"];
    [self creatButton:CGRectMake(175.0f, 20.0f, 50.0f, 50.0f) tag:3 text:@"黑白" image:@"filter_demo_bw.png"];
    [self creatButton:CGRectMake(255.0f, 20.0f, 50.0f, 50.0f) tag:4 text:@"鲜艳" image:@"filter_demo_focus.png"];
    [self creatButton:CGRectMake(330.0f, 20.0f, 50.0f, 50.0f) tag:5 text:@"淡雅" image:@"filter_demo_lite.png"];
    [self creatButton:CGRectMake(408.0f, 20.0f, 50.0f, 50.0f) tag:6 text:@"梦幻" image:@"filter_demo_dream.png"];
    [self creatButton:CGRectMake(485.0f, 20.0f, 50.0f, 50.0f) tag:7 text:@"酒红" image:@"filter_demo_wine.png"];
    [self creatButton:CGRectMake(560.0f, 20.0f, 50.0f, 50.0f) tag:8 text:@"青柠" image:@"filter_demo_lemo.png"];
    [self creatButton:CGRectMake(635.0f, 20.0f, 50.0f, 50.0f) tag:9 text:@"夜色" image:@"filter_demo_lemo.png"];

    UIImageView *bar = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"filterbar.png"]];
    [bar setFrame:CGRectMake(0.0f, scrollerView.frame.origin.y+scrollerView.frame.size.height-4, 320.0f, 54)];
    [self addSubview:bar];
    [bar release];
    UIButton *send = [[UIButton alloc]initWithFrame:CGRectMake(230.0f, self.bounds.size.height-44, 40.0f, 35.0f)];
    [send addTarget:self action:@selector(doSave) forControlEvents:UIControlEventTouchUpInside];
    [send setBackgroundImage:[UIImage imageNamed:@"filter_yes_a.png"] forState:UIControlStateNormal];
    [send setBackgroundImage:[UIImage imageNamed:@"filter_yes_b.png"] forState:UIControlStateHighlighted];
    [send setBackgroundColor:[UIColor clearColor]];
    [self addSubview:send];
    [send release];
    
    UIButton *save = [[UIButton alloc]initWithFrame:CGRectMake(50.0f, self.bounds.size.height-44, 40.0f, 35.0f)];
    [save addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];
    [save setBackgroundImage:[UIImage imageNamed:@"filter_close_a.png"] forState:UIControlStateNormal];
    [save setBackgroundImage:[UIImage imageNamed:@"filter_close_b.png"] forState:UIControlStateHighlighted];
    [save setBackgroundColor:[UIColor clearColor]];
    [self addSubview:save];
    [save release];
    
    //向左
    UIButton *right = [[UIButton alloc]initWithFrame:CGRectMake(140.0f, self.bounds.size.height-44, 40.0f, 35.0f)];
    [right addTarget:self action:@selector(returnRound:) forControlEvents:UIControlEventTouchUpInside];
    [right setTag:1999];
    [right setBackgroundImage:[UIImage imageNamed:@"filter_rotate_a.png"] forState:UIControlStateNormal];
    [right setBackgroundImage:[UIImage imageNamed:@"filter_rotate_b.png"] forState:UIControlStateHighlighted];
    [right setBackgroundColor:[UIColor clearColor]];
    [self addSubview:right];
    [right release];
    

    
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

-(void)returnRound:(id)sender{  
    if (rotation < -4)
        rotation = 4 - abs(rotation);
    if (rotation > 4)
        rotation = rotation - 4;

    [UIView animateWithDuration:0.5f animations:^{
        CGAffineTransform rotationTransform = CGAffineTransformMakeRotation(rotation * M_PI / 2);
        rootImageView.image = [self scaleAndRotateImage:rootImageView.image transform:rotationTransform];
    } completion:^(BOOL finished) {
        if (finished)
        {            
            [UIView animateWithDuration:0.5f animations:^{
                rootImageView.alpha = 1.0f;
            }];
        }
    }];
   
}
-(void)creatButton:(CGRect)rect tag:(int)tag text:(NSString*)text image:(NSString*)strImage{
    UIImageView *shadow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"filtershadow.png"]];
    [shadow setFrame:CGRectMake(rect.origin.x-2.5, rect.origin.y-2.5, 55, 55)];
    [scrollerView addSubview:shadow];
    [shadow release];
    UIButton *btn = [[UIButton alloc]initWithFrame:rect];
    [btn setTag:tag];
    [btn setBackgroundColor:[UIColor clearColor]];
    [btn addTarget:self action:@selector(doSelect:) forControlEvents:UIControlEventTouchUpInside];
    [scrollerView addSubview:btn]; 
    [btn setImage:[UIImage imageNamed:strImage] forState:UIControlStateNormal];
    [btn release];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(rect.origin.x, rect.origin.y+40, rect.size.width, rect.size.height)];
    [label setText:text];
    [label setTextColor:[UIColor whiteColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setBackgroundColor:[UIColor clearColor]];
    [scrollerView addSubview:label];
    [label release];
}
-(void)doSelect:(id)sender{
    UIButton *btn = (UIButton*)sender;
    switch (btn.tag) {
        case 0:
        {
            rootImageView.image = currentImage;
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelay:0.3];
            [UIView commitAnimations];
        }
            break;
        case 1:
        {
            
            rootImageView.image = currentImage;
             [rootImageView setBackgroundColor:[UIColor grayColor]];
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelay:0.3];
            imageVeiwFilter.frame = CGRectMake(12.5f, 12.5f, 65.0f, 65.0f);
            [UIView commitAnimations];
            
        }
            break;
        case 2:
        {
            rootImageView.image = [DYBImageUtil imageWithImage:currentImage withColorMatrix:colormatrix_lomo];
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelay:0.3];
             imageVeiwFilter.frame = CGRectMake(12.5f+80, 12.5f, 65.0f, 65.0f);
            [UIView commitAnimations];
        }
            break;
        case 3:
        {
            rootImageView.image = [DYBImageUtil imageWithImage:currentImage withColorMatrix:colormatrix_heibai];
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelay:0.3];
             imageVeiwFilter.frame = CGRectMake(92.5f+75, 12.5f, 65.0f, 65.0f);
            [UIView commitAnimations];
            
        }
            break;
        case 4:
        {
            rootImageView.image = [DYBImageUtil imageWithImage:currentImage withColorMatrix:colormatrix_gete];
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelay:0.3];
             imageVeiwFilter.frame = CGRectMake(167.5f+80, 12.5f, 65.0f, 65.0f);
            [UIView commitAnimations];
        }
            break;
        case 5:
        {
            rootImageView.image = [DYBImageUtil imageWithImage:currentImage withColorMatrix:colormatrix_danya];
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelay:0.3];
             imageVeiwFilter.frame = CGRectMake(277.5f+45, 12.5f, 65.0f, 65.0f);
            [UIView commitAnimations];
        }
            break;
        case 6:
        {
            rootImageView.image = [DYBImageUtil imageWithImage:currentImage withColorMatrix:colormatrix_menghuan];
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelay:0.3];
             imageVeiwFilter.frame = CGRectMake(362.5f+38, 12.5f, 65.0f, 65.0f);
            [UIView commitAnimations];
        }
            break;
        case 7:
        {
            rootImageView.image = [DYBImageUtil imageWithImage:currentImage withColorMatrix:colormatrix_jiuhong];
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelay:0.3];
             imageVeiwFilter.frame = CGRectMake(432.5f+45, 12.5f, 65.0f, 65.0f);
            [UIView commitAnimations];
        }
            break;
        case 8:
        {
             rootImageView.image = [DYBImageUtil imageWithImage:currentImage withColorMatrix:colormatrix_qingning];
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelay:0.3];
             imageVeiwFilter.frame = CGRectMake(477.5f+80-5, 12.5f, 65.0f, 65.0f);
            [UIView commitAnimations];
        }
            break;
        case 9:
        {
            rootImageView.image = [DYBImageUtil imageWithImage:currentImage withColorMatrix:colormatrix_yese];            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelay:0.3];
            imageVeiwFilter.frame = CGRectMake(477.5f+80-5+75, 12.5f, 65.0f, 65.0f);
            [UIView commitAnimations];
        }
            break;
        case 10:
        {
            rootImageView.image = [DYBImageUtil imageWithImage:currentImage withColorMatrix:colormatrix_yese];            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelay:0.3];
            imageVeiwFilter.frame = CGRectMake(477.5f+80-5+75+75, 12.5f, 65.0f, 65.0f);
            [UIView commitAnimations];
        }
            break;
    }


}

-(UIImage *)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    
    UIGraphicsBeginImageContext(newSize);//根据当前大小创建一个基于位图图形的环境
    
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];//根据新的尺寸画出传过来的图片
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();//从当前环境当中得到重绘的图片
    
    UIGraphicsEndImageContext();//关闭当前环境
    
    return newImage;
}
-(void)doBack{

    [self removeFromSuperview];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"photoShowKeyBoard" object:nil];
}
-(void)dealloc{
    [super dealloc];
    [imageVeiwFilter release];
    [scrollerView release];
    [rootImageView release];
    [rootImage release];
   
}

@end
