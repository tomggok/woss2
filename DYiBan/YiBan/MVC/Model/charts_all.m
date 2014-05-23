//
//  charts_all.m
//  Yiban
//
//  Created by NewM on 12-12-2.
//
//

#import "charts_all.h"

@implementation charts_all
@synthesize chartstype,charts,havenext,title;

- (void)dealloc
{
    RELEASE(charts);
    RELEASE(chartstype);
    RELEASE(havenext);
    RELEASE(title);
    [super dealloc];
}
//+ (Class)charts_class{
//    return NSClassFromString(@"charts");
//}
@end
