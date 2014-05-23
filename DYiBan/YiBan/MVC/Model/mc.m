//
//  mc.m
//  Magic
//
//  Created by 周 哲 on 12-11-3.
//
//

#import "mc.h"
#import "user.h"
@implementation mc
@synthesize id;
@synthesize title;
@synthesize content;
@synthesize pic;
@synthesize status_id;
@synthesize status_type;
@synthesize time;
@synthesize view;
@synthesize user_info;
@synthesize target;

//+(Class)target_class{
//    return NSClassFromString(@"target");
//}

- (void)dealloc
{
    RELEASE(self.id);
    RELEASE(title);//消息标题
    RELEASE(content);//at内容
    RELEASE(pic);//内容图片
    RELEASE(status_id);//动态id
    RELEASE(status_type);//动态类型
//    RELEASE(time);//消息产生时间
    RELEASE(user_info);//当前登陆用户
    RELEASE(target);
    
    [super dealloc];
}
@end
