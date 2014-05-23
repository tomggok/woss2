//
//  ext.m
//  Yiban
//
//  Created by Hyde.Xu on 13-7-5.
//
//

#import "ext.h"

@implementation ext

@synthesize address;
@synthesize filename;
@synthesize img_url;
@synthesize lat;
@synthesize lon;
@synthesize msgid;
@synthesize speech_length;
@synthesize type;

-(void)dealloc{
    [address release];
    [filename release];
    [img_url release];
    [lat release];
    [lon release];
    [msgid release];
    [speech_length release];
    [type release];
    
    [super dealloc];
}


@end
