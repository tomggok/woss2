//
//  SideSwipeViewController.h
//  Yiban
//
//  Created by Hyde.Xu on 13-2-27.
//
//

#import <UIKit/UIKit.h>
#import "DYBBaseViewController.h"
typedef enum _showOperationType {
	allOperationsType = 0,              //5个按钮都有
    onlyDELOperationType = 1,           //只有删除按钮
    onlyShareOperationType = 2,         //只有分享按钮
    shareANDDELOpeartionType = 3,       //分享和删除
    goodANDbelittleOperationType = 4    //赞和踩
} ShowOperationType;

@interface DYBSideSwipeViewController : DYBBaseViewController
{
    BOOL animatingSideSwipe;
    UIView* sideSwipeView;
    UISwipeGestureRecognizerDirection sideSwipeDirection;
    UITableView *_tableview;
    UITableViewCell* sideSwipeCell;
    ShowOperationType type;

}
AS_SIGNAL(TOUCHBTN) //发送信息到别的对象的信号
AS_SIGNAL(OPEARTION) //点击btn 事件
@property (nonatomic) BOOL animatingSideSwipe;
@property (nonatomic, retain) UIView* sideSwipeView;
@property (nonatomic) UISwipeGestureRecognizerDirection sideSwipeDirection;
@property (nonatomic, retain) UITableView *_tableview;
@property (nonatomic, retain) UITableViewCell* sideSwipeCell;
@property (nonatomic,retain)NSObject *sender;
@property (nonatomic,assign)ShowOperationType type;

- (void)initSwipeView:(UITableView *)tableview;
- (void) removeSideSwipeView:(BOOL)animated;

@end
