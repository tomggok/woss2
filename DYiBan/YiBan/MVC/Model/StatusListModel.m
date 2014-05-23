//
//  StatusListModel.m
//  Yiban
//
//  Created by NewM on 12-12-12.
//
//

#import "StatusListModel.h"

@implementation StatusListModel
@synthesize data,sqlid,time,type,messagetype,maxId,maxTime;

- (void)dealloc
{
    RELEASE(sqlid);
    RELEASE(messagetype);
    RELEASE(maxId);
    RELEASE(maxTime);
    RELEASE(data);
    RELEASE(time);
    RELEASE(type);
    
    [super dealloc];
}
@end
