//
//  eclass.m
//  Yiban
//
//  Created by Hyde.Xu on 13-2-18.
//
//

#import "eclass.h"

@implementation eclass
@synthesize userid;
@synthesize name;
@synthesize active;
@synthesize id,pic,college,year;


- (void)dealloc
{
    RELEASE(userid);
    RELEASE(name);
    RELEASE(active);
    RELEASE(pic);
    RELEASE(year);
    RELEASE(college);
    RELEASE(self.id);

    [super dealloc];
}
@end
