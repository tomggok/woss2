//
//  news_detail.m
//  Yiban
//
//  Created by Hyde.Xu on 12-11-26.
//
//

#import "news_detail.h"

@implementation news_detail
@synthesize news_list;

//+(Class)news_list_class{
//    return NSClassFromString(@"news_data");
//}
- (void)dealloc
{
    RELEASE(news_list);
    [super dealloc];
}
@end
