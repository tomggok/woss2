//
//  WOSOrderDetailTableViewCell.m
//  WOS
//
//  Created by apple on 14-5-19.
//  Copyright (c) 2014年 ZzL. All rights reserved.
//

#import "WOSOrderDetailTableViewCell.h"

@implementation WOSOrderDetailTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)creatCell:(NSDictionary *)dict{

    UILabel *labelName = [[UILabel alloc]initWithFrame:CGRectMake(82/2, 0.0f, 210/2, 30)];
    [labelName setBackgroundColor:[UIColor clearColor]];
    [labelName setTextColor:[UIColor whiteColor]];
    [labelName setText:[dict objectForKey:@"foodName"]];
    [self addSubview:labelName];
    RELEASE( labelName);
    
    UILabel *labelNum = [[UILabel alloc]initWithFrame:CGRectMake(300.0f/2, 0.0f, 80/2, 30.0f)];
    [labelNum setBackgroundColor:[UIColor clearColor]];
    NSString *countN = [[dict objectForKey:@"foodCount"] stringValue];
    [labelNum setText:countN];
    [labelNum setTextColor:[UIColor whiteColor]];

    [self addSubview:labelNum];
    RELEASE( labelNum);
    
    
    UILabel *labelPrice = [[UILabel alloc]initWithFrame:CGRectMake(514/2, 0.0f, 80/2, 30.0f)];
    
    [labelPrice setText:[[dict objectForKey:@"foodPrice"] stringValue]];
    [self addSubview:labelPrice];
    [labelPrice setTextColor:[UIColor whiteColor]];

    [labelPrice setBackgroundColor:[UIColor clearColor]];
    RELEASE( labelPrice);
    
}

@end
