//
//  UserLoginModel.m
//  Yiban
//
//  Created by NewM on 12-12-10.
//
//

#import "UserLoginModel.h"

@implementation UserLoginModel
@synthesize autoLogin,userId,sessID,lastTime,userName;

- (void)dealloc
{
    RELEASE(lastTime);
    RELEASE(autoLogin);
    RELEASE(userId);
    RELEASE(sessID);
    [super dealloc];
}

- (id)initDict:(NSMutableDictionary *)dict
{
    self = [super init];
    if (self) {
        self.sessID = [dict objectForKey:@"sessID"];
        self.userId = [dict objectForKey:@"userid"];
        self.userName = [dict objectForKey:@"username"];
        self.autoLogin = [dict objectForKey:@"autoLogin"];
        self.lastTime = [dict objectForKey:@"lasttime"];
    }
    return self;
}

- (NSMutableDictionary *)retunDict{
    NSMutableDictionary *dict = [[[NSMutableDictionary alloc] initWithCapacity:5] autorelease];
    [dict setValue:userId forKey:@"userid"];
    [dict setValue:sessID forKey:@"sessID"];
    [dict setValue:userName forKey:@"username"];
    [dict setValue:autoLogin forKey:@"autoLogin"];
    [dict setValue:lastTime forKey:@"lasttime"];
    
    return dict;

}
@end
