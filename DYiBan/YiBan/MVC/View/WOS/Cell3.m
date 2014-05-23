//
//  Cell3.m
//  DYiBan
//
//  Created by tom zeng on 13-12-24.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "Cell3.h"

@implementation Cell3

@synthesize titleLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self creatCell];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)creatCell{
    
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5 + 0, 0.0f, 50.0f, 50.0f)];
    [self addSubview:titleLabel];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    RELEASE(titleLabel);
    
    UIImageView *arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(200.0f, 5.0f, 50.0f, 50.0f)];
    [arrowImageView setBackgroundColor:[UIColor grayColor]];
    [self addSubview:arrowImageView];
    RELEASE(arrowImageView);
    
}



@end
