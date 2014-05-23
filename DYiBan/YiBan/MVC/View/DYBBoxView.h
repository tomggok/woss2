//
//  DYBBoxView.h
//  DYiBan
//
//  Created by Song on 13-8-21.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseView.h"

@interface DYBBoxView : UIView
@property (nonatomic,retain) UILabel* textLabel;
@property (nonatomic, retain)NSString *id;
-(void)arrangeViews;
@end
