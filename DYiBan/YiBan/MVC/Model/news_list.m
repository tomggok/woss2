//
//  news_data.m
//  Yiban
//
//  Created by Hyde.Xu on 12-11-26.
//
//

#import "news_list.h"

@implementation news_list
@synthesize category;
@synthesize category_id;
@synthesize havemore;
@synthesize havenext;
@synthesize news_list;

@synthesize author;
@synthesize content;
@synthesize from;
@synthesize hits;
@synthesize id;
@synthesize pics;
@synthesize thumb;
@synthesize time;
@synthesize title;

//+(Class)news_list_class{
//    return NSClassFromString(@"news");
//}

- (void)dealloc
{
    
    RELEASE(category);
    RELEASE(category_id);
    RELEASE(havemore);
    RELEASE(news_list);
    RELEASE(havenext);
    RELEASE(author);
    RELEASE(content);
    RELEASE(from);
    RELEASE(hits);
    RELEASE(pics);
    RELEASE(thumb);
    RELEASE(time);
    RELEASE(title);
   
    [super dealloc];
}

@end
