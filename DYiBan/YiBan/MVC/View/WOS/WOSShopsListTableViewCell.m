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

    UIImageView *imageViewIcon = [[UIImageView alloc]initWithFrame:CGRectMake(10.0f, 10.0f, 30.0f, 30.0f)];
      NSURL *url = [NSURL URLWithString:[DYBShareinstaceDelegate addIPImage:[dict objectForKey:@"imgUrl"] ]];
    [imageViewIcon setImageWithURL:url];
//    [imageViewIcon setBackgroundColor:[UIColor redColor]];
    [self addSubview:imageViewIcon];
    RELEASE(imageViewIcon);
    
    UILabel *labelName = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(imageViewIcon.frame) + 10 + CGRectGetWidth(imageViewIcon.frame), 10.0f, 150.0f, 20.0f)];
    
    [labelName setText:[dict objectForKey:@"kitchenName"]];
    [self addSubview:labelName];
    RELEASE(labelName);
    
    
    UIImageView *imageViewIndexHui = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(labelName.frame)+ CGRectGetWidth(labelName.frame),  10, 20.0f, 20.0f)];
    [imageViewIndexHui setBackgroundColor:[UIColor redColor]];
//      NSURL *url = [NSURL URLWithString:[DYBShareinstaceDelegate addIPImage:[dict objectForKey:@"imgUrl"]]];
//    [imageViewIndexHui setImageWithURL:url];
    [self addSubview:imageViewIndexHui];
    RELEASE(imageViewIndexHui);
    
    UIImageView *imageViewIndexchuan = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(labelName.frame), 20 + 10, 20.0f, 20.0f)];
    [imageViewIndexchuan setBackgroundColor:[UIColor redColor]];
    [self addSubview:imageViewIndexchuan];
    RELEASE(imageViewIndexchuan);
    
    WOSStarView *start = [[WOSStarView alloc]initWithFrame:CGRectMake(CGRectGetMinX(imageViewIndexchuan.frame) + 10, CGRectGetMinY(imageViewIndexchuan.frame), 100.0f, 20.0f) num:[[dict objectForKey:@"starLevel"] intValue]];
    [self addSubview:start];
    RELEASE(start);
    
    
    UILabel *labelNameDistance = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(imageViewIcon.frame) + 10, 10.0f + CGRectGetMinY(start.frame), 150.0f, 20.0f)];
    double lat = 100;
    double lon = 34;
    NSString *gps = [dict objectForKey:@"gps"];
    NSArray *arrayGPS = [gps componentsSeparatedByString:@","];
    double tt = [DYBShareinstaceDelegate getDsitance_lat_a:lat lng_a:lon lat_b:[[arrayGPS objectAtIndex:0] doubleValue] lng_b:[[arrayGPS objectAtIndex:1] doubleValue]];
    
    [labelNameDistance setText:[NSString stringWithFormat:@"距离我%@",[self getDistance:tt] ]];
    [self addSubview:labelNameDistance];
    RELEASE(labelNameDistance);
    
    
    UILabel *labelFree = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(labelNameDistance.frame) + 10 +CGRectGetWidth(labelNameDistance.frame), 10.0f + CGRectGetMinY(start.frame), 150.0f, 20.0f)];
    
    [labelFree setText:[NSString stringWithFormat:@"%@",[dict objectForKey:@"pricePU"]]];
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
