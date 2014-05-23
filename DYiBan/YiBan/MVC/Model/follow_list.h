//
//  follow_list.h
//  Yiban
//
//  Created by Hyde.Xu on 13-4-18.
//
//

#import <Foundation/Foundation.h>
#import "user.h"

@interface follow_list : MagicJSONReflection
@property (nonatomic, retain) NSString *id;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *content;
@property (nonatomic, retain) NSString *from;
@property (nonatomic, retain) NSString *time;
@property (nonatomic, retain) user *user;
@property (nonatomic, retain) NSArray *target;
@end
