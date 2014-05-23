//
//  UIView+Catecory.m
//  Yiban
//
//  Created by tom zeng on 13-5-7.
//
//

#import "UIView+Catecory.h"

@implementation UIView (Catecory)
- (UIViewController *)viewController
{
	if (self.superview)
    {
		return nil;
    }
    
	id nextResponder = [self nextResponder];
	if ( [nextResponder isKindOfClass:[UIViewController class]] )
	{
		return (UIViewController *)nextResponder;
	}else
	{
		return nil;
	}
}

@end
