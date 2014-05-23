//
//  DYBDataBankSelectBtn.h
//  DYiBan
//
//  Created by tom zeng on 13-9-2.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <Foundation/Foundation.h>

//typedef enum _showOperationType {
//	allOperationsType = 0,              //5个按钮都有
//    onlyDELOperationType = 1,           //只有删除按钮
//    onlyShareOperationType = 2,         //只有分享按钮
//    shareANDDELOpeartionType = 3,       //分享和删除
//    goodANDbelittleOperationType = 4    //赞和踩
//} ShowOperationType;

@interface DYBDataBankSelectBtn : UIView{


// ShowOperationType showType;

}
@property (nonatomic,assign) int showType;
@property (nonatomic,retain) UITableViewCell *targetCell;
@property (nonatomic,assign) id sendMegTarget;
@property (nonatomic,retain) NSIndexPath *touchCellIndexPath;
@property (nonatomic,assign) BOOL bFolder;
@property (nonatomic,assign) BOOL bUserSelfFile; //是不是用户自己的文件 是，不能转存
@property (nonatomic,assign) BOOL beginOrPause;//暂停或开始 为了DYBDataBankSelectBtn* btnBottom（ begin:YES pause:NO）

-(UITableViewCell *)addBtnToCell:(UIView *)view type:(int)type;

-(id)initTarget:(id)target index:(NSIndexPath *)index;
AS_SIGNAL(TOUCHBTN)
AS_SIGNAL(TOUCHSIGLEBTN)

//重新设置bt的object
- (void)resetBtRow;
@end
