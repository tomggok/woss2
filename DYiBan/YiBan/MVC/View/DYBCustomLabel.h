//
//  DYBCustomLabel.h
//  DYiBan
//
//  Created by Hyde.Xu on 13-8-16.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "Magic_UILabel.h"
#import "DYBUILabel.h"
@interface DYBCustomLabel : DYBUILabel{
    NSArray *_arrTarget;
    int typeIndex;
}
@property (assign,nonatomic)int typeIndex;
- (id)initWithFrame:(CGRect)frame target:(NSArray *)arrTarget;
- (void)replaceTargetText;
- (void)replaceEmojiandTarget:(BOOL)bHaveTarget;

@end
