//
//  DYBCellForSendPrivateLetter.h
//  DYiBan
//
//  Created by zhangchao on 13-9-2.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYBCustomLabel.h"

//发私信页的cell
@interface DYBCellForSendPrivateLetter : UITableViewCell
{
    DYBCustomLabel *_lb_content,*_lb_time,*_lb_adress;
    UIView *_v_Contentback/*主要内容背景*/;
    MagicUIImageView *_imgV_showImg,*_imagV_fail,*_imgV_ArrowR,*_imgV_ArrowL;
}

@property(nonatomic,retain)MagicUIImageView *_imgV_showImg,*_imagV_fail;
@property(nonatomic,retain)DYBCustomLabel *_lb_content,*_lb_time,*_lb_adress;
@property(nonatomic, retain) NSArray* matches;

-(void)setContent:(id)data indexPath:(NSIndexPath *)indexPath tbv:(UITableView *)tbv;


@end
