//
//  charts.m
//  Yiban
//
//  Created by NewM on 12-12-2.
//
//

#import "charts.h"

@implementation charts
@synthesize id,name,pic,rank,totalpoints,weekpoints;

- (void)dealloc
{
//    [id release];
    RELEASE(name);
    RELEASE(pic);
    RELEASE(rank);
    RELEASE(totalpoints);
    RELEASE(weekpoints);
    [super dealloc];
}
@end
