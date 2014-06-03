//
//  WOSShopsListTableViewCell.m
//  WOS
//
//  Created by apple on 14-4-19.
//  Copyright (c) 2014年 ZzL. All rights reserved.
//
#import "WOSStarView.h"
#import "WOSShopsListTableViewCell.h"
#import "UIImageView+WebCache.h"
@implementation WOSShopsListTableViewCell

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

//    UIImageView *imageViewIcon = [[UIImageView alloc]initWithFrame:CGRectMake(10.0f, 10.0f, 50.0f, 50.0f)];
//      NSURL *url = [NSURL URLWithString:[DYBShareinstaceDelegate addIPImage:[dict objectForKey:@"imgUrl"] ]];
//    [imageViewIcon setImageWithURL:url];
//    [imageViewIcon setBackgroundColor:[UIColor redColor]];
//    [self addSubview:imageViewIcon];
//    RELEASE(imageViewIcon);
    
    
    UILabel *imageViewIcon = [[UILabel alloc]initWithFrame:CGRectMake(10.0f, 10.0f, 50.0f, 50.0f)];
    [imageViewIcon setBackgroundColor:[UIColor colorWithRed:255.0f/255 green:91.0f/255 blue:91.0f/255 alpha:1.0f]];
    [imageViewIcon setTextAlignment:NSTextAlignmentCenter];
    [imageViewIcon setTextColor:[UIColor whiteColor]];
    [imageViewIcon.layer setCornerRadius:10.0f];
    [imageViewIcon.layer setBorderWidth:0.0f];
    [imageViewIcon.layer setMasksToBounds:YES];
    
    [imageViewIcon setText:[[dict objectForKey:@"kitchenName"] substringToIndex:1]];
    [self addSubview:imageViewIcon];
    
    UILabel *labelName = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(imageViewIcon.frame) + 10 + CGRectGetWidth(imageViewIcon.frame), 10.0f, 120.0f, 20.0f)];
    [labelName setBackgroundColor:[UIColor clearColor]];
    [labelName setFont:[UIFont systemFontOfSize:16.0f]];
    [labelName setText:[dict objectForKey:@"kitchenName"]];
    [self addSubview:labelName];
    RELEASE(labelName);
    
    
    
  
    
    
    UIImage *imagehui = [UIImage imageNamed:@"优惠小图标"];
    UIImageView *imageViewIndexHui = [[UIImageView alloc]initWithFrame:CGRectMake(370/2,  10, imagehui.size.width/2, imagehui.size.height/2)];
    [imageViewIndexHui setImage:imagehui];
    [imageViewIndexHui setBackgroundColor:[UIColor clearColor]];
//    if ([[dict objectForKey:@"hasDiscount"] boolValue]) {
        [self addSubview:imageViewIndexHui];
        RELEASE(imageViewIndexHui);

//    }
    
     UIImage *imageType = [UIImage imageNamed:@"川菜小图标"];
    UIImageView *imageViewIndexchuan = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(labelName.frame), 20 + 10, imageType.size.width/2, imageType.size.height/2)];
    [imageViewIndexchuan setImage:imageType];
    
    [imageViewIndexchuan setBackgroundColor:[UIColor clearColor]];
    [self addSubview:imageViewIndexchuan];
    RELEASE(imageViewIndexchuan);
    
    WOSStarView *start = [[WOSStarView alloc]initWithFrame:CGRectMake(CGRectGetMinX(imageViewIndexchuan.frame) + CGRectGetWidth(imageViewIndexchuan.frame) + 10, CGRectGetMinY(imageViewIndexchuan.frame), 100.0f, 20.0f) num:[[dict objectForKey:@"starLevel"] intValue]];
    [self addSubview:start];
    RELEASE(start);
    
    
    UILabel *labelNameDistance = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(imageViewIcon.frame) + CGRectGetWidth(imageViewIcon.frame) + 10, 15.0f + CGRectGetMinY(start.frame), 120.0f, 20.0f)];
    double lat = 100;
    double lon = 34;
    NSString *gps = [dict objectForKey:@"gps"];
    NSArray *arrayGPS = [gps componentsSeparatedByString:@","];
    double tt = [DYBShareinstaceDelegate getDsitance_lat_a:lat lng_a:lon lat_b:[[arrayGPS objectAtIndex:0] doubleValue] lng_b:[[arrayGPS objectAtIndex:1] doubleValue]];
    [labelNameDistance setFont:[UIFont systemFontOfSize:12.0f]];
    [labelNameDistance setTextColor:[UIColor colorWithRed:159.0f/255 green:159.0f/255 blue:159.0f/255 alpha:1.0f]];
    [labelNameDistance setText:[NSString stringWithFormat:@"距离我%@",[self getDistance:tt] ]];
    [self addSubview:labelNameDistance];
    RELEASE(labelNameDistance);
      [labelNameDistance setBackgroundColor:[UIColor clearColor]];
    
    UILabel *labelFree = [[UILabel alloc]initWithFrame:CGRectMake(370/2, 15.0f + CGRectGetMinY(start.frame), 120.0f, 20.0f)];
    [labelFree setFont:[UIFont systemFontOfSize:12.0f]];
    [labelFree setTextColor:[UIColor colorWithRed:159.0f/255 green:159.0f/255 blue:159.0f/255 alpha:1.0f]];
    [labelFree setBackgroundColor:[UIColor clearColor]];
    [labelFree setText:[NSString stringWithFormat:@"%@元起送",[dict objectForKey:@"pricePU"]]];
    [self addSubview:labelFree];
    RELEASE(labelFree);
    
}

-(NSString *)getDistance:(double)distance{

    double distance1 = 0;
    if (distance > 1000) {
        distance1 = distance/1000;
        return [NSString stringWithFormat:@"%.2fKM",distance1];
    }else{
    
        return [NSString stringWithFormat:@"%.2f",distance];
    }

}

@end
