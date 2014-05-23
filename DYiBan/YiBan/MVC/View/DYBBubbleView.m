//
//  DYBBubbleView.m
//  DYiBan
//
//  Created by Hyde.Xu on 13-9-4.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBubbleView.h"
#import "NSString+Count.h"
#import "DYBCheckInMainViewController.h"

@implementation DYBBubbleView

@synthesize sginInfo = _sginInfo;


-(void)dealloc{
    [super dealloc];
    
    RELEASE(_sginInfo);
}

- (id)initWithFrame:(CGRect)frame BubbleInfo:(sgin_list *)arrInfo;
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.sginInfo = arrInfo;
        
        MagicUIImageView *_imgUserPortrait = [[MagicUIImageView alloc] initWithFrame:CGRectMake(8.75, 5.25, 45, 45) backgroundColor:[UIColor clearColor] image:nil isAdjustSizeByImgSize:NO userInteractionEnabled:NO masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:self Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
        [_imgUserPortrait setNeedRadius:YES];
        RELEASE(_imgUserPortrait);
        
        NSString *encondeUrl= [arrInfo.user.pic_b stringByAddingPercentEscapesUsingEncoding];
        if ([NSURL URLWithString:encondeUrl] == nil) {
            [_imgUserPortrait setImage:[UIImage imageNamed:@"no_pic_50.png"]];
        }else
        {
            _imgUserPortrait._b_isShade=NO;
            [_imgUserPortrait setImageWithURL:[NSURL URLWithString:encondeUrl] placeholderImage:[UIImage imageNamed:@"no_pic_50.png"]];
            
        }   
        
        UIImage *imgBKG = [UIImage imageNamed:@"bkg_usericon.png"];
        UIImageView *imgBgd = [[UIImageView alloc] initWithImage:imgBKG];
        [imgBgd setFrame:CGRectMake(0, 0, imgBKG.size.width/2, imgBKG.size.height/2)];
        [self addSubview:imgBgd];
        [self sendSubviewToBack:imgBgd];
        [imgBgd release];
        
        UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toFront)];
        singleRecognizer.numberOfTapsRequired = 1;
        [self addGestureRecognizer:singleRecognizer];
        [singleRecognizer release];
        [self setUserInteractionEnabled:YES];
    }
    return self;
}

- (void)toFront{
    [self.superview bringSubviewToFront:self];
    
    NSDictionary *dicUser = [[NSDictionary alloc] initWithObjectsAndKeys:_sginInfo.user.userid, @"userid", _sginInfo.user.name, @"username", nil];
    [self sendViewSignal:[DYBCheckInMainViewController PERSONALPAGE] withObject:[dicUser retain]];
    RELEASE(dicUser);
}

@end
