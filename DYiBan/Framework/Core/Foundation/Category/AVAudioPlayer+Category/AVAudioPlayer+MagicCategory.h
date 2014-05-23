//
//  AVAudioPlayer+MagicCategory.h
//  DYiBan
//
//  Created by zhangchao on 13-11-14.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface AVAudioPlayer (MagicCategory)

@property (nonatomic,assign) id ob;//用于播放结束后对某对象的操作 
@property (nonatomic,assign) BOOL b_isPlaying;//方便在KVO里判断是否正在播放

@end
