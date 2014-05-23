//
//  DYBCheckImageViewController.h
//  DYiBan
//
//  Created by Hyde.Xu on 13-8-23.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseViewController.h"

@interface DYBCheckImageViewController : DYBBaseViewController{
    NSString *_strIMAGEurl;
    NSInteger _nInitYpe; //1.withURL 2.withImage
    UIImage *_image;
}

@property (nonatomic,assign)    NSInteger nInitYpe; //1.withURL 2.withImage
@property (nonatomic,assign)    BOOL bIsNeedDeleBt; //是否需要右上角删除按钮

AS_SIGNAL(DELETEMAGE) //删除信号

- (id)initWithURL:(NSString *)imageURL;
- (id)initWithImage:(UIImage *)image;

@end
