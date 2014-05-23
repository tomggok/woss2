//
//  news_data.h
//  Yiban
//
//  Created by Hyde.Xu on 12-11-26.
//
//

//#import "Jastor.h"

@interface news_list : MagicJSONReflection

@property(nonatomic, retain)NSString* category;
@property(nonatomic, retain)NSString* category_id;
@property(nonatomic, retain)NSString* havemore;
@property(nonatomic, retain)NSString* havenext;
@property(nonatomic, retain)NSArray*  news_list;

@property(nonatomic, retain)NSString* author;
@property(nonatomic, retain)NSString* content;
@property(nonatomic, retain)NSString* from;
@property(nonatomic, retain)NSString* hits;
@property(nonatomic, retain)NSString* id;
@property(nonatomic, retain)NSArray* pics;
@property(nonatomic, retain)NSString* thumb;
@property(nonatomic, retain)NSString* time;
@property(nonatomic, retain)NSString* title;

//+(Class)news_list_class;

@end
