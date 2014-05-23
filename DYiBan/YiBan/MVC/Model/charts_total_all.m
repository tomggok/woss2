//
//  charts_total_all.m
//  Yiban
//
//  Created by NewM on 12-12-3.
//
//

#import "charts_total_all.h"

@implementation charts_total_all
@synthesize charts_list;

//+ (Class)charts_list_class{
//    return NSClassFromString(@"charts_list");
//}

- (void)dealloc
{
    RELEASE(charts_list);
    [super dealloc];
}
@end
