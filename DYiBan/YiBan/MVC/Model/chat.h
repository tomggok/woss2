//
//  chat.h
//  Magic
//
//  Created by 周 哲 on 12-11-6.
//
//

#import <Foundation/Foundation.h>
#import "user.h"
#import "ext.h"
#import "target.h"

//#import "Jastor.h"
@interface chat : MagicJSONReflection
@property(retain,nonatomic)NSString * id;
@property(retain,nonatomic)NSString * content;//消息内容
@property(assign,nonatomic)int time;//消息产生时间
@property(retain,nonatomic)NSString * status_id;//当TYPE为2时返回，辅导员通知动态id
@property(retain,nonatomic)NSString * status_type;// 当TYPE为2时返回，辅导员通知动态id类型
@property(retain,nonatomic)user * user_info;//发消息人数据结构
@property(assign,nonatomic)int view; //是否阅读 0 未读
@property(retain,nonatomic)ext *ext;
@property(retain,nonatomic)NSString *str_time;//自己创建此model时得不到int类型时间,只能创建一个str类型时间
@property(retain,nonatomic)UIImage *photoImage;//图片
@property(assign,nonatomic)int  indexRow;//当前行数
@property(assign,nonatomic)int  SucessSend;//发送是否成功 0:no 1:yes
@property(assign,nonatomic)target *target;//是否是网址

@end
