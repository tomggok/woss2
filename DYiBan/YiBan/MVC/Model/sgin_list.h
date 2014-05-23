//
//  sign_list.h
//  Yiban
//
//  Created by Hyde.Xu on 12-11-29.
//
//

//#import "Jastor.h"
#import "sign_user.h"

@interface sgin_list : MagicJSONReflection

@property(nonatomic, retain) NSString *address;
@property(nonatomic, retain) NSString *from;
@property(nonatomic, retain) NSString *id;
@property(nonatomic, retain) NSString *lat;
@property(nonatomic, retain) NSString *lng;
@property(nonatomic, retain) NSString *time;
@property(nonatomic, retain) sign_user *user;

//+(Class)sgin_list_class;

@end
