//
//  DYBBoxView.m
//  DYiBan
//
//  Created by Song on 13-8-21.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBoxView.h"

@implementation DYBBoxView
@synthesize textLabel = _textLabel,id = _id;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _textLabel = [[MagicUILabel alloc] init];
		[_textLabel setFont:[DYBShareinstaceDelegate DYBFoutStyle:17]];
        _textLabel.textAlignment = NSTextAlignmentCenter;
		[_textLabel setLineBreakMode:UILineBreakModeTailTruncation];
        [_textLabel setContentMode:UIViewContentModeCenter];
		[_textLabel setBackgroundColor:[UIColor clearColor]];
		[self addSubview:_textLabel];
        
    }
    return self;
}


-(void)arrangeViews {
    
     [_textLabel setFrame:CGRectMake(0, 0, 320, self.frame.size.height)];
    
}

- (void)dealloc {
    
    RELEASEVIEW(_textLabel);
    RELEASE(_id);
    [super dealloc];
}


@end
