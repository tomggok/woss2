//
//  WOSAddrCell.m
//  DYiBan
//
//  Created by tom zeng on 13-12-24.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "WOSAddrCell.h"

@implementation WOSAddrCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
//        [self creatCell:nil];
        
    }
    return self;
}

-(void)creatCell:(NSDictionary *)dict{
    
    UILabel *labelAddr = [[UILabel alloc]initWithFrame:CGRectMake(5.0f, 5.0f, 300.0f, 30.0f)];
    [labelAddr setText:[dict objectForKey:@"receiverAddress"]];
//    [labelAddr setTextColor:[UIColor yellowColor]];
    [labelAddr setTag:100];
    [labelAddr setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:labelAddr];
    RELEASE(labelAddr)
    
    UILabel *labelName = [[UILabel alloc]initWithFrame:CGRectMake(5.0f, 30 + 5, 200, 20)];
    [labelName setTag:101];
    [labelName setText:[dict objectForKey:@"receiverName"]];
//    [labelName setTextColor:ColorGryWhite];
    [labelName setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:labelName];
    RELEASE(labelName);

//    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, cell.frame.size.height - 1 , 320,1)];
//    UIImage *imageNew = [UIImage imageNamed:@"分割虚线"] ;
//    [imageView setImage:imageNew];
//    [cell addSubview:imageView];
//    RELEASE(imageView);

    
    UIImageView *imageFen = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 110/2-1, 320.0f, 1)];
    [imageFen setImage:[UIImage imageNamed:@"分割虚线"]];
    [self.contentView addSubview:imageFen];
    RELEASE(imageFen);
    
    UIImage *image = [UIImage imageNamed:@"对号1"];
    
    UIButton *btnSelect = [[UIButton alloc]initWithFrame:CGRectMake(240.0f, (110/2 - image.size.height/2)/2, image.size.width/2, image.size.height/2)];
    [btnSelect setImage:image forState:UIControlStateNormal];
    [btnSelect addTarget:self action:@selector(doSelect) forControlEvents:UIControlEventTouchUpInside];
    [btnSelect setHidden:YES];
    [btnSelect setTag:13];
    [self.contentView addSubview:btnSelect];
    RELEASE(btnSelect);
    
}

-(void)doSelect{


}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
