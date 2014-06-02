//
//  WOSPayCardTableViewCell.m
//  WOS
//
//  Created by apple on 14-5-31.
//  Copyright (c) 2014年 ZzL. All rights reserved.
//

#import "WOSPayCardTableViewCell.h"

@implementation WOSPayCardTableViewCell

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

-(void)ceatCell:(NSDictionary *)dict{


    UILabel *labelName = [[UILabel alloc]initWithFrame:CGRectMake(10.0f, 10.0f, 100.0f, 20.0f)];
    [labelName setText:[dict objectForKey:@"summary"]];
    [labelName setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:labelName];
    RELEASE( labelName);
    
    
    UIButton  *btn = [[UIButton alloc]initWithFrame:CGRectMake(280.0f, 10.0f, 20.0f, 20.0f)];
    [btn  addTarget:self action:@selector(doTouch:) forControlEvents:UIControlEventTouchUpInside];\
    [self addSubview:btn];
    RELEASE( btn);
    
    

}
-(void)doTouch:(id)sender{


}



@end
