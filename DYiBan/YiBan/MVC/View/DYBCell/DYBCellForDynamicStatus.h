//
//  DYBCellForDynamicStatus.h
//  DYiBan
//
//  Created by Hyde.Xu on 13-8-27.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DYBCellForDynamicStatus : UITableViewCell{
    NSString *_strUserName;
    NSString *_strUserID;
    float fadd;
}

-(void)setContent:(id)data type:(int)type indexPath:(NSIndexPath *)indexPath tbv:(UITableView *)tbv;

@end
