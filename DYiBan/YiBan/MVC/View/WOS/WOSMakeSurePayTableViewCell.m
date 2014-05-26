//
//  WOSMakeSurePayTableViewCell.m
//  WOS
//
//  Created by apple on 14-5-27.
//  Copyright (c) 2014年 ZzL. All rights reserved.
//

#import "WOSMakeSurePayTableViewCell.h"

@implementation WOSMakeSurePayTableViewCell

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
-(void)creatCell:(NSArray *)dict{

    NSDictionary *dd = [dict objectAtIndex:0];
    UILabel *labelName = [[UILabel alloc]initWithFrame:CGRectMake(10.0f, 4.0f, 150.0f, 30.0f)];
    [labelName setBackgroundColor:[UIColor clearColor]];
    [labelName setText:[dd objectForKey:@"foodName"]];
    [self addSubview:labelName];
    RELEASE(labelName)
    
    UILabel *labelPrece = [[UILabel alloc]initWithFrame:CGRectMake(210.0f, 4.0f, 150.0f, 30.0f)];
    [labelPrece setBackgroundColor:[UIColor clearColor]];
    NSString *stringPrice = [dd objectForKey:@"foodPrice"];
    [labelPrece setText:[NSString stringWithFormat:@"%.2f",[stringPrice floatValue] * dict.count]];
    [self addSubview:labelPrece];
    RELEASE(labelPrece)
    
    

}
@end
