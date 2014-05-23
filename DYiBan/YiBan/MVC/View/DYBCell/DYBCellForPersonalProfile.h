//
//  DYBCellForPersonalProfile.h
//  DYiBan
//
//  Created by zhangchao on 13-9-8.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYBCustomLabel.h"
#import "DYBInputView.h"
//个人资料cell
@interface DYBCellForPersonalProfile : UITableViewCell
{
    MagicUIImageView *_imgV_icon;
    DYBCustomLabel *_lbTitle,*_lb_content;
    UIView *_vBack;
    MagicUIButton *_btIcon;
    MagicUITextField *_nameInput;
}

-(void)setContent:(id)data indexPath:(NSIndexPath *)indexPath tbv:(UITableView *)tbv;
@end
