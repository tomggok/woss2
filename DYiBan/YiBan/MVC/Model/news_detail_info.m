//
//  news_detail_info.m
//  Yiban
//
//  Created by Hyde.Xu on 12-11-28.
//
//

#import "news_detail_info.h"

@implementation news_detail_info
@synthesize news;

- (void)dealloc
{
    RELEASE(news);
    [super dealloc];
}
@end
