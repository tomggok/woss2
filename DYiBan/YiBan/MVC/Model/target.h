//
//  target.h
//  Magic
//
//  Created by tom zeng on 12-11-10.
//
//

#import <Foundation/Foundation.h>

@interface target : MagicJSONReflection
@property(nonatomic,retain)NSString* type;//替换类型 0 httpurl 1 user 2 班级
@property(nonatomic,retain)NSString* targetid;//替换类型id，如果是user就是userid
@property(nonatomic,retain)NSString*  targetlink;// 链接地址
@property(nonatomic,retain)NSString*  targetname;// 替换资源，如人名
@property(nonatomic,retain)NSString* id;//匹配替换内容的对应id
@end
