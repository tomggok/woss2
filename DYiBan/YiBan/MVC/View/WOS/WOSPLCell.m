//
//  WOSPLCell.m
//  DYiBan
//
//  Created by tom zeng on 13-12-25.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "WOSPLCell.h"
#import "WOSStarView.h"


@implementation WOSPLCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)creatCell :(NSDictionary *)dict{

    UILabel *labelPLName = [[UILabel alloc]initWithFrame:CGRectMake(10.0f, 5 , 150, 20)];
    
    [labelPLName setBackgroundColor:[UIColor clearColor]];
    [labelPLName setTextColor:[UIColor whiteColor]];
    [labelPLName setText:[dict objectForKey:@"userName"]];
    [labelPLName sizeToFit];
    [self addSubview:labelPLName];
    RELEASE(labelPLName);
    
    int num = [[dict objectForKey:@"starLevel"] integerValue];
    WOSStarView *star = [[WOSStarView alloc]initWithFrame:CGRectMake(CGRectGetMidX(labelPLName.frame) + CGRectGetWidth(labelPLName.frame),5, 100, 30) num:num];
    [self addSubview:star];
    [star release];
    
    
    
    UILabel *lableTime = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMidX(star.frame) + CGRectGetWidth(star.frame)-30, 5, 250, 20)];
    [lableTime setBackgroundColor:[UIColor clearColor]];
    [lableTime setTextColor:[UIColor whiteColor]];
    [lableTime setText:[dict objectForKey:@"createTime"]];
    [lableTime setFont:[UIFont systemFontOfSize:13]];
    [self addSubview:lableTime];
    RELEASE(lableTime);
    
    
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(10.0f, CGRectGetMidY(labelPLName.frame) + CGRectGetHeight(labelPLName.frame), 300, 40)];
    [textView setBackgroundColor:[UIColor clearColor]];
    [textView setTextColor:[UIColor whiteColor]];
    [textView setText:[dict objectForKey:@"comment"]];
    [textView sizeToFit];
    [textView setUserInteractionEnabled:NO];
    [textView setEditable:NO];
    [self addSubview:textView];
    RELEASE(textView);

//    个人中心_line
    UIImageView *imageView  =[[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 79, 320.0f, 1)];
    [imageView setImage:[UIImage imageNamed:@"个人中心_line"]];
    [self addSubview:imageView];
    RELEASE( imageView);


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
