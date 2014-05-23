//
//  WOSOrderCAICell.m
//  DYiBan
//
//  Created by tom zeng on 14-1-9.
//  Copyright (c) 2014年 ZzL. All rights reserved.
//

#import "WOSOrderCAICell.h"

@implementation WOSOrderCAICell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self creat:nil];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)creat:(NSDictionary *)dict{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 70)];

    [self addSubview:view];
    RELEASE( view);
    
    UIImageView *imageViewIcon = [[UIImageView alloc]initWithFrame:CGRectMake(5.0f, 5.0f, 80, 70)];
    [imageViewIcon setBackgroundColor:[UIColor redColor]];
    [imageViewIcon setImage:[UIImage imageNamed:@"food1.png"]];
    [view addSubview:imageViewIcon];
    RELEASE(imageViewIcon);
    
    UILabel *labelNum = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(imageViewIcon.frame) + CGRectGetMinX(imageViewIcon.frame) + 3 + 3, 5, 100, 15)];
    [labelNum setBackgroundColor:[UIColor clearColor]];
    [labelNum setTextColor:[UIColor blackColor]];
    [labelNum setText:[NSString stringWithFormat:@"宫保鸡丁"]];
    [view addSubview:labelNum];
    RELEASE(labelNum);

    
    
    
    UILabel *labelPrice = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(imageViewIcon.frame) + CGRectGetMinX(imageViewIcon.frame) + 3 + 2,   CGRectGetMinY(labelNum.frame) +CGRectGetHeight(labelNum.frame) + 3 + 2 + 7, 100, 15)];
    [labelPrice setText:@"￥93/份"];
    [labelPrice setTextColor:[UIColor colorWithRed:246/255.0f green:46/255.0f blue:9/255.0f alpha:1.0f]];
    [labelPrice setBackgroundColor:[UIColor clearColor]];
    [view addSubview:labelPrice];
    RELEASE(labelPrice);
    
    UILabel *labelAddr = [[UILabel alloc]initWithFrame:CGRectMake(100 + CGRectGetWidth(imageViewIcon.frame) + CGRectGetMinX(imageViewIcon.frame) + 3 + 2,   CGRectGetMinY(labelPrice.frame) +CGRectGetHeight(labelPrice.frame) - 15 , 100, 15) ];
    [labelAddr setTextColor:[UIColor blackColor]];
    [labelAddr setBackgroundColor:[UIColor clearColor]];
    [labelAddr setText:@"数量1份"];
    [view addSubview:labelAddr];
    RELEASE(labelAddr);
    

    
    
    UIImageView *imageFen = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 79, 320.0f, 1)];
    [imageFen setImage:[UIImage imageNamed:@"个人中心_line"]];
    [self addSubview:imageFen];
    RELEASE(imageFen);
    [view setBackgroundColor:[UIColor clearColor]];
}

@end
