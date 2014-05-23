//
//  WOSGoodFoodListCell.m
//  DYiBan
//
//  Created by tom zeng on 13-12-9.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "WOSGoodFoodListCell.h"
#import "WOSStarView.h"

@implementation WOSGoodFoodListCell

@synthesize row = _row;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//        [self creat:nil];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(id)initRow:(NSDictionary *)dic{
    _row = 1;
   
    
    self = [super initWithStyle:nil reuseIdentifier:nil];
    if (self) {
        // Initialization code
        //        [self creat:nil];
         [self creat:dic];
    }
    return self;

}
-(void)creat:(NSDictionary *)dict{

    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 145/2)];
    [self addSubview:view];
    RELEASE( view);
    
    UIImageView *imageViewIcon = [[UIImageView alloc]initWithFrame:CGRectMake(9.0f,7.0f, 110/2, 110/2)];
    [imageViewIcon setBackgroundColor:[UIColor redColor]];
    [imageViewIcon setImage:[UIImage imageNamed:@"food1.png"]];
    [view addSubview:imageViewIcon];
    RELEASE(imageViewIcon);
    
  
    
    
    UILabel *labelNum = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(imageViewIcon.frame) + CGRectGetMinX(imageViewIcon.frame) + 3 + 3, 5, 100, 15)];
    [labelNum setBackgroundColor:[UIColor clearColor]];
//    [labelNum setTextColor:ColorGryWhite];
    [labelNum setText:[dict objectForKey:@"kitchenName"]];
    [labelNum sizeToFit];
    [view addSubview:labelNum];
    RELEASE(labelNum);
    
    UIImage *imageChuan1 = [UIImage imageNamed:@"优惠小图标"];
    UIImageView *imageViewChuan1 = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(labelNum.frame) + CGRectGetMinX(labelNum.frame) + 3 + 3, 5,imageChuan1.size.width/2 , imageChuan1.size.height/2)];
    [view addSubview:imageViewChuan1];
    [imageViewChuan1 setImage:imageChuan1];
    [imageViewChuan1 release];
    [imageViewChuan1 setBackgroundColor:[UIColor redColor]];

    
    UIImage *imageChuan = [UIImage imageNamed:@"川菜小图标"];
    UIImageView *imageViewChuan = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(imageViewIcon.frame) + CGRectGetMinX(imageViewIcon.frame) + 3 ,  CGRectGetHeight(labelNum.frame) + 5 + 3,imageChuan.size.width/2 , imageChuan.size.height/2)];
    [imageViewChuan setImage:imageChuan];
    [view addSubview:imageViewChuan];
    [imageViewChuan setBackgroundColor:[UIColor redColor]];
    [imageViewChuan release];
    
    int num = [[dict objectForKey:@"starLevel"] integerValue];
    
    WOSStarView *star = [[WOSStarView alloc]initWithFrame:CGRectMake(CGRectGetWidth(imageViewChuan.frame) + CGRectGetMinX(imageViewChuan.frame) + 3, CGRectGetHeight(labelNum.frame) + 5 + 3,100, 30) num:num];
    [star setBackgroundColor:[UIColor clearColor]];
    [view addSubview:star];
    [star release];
    
    
    UILabel *labelPrice = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(star.frame) + CGRectGetMinX(star.frame) + 3,  CGRectGetHeight(labelNum.frame) + 5 + 7 , 100, 15)];
    [labelPrice setText:[NSString stringWithFormat:@"人均：%@",[dict objectForKey:@"pricePU"]]];
    [labelPrice setTextColor:[UIColor colorWithRed:250/255.0f green:250/255.0f blue:250/255.0f alpha:1.0f]];
    [labelPrice setBackgroundColor:[UIColor clearColor]];
    [view addSubview:labelPrice];
    RELEASE(labelPrice);
    
    UILabel *labelAddr = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(imageViewIcon.frame) + CGRectGetMinX(imageViewIcon.frame) + 3 + 2,   CGRectGetMinY(labelPrice.frame) +CGRectGetHeight(labelPrice.frame) + 3 + 2, 100, 15) ];
    [labelAddr setTextColor:[UIColor colorWithRed:250/255.0f green:250/255.0f blue:250/255.0f alpha:1.0f]];
    [labelAddr setBackgroundColor:[UIColor clearColor]];
    [labelAddr setText:[dict objectForKey:@"typeName"]];
    [view addSubview:labelAddr];
    RELEASE(labelAddr);
    
    UIImage *imageT = [UIImage imageNamed:@"jian"];
    UIImageView *imageViewInt = [[UIImageView alloc]initWithFrame:CGRectMake(280.0f + 5, CGRectGetHeight(self.frame) - imageT.size.height/2 -3, imageT.size.width/2, imageT.size.height/2)];
    [imageViewInt setImage:imageT];
//    [view addSubview:imageViewInt];
////    [imageViewInt setBackgroundColor:[UIColor redColor]];
//    RELEASE(imageViewInt);
    [view setBackgroundColor:[UIColor whiteColor]];

    UIImageView *imageFen = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 145/2 - 1, 320.0f, 1)];
    [imageFen setImage:[UIImage imageNamed:@"class_dotline"]];
    [view addSubview:imageFen];
    RELEASE(imageFen);
}


@end
