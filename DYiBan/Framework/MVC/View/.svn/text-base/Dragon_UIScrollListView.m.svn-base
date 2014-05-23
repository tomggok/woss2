//
//  Dragon_UIScrollListView.m
//  DYiBan
//
//  Created by NewM on 13-9-6.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "Dragon_UIScrollListView.h"
@interface DragonUIScrollListView()
{
    DragonUIScrollView *_scrollview;
    
    DragonUIZoomView *firstView;
    DragonUIZoomView *seconView;
    DragonUIZoomView *thirdView;
    
    DragonUIImageView *firstImgView;
    DragonUIImageView *seconImgView;
    DragonUIImageView *thirdImgView;
    

}
@end


@implementation DragonUIScrollListView
@synthesize imgArr = _imgArr, selectIndex = _selectIndex;

DEF_SIGNAL(SCROLLVIEWNUM);
- (void)dealloc
{
    RELEASEVIEW(_scrollview);
    
    RELEASEVIEW(firstView);
    RELEASEVIEW(seconView);
    RELEASEVIEW(thirdView);
    
    RELEASEOBJ(firstImgView);
    RELEASEOBJ(seconImgView);
    RELEASEOBJ(thirdImgView);
    
    RELEASE(_imgArr);
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _scrollview = [[DragonUIScrollView alloc] initWithFrame:self.bounds];
        [_scrollview setShowsHorizontalScrollIndicator:NO];
        [self addSubview:_scrollview];
        [_scrollview setPagingEnabled:YES];
        
        
        
        seconView = [[DragonUIZoomView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        seconImgView = [[DragonUIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(seconView.frame), CGRectGetHeight(seconView.frame))];
        
        firstView = [[DragonUIZoomView alloc] initWithFrame:CGRectMake(seconView.frame.origin.x - CGRectGetWidth(seconView.frame), 0, CGRectGetWidth(seconView.frame), CGRectGetHeight(seconView.frame))];
        firstImgView = [[DragonUIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(seconView.frame), CGRectGetHeight(seconView.frame))];
        
        thirdView = [[DragonUIZoomView alloc] initWithFrame:CGRectMake(seconView.frame.origin.x + CGRectGetWidth(seconView.frame), 0, CGRectGetWidth(seconView.frame), CGRectGetHeight(seconView.frame))];
        thirdImgView = [[DragonUIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(seconView.frame), CGRectGetHeight(seconView.frame))];
        
        [_scrollview addSubview:firstView];
        [firstView setContent:firstImgView animated:NO];
        [_scrollview addSubview:seconView];
        [seconView setContent:seconImgView animated:NO];
        [_scrollview addSubview:thirdView];
        [thirdView setContent:thirdImgView animated:NO];
        
        [firstView setBackgroundColor:[UIColor clearColor]];
        [seconView setBackgroundColor:[UIColor clearColor]];
        [thirdView setBackgroundColor:[UIColor clearColor]];
        
    }
    return self;
}

- (void)setImgFrame:(CGRect)frame
{
    [seconView setFrame:frame];
    
    CGFloat firstX = seconView.frame.origin.x - CGRectGetWidth(seconView.frame);
    CGFloat thirdX = seconView.frame.origin.x + CGRectGetWidth(seconView.frame);
    [firstView setFrame:CGRectMake(firstX, 0, CGRectGetWidth(seconView.frame), CGRectGetHeight(seconView.frame))];
    [thirdView setFrame:CGRectMake(thirdX, 0, CGRectGetWidth(seconView.frame), CGRectGetHeight(seconView.frame))];
    
    if (firstX < 0)
    {
        [firstView setHidden:YES];
    }else
    {
        [firstView setHidden:NO];
    }
    
    if (thirdX >= _scrollview.contentSize.width) {
        [thirdView setHidden:YES];
    }else
    {
        [thirdView setHidden:NO];
    }
    
}

- (void)setImgIndex:(NSInteger)index
{
    NSDictionary *imgDict = [_imgArr objectAtIndex:index];
    if ([[imgDict allKeys] count] >= 2)
    {
        [seconImgView setImgWithUrl:[imgDict objectForKey:kSHOWIMGKEY] defaultImg:[imgDict objectForKey:kDEFAULTIMGKEY]];
        
        if (!firstView.isHidden && (index - 1) >= 0)
        {
            imgDict = [_imgArr objectAtIndex:index - 1];
            [firstImgView setImgWithUrl:[imgDict objectForKey:kSHOWIMGKEY] defaultImg:[imgDict objectForKey:kDEFAULTIMGKEY]];
        }
        
        if (!thirdView.isHidden && (index + 1) < [_imgArr count])
        {
            imgDict = [_imgArr objectAtIndex:index + 1];
            [thirdImgView setImgWithUrl:[imgDict objectForKey:kSHOWIMGKEY] defaultImg:[imgDict objectForKey:kDEFAULTIMGKEY]];
        }
    }else
    {
        [seconImgView setImage:[imgDict objectForKey:kSHOWIMGKEY]];
        
        if (!firstView.isHidden)
        {
            imgDict = [_imgArr objectAtIndex:index - 1];
            [firstImgView setImage:[imgDict objectForKey:kSHOWIMGKEY]];
        }
        
        if (!thirdView.isHidden)
        {
            imgDict = [_imgArr objectAtIndex:index + 1];
            [thirdImgView setImage:[imgDict objectForKey:kSHOWIMGKEY]];
        }
    }
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d", index], @"index", _scrollview, @"scrollview", nil];
    [self sendViewSignal:[DragonUIScrollListView SCROLLVIEWNUM] withObject:dict];
    
}

- (void)setImgArr:(NSArray *)imgArr
{
    RELEASEOBJ(_imgArr);
    
    _imgArr = [imgArr retain];
    
    [_scrollview setContentSize:CGSizeMake(CGRectGetWidth(self.frame)*([_imgArr count]), CGRectGetHeight(self.frame))];
    
}

- (void)setSelectIndex:(NSInteger)selectIndex
{
    _selectIndex = selectIndex;
    
    if (_selectIndex >= ([_imgArr count]))
    {
        return;
    }
        

    CGRect secFrame = seconView.frame;
    secFrame.origin.x = CGRectGetWidth(self.frame) * selectIndex;
    
    [_scrollview scrollRectToVisible:secFrame animated:NO];

    [self setImgFrame:secFrame];
    [self setImgIndex:selectIndex];
}

#pragma mark - 
#pragma mark - scrollview
- (void)handleViewSignal_DragonUIScrollView:(DragonViewSignal *)signal
{
    if ([signal is:[DragonUIScrollView SCROLLVIEWDIDSCROLL]])
    {
        DLogInfo(@"end === %f", _scrollview.contentOffset.x);
        int scrollviewX = _scrollview.contentOffset.x;
        int viewWidth = CGRectGetWidth(self.frame);
        CGFloat result = scrollviewX % viewWidth;
        NSInteger page = floor((_scrollview.contentOffset.x - viewWidth/2) / viewWidth) + 1;
        if (result == 0 && _selectIndex != page)
        {
            _selectIndex = page;
            [[firstView innerView] setZoomScale:1.f];
            [[seconView innerView] setZoomScale:1.f];
            [[thirdView innerView] setZoomScale:1.f];
            NSInteger index = _scrollview.contentOffset.x / 320;
            
            
            CGRect secFrame = seconView.frame;
            secFrame.origin.x = _scrollview.contentOffset.x;
            
            [self setImgFrame:secFrame];
            [self setImgIndex:index];
        }
        
    }
}


@end
