//
//  news.h
//  Yiban
//
//  Created by Hyde.Xu on 12-11-26.
//
//

//#import "Jastor.h"

@interface news : MagicJSONReflection

@property(nonatomic, retain)NSString* author;
@property(nonatomic, retain)NSString* category;
@property(nonatomic, retain)NSString* category_id;
@property(nonatomic, retain)NSString* content;
@property(nonatomic, retain)NSString* from;
@property(nonatomic, retain)NSString* hits;
@property(nonatomic, retain)NSString* id;
@property(nonatomic, retain)NSArray* pics;
@property(nonatomic, retain)NSString* thumb;
@property(nonatomic, retain)NSString* time;
@property(nonatomic, retain)NSString* title;

//+(Class)pics_class;

@end
