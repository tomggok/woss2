//
//  DYBCellForDynamic.h
//  DYiBan
//
//  Created by Hyde.Xu on 13-8-13.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "status.h"

@interface DYBCellForDynamic : UITableViewCell{
    status *_dynamicStatus;
    MagicUIImageView *_viewQuick;
    
    MagicUILabel *_lbLikeCount;
    MagicUILabel *_lbLiker;
    MagicUIButton *_btnQuick;
    MagicUIButton *_btnQuickLike;
    MagicUIButton *_btnQuickCommment;
    NSInteger _nRow;
}

-(void)setContent:(id)data indexPath:(NSIndexPath *)indexPath tbv:(UITableView *)tbv;

AS_SIGNAL(QUICKFUNCTION)
AS_SIGNAL(QUICKLIKE)
AS_SIGNAL(QUICKCOMMENT)

@end
