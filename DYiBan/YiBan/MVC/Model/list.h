//
//  YiBanApp.h
//  Yiban
//
//  Created by Hyde.Xu on 13-1-7.
//
//

//#import "Jastor.h"

@interface list : MagicJSONReflection

@property (nonatomic, retain)NSString *store_url;
@property (nonatomic, retain)NSString *schemes_url;
@property (nonatomic, retain)NSString *name;
@property (nonatomic, retain)NSString *app_icon;
@property (nonatomic, assign)NSInteger tip_type;
@property (nonatomic, assign)NSInteger app_type;
@property (nonatomic, assign)NSInteger app_category;
@property (nonatomic, assign)NSInteger installed_count;

@end
