//
//  WOSMakeOrderTableViewCell.m
//  WOS
//
//  Created by axingg on 14-5-22.
//  Copyright (c) 2014年 ZzL. All rights reserved.
//

#import "WOSMakeOrderTableViewCell.h"
#import "WOSCalculateOrder.h"





@implementation WOSMakeOrderTableViewCell

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



-(void)creatCell:(NSArray *)dict1{

    NSDictionary *dict = [dict1 objectAtIndex:0];
    
    WOSCalculateOrder *calculateView  = [[WOSCalculateOrder alloc]initWithFrame:CGRectMake( 20, 5.0f, 300.0f, 40.0f) name:[dict objectForKey:@"foodName"]];
    calculateView.name = [dict objectForKey:@"foodName"];
    [calculateView setBackgroundColor:[UIColor clearColor]];
    calculateView.dict = dict;
    calculateView.lableMid.text = [NSString stringWithFormat:@"%d",[dict1 count]];
    [self addSubview:calculateView];
    RELEASE(calculateView);

}

@end
