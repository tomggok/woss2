//
//  DYBCellForSchoolList.h
//  DYiBan
//
//  Created by Song on 13-9-3.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DYBCellForSchoolList : UITableViewCell
{
    MagicUILabel *_lb_newContent;
    MagicUIImageView *_imgV_sepline/*分割线*/,*_imgV_star/**/;
}
@property(retain,nonatomic)MagicUIImageView *_imgV_star;
-(void)setContent:(id)data indexPath:(NSIndexPath *)indexPath tbv:(UITableView *)tbv;
@end
