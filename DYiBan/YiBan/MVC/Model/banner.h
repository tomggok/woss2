//
//  bannerMode.h
//  Yiban
//
//  Created by tom zeng on 13-1-14.
//
//

//#import "Jastor.h"

@interface banner : MagicJSONReflection
@property(retain,nonatomic)NSString* type;
@property(assign,nonatomic)int id;
@property(retain,nonatomic)NSString* title;
@property(retain,nonatomic)NSString* target_id;
@property(retain,nonatomic)NSString* target_type;
@property(retain,nonatomic)NSString* url;
@property(retain,nonatomic)NSString* banner_img;
@property(retain,nonatomic)NSString* end_time;
@end
