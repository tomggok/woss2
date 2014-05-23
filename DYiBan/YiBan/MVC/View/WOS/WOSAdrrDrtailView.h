//
//  WOSAdrrDrtailView.h
//  WOS
//
//  Created by apple on 14-5-18.
//  Copyright (c) 2014年 ZzL. All rights reserved.
//
@protocol WOSAdrrDrtailViewDelegate <NSObject>

-(void)delSueese:(NSString *)strIndex;

@end
#import <UIKit/UIKit.h>

@interface WOSAdrrDrtailView : DYBBaseView

@property (nonatomic,assign)id <WOSAdrrDrtailViewDelegate>delegate;
-(void)addView:(NSDictionary *)dict;
@end
