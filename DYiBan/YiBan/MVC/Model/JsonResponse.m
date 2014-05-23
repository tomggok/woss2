//
//  JsonResponse.m
//  Magic
//
//  Created by 周 哲 on 12-11-1.
//
//

#import "JsonResponse.h"

@implementation JsonResponse
@synthesize data;
@synthesize message;
@synthesize sessID;

@synthesize response;
- (void)dealloc
{
    RELEASE(message);
    RELEASE(sessID);
    RELEASE(data);
    [super dealloc];
}
@end
