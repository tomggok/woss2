//
//  charts_list.m
//  Yiban
//
//  Created by NewM on 12-12-3.
//
//

#import "charts_list.h"

@implementation charts_list
@synthesize charts,chartstype,title;

//+ (Class)charts_class{
//    return NSClassFromString(@"charts");
//}

- (void)dealloc
{
    RELEASE(chartstype);
    RELEASE(title);
    RELEASE(charts);
    [super dealloc];
}

@end
