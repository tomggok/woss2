//
//  DYBLoadingView.m
//  DYiBan
//
//  Created by NewM on 13-9-24.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBLoadingView.h"

@implementation DYBLoadingView
{
    MagicUIImageView *imgView;
}

- (void)dealloc
{
    [imgView stopAnimating];
    [super dealloc];
}

- (id)init
{
    return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame
{
    frame = MAINFRAME;
//    frame.size.height += 20;

    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setUserInteractionEnabled:NO];
//        MagicUIImageView *bgView = [[MagicUIImageView alloc] initWithFrame:frame];
//        [bgView setBackgroundColor:[UIColor clearColor]];
//        [bgView setImage:[UIImage imageNamed:@"newlodingmask"]];
//        [self addSubview:bgView];
//        RELEASE(bgView);
        
        CGSize mainSize = MAINSIZE;
        CGFloat img = 32;

        MagicUIImageView *loadBgView = [[MagicUIImageView alloc] initWithFrame:CGRectMake((mainSize.width - img) / 2, (mainSize.height - img) / 2, img, img)];
//        [loadBgView setCenter:CGPointMake(, (mainSize.height) / 2)];
        [loadBgView setImage:[UIImage imageNamed:@""]];
        [self addSubview:loadBgView];
         
        NSArray *imgArr = [NSArray arrayWithObjects:
         [UIImage imageNamed:@"newloding01.png"],
         [UIImage imageNamed:@"newloding02.png"],
         [UIImage imageNamed:@"newloding03.png"],
         [UIImage imageNamed:@"newloding04.png"],
         [UIImage imageNamed:@"newloding05.png"],
         [UIImage imageNamed:@"newloding06.png"],
         [UIImage imageNamed:@"newloding07.png"],
         [UIImage imageNamed:@"newloding08.png"],
         [UIImage imageNamed:@"newloding09.png"],
         [UIImage imageNamed:@"newloding10.png"],
         [UIImage imageNamed:@"newloding11.png"],
         [UIImage imageNamed:@"newloding12.png"],nil];
        
        imgView = [[MagicUIImageView alloc] initWithFrame:CGRectMake(0, 0, img, img)];
        [imgView setAnimationImages:imgArr];
        [imgView setAnimationDuration:.5f];
        [imgView startAnimating];
        
        [loadBgView addSubview:imgView];
        RELEASE(imgView);
        RELEASE(loadBgView);
        
        
        /*
         MagicUIImageView *bgView = [[MagicUIImageView alloc] initWithFrame:frame];
         [bgView setBackgroundColor:[UIColor clearColor]];
         [bgView setImage:[UIImage imageNamed:@"mask_screen_black"]];
         [self addSubview:bgView];
         RELEASE(bgView);
         
         CGSize mainSize = MAINSIZE;
         
         MagicUIImageView *loadBgView = [[MagicUIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
         [loadBgView setCenter:CGPointMake((mainSize.width) / 2, (mainSize.height) / 2)];
         [loadBgView setImage:[UIImage imageNamed:@""]];
         [bgView addSubview:loadBgView];
         
         NSArray *imgArr = [NSArray arrayWithObjects:
         [UIImage imageNamed:@"loading01.png"],
         [UIImage imageNamed:@"loading02.png"],
         [UIImage imageNamed:@"loading03.png"],
         [UIImage imageNamed:@"loading04.png"],
         [UIImage imageNamed:@"loading05.png"],
         [UIImage imageNamed:@"loading06.png"],
         [UIImage imageNamed:@"loading07.png"],
         [UIImage imageNamed:@"loading08.png"],
         [UIImage imageNamed:@"loading09.png"],
         [UIImage imageNamed:@"loading10.png"],
         [UIImage imageNamed:@"loading11.png"],
         [UIImage imageNamed:@"loading12.png"],nil];
         
         MagicUIImageView *imgView = [[MagicUIImageView alloc] initWithFrame:CGRectMake(6, 6, 32, 32)];
         [imgView setAnimationImages:imgArr];
         [imgView setAnimationDuration:.5f];
         [imgView startAnimating];
         
         [loadBgView addSubview:imgView];
         RELEASE(imgView);
         RELEASE(loadBgView);

         */
    }
    return self;
}



@end
