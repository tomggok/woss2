//
//  DYBDataBankShareChooseView.m
//  DYiBan
//
//  Created by tom zeng on 13-8-28.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBDataBankShareChooseView.h"

@implementation DYBDataBankShareChooseView
@synthesize arrayObj = _arrayObj;
- (id)initWithFrame:(CGRect)frame arrayObj:(NSArray *)array
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _arrayObj = array;

        [self initView];
    }
    return self;
}

-(void)initView{
    
    int offset = 40;
    [self setBackgroundColor:[UIColor greenColor]];
    UIImageView *imageViewTop = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, 4)];
    [self addSubview:imageViewTop];
    [imageViewTop setBackgroundColor:[UIColor redColor]];
    RELEASE(imageViewTop);
    
    UIImageView *imageViewMid = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, 4)];
    [imageViewMid setUserInteractionEnabled:YES];
    [self addSubview:imageViewMid];
    RELEASE(imageViewMid);

    for (int i = 1; i <= _arrayObj.count; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [btn setTitle:[_arrayObj objectAtIndex:i-1] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
        [btn setBackgroundColor:[UIColor blackColor]];
        [btn setFrame:CGRectMake(2.0f, 2.0f + offset * (i - 1) , 60.0f, 30.0f)];
        [btn setTag:i];
        
        [btn addTarget:self action:@selector(touchME:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    [imageViewMid setFrame:CGRectMake(0.0f, imageViewTop.frame.origin.y +imageViewTop.frame.size.height, self.frame.size.width, 50 * (_arrayObj.count))];
                                      
    UIImageView *imageBot = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, imageViewMid.frame.origin.y + imageViewMid.frame.size.height , self.frame.size.width, 4)];
    [self addSubview:imageBot];
    RELEASE(imageBot);


}

-(void)touchME:(id)sender{
    
    UIButton *btn = (UIButton *)sender;

    NSLog(@"ddd %d",btn.tag);

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
