//
//  news.m
//  Yiban
//
//  Created by Hyde.Xu on 12-11-26.
//
//

#import "news.h"

@implementation news
@synthesize author;
@synthesize category;
@synthesize category_id;
@synthesize content;
@synthesize from;
@synthesize hits;
@synthesize id;
@synthesize pics;
@synthesize thumb;
@synthesize time;
@synthesize title;

//+(Class)pics_class{
//    return NSClassFromString(@"pics");
//}
- (void)dealloc
{
    RELEASE(category);
    RELEASE(category_id);
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
