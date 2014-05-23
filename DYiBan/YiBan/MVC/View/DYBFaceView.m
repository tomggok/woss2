//
//  DYBFaceView.m
//  DYiBan
//
//  Created by Song on 13-9-5.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBFaceView.h"
#import "DYBPageControl.h"
@implementation DYBFaceView {
    DYBPageControl *pageController;
}
@synthesize _faceScrollView;
@synthesize faces;
@synthesize  delegate;

/**
 使用时注意 请注册一个表情选中事件的广播
 **/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    [self initview];
    return self;
    
}

-(void)initview{
    
    _faceScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 215)];
    _faceScrollView.pagingEnabled = YES;
    _faceScrollView.delegate = self;
    [self addSubview: _faceScrollView];
    [_faceScrollView setBackgroundColor:[UIColor whiteColor]];
    [_faceScrollView setAlpha:0.9];
    [_faceScrollView setShowsHorizontalScrollIndicator:NO];
    faces= [[NSMutableArray alloc] init];
    for (int i = 0;i<105;i++){
        UIImage *face = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png",i]];
        NSMutableDictionary *dicFace = [NSMutableDictionary dictionary];
        [dicFace setValue:face forKey:[NSString stringWithFormat:@"[/%d]",i]];
        [faces addObject:dicFace];
    }
    
    
    int xIndex = 0;
    int yIndex = 0;
    int emojiRangeArray[12] = {0,48};
    for (int j = 0 ; j<2 ; j++ ) {
        int startIndex = emojiRangeArray[j];
        int endIndex = emojiRangeArray[j+1];
        for (int i = startIndex ; i<= endIndex ; i++ ) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(10 + xIndex*45.0, 10 + yIndex*45.0, 32.0f, 32.0f);
            NSMutableDictionary *tempdic = [faces objectAtIndex:i];
            
            UIImage *tempImage = [tempdic valueForKey:[NSString stringWithFormat:@"[/%d]",i]];
            [button setBackgroundImage:tempImage forState:UIControlStateNormal];
            button.tag = i;
            [button addTarget:self action:@selector(didSelectAFace:)forControlEvents:UIControlEventTouchUpInside];
            [_faceScrollView addSubview:button];
            xIndex += 1;
            if (xIndex == 14) {
                xIndex = 0;
                yIndex += 1;
            }
        }
    }
    [_faceScrollView setContentSize:CGSizeMake(640.0f,  _faceScrollView.frame.size.height)];
    pageController = [[DYBPageControl alloc]initWithFrame:CGRectMake(0.0f, 185, 50.0f, 30.0f)];
    pageController.numberOfPages = 2;
    pageController.currentPage = 0;
    [pageController setCenter:CGPointMake(160, 200)];
    [pageController addTarget:self action:@selector(doPage:) forControlEvents:UIControlEventValueChanged];
    [pageController setBackgroundColor:[UIColor whiteColor]];
    [pageController setAlpha:0.9];
    [self addSubview:pageController];
}
-(void)doPage:(UIPageControl*)sender{
    
    UIPageControl *pageController1 = (UIPageControl*)sender;
    int currentPage = pageController1.currentPage;
    _faceScrollView.contentOffset = CGPointMake(320.0*(currentPage+0), 0);
}
/**
 发送表情选中消息
 **/
-(void)didSelectAFace:(id)sender
{
    if (delegate && [delegate respondsToSelector:@selector(selectFace:)]) {
//        [[CommonHelper shareInstance]playSound:5];
        [delegate selectFace:sender];
        
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int page = scrollView.contentOffset.x/320;
    pageController.currentPage = page;
    
}
-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed{
    
    
    
}
-(void)dealloc{
    [super dealloc];
    RELEASEVIEW(pageController);
    RELEASEVIEW(_faceScrollView);
}



@end
