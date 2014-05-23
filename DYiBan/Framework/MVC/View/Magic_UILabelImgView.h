//
//  Magic_UILabelImgView.h
//  MagicFramework
//
//  Created by NewM on 13-4-22.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MagicUILabelImgView : UIView
{
    id        ctFrame;
    NSString *_imgName;
    CGRect    imgBound;
}
@property (nonatomic, assign)id        ctFrame;
@property (nonatomic, retain)NSString *imgName;
@property (nonatomic, assign)CGRect    imgBound;
@end
