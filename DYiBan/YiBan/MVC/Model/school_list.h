//
//  school_list.h
//  Yiban
//
//  Created by NewM on 12-12-10.
//
//

//#import "Jastor.h"

@interface school_list : MagicJSONReflection
@property (nonatomic, retain)NSString *cert_key;
@property (nonatomic, retain)NSString *cert_name;
@property (nonatomic, retain)NSString *hasData;
@property (nonatomic, retain)NSString *id;
@property (nonatomic, retain)NSString *name;
@property (nonatomic, retain)NSArray *eclasses;

//+ (Class)eclasses_class;
@end
