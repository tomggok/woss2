//
//  WOSCardCell.m
//  WOS
//
//  Created by tom zeng on 14-2-17.
//  Copyright (c) 2014年 ZzL. All rights reserved.
//

#import "WOSCardCell.h"

@implementation WOSCardCell

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


-(void)creatCell:(NSDictionary *)dict{
    
//    UIImage *image = [UIImage imageNamed:@""];
    UIImageView *imageFen = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 10, 320.0f, 83)];
    [imageFen setImage:[UIImage imageNamed:@"优惠券1.png"]];
    [self addSubview:imageFen];
    RELEASE(imageFen);
    
//    UILabel *labelAddr = [[UILabel alloc]initWithFrame:CGRectMake(5.0f, 0.0f, 300.0f, 30)];
//    [labelAddr setText:[dict objectForKey:@"receiverAddress"]];
//    [labelAddr setTextColor:ColorGryWhite];
//    [labelAddr setBackgroundColor:[UIColor clearColor]];
//    [imageFen addSubview:labelAddr];
//    RELEASE(labelAddr)
    
    UILabel *labelName = [[UILabel alloc]initWithFrame:CGRectMake(35.0f, 10 , 200, 30)];
    [labelName setText:[dict objectForKey:@"kitchenName"]];
    [labelName setTextColor:[UIColor whiteColor]];
    [labelName setBackgroundColor:[UIColor clearColor]];
    [self addSubview:labelName];
    RELEASE(labelName);
    
    UILabel *labelTime = [[UILabel alloc]initWithFrame:CGRectMake(35.0f, 36, 250.0f, 40.0f)];
    [labelTime setBackgroundColor:[UIColor clearColor]];
    [labelTime setText:[dict objectForKey:@"summary"]];
    [labelTime setTextColor:[UIColor redColor]];
    [self addSubview:labelTime];
    RELEASE(labelTime);
    
    
    
    
    [self setBackgroundColor:[UIColor clearColor]];
}

@end
