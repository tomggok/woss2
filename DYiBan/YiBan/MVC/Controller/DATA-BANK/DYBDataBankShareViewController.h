//
//  DYBDataBankShareViewController.h
//  DYiBan
//
//  Created by tom zeng on 13-8-9.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseViewController.h"
#import "DYBHttpMethod.h"
#import "DYBDataBankListCell.h"
#import "DYBSideSwipeTableViewCell.h"
#import "DYBDataBankListCell.h"
#import "Magic_UITableView.h"
#import "DYBDtaBankSearchView.h"
#import <AVFoundation/AVFoundation.h>

typedef enum _shareType {
	MEShowToSomeone = 1,              //我共享的
    SomeoneShowToME = 2,           //共享给我的
    Commonality = 3,         //公共资源
} ShowType;

@interface DYBDataBankShareViewController : DYBBaseViewController<AVAudioPlayerDelegate>{


}
@property(nonatomic,retain)UIImage *imageFuzzy;
@property(nonatomic,assign)ShowType showType;
@property(nonatomic,retain)UIButton *goodBtn;
@property(nonatomic,retain)UIButton *badBtn;


AS_SIGNAL(SWITCHDYBAMICBUTTON)
AS_SIGNAL(MENUSELECT)
AS_SIGNAL(CHOOSE)
AS_SIGNAL(SHOWCHOOSE)

@end
