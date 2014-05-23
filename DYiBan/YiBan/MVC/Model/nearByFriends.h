//
//  nearByFriends.h
//  Yiban
//
//  Created by zhangchao on 13-4-7.
//
//

#import <Foundation/Foundation.h>

    //附近的人数据模型
@interface nearByFriends : MagicJSONReflection

@property (copy, nonatomic) NSString *distance;
@property (copy, nonatomic) NSString *lng;
@property (copy, nonatomic) NSString *lat;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *pic;
@property (copy, nonatomic) NSString *userid;
@property (copy, nonatomic) NSString *usertype,*address,*time/*时间是用户点击附近的人的时候获取到自己地理位置的时间 与 附近开启过地理位置共享的人开启的那个时间的时间差
*/,*sign_time,*truename;

@end
