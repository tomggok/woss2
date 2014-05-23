//
//  DYBCellForBanner.h
//  DYiBan
//
//  Created by Hyde.Xu on 13-8-20.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DYBCellForBanner : UITableViewCell{
    NSMutableArray *_arrBnerView;
    NSMutableArray *_arrBnerData;
    BOOL bStop;
    NSInteger nCurViewTag;
    
    MagicUIButton *_btnClose;
    
    dispatch_queue_t _bannerQ;
}

-(void)setContent:(id)data indexPath:(NSIndexPath *)indexPath tbv:(UITableView *)tbv;

AS_SIGNAL(CLOSEBUTTON)

@end
