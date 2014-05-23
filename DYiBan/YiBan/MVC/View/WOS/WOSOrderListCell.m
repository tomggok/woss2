//
//  WOSOrderListCell.m
//  DYiBan
//
//  Created by tom zeng on 13-12-24.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "WOSOrderListCell.h"

@implementation WOSOrderListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//        [self creat:nil];
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
    [labelNum setTextColor:ColorGryWhite];
    [labelNum setText:[NSString stringWithFormat:@"海底捞火锅"]];
    [view addSubview:labelNum];
    RELEASE(labelNum);
    
//    WOSStarView *star = [[WOSStarView alloc]initWithFrame:CGRectMake(CGRectGetWidth(imageViewIcon.frame) + CGRectGetMinX(imageViewIcon.frame) + 3, CGRectGetHeight(labelNum.frame) + 5 + 3,100, 30) num:3];
//    [view addSubview:star];
//    [star release];
    UILabel *labelTime = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(imageViewIcon.frame) + CGRectGetMinX(imageViewIcon.frame) + 3 + 3,  CGRectGetHeight(labelNum.frame) + 5 + 7, 220, 15)];
    [labelTime setFont:[UIFont systemFontOfSize:14]];
    [labelTime setTextColor:ColorGryWhite];
    [labelTime setBackgroundColor:[UIColor clearColor]];
    [labelTime setText: [NSString stringWithFormat:@"订单时间：%@",[dict objectForKey:@"createTime"]]];
    [self addSubview:labelTime];
    RELEASE(labelTime);
    
    
    
    UILabel *labelPrice = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(imageViewIcon.frame) + CGRectGetMinX(imageViewIcon.frame) + 3 + 2,   CGRectGetMinY(labelTime.frame) +CGRectGetHeight(labelTime.frame) + 3 + 2 + 7, 100, 15)];
    [labelPrice setText:[NSString stringWithFormat:@"总额：%@",[dict objectForKey:@"totalSum"]]];
    [labelPrice setTextColor:[UIColor colorWithRed:246/255.0f green:46/255.0f blue:9/255.0f alpha:1.0f]];
    [labelPrice setBackgroundColor:[UIColor clearColor]];
    [view addSubview:labelPrice];
    RELEASE(labelPrice);
    
    UILabel *labelAddr = [[UILabel alloc]initWithFrame:CGRectMake(100 + CGRectGetWidth(imageViewIcon.frame) + CGRectGetMinX(imageViewIcon.frame) + 3 + 2,   CGRectGetMinY(labelPrice.frame) +CGRectGetHeight(labelPrice.frame) - 15 , 100, 15) ];
    [labelAddr setTextColor:ColorGryWhite];
    [labelAddr setBackgroundColor:[UIColor clearColor]];
    [labelAddr setText:[self getStatus:[dict objectForKey:@"status"]]];
    [view addSubview:labelAddr];
    RELEASE(labelAddr);
    
    UIImage *imageT = [UIImage imageNamed:@"jian"];
    UIImageView *imageViewInt = [[UIImageView alloc]initWithFrame:CGRectMake(280.0f + 10, CGRectGetHeight(self.frame) - imageT.size.height/2 -3, imageT.size.width/2, imageT.size.height/2)];
    [imageViewInt setImage:imageT];
    [view addSubview:imageViewInt];
    //    [imageViewInt setBackgroundColor:[UIColor redColor]];
    RELEASE(imageViewInt);
    [view setBackgroundColor:ColorBG];
    
    
    UIImageView *imageFen = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 79, 320.0f, 1)];
    [imageFen setImage:[UIImage imageNamed:@"个人中心_line"]];
    [self addSubview:imageFen];
    RELEASE(imageFen);
}

-(NSString *)getStatus:(NSString *)key{

    if ([key isEqualToString:@"0"]) {
        return @"处理中";
    }
   else if ([key isEqualToString:@"1"]) {
        return @"配送中";
    }
   else if ([key isEqualToString:@"2"]) {
        return @"已经送达";
    }


}

@end
