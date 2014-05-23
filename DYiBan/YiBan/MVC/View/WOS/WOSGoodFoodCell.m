//
//  WOSGoodFoodCell.m
//  DYiBan
//
//  Created by tom zeng on 13-12-4.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "WOSGoodFoodCell.h"

@implementation WOSGoodFoodCell

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

-(void)creatCell:(NSDictionary *)dict {

    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 40.0f)];
    [imageView setImage:[UIImage imageNamed:@""]];

    [self addSubview:imageView];
    RELEASE(imageView);
    
    UILabel *labelName = [[UILabel alloc]initWithFrame:CGRectMake(5.0f, CGRectGetHeight(imageView.frame), 100.0f, 20.0f)];
    [labelName setText:@"rrrr"];
    [self addSubview:labelName];
    RELEASE(labelName);
    
    UILabel *labelDistance = [[UILabel alloc]initWithFrame:CGRectMake(280.0f, CGRectGetHeight(imageView.frame), 40.0f, 20.0f)];
    [labelDistance setText:@"333"];
    [self addSubview:labelDistance];
    RELEASE(labelDistance);
    

}

@end
