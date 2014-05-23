//
//  DYBDataBnakSchoolAndCollegeViewController.h
//  DYiBan
//
//  Created by tom zeng on 13-9-16.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseViewController.h"

@interface DYBDataBnakSchoolAndCollegeViewController : DYBBaseViewController

@property (nonatomic,retain)NSString *docAddr;
@property (nonatomic,retain)NSDictionary *dictInfo;
@property (nonatomic,assign)int type; // 0学院 1 学校
AS_SIGNAL(RIGHTSIGNAL)
@end
