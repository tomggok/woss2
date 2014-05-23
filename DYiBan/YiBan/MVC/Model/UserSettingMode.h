//
//  UserSettingMode.h
//  Yiban
//
//  Created by NewM on 12-11-20.
//
//

#import <Foundation/Foundation.h>
//#import "Jastor.h"
@interface UserSettingMode : MagicJSONReflection

@property (nonatomic, retain)NSString *userId;//userId
@property (nonatomic, retain)NSString *upSendImgType;//上传图片的质量
@property (nonatomic, retain)NSString *userPersonPageBg;//个人主页背景图片
@property (nonatomic, assign)BOOL teacherPush;//辅导员推送
@property (nonatomic, assign)BOOL evaluatePush;//评价推送
@property (nonatomic, assign)BOOL privateMessagePush;//私信推送
@property (nonatomic, assign)BOOL atMePush;//@我时推送
@property (nonatomic, assign)BOOL addMePush;//加我为好友推送
@property (nonatomic, assign)BOOL timeForNoPush;//免打扰时段开启
@property (nonatomic, assign)BOOL sound;//声音
@property (nonatomic, assign)BOOL shake;//震动
@property (nonatomic, assign)BOOL jobPush;//就业信息
@property (nonatomic, assign)BOOL dataBasePush;//资料库推送
@property (nonatomic, assign)BOOL wifiForPush;//仅再wifi下同步上传下载
@property (nonatomic, retain)NSString *userName;//用户
@property (nonatomic, retain)NSString *passWord;//密码
@property (nonatomic, assign)BOOL isRememberPass;//是否记住密码
@property (nonatomic, assign)BOOL notesWifiForPush;//笔记wifi
@property (nonatomic, assign)BOOL notesSaveForPush;//笔记转存
@property (nonatomic, retain)NSString *updateUserDetailTime;//获得当前用户个人资料的时间（yyyy－MM－dd hh：ss：mm）
@property (nonatomic, retain)NSString *addFriendMessageTime;//获得好友动态的时间（yyyy－MM－dd hh：ss：mm）
- (id)init:(NSDictionary *)dict;
- (NSMutableDictionary *)dict;
@end
