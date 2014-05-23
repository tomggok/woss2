//
//  DYBFaceView.h
//  DYiBan
//
//  Created by Song on 13-9-5.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol faceDelegate <NSObject>
@optional
-(void)selectFace:(id)sender;

@end

@interface DYBFaceView : UIView<UIScrollViewDelegate,UIPageViewControllerDelegate,faceDelegate>{
    id<faceDelegate>delegate;
}
@property(retain,nonatomic) UIScrollView *_faceScrollView ;
@property(retain,nonatomic) NSMutableArray *faces;
@property(assign,nonatomic)id<faceDelegate>delegate;

@end
