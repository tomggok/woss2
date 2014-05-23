//
//  CheckVersionModel
//  Yiban
//
//  Created by NewM on 12-11-20.
//
//

#import "CheckVersionModel.h"

@implementation CheckVersionModel
@synthesize version,status;

- (void)dealloc
{
//    RELEASE(version);
    RELEASE(version);
    RELEASE(status);
    [super dealloc];
}
@end
