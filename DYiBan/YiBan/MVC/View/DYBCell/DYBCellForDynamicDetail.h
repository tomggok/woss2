//
//  DYBCellForDynamicDetail.h
//  DYiBan
//
//  Created by Hyde.Xu on 13-8-23.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "status.h"

@interface DYBCellForDynamicDetail : UITableViewCell{
    status *_dynamicStatus;
}

-(void)setContent:(id)data indexPath:(NSIndexPath *)indexPath tbv:(UITableView *)tbv;

@property (nonatomic, retain) NSString *strContent;

@end
