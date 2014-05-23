//
//  status_user_list.h
//  Yiban
//
//  Created by Hyde.Xu on 13-4-17.
//
//

#import <Foundation/Foundation.h>

@interface action_list : MagicJSONReflection
@property (nonatomic, retain) NSString *desc; //用户心情
@property (nonatomic, retain) NSString *fullname;
@property (nonatomic, retain) NSString *is_vip;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *pic;
@property (nonatomic, retain) NSString *pic_b;
@property (nonatomic, retain) NSString *pic_s;
@property (nonatomic, retain) NSString *sex;
@property (nonatomic, retain) NSString *time;
@property (nonatomic, retain) NSString *truename;
@property (nonatomic, retain) NSString *userid;
@property (nonatomic, retain) NSString *usertype;
@property (nonatomic, retain) NSString *verify;

@end
