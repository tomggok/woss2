//
//  DYBXinhuaNewsContentCellView.m
//  DYiBan
//
//  Created by Song on 13-9-11.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBXinhuaNewsContentCellView.h"
#import "pics.h"
#define     NormalFont14        [UIFont fontWithName:@"Helvetica" size:14]
#define     ScreenWidth     320
#define     ScreenHeight    480

#define NewsImageWidth              100
#define NewsContentCellLeftWidth    15
#define NewsContentCellTopWidth     10
#define NewsContentCellMidWidth     10
#define NewsContentPicWidth        290
#define NewsContentPicHeight       290


#define     CoWordColor     [UIColor colorWithRed:40/255.0 green:40/255.0 blue:40/255.0 alpha:1]//内容字统一色

@implementation DYBXinhuaNewsContentCellView
DEF_SIGNAL(IMAGECLICKEEND)
-(void)dealloc{
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame news_info:(news *)news;
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        contentLabel = [[UILabel alloc] init];
        picView = [[UIImageView alloc] init];
        [picView setContentMode:UIViewContentModeScaleAspectFit];
        
        //图片定宽不定高
        
        pics *arraypic = (pics *)[news.pics objectAtIndex:0];
        picView.backgroundColor = [UIColor clearColor];
        
        NSString *url = @"";
        float imageHeigt = 0;
        //        CGRect photoRect = CGRectMake(0, 0, 0, 0);
        if ([news.pics count] > 0)
        {
            if ([arraypic.pic_s length] > 0)
            {
                url = arraypic.pic_s;
            }
        }
        
        if ([url length] > 0)
        {
            NSURL* url = [NSURL URLWithString:arraypic.pic_s];
            //            NSData* data = [[NSData alloc] initWithContentsOfURL:url];
            //            UIImage *feedImage = [UIImage imageWithData:data];
            //
            //            [data release];
            
            [self setImageWithURLXH:url];
            
            if (picView.image == nil)
            {
                picView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"basedBigPhoto_feedDetail" ofType:@"png"]];
            }
            else
            {
                CGImageRef imgRef = picView.image.CGImage;
                imageHeigt = (NewsContentPicWidth*picView.image.size.height)/picView.image.size.width;
                CGRect   rect1 = CGRectMake(0,0, picView.image.size.width,  picView.image.size.height);
                CGImageRef img=CGImageCreateWithImageInRect(imgRef,rect1);
                
                UIImage *newImage = [UIImage imageWithCGImage:img];
                CGImageRelease(img);
                
                picView.image = newImage;
            }
            
            if (imageHeigt == 0)
            {
                imageHeigt = NewsContentPicHeight;
            }
            else
            {
                imageHeigt = imageHeigt;
            }
            
            
            picView.frame = CGRectMake(NewsContentCellLeftWidth, NewsContentCellTopWidth, NewsContentPicWidth, imageHeigt);
            //            photoRect = CGRectMake(NewsContentCellLeftWidth, NewsContentCellTopWidth, NewsContentPicWidth, imageHeigt);
            
            UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ViewBigPic)];
            singleRecognizer.numberOfTapsRequired = 1;
            [picView addGestureRecognizer:singleRecognizer];
            [singleRecognizer release];
            [picView setUserInteractionEnabled:YES];
        }
        
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.textColor = CoWordColor;
        contentLabel.textAlignment = UITextAlignmentLeft;
        contentLabel.text = news.content;
        contentLabel.font = NormalFont14;
        contentLabel.numberOfLines = 1000;
        CGSize titleSize = [contentLabel.text sizeWithFont:contentLabel.font
                                         constrainedToSize:CGSizeMake(ScreenWidth-2*NewsContentCellLeftWidth, 10000)
                                             lineBreakMode:UILineBreakModeTailTruncation];
        
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        if ([url length] > 0)
        {
            contentLabel.frame = CGRectMake(NewsContentCellLeftWidth, picView.frame.origin.y+picView.frame.size.height+NewsContentCellMidWidth, titleSize.width, titleSize.height);
            [self addSubview:picView];
            [picView release];
        }
        else
        {
            contentLabel.frame = CGRectMake(NewsContentCellLeftWidth, NewsContentCellTopWidth, titleSize.width, titleSize.height);
            [picView removeFromSuperview];
        }
        [self addSubview:contentLabel];
        [contentLabel release];
    }
    return self;
}

+(CGFloat )getHeightByNewsModel:(news *)model
{
    CGFloat height = 0;
    
    CGSize titleSize = [model.content sizeWithFont:NormalFont14
                                 constrainedToSize:CGSizeMake(ScreenWidth-2*NewsContentCellLeftWidth, 10000)
                                     lineBreakMode:UILineBreakModeTailTruncation];
    
    pics *arraypic = (pics *)[model.pics objectAtIndex:0];
    NSString *url = @"";
    CGFloat imageHeightThis = 0;
    if ([model.pics count] > 0)
    {
        
        if ([arraypic.pic_s length] > 0)
        {
            url = arraypic.pic_s;
        }
    }
    
    if ([url length] > 0)
    {
        imageHeightThis = NewsContentPicHeight;
        height = NewsContentCellTopWidth+imageHeightThis;
        height = height + NewsContentCellMidWidth+titleSize.height+NewsContentCellTopWidth;
        
    }
    else
    {
        height = NewsContentCellTopWidth + titleSize.height+NewsContentCellTopWidth;
    }
    
    return height;
}

- (void)setImageWithURLXH:(NSURL *)url{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];
    
    if (url)
    {
        [manager downloadWithURL:url delegate:self options:0];
    }
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    picView.image = image;
    
    float imageHeigt = (NewsContentPicWidth*picView.image.size.height)/picView.image.size.width;
    picView.frame = CGRectMake(NewsContentCellLeftWidth, NewsContentCellTopWidth, NewsContentPicWidth, imageHeigt);
    contentLabel.frame = CGRectMake(NewsContentCellLeftWidth, picView.frame.origin.y+picView.frame.size.height+NewsContentCellMidWidth, contentLabel.frame.size.width, contentLabel.frame.size.height);
    
    [self setNeedsLayout];
}


- (void)ViewBigPic{
    
    [self sendViewSignal:[DYBXinhuaNewsContentCellView IMAGECLICKEEND] withObject:nil from:self target:[self superview]];
}


@end
