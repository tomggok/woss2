//
//  DYBPersonalPhotoImageController.h
//  DYiBan
//
//  Created by Song on 13-9-12.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseViewController.h"

@interface DYBPersonalPhotoImageController : DYBBaseViewController{
    
//    MagicUITableView *_tbv;
}
@property (nonatomic, retain)NSString *userId;//查看相册用户的id
@property (nonatomic, retain)NSString *photoid;//查看相册id
@property (nonatomic, assign)NSString *allImgCount;//相册图片总数
@property (nonatomic, assign)NSString *albumName;//相册名字
@end
