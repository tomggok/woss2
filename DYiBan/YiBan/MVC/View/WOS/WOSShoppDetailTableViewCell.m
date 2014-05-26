//
//  WOSShoppDetailTableViewCell.m
//  WOS
//
//  Created by apple on 14-5-21.
//  Copyright (c) 2014年 ZzL. All rights reserved.
//

#import "WOSShoppDetailTableViewCell.h"
#import "WOSStarView.h"
#import "DYBSetButton.h"




@implementation WOSShoppDetailTableViewCell
@synthesize delegate;

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

    UILabel *labelName = [[UILabel alloc]initWithFrame:CGRectMake(10.0f, 10.f, 100, 20)];
    [labelName setText:[dict objectForKey:@"foodName"]];
    [labelName setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:labelName];
    RELEASE(labelName);
    
//    NSString *string = [dict objectForKey:@""];
//    WOSStarView *star = [[WOSStarView alloc]initWithFrame:CGRectMake(250/2, 10.0f, 100.0f, 20.0f) num:[]];
//    [self.contentView addSubview:star];
//    [star release];
    
    UILabel *labelPrice = [[UILabel alloc]initWithFrame:CGRectMake(420/2, 10.0f, 50.0, 20.0f)];
    [labelPrice setText:[NSString stringWithFormat:@"%@",[dict objectForKey:@"foodPrice"]]];
    [self.contentView addSubview:labelPrice];
    RELEASE(labelPrice);
    
    
    UIImage *image = [UIImage imageNamed:@"加入"];
    DYBSetButton *btn = [[DYBSetButton alloc]initWithFrame:CGRectMake(510/2, 10.0f, 107/2, 60/2)];
    [btn setImage:image forState:UIControlStateNormal];
    btn.sender = dict;
    [btn addTarget:self action:@selector(doAdd:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn];
    RELEASE(btn);

}

-(void)doAdd:(id)sender{
    
    DYBSetButton *btn = (DYBSetButton *)sender;
    
    if ([delegate respondsToSelector:@selector(shareOrderView:)]) {
        [delegate shareOrderView:btn.sender];
    }
    

}


@end
