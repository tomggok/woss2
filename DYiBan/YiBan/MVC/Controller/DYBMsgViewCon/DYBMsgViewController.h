//
//  SYBMsgViewController.h
//  DYiBan
//
//  Created by zhangchao on 13-8-7.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseViewController.h"
#import "msg_count.h"
#import "DYBUnreadMsgView.h"

//消息页
@interface DYBMsgViewController : DYBBaseViewController
{
    MagicUIButton *_bt_sendPrivateLetter/*发私信*/,*_bt_sendNotice/*发通知*/,*_bt_notice,*_bt_MentionedMe/*提到我的*/,*_bt_CommentMe/*评论我的*/,*_bt_systemMsg/*系统消息*/;
//    MagicUITableView *_tbv;//
    msg_count *_model_message_count/*用户新信息数接口的数据模型*/;
//    NSMutableArray *_muA_privateLetterList/*私信列表*/;
//    BOOL _b_couldReload;//2个接口有一个回调后变成yes,下拉刷新时同时请求2个接口,变成no
    UIView *_v_fourbtBack/*4个按钮的背景view*/;
    DYBUnreadMsgView *_v_Notice/*未读通知提示*/,*_v_MentionedMe/*未读提到我的提示*/,*_v_CommentMe/*未读评论我的提示*/,*_v_systemMsg/*未读系统信息提示*/;
    int _i_totalNumOfUnreadMsg/*未读信息总数*/;
}

//@property (nonatomic,retain) DYBUnreadMsgView *v_totalNumOfUnreadMsg/*未读信息总数视图*/;

-(void)countTotalNumOfUnreadMsg;
-(void)initTotalNumOfUnreadMsgRequest;

@end
