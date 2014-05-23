//
//  recommendfriend.h
//  Yiban
//
//  Created by Hyde.Xu on 12-11-25.
//
//

//#import "Jastor.h"

    //可能认识的人数据模型
@interface recommendfriend : MagicJSONReflection

@property (retain, nonatomic) NSString *canfriend;
@property (retain, nonatomic) NSString *distance;
@property (retain, nonatomic) NSString *id;
@property (retain, nonatomic) NSString *is_vip;
@property (retain, nonatomic) NSString *isfollow;
@property (retain, nonatomic) NSString *isfriend;
@property (retain, nonatomic) NSString *lng;
@property (retain, nonatomic) NSString *lat;
@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) NSString *pic;
@property (retain, nonatomic) NSString *pic_b;
@property (retain, nonatomic) NSString *sex;
@property (retain, nonatomic) NSString *truename;
@property (retain, nonatomic) NSString *fullname;
@property (retain, nonatomic) NSString *relation_desc;
@property (retain, nonatomic) NSString *user_college;
@property (retain, nonatomic) NSString *user_schoolid;
@property (retain, nonatomic) NSString *user_schoolname;
@property (retain, nonatomic) NSString *userid;
@property (retain, nonatomic) NSString *usertype;

@end
