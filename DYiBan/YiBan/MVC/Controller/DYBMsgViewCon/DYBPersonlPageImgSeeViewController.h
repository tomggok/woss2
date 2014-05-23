//
//  DYBPersonlPageImgSeeViewController.h
//  DYiBan
//
//  Created by Song on 13-9-13.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseViewController.h"
#import "albums.h"
@interface DYBPersonlPageImgSeeViewController : DYBBaseViewController
{
    NSMutableArray *_imgArray;//要加载的array
    albums *_getInObjectl;//传进来的对象
    UINavigationBar *headBar;//上面的bar
    UIButton *createrAndTime;//显示由谁上传
    
    NSString *albumId;//相册id
    NSString *userId;//查看相册用户的id
    
    BOOL ifReadOne;//是否读取一张
    MagicUIScrollListView *scroller;
    NSMutableArray *array;
    
    int currentImg;
    
    
    
    
}
@property (nonatomic, assign)int type;
@property (nonatomic, retain)NSMutableArray *imgArray;
@property (nonatomic, retain)albums *getInObjectl;
@property (nonatomic, retain)NSString *albumId;//相册id
@property (nonatomic, assign)BOOL ifReadOne;//是否读取一张
@property (nonatomic, retain)NSString *userId;//查看相册用户的id
@property (nonatomic, assign)NSInteger allImgCount;//相册总数
@property (nonatomic, assign)BOOL iswillred;//是否有下一页
@end
