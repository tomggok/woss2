//
//  sign_user.h
//  Yiban
//
//  Created by Hyde.Xu on 12-11-29.
//
//

//#import "Jastor.h"
#import "sign_user.h"

@interface sign_user : MagicJSONReflection

@property (retain, nonatomic) NSString *desc;
@property (retain, nonatomic) NSString *fullname;
@property (retain, nonatomic) NSString *is_vip;
@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) NSString *pic;
@property (retain, nonatomic) NSString *pic_b;
@property (retain, nonatomic) NSString *sex;
@property (retain, nonatomic) NSString *truename;
@property (retain, nonatomic) NSString *userid;
@property (retain, nonatomic) NSString *usertype;
@property (retain, nonatomic) NSString *verify;
@property (retain, nonatomic) sign_user *user;

@end
