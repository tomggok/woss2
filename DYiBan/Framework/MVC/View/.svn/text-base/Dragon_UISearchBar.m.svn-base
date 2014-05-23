//
//  Dragon_UISearchBar.m
//  ShangJiaoYuXin
//
//  Created by zhangchao on 13-5-7.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "Dragon_UISearchBar.h"
#import "UITableView+property.h"
#import "NSDictionary-MutableDeepCopy.h"
#import "UIView+DragonCategory.h"

@implementation DragonUISearchBar

DEF_SIGNAL(BEGINEDITING) //第一次按下搜索框
DEF_SIGNAL(CANCEL) //取消搜索后要干事就接受此消息
DEF_SIGNAL(SEARCH) //按下搜索按钮
DEF_SIGNAL(CHANGEWORD)//内容改变
DEF_SIGNAL(SEARCHING)//开始搜索

@synthesize b_isSearching=_b_isSearching,bt_Shade=_bt_Shade;

-(id)initWithFrame:(CGRect)frame  backgroundColor:(UIColor *)backgroundColor placeholder:(NSString *)placeholder isHideOutBackImg:(BOOL)isHideOutBackImg isHideLeftView:(BOOL)isHideLeftView/*隐藏左边的放大镜*/
{
    if (self=[super initWithFrame:frame]) {
        self.delegate=self;
        self.backgroundColor=backgroundColor;
        self.placeholder=placeholder;
        self.barStyle =UIBarStyleBlackTranslucent;//控件的样式
        self.autocorrectionType = UITextAutocorrectionTypeNo;//对于文本对象自动校正风格
        self.autocapitalizationType = UITextAutocapitalizationTypeNone;//首字母不自动大写s
        
        if (isHideOutBackImg) {/*外围背景图是否隐藏*/
            [(UIView *)[[self subviews] objectAtIndex:0] removeFromSuperview];
            
        }
        _isHideLeftView=isHideLeftView;/*是否隐藏左边的视图*/
        
        {//底线
            UIView *v=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)-1, CGRectGetWidth(self.frame), 1)];
            v.backgroundColor=[DragonCommentMethod colorWithHex:@"e5e5e5"];
            [self addSubview:v];
            RELEASE(v);
        }
    }
    return self;
}

//- (void)drawRect:(CGRect)rect
//{
//    UIImage *image = [UIImage imageNamed: @"input.png"];
//    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//}

#pragma mark- 自定义背景
-(void)customBackGround:(UIImageView *)imgV
{
    [imgV setFrame:CGRectMake(0, 0, self.bounds.size.width-10, self.frame.size.height-19)];//调整新背景图大小已覆盖 原来 的圆角边框
    imgV.contentMode=UIViewContentModeScaleToFill;
    imgV.tag=-1;
    
    if ([self.subviews count] > 0) {
        UIView *segment = [self.subviews objectAtIndex:0];//背景图
        [segment addSubview: imgV];
    }
//    segment.hidden=YES;=lpppp
}

- (void)layoutSubviews {


    {
        UITextField *searchField=[self valueForKey:@"_searchField"];
        
        if (searchField) {
        // 改输入字体颜色
        searchField.textColor = [DragonCommentMethod colorWithHex:@"333333"];

        // 改 placeholde 颜色
        [searchField setValue:[DragonCommentMethod colorWithHex:@"aaaaaa"] forKeyPath:@"_placeholderLabel.textColor"];
            
            if (_isHideLeftView)
            {
                [searchField.leftView removeFromSuperview];
                [searchField.leftView release];
                searchField.leftView=Nil;
                
            }
            
        }
     
        
//        for(int i = 0; ; i++) {
//            if([[self.subviews objectAtIndex:i] isKindOfClass:[UITextField class]]) { //conform?
//                searchField = [self.subviews objectAtIndex:i];
//                break;
//            }
//        }
        
//        if(searchField) {
////            searchField.textColor = [UIColor blackColor];
//           
//            if (_isHideLeftView)
//            {
//                [searchField.leftView removeFromSuperview];
//                [searchField.leftView release];
//                searchField.leftView=Nil;
//
//            }
//        }
    }
    
	[super layoutSubviews];
}

#pragma mark- 重写函数,改变取消按钮的样式
-(void)addSubview:(UIView *)view
{
    [super addSubview:view];
    if ([view isKindOfClass:[UIButton class]]) {
        UIButton *cancelButton = (UIButton *)view;
//        cancelButton.tag=-1;
//        cancelButton.backgroundColor=[UIColor clearColor];
        
//        UIImage *img=[UIImage imageNamed:@"btn_search_cancel_def"];
//        [cancelButton setBounds:CGRectMake(0, 0, img.size.width/2, img.size.height/2)];

//        UIImageView *imgV=[[UIImageView alloc]initWithImage:img];
//        imgV.contentMode=UIViewContentModeScaleAspectFit;
//        [imgV setFrame:CGRectMake(0, 0, cancelButton.frame.size.width, cancelButton.frame.size.height)];
//        [cancelButton addSubview:imgV];
//        [imgV release];
        
//        [cancelButton setBackgroundImage:img forState:UIControlStateNormal];
//        [cancelButton setBackgroundImage: [UIImage imageNamed:@"btn_search_cancel_high"] forState:UIControlStateHighlighted];
//        [cancelButton setTitle:@"" forState:UIControlStateNormal];
//        [cancelButton setImageEdgeInsets:UIEdgeInsetsMake(2, 0, 2, 0)];
//        cancelButton.titleLabel.font=[UIFont systemFontOfSize:13];
//        cancelButton.layer.borderColor=[UIColor blackColor].CGColor;
//        cancelButton.layer.borderWidth=0.6;
        
        cancelButton.hidden=YES;//隐藏系统的cancel按钮

    }
}

-(BOOL)cancelSearch
{
    if (self.b_isSearching) {
        [self resignFirstResponder];
        self.text=Nil;//消失右边的X号
        
        self.b_isSearching=NO;
        
        [self releaseShadeBt];
        
        [self releaseCancelBt];
        return YES;
    }
    return NO;
}

-(void)releaseCancelBt
{
    if (_bt_cancel) {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [_bt_cancel setFrame:_bt_cancel._originFrame];
        }completion:^(BOOL b){
            REMOVEFROMSUPERVIEW(_bt_cancel);
        }];
    }
}

-(void)releaseShadeBt
{
    if (_bt_Shade) {
        REMOVEFROMSUPERVIEW(_bt_Shade);
    }
}

#pragma mark- 初始取消search的背景按钮
-(void)initShadeBt
{
    if (!_bt_Shade) {
        _bt_Shade=[[DragonUIButton alloc]initWithFrame:CGRectMake(0, self.frame.origin.y+self.frame.size.height, screenShows.size.width, screenShows.size.height)];
        _bt_Shade.tag=k_tag_fadeBt;
        _bt_Shade.backgroundColor=[UIColor blackColor];
        [self.superview addSubview:_bt_Shade];
        RELEASE(_bt_Shade);
        _bt_Shade.alpha=0;
        
        [UIView animateWithDuration:0.3 animations:^{
            _bt_Shade.alpha=0.75;
        }];        
    }
  
}

#pragma mark- 初始 cancelBT
-(void)initCancelBt:(UIImage *)normalImg HighlightedImg:(UIImage *)HighlightedImg
{
    if (!_bt_cancel) {
        _bt_cancel=[[DragonUIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.frame), /*CGRectGetMinY(self.frame)*/ 0, normalImg.size.width/2, normalImg.size.height/2)];
        _bt_cancel.tag=k_tag_CancelBt;
        [_bt_cancel setImage:normalImg forState:UIControlStateNormal];
        [_bt_cancel setImage:HighlightedImg forState:UIControlStateHighlighted];
        _bt_cancel.backgroundColor=[UIColor clearColor];
        [_bt_cancel addSignal:[DragonUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside object:self];
        [self addSubview:_bt_cancel];
        _bt_cancel.hidden=NO;
        [_bt_cancel changePosInSuperViewWithAlignment:1];
        _bt_cancel._originFrame=CGRectMake(CGRectGetMaxX(self.frame), CGRectGetMinY(_bt_cancel.frame), normalImg.size.width/2, normalImg.size.height/2);
        [self bringSubviewToFront:_bt_cancel];
        RELEASE(_bt_cancel);
        
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [_bt_cancel setFrame:CGRectMake(CGRectGetMaxX(self.frame)-normalImg.size.width/2-15,CGRectGetMinY(_bt_cancel._originFrame), normalImg.size.width/2, normalImg.size.height/2)];
            
//            [_bt_cancel changePosInSuperViewWithAlignment:1];

        }completion:^(BOOL b){

        }];
    }
}

#pragma mark- 接受按钮信号
- (void)handleViewSignal_DragonUIButton:(DragonViewSignal *)signal
{
    if ([signal is:[DragonUIButton TOUCH_UP_INSIDE]]) {
        DragonUIButton *bt=(DragonUIButton *)signal.source;
        
        if (bt)
        {
            switch (bt.tag) {
                case k_tag_CancelBt://取消搜索
                case k_tag_fadeBt:
                {
                    DragonUISearchBar *search=(DragonUISearchBar *)signal.object;
                    [search cancelSearch];
                    
                    [self sendViewSignal:[DragonUISearchBar CANCEL] withObject:self];
                }
                    break;
                default:
                    break;
            }
        }
        
    }
    
}

#pragma mark- UISearchBarDelegate
//输入搜索文字时隐藏搜索按钮，清空时显示
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {

    [self sendViewSignal:[DragonUISearchBar BEGINEDITING] withObject:self];

    UIView *segment = [self.subviews objectAtIndex:0];
    [segment setFrame:CGRectMake(segment.frame.origin.x, segment.frame.origin.y, 50, segment.frame.size.height)];
    
    [self setNeedsDisplay];
    
    self.b_isSearching=YES;
    
    return YES;
    
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    
    searchBar.showsScopeBar = NO;
    
//    [searchBar sizeToFit];
    
    [searchBar setShowsCancelButton:NO animated:YES];
    
    return YES;
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar                    // called when cancel button pressed
{
//    DLogInfo(@"%f",CGRectGetWidth(self.bounds));
//    [self resignFirstResponder];
    
    [self cancelSearch];
    
    [self sendViewSignal:[DragonUISearchBar CANCEL] withObject:self];

//    self.text=self.placeholder;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar                  // called when keyboard search button pressed
{
    [self sendViewSignal:[DragonUISearchBar SEARCH] withObject:self];
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text NS_AVAILABLE_IOS(3_0) // called before text changes
{
//    NSString *length = [NSString stringWithFormat:@"%d",range.length];
//    NSString *location = [NSString stringWithFormat:@"%d", range.location];
//    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:length,@"length",location, @"location", searchBar, @"searchBar", text, @"text", nil];
//    
//    NSString *_text = [searchBar.text stringByReplacingCharactersInRange:range withString:text];
    
//    if (_target.maxLength > 0 && _text.length > _target.maxLength) {
//        DragonViewSignal *signal = [_target sendViewSignal:[DragonUITextView TEXT_OVERFLOW] withObject:userInfo];
//        
//        if (signal && [signal returnValue]) {
//            
//            return signal.boolValue;
//        }
//        
//        return YES;
//    }
//    DragonViewSignal *signal = [_target sendViewSignal:[DragonUITextView TEXTVIEW] withObject:userInfo];
    
//    RELEASEOBJ(userInfo);
//    if (signal && [signal returnValue]) {
//        return signal.boolValue;
//    }
    
    return YES;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{

    [self sendViewSignal:[DragonUISearchBar CHANGEWORD] withObject:searchText];

}
@end
