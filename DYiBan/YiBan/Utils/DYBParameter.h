//
//  DYBParameter.h
//  DYiBan
//
//  Created by NewM on 13-7-31.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
/////////////////////服务器地址
#define    YangfanNei           @"http://10.21.118.32/api/YiBan/index.php"

#define    KaifaNei             @"http://10.21.118.243/api/YiBan/index_dev.php" //测试服1  可用账号:   colog 123456  |397866153@qq.com  111111
#define    KaifaNeiMessage      @"http://10.21.118.243:8089/mobile/index/index" 

#define    KAIFATESTNEI         @"http://10.21.3.30:30080/api/YiBan/index_dev.php" //测试内
#define    KAIFATESTNEIMessage  @"http://10.21.3.30:30081/mobile/index/index" //资料库专用

#define    KAIFATESTWAI         @"http://221.130.201.27:30080/api/YiBan/index_dev.php"//测试外

#define    YufabuNei            @"http://10.21.3.86/api/YiBan/index_dev.php"
#define    YufabuNeiMessage     @"http://10.21.3.86:8089/mobile/index/index"//资料库预发布

#define    YufabuWai            @"http://221.130.201.42/api/YiBan/index_dev.php"
#define    YufabuWaiMessage     @"http://221.130.201.42:8089/mobile/index/index"//资料库预发布

#define    YangfanWai           @"http://112.64.173.226:10080/api/YiBan/index.php"
#define    KaifaWai             @"http://112.64.173.229:30080/api/YiBan/index_dev.php"

#define    Shengchan            @"http://mobile01.yiban.cn/api/YiBan/index.php" //外网地址,上线版本接口
#define    ShengchanMessage     @"http://mobile.yiban.cn/app/disk"//外网资料库
//221.130.201.102

//#define    DenJun               @"http://221.130.201.102/mobile/index/index"
#define    TESTDATABANK         @"http://221.130.201.102:89/api/YiBan/index_dev.php"

#define    WOSLOCALHOST         @"http://118.244.202.47/iphone/"

#undef INTERFACEDOACTION
#define INTERFACEDOACTION   @"interfacedoaction"


/////////////////////方法宏
#undef SHARED
#define SHARED  [DYBShareinstaceDelegate sharedInstace]

#undef APPDELEGATE
#define APPDELEGATE  ((AppDelegate *)[[UIApplication sharedApplication] delegate])

#undef numsOfPage

#define numsOfPage  10  //每页获取几条数据


// DATA BANK

#define ICAN_LEFT     7.5*2
#define ICAN_TOP      6.0*2

#define ICAN_LENGHT   30*2
#define ICAN_WIDTH    30*2

#define LABELDISTANCEICAN 10

#define NUM_TOP            8.5*2
#define NUM_LENGHT         21.5*2
#define NUM_HIGHT          10.0*2
#define DISTANCE_NUM_NAME  5.5*2

#define CELLHIGHT   42.0*2

#define SWIPICAN_HIGHT    52/2
#define SWIPICAN_WIDTH    36/2

#define CELL_BTN_WIDTH    100/2
#define CELL_BTN_HIGHT    134/2

#define NEWCELL_BTN_WIDTH 90/2
#define NEWCELL_BTN_HIGHT 90/2

#define CELLTOUCHIMG_TAG  909

#define BTNTAG_SHARE         901
#define BTNTAG_CHANGE        902
#define BTNTAG_RENAME        903
#define BTNTAG_DOWNLOAD      904
#define BTNTAG_DEL           905
#define BTNTAG_GOOD          906
#define BTNTAG_BAD           907
#define BTNTAG_REPORT        908
#define BTNTAG_CANCELSHARE   909
#define BTNTAG_RESTART       910
#define BTNTAG_ADDFOLDER     911
#define BTNTAG_GOONDOWNLOAD  912  //在2G/3G下继续下载
#define BTNTAG_EDITSHARE     913

#define BTNTAG_SINGLE        914
#define BTNTAG_CHANGESAVE    915
#define BTNTAG_TEXTVIEW    916
#define BTNTAG_TEXTVIEWSINGLE    917

#define REQUESTTAG_FIRIST    1001 //第一次请求网络
#define REQUESTTAG_MORE      1002 //加载更多

#define SEARCHBAT_HIGH       57
#define numsOfPage  10  //每页获取几条数据
#define SYSTEMFOLDER  100

///////////////////字体颜色
#define ColorTextCount [MagicCommentMethod colorWithHex:@"cccccc"]
#define ColorGray [MagicCommentMethod colorWithHex:@"aaaaaa"]
#define ColorBlack [MagicCommentMethod colorWithHex:@"333333"]
#define ColorContentGray [MagicCommentMethod colorWithHex:@"888888"]
#define ColorDivLine [MagicCommentMethod colorWithHex:@"e5e5e5"] //边框色
#define BKGGray [MagicCommentMethod colorWithHex:@"f5f5f5"]  //和[MagicCommentMethod color:248 green:248 blue:248 alpha:1]一样
#define BKGGraylight [MagicCommentMethod colorWithHex:@"fafafa"]
#define ColorBlue [MagicCommentMethod colorWithHex:@"009cd5"]//蓝色
#define ColorGreen [MagicCommentMethod colorWithHex:@"6eab44"]//绿色
#define ColorCellSepL [MagicCommentMethod colorWithHex:@"0xeeeeee"] //Cell的分割线
#define ColorRed [MagicCommentMethod colorWithHex:@"0xde341a"]
#define Colortime [MagicCommentMethod colorWithHex:@"0x999999"] //用于显示时间等
#define ColorWhite [MagicCommentMethod colorWithHex:@"0xffffff"] //白色
#define ColorCheckinFontColor [MagicCommentMethod colorWithHex:@"222222"]
#define ColorSlightGray [MagicCommentMethod colorWithHex:@"0xfafafax"] //最淡的灰色
#define ColorBackgroundGray [MagicCommentMethod colorWithHex:@"f8f8f8"] //最淡的背景色
#define ColorNav [MagicCommentMethod color:248 green:248 blue:248 alpha:1] //导航栏背景色

#define ColorBG [MagicCommentMethod color:36 green:36 blue:36 alpha:1] //view背景色
#define ColorTextYellow [MagicCommentMethod color:226 green:72 blue:49 alpha:1] //view背景色
#define ColorGryWhite [MagicCommentMethod color:191 green:192 blue:191 alpha:1] //字体色

///////////////////动态Cell最大限制数
#define DynamicLimitNum 1000


///////////////////sql的表名
#define kYIBANUSERTABLE             @"yiban_user"//登陆信息
#define kYIBANSTATUSLISTTABLE       @"yiban_statuslist"//动态列表
#define KDATABANKDOWNLIST           @"databank_downloadlist"//资料库下载类表
#define kDATABANKDOWNDETAIL         @"databank_downdetail"//下载资料的详细信息
//#define kDATABANKTABLE              @"databank"
#define kDATABANKOFFLINELISTTABLE   @"offlinelist"
#define kDATABANKCACHE              @"databankcache" //缓存资料库

///////////////////借口定义
#define kSecurityLogout     @"security_logout"//退出帐户
#define kSecurityReg        @"security_reg"//新用户注册
#define kSecurityLogin      @"security_login"//登陆和二维码登陆
#define kSecurityAutologin  @"security_autologin"//自动登陆
#define kStatusList         @"status_list"//动态列表
#define kStatusDel          @"status_del"//删除动态
#define kUserDetail         @"user_detail"//用户详细信息
#define kUserSetting        @"user_setting"//发送token
#define kNoteSetting        @"notes_setting"//笔记设置信息   

#ifndef no_pic_50
#define no_pic_50 @"no_pic_50.png"  //50*50头像的默认图
#endif


#define PICKERPRIVATEFSS        @"好友,同学,校友可见"
#define PICKERPRIVATEAP         @"所有人可见"
#define PICKERPRIVATEOF         @"仅好友可见"
#define PICKERPRIVATEOM         @"仅自己可见"
#define PICKERPRIVATESM         @"显星座"
#define PICKERPRIVATESD         @"显月日"


#ifndef k_NoteListDateBase
#define k_NoteListDateBase @"k_NoteListDateBase"  //所有账号公用的笔记缓存数据表名
#endif

#ifndef k_Note_UserID
#define k_Note_UserID @"k_Note_UserID"  //所有账号公用的笔记缓存数据表里的字段: 用户ID
#endif

#ifndef k_Note_NID
#define k_Note_NID @"k_Note_NID"  //所有账号公用的笔记缓存数据表里的字段: 笔记ID(未点保存就返回上一页的笔记ID固定用 k_Note_EditingNoteName)
#endif

#ifndef k_Note_CreaTime
#define k_Note_CreaTime @"k_Note_CreaTime"  //所有账号公用的笔记缓存数据表里的字段: 笔记创建时间
#endif

#ifndef k_Note_JsonStr
#define k_Note_JsonStr @"k_Note_JsonStr"  //所有账号公用的笔记缓存数据表里的字段: 笔记的json数据
#endif

#ifndef k_Note_isUpdatedToServer
#define k_Note_isUpdatedToServer @"k_Note_isUpdatedToServer"  //所有账号公用的笔记缓存数据表里的字段: 笔记是否已编辑完成并提交到服务器,如果编辑完成并点了保存按钮,但没网,就缓存到本地
#endif

#ifndef k_Note_EditingNoteName
#define k_Note_EditingNoteName @"k_Note_EditingNoteName"  //所有账号公用的笔记缓存数据表里的字段: 正在编辑中的没点保存按钮就返回上一页时的笔记的固定名字,只有最新的一份,注销后清除
#endif

#define USERMODLE   @"usermodle"

