//
//  SGFocusImageFrame.m
//  ScrollViewLoop
//
//  Created by Vincent Tang on 13-7-18.
//  Copyright (c) 2013年 Vincent Tang. All rights reserved.
//

#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"
#import <objc/runtime.h>
#define ITEM_WIDTH 304
#import "UIImageView+WebCache.h"
//#import "lab"
//#import "FMessageViewController.h"
#define rightDirection 1
#define leftDirection 0


@interface SGFocusImageFrame () {
    UIScrollView *_scrollView;
    //    GPSimplePageView *_pageControl;
    UIPageControl *_pageControl;
    
    
    int pageNumer;//页码
    int switchDirection;//方向
    NSMutableArray *imageNameArr;//图片数组
    NSMutableArray *titleStrArr;//标题数组
    
    UIScrollView *imageSV;//滚动视图
    int _page;//页码
}

- (void)setupViews;
- (void)switchFocusImageItems;
@end

static NSString *SG_FOCUS_ITEM_ASS_KEY = @"loopScrollview";

static CGFloat SWITCH_FOCUS_PICTURE_INTERVAL = 5.0; //switch interval time

@implementation SGFocusImageFrame
@synthesize delegate = _delegate,arrayString = _arrayString,arrayImage = _arrayImage;

- (id)initWithFrame:(CGRect)frame delegate:(id<SGFocusImageFrameDelegate>)delegate focusImageItems:(SGFocusImageItem *)firstItem, ...
{
    self = [super initWithFrame:frame];
    if (self) {
        NSMutableArray *imageItems = [NSMutableArray array];
        SGFocusImageItem *eachItem;
        va_list argumentList;
        if (firstItem)
        {
            [imageItems addObject: firstItem];
            va_start(argumentList, firstItem);
            while((eachItem = va_arg(argumentList, SGFocusImageItem *)))
            {
                [imageItems addObject: eachItem];
            }
            va_end(argumentList);
        }
        
        objc_setAssociatedObject(self, (const void *)SG_FOCUS_ITEM_ASS_KEY, imageItems, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        _isAutoPlay = YES;
        [self setupViews];
        
        [self setDelegate:delegate];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame delegate:(id<SGFocusImageFrameDelegate>)delegate imageItems:(NSArray *)items isAuto:(BOOL)isAuto arrayStringTotal:(NSArray *)array arrayImage:(NSMutableArray *)arrayImg{
    self = [super initWithFrame:frame];
    if (self)
    {
        _arrayString = array;
         _arrayImage = arrayImg;
        [_arrayImage retain];
        NSMutableArray *imageItems = [NSMutableArray arrayWithArray:items];
        objc_setAssociatedObject(self, (const void *)SG_FOCUS_ITEM_ASS_KEY, imageItems, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        _isAutoPlay = isAuto;
        [self setupViews];
       
        [self setDelegate:delegate];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame delegate:(id<SGFocusImageFrameDelegate>)delegate imageItems:(NSArray *)items
{
    return [self initWithFrame:frame delegate:delegate imageItems:items isAuto:YES];
}

- (void)dealloc
{
    objc_setAssociatedObject(self, (const void *)SG_FOCUS_ITEM_ASS_KEY, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    _scrollView.delegate = nil;
    [_scrollView release];
       [_arrayImage release];
    [_pageControl release];
    [super dealloc];
}


#pragma mark - private methods 
- (void)setupViews
{
    NSArray *imageItems = objc_getAssociatedObject(self, (const void *)SG_FOCUS_ITEM_ASS_KEY);
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.scrollsToTop = NO;

    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height -16, 320, 10)];
    _pageControl.userInteractionEnabled = NO;
    [self addSubview:_scrollView];
    [self addSubview:_pageControl];
    

    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    
    _pageControl.numberOfPages = imageItems.count>1?imageItems.count -2:imageItems.count;
    _pageControl.currentPage = 0;
    
    _scrollView.delegate = self;
    
    // single tap gesture recognizer
    UITapGestureRecognizer *tapGestureRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureRecognizer:)];
    tapGestureRecognize.delegate = self;
    [_scrollView addGestureRecognizer:tapGestureRecognize];
    tapGestureRecognize.numberOfTapsRequired = 1;
    
    
    for (int i = 0; i < _arrayString.count; i++) {

        
        UILabel *imageView = [[UILabel alloc] initWithFrame:CGRectMake((i ) * _scrollView.frame.size.width, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];

        [imageView setText:[_arrayString objectAtIndex:i]];
        
        imageView.backgroundColor = i%2?[UIColor redColor]:[UIColor blueColor];
        
        
        UIImageView *imageViewSure = [[UIImageView alloc]initWithFrame:CGRectMake((i +0) * _scrollView.frame.size.width, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
        [imageViewSure setBackgroundColor:[UIColor redColor]];
        [imageViewSure setImage:[UIImage imageNamed:[_arrayImage objectAtIndex:i]]];
        [imageViewSure setImageWithURL:[NSURL URLWithString:[_arrayImage objectAtIndex:i]]];
        [imageViewSure setFrame:CGRectMake((i +0) * _scrollView.frame.size.width, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
        [_scrollView addSubview:imageViewSure];
        [imageViewSure release];

    }
    [tapGestureRecognize release];
    if ([imageItems count]>1)
    {
       
        [_scrollView setContentOffset:CGPointMake(ITEM_WIDTH, 0) animated:NO] ;
        if (_isAutoPlay)
        {
            [self performSelector:@selector(switchFocusImageItems) withObject:nil afterDelay:SWITCH_FOCUS_PICTURE_INTERVAL];
        }
        
    }
    
    _page = 0;
     [_scrollView setContentSize:CGSizeMake(ITEM_WIDTH * _arrayImage.count, CGRectGetHeight(_scrollView.frame))];
   [NSTimer scheduledTimerWithTimeInterval:20.0f target:self selector:@selector(changeView) userInfo:nil repeats:YES];
    //objc_setAssociatedObject(self, (const void *)SG_FOCUS_ITEM_ASS_KEY, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [_scrollView setBackgroundColor:[UIColor clearColor]];
    
    [_scrollView setContentOffset:CGPointMake(-100, 0) animated:NO] ;
}



-(void)changeView
{

    if (_page == 0) {
        switchDirection = rightDirection;
    }else if(_page == _arrayImage.count - 1){
        switchDirection = leftDirection;
    }
    if (switchDirection == rightDirection) {
        _page ++;
    }else if (switchDirection == leftDirection){
        
        if (_page == 1) {
            
            _page ++;
            switchDirection = rightDirection;
        }else{
            
            _page --;
            
        }
    }

    NSLog(@"page --- %d",_page);
//    [_scrollView setContentOffset:CGPointMake(ITEM_WIDTH*_page, 0) animated:YES];
    
    
    
}


- (void)switchFocusImageItems
{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(switchFocusImageItems) object:nil];
    
    CGFloat targetX = _scrollView.contentOffset.x + _scrollView.frame.size.width;
    NSArray *imageItems = objc_getAssociatedObject(self, (const void *)SG_FOCUS_ITEM_ASS_KEY);
    targetX = (int)(targetX/ITEM_WIDTH) * ITEM_WIDTH;
    [self moveToTargetPosition:targetX];
    
    if ([imageItems count]>1 && _isAutoPlay)
    {
        [self performSelector:@selector(switchFocusImageItems) withObject:nil afterDelay:SWITCH_FOCUS_PICTURE_INTERVAL];
    }
    
}

- (void)singleTapGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    NSLog(@"ttttttt");
    
    NSLog(@"%s", __FUNCTION__);
    int page = (int)(_scrollView.contentOffset.x / _scrollView.frame.size.width);
    DLogInfo(@"page -- ? %d",page);
    if (gestureRecognizer.numberOfTouches == 1) {
        
        if ([self.delegate respondsToSelector:@selector(foucusImageFrame:currentItem:)])
        {
            [self.delegate foucusImageFrame:self currentItem:page];
        }
    }
}

- (void)moveToTargetPosition:(CGFloat)targetX
{
    BOOL animated = YES;
    //    NSLog(@"moveToTargetPosition : %f" , targetX);
    [_scrollView setContentOffset:CGPointMake(targetX, 0) animated:animated];
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float targetX = scrollView.contentOffset.x;
    NSArray *imageItems = objc_getAssociatedObject(self, (const void *)SG_FOCUS_ITEM_ASS_KEY);
    if ([imageItems count]>3)
    {
        if (targetX >= ITEM_WIDTH * ([imageItems count] -1)) {
            targetX = ITEM_WIDTH;
            [_scrollView setContentOffset:CGPointMake(targetX, 0) animated:NO];
        }
        else if(targetX <= 0)
        {
            targetX = ITEM_WIDTH *([imageItems count]-2);
            [_scrollView setContentOffset:CGPointMake(targetX, 0) animated:NO];
        }
    }
    int page = (_scrollView.contentOffset.x+ITEM_WIDTH/2.0) / ITEM_WIDTH;
    //    NSLog(@"%f %d",_scrollView.contentOffset.x,page);
    if ([imageItems count] > 1)
    {
        page --;
        if (page >= _pageControl.numberOfPages)
        {
            page = 0;
        }else if(page <0)
        {
            page = _pageControl.numberOfPages -1;
        }
    }
    if (page!= _pageControl.currentPage)
    {
//        if ([self.delegate respondsToSelector:@selector(foucusImageFrame:currentItem:)])
//        {
////            [self.delegate foucusImageFrame:self currentItem:page];
//        }
    }
    _pageControl.currentPage = page;
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        CGFloat targetX = _scrollView.contentOffset.x + _scrollView.frame.size.width;
        targetX = (int)(targetX/ITEM_WIDTH) * ITEM_WIDTH;
        [self moveToTargetPosition:targetX];
    }
   
     
    
    [self performSelector:@selector(delayFun) withObject:nil afterDelay:0.2];
}
-(void)delayFun{

 NSLog(@"currentpage -- %d",_pageControl.currentPage);
    int page = (_scrollView.contentOffset.x+ITEM_WIDTH/2.0) / ITEM_WIDTH;
    NSLog(@">>>>page ---- %d",page);
    _page = page;


}

- (void)scrollToIndex:(int)aIndex
{
    NSArray *imageItems = objc_getAssociatedObject(self, (const void *)SG_FOCUS_ITEM_ASS_KEY);
    if ([imageItems count]>1)
    {
        if (aIndex >= ([imageItems count]-2))
        {
            aIndex = [imageItems count]-3;
        }
        [self moveToTargetPosition:ITEM_WIDTH*(aIndex+1)];
    }else
    {
        [self moveToTargetPosition:0];
    }
    [self scrollViewDidScroll:_scrollView];
    
}

@end