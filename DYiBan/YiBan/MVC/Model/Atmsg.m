//
//  Atmsg.m
//  Magic
//
//  Created by 周 哲 on 12-11-3.
//
//

#import "Atmsg.h"

@implementation Atmsg
@synthesize havenext;
@synthesize newcount;
@synthesize ma;
//+(Class)ma_class{
//    return NSClassFromString(@"ma");
//}
- (void)dealloc
{
    RELEASE(ma);
    [super dealloc];
}
@end
