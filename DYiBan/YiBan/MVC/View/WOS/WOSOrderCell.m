//
//  WOSOrderCell.m
//  DYiBan
//
//  Created by tom zeng on 13-12-2.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "WOSOrderCell.h"
#import "WOSCalculateOrder.h"

@implementation WOSOrderCell{

    UIImageView *imageHaveAdd;


}
DEF_SIGNAL(DOORDER)
@synthesize dictInfo = _dictInfo;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//        [self creatCell:nil];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)creatCell:(NSDictionary *)dict{

//    imageHaveAdd  = [[UIImageView alloc]initWithFrame:CGRectMake(10.0f, 5.0f, 20.0f, 20.0f)];
//    [imageHaveAdd setBackgroundColor:[UIColor grayColor]];
//    [self addSubview:imageHaveAdd];
//    RELEASE(imageHaveAdd);
    _dictInfo = dict;
    UILabel *labelName = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 100.0f, 15.0f)];
    [labelName setTextColor:[UIColor blackColor]];
    [labelName setBackgroundColor:[UIColor clearColor]];
    [labelName setText:[dict objectForKey:@"foodName"]];
    [labelName sizeToFit];
    [self addSubview:labelName];
    RELEASE(labelName);
    
    UILabel *labelPrice = [[UILabel alloc]initWithFrame:CGRectMake(10.0f, CGRectGetHeight(labelName.frame)+ 7 , 100.0f, 15.0f)];
    
    [labelPrice setText:[NSString stringWithFormat:@"￥ %@",[dict objectForKey:@"foodPrice"]]];
    [labelPrice setTextColor:[UIColor redColor]];
    [labelPrice sizeToFit];
    [labelPrice setBackgroundColor:[UIColor clearColor]];
    [self addSubview:labelPrice];
    RELEASE(labelPrice);


    UILabel *labelPrice2 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(labelPrice.frame) + CGRectGetWidth(labelPrice.frame), CGRectGetHeight(labelName.frame)+ 7 , 100.0f, 15.0f)];
    [labelPrice2 setText:@"/份"];
    [labelPrice2 setTextColor:[UIColor whiteColor]];
    [labelPrice2 sizeToFit];
    [labelPrice2 setBackgroundColor:[UIColor clearColor]];
    [self addSubview:labelPrice2];
    RELEASE(labelPrice2);

    
    UIImage *imageT = [UIImage imageNamed:@"add"];
    UIImageView *imageViewInt = [[UIImageView alloc]initWithFrame:CGRectMake(200.0f , CGRectGetHeight(self.frame) - imageT.size.height/2 - 20, imageT.size.width, imageT.size.height)];
    [imageViewInt setImage:imageT];
    [self addSubview:imageViewInt];
    [imageViewInt setBackgroundColor:[UIColor clearColor]];
    [imageViewInt setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doTap)];
    [tap setNumberOfTapsRequired:1];
    [tap setNumberOfTouchesRequired:1];
    [imageViewInt addGestureRecognizer:tap];
    RELEASE(tap);
}

-(void)doTap{

    [self sendViewSignal:[WOSOrderCell DOORDER] withObject:_dictInfo from:self target:self.superview];

}
@end
