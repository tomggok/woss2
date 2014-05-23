//
//  WOSGoodPriceCell.m
//  DYiBan
//
//  Created by tom zeng on 13-12-26.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "WOSGoodPriceCell.h"
#import "WOSMakeSureOrderListViewController.h"
#import "UIImageView+WebCache.h"

@implementation WOSGoodPriceCell

@synthesize  targetObj = _targetObj;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//        [self creatView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)creatView:(NSDictionary *)dcit{

    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 70)];
    [self addSubview:view];
    RELEASE( view);
    
    UIImageView *imageViewIcon = [[UIImageView alloc]initWithFrame:CGRectMake(5.0f, 5.0f, 93, 70)];
    [imageViewIcon setBackgroundColor:[UIColor redColor]];
    NSURL *url = [NSURL URLWithString:[DYBShareinstaceDelegate addIPImage:[dcit objectForKey:@"imgUrl"]]];
//    [imageViewIcon setImage:[UIImage imageNamed:@"food1.png"]];
    [imageViewIcon setImageWithURL:url];
    [imageViewIcon setFrame:CGRectMake(5.0f, 5.0f, 93, 70)];
    [view addSubview:imageViewIcon];
    RELEASE(imageViewIcon);
    
    UILabel *labelNum = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(imageViewIcon.frame) + CGRectGetMinX(imageViewIcon.frame) + 3 + 3, 5, 100, 15)];
    [labelNum setBackgroundColor:[UIColor clearColor]];
    [labelNum setTextColor:[UIColor whiteColor]];
    [labelNum setText:[dcit objectForKey:@"kitchenName"]];
    [view addSubview:labelNum];
    RELEASE(labelNum);
    
    
    UILabel *star = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(imageViewIcon.frame) + CGRectGetMinX(imageViewIcon.frame) + 3, CGRectGetHeight(labelNum.frame) + 5 + 3,100, 30) ];
    [star setText:[dcit objectForKey:@"foodName"]];
    [star setBackgroundColor:[UIColor clearColor]];
    [star setTextColor:[UIColor redColor]];
    [view addSubview:star];
    [star release];
    
    
    UILabel *labelPrice = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(imageViewIcon.frame) + CGRectGetMinX(imageViewIcon.frame) + 3 + 2,  CGRectGetMinY(star.frame) +CGRectGetHeight(star.frame) + 7 , 100, 15)];
    [labelPrice setText:[NSString stringWithFormat:@"特价￥%@",[dcit objectForKey:@"discountPrice"] ]];
    [labelPrice setTextColor:[UIColor colorWithRed:246/255.0f green:46/255.0f blue:9/255.0f alpha:1.0f]];
    [labelPrice setBackgroundColor:[UIColor clearColor]];
    [view addSubview:labelPrice];
    RELEASE(labelPrice);
    
    UILabel *labelAddr = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(labelPrice.frame) + CGRectGetMinX(labelPrice.frame) + 3 + 2,  CGRectGetMinY(star.frame) +CGRectGetHeight(star.frame) + 7 , 100, 15) ];
    [labelAddr setTextColor:[UIColor whiteColor]];
    [labelAddr setBackgroundColor:[UIColor clearColor]];
    [labelAddr setText:[NSString stringWithFormat:@"原价￥%@",[dcit objectForKey:@"foodPrice"]]];
    [view addSubview:labelAddr];
    RELEASE(labelAddr);
    
    UILabel *labelNo = [[UILabel alloc]initWithFrame:CGRectMake(50.0f, CGRectGetHeight(labelAddr.frame)/2, CGRectGetWidth(labelAddr.frame)-65, 1)];
    [labelNo setBackgroundColor:[UIColor whiteColor]];
    [labelAddr addSubview:labelNo];
    RELEASE(labelNo);
    
    
    UIImage *imageT = [UIImage imageNamed:@"add"];
    UIImageView *imageViewInt = [[UIImageView alloc]initWithFrame:CGRectMake(280.0f , CGRectGetHeight(self.frame) - imageT.size.height/2 , imageT.size.width, imageT.size.height)];
    [imageViewInt setImage:imageT];
    [view addSubview:imageViewInt];
     [imageViewInt setBackgroundColor:[UIColor clearColor]];
    [imageViewInt setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doGoodPrice)];
    [tap setNumberOfTapsRequired:1];
    [tap setNumberOfTouchesRequired:1];
    [imageViewInt addGestureRecognizer:tap];
    [tap release];
    RELEASE(imageViewInt);
    [view setBackgroundColor:ColorBG];

    UIImageView *imageFen = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 89, 320.0f, 1)];
    [imageFen setImage:[UIImage imageNamed:@"个人中心_line"]];
    [view addSubview:imageFen];
    RELEASE(imageFen);
    
}

-(void)doGoodPrice{
    
    
    WOSMakeSureOrderListViewController *makeSure = [[WOSMakeSureOrderListViewController alloc]init];
    [_targetObj.navigationController pushViewController:makeSure animated:YES];
    [makeSure release];


}
- (void)dealloc
{
    [_targetObj release];
    [super dealloc];
}

@end
