//
//  DYBBubbleView.h
//  DYiBan
//
//  Created by Hyde.Xu on 13-9-4.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseView.h"
#import "sgin_list.h"

@interface DYBBubbleView : DYBBaseView

@property (nonatomic, retain)sgin_list *sginInfo;
- (id)initWithFrame:(CGRect)frame BubbleInfo:(sgin_list *)arrInfo;

@end
