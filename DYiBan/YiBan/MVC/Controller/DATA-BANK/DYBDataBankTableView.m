//
//  DYBDataBankTableView.m
//  DYiBan
//
//  Created by tom zeng on 13-8-15.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBDataBankTableView.h"

@implementation DYBDataBankTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(UIImage *)getBarImage{

//    UIImage *imageFuzzy = [self captureView:self.superview frame:CGRectMake(0.0f, self.frame.size.height - 50 - 0, 320.0f, 50.0f)];

    return nil;
}

#pragma mark - uiscrollview
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

//    UIImage *imageFuzzy = [self captureView:self.superview frame:CGRectMake(0.0f, self.frame.size.height - 50 - 0, 320.0f, 50.0f)];
//    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:scrollView, @"scrollView",imageFuzzy,@"imageData",nil];
//    
//    [self sendViewSignal:[DragonUITableView TABLESCROLLVIEWDIDSCROLL] withObject:dict];
    
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSNumber *nDecelerate = [NSNumber numberWithBool:decelerate];
    
    UIImage *imageFuzzy = [self captureView:self frame:CGRectMake(0.0f, self.frame.size.height - 50 - 0, 320.0f, 50.0f)];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:scrollView, @"scrollView", nDecelerate, @"decelerate",@"imageData",imageFuzzy,nil];
    [self sendViewSignal:[DragonUITableView TABLESCROLLVIEWDIDENDDRAGGING] withObject:dict];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:tableView, @"tableView", indexPath, @"indexPath", nil];
    DragonViewSignal *viewSignal = [self sendViewSignal:[DragonUITableView TABLECELLFORROW] withObject:dict];
    UITableViewCell *cell = (UITableViewCell *)[viewSignal returnValue];
    
    
    return cell;
}

-(UIImage*)captureView:(UIView *)theView frame:(CGRect)fra{
    
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRef ref = CGImageCreateWithImageInRect(img.CGImage, fra);
    UIImage *i = [UIImage imageWithCGImage:ref];
    CGImageRelease(ref);
    return i;
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
