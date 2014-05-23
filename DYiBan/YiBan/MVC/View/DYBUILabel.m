//
//  DYBUILabel.m
//  DYiBan
//
//  Created by NewM on 13-9-12.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBUILabel.h"
#import "UILabel+ReSize.h"

@implementation DYBUILabel
{
    MagicUIImageView *imgView;
}
@synthesize imgType = _imgType;
- (void)dealloc
{
    [super dealloc];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    [self setIMGType:_imgType];
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    [self setIMGType:_imgType];
}

- (void)initIMGView
{
    if (self.maxLineNum != 0 && (self.maxLineNum < self.realLineNum))
    {
        CGFloat imgX = CGRectGetWidth(self.frame) - 55;
        CGFloat imgY = CGRectGetHeight(self.frame) - 22;
        imgView = [[MagicUIImageView alloc] initWithFrame:CGRectMake(imgX, imgY, 55, 22)];
        [imgView setImage:[UIImage imageNamed:@"mask_more.png"]];
        [self addSubview:imgView];
        [self bringSubviewToFront:imgView];
        RELEASE(imgView);
    }
}

- (void)setIMGType:(int)type
{
    if (self.maxLineNum != 0 && (self.maxLineNum < self.realLineNum))
    {
        [self initIMGView];
        switch (type) {
            case 1:
                [imgView setImage:[UIImage imageNamed:@"mask_more.png"]];
                break;
            case 2:
                [imgView setImage:[UIImage imageNamed:@"mask_more_gray.png"]];
                [imgView setFrame:CGRectMake(CGRectGetMinX(imgView.frame), CGRectGetMinY(imgView.frame)+4, 55, 18)];
                break;
            default:
                break;
        }
    }
}

- (void)setMaxLineNum:(NSInteger)maxLineNum maxFrame:(CGSize)maxFrame
{
    [self setMaxLineNum:maxLineNum];
    
    if (!self.needCoretext)
    {
        [self setLineBreakMode:NSLineBreakByTruncatingTail];
        [self setNumberOfLines:maxLineNum];
        
        [self sizeToFitByconstrainedSize:maxFrame];
    }
}

@end
