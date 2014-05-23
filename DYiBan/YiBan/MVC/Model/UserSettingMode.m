//
//  UserSettingMode.m
//  Yiban
//
//  Created by NewM on 12-11-20.
//
//

#import "UserSettingMode.h"
#import "user.h"

@implementation UserSettingMode
@synthesize userId=_userId,upSendImgType=_upSendImgType,userPersonPageBg=_userPersonPageBg;
@synthesize addMePush=_addMePush,atMePush=_atMePush,evaluatePush=_evaluatePush,privateMessagePush=_privateMessagePush,teacherPush=_teacherPush,timeForNoPush=_timeForNoPush;
@synthesize sound = _sound,shake = _shake,jobPush=_jobPush;;
@synthesize userName=_userName,passWord=_passWord,isRememberPass=_isRememberPass;
@synthesize addFriendMessageTime = _addFriendMessageTime,updateUserDetailTime = _updateUserDetailTime,dataBasePush = _dataBasePush, wifiForPush = _wifiForPush,notesWifiForPush = _notesWifiForPush,notesSaveForPush = _notesSaveForPush;
- (id)init:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.userId = SHARED.curUser.userid;
        self.upSendImgType = [[dict objectForKey:@"upSendImgType"] description];
        self.userPersonPageBg = [[dict objectForKey:@"userPersonPageBg"] description];
        
        self.timeForNoPush = [[dict objectForKey:@"timeForNoPush"] boolValue];
        self.teacherPush = [[dict objectForKey:@"teacherPush"] boolValue];
        self.privateMessagePush = [[dict objectForKey:@"privateMessagePush"] boolValue];
        self.evaluatePush = [[dict objectForKey:@"evaluatePush"] boolValue];
        self.atMePush = [[dict objectForKey:@"atMePush"] boolValue];
        self.addMePush = [[dict objectForKey:@"addMePush"] boolValue];
        
        self.dataBasePush = [[dict objectForKey:@"dataBasePush"] boolValue];
        self.wifiForPush = [[dict objectForKey:@"wifiForPush"] boolValue];
        
        self.notesWifiForPush = [[dict objectForKey:@"notesWifiForPush"] boolValue];
        self.notesSaveForPush = [[dict objectForKey:@"notesSaveForPush"] boolValue];
        
        self.sound = [[dict objectForKey:@"sound"] boolValue];
        self.shake = [[dict objectForKey:@"shake"] boolValue];
        
        self.userName = [dict objectForKey:@"username"];
        self.passWord = [dict objectForKey:@"password"];
        self.isRememberPass = [[dict objectForKey:@"rememberPwd"] boolValue];
        
        self.addFriendMessageTime = [[dict objectForKey:@"addFriendMessageTime"] description];
        self.updateUserDetailTime = [[dict objectForKey:@"updateUserDetailTime"] description];
        
    }
    return self;
}

- (NSMutableDictionary *)dict{
    NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
    [dict setValue:_userId forKey:@"userId"];
    [dict setValue:_upSendImgType forKey:@"upSendImgType"];
    [dict setValue:_userPersonPageBg forKey:@"userPersonPageBg"];
    
    [dict setValue:[NSString stringWithFormat:@"%d",_addMePush] forKey:@"addMePush"];
    [dict setValue:[NSString stringWithFormat:@"%d",_atMePush] forKey:@"atMePush"];
    [dict setValue:[NSString stringWithFormat:@"%d",_evaluatePush] forKey:@"evaluatePush"];
    [dict setValue:[NSString stringWithFormat:@"%d",_privateMessagePush] forKey:@"privateMessagePush"];
    [dict setValue:[NSString stringWithFormat:@"%d",_teacherPush] forKey:@"teacherPush"];
    [dict setValue:[NSString stringWithFormat:@"%d",_timeForNoPush] forKey:@"timeForNoPush"];
    [dict setValue:[NSString stringWithFormat:@"%d",_dataBasePush] forKey:@"dataBasePush"];
    [dict setValue:[NSString stringWithFormat:@"%d",_wifiForPush] forKey:@"wifiForPush"];
    [dict setValue:[NSString stringWithFormat:@"%d",_notesWifiForPush] forKey:@"notesWifiForPush"];
    [dict setValue:[NSString stringWithFormat:@"%d",_notesSaveForPush] forKey:@"notesSaveForPush"];

    [dict setValue:[NSString stringWithFormat:@"%d",_sound] forKey:@"sound"];
    [dict setValue:[NSString stringWithFormat:@"%d",_shake] forKey:@"shake"];
    
    [dict setValue:_userName forKey:@"username"];
    [dict setValue:_passWord forKey:@"password"];
    [dict setValue:[NSString stringWithFormat:@"%d",_isRememberPass] forKey:@"rememberPwd"];
    
    [dict setValue:_addFriendMessageTime forKey:@"addFriendMessageTime"];
    [dict setValue:_updateUserDetailTime forKey:@"updateUserDetailTime"];
    [dict setValue:[NSString stringWithFormat:@"%d",_jobPush] forKey:@"jobPush"];
    
    return dict;
    
}

- (void)dealloc
{
    RELEASE(_userPersonPageBg);
    RELEASE(_userId);
    RELEASE(_upSendImgType);
    RELEASE(_userName);
    RELEASE(_passWord);
    RELEASE(_updateUserDetailTime);
    RELEASE(_addFriendMessageTime);
    [super dealloc];
}
@end
