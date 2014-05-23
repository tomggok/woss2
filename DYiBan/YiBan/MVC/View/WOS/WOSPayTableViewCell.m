//
//  WOSPayTableViewCell.m
//  WOS
//
//  Created by axingg on 14-5-22.
//  Copyright (c) 2014年 ZzL. All rights reserved.
//

#import "WOSPayTableViewCell.h"

@implementation WOSPayTableViewCell

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

    UILabel *labelName = [[UILabel alloc]initWithFrame:CGRectMake(10.0f, 10.0f, 100.0f, 20.0f)];
    [labelName setText:@"tete"];
    [labelName setBackgroundColor:[UIColor clearColor]];
    [self addSubview:labelName];
    RELEASEOBJ(labelName)

    UILabel *labelPrice = [[UILabel alloc]initWithFrame:CGRectMake(10.0f, 10.0f, 100.0f, 20.0f)];
    [labelPrice setText:@"120"];
    [labelPrice setBackgroundColor:[UIColor clearColor]];
    [labelName setTextColor:[UIColor colorWithRed:97.0f/255 green:97.0f/255 blue:97.0f/255 alpha:1.0]];
    [self addSubview:labelPrice];
    RELEASEOBJ(labelPrice)

    
    
    
}

@end
