//
//  StatusListModel.h
//  Yiban
//
//  Created by NewM on 12-12-12.
//
//

#import <Foundation/Foundation.h>

@interface StatusListModel : MagicJSONReflection
@property (nonatomic, retain)NSString *sqlid;
@property (nonatomic, retain)NSString *data;//数据
@property (nonatomic, retain)NSString *maxId;//响应时最大id
@property (nonatomic, retain)NSString *maxTime;//响应时最大id的时间
@property (nonatomic, retain)NSString *messagetype;//信息类型是隐藏型（1,正常 2,展开的信息）
@property (nonatomic, retain)NSString *time;//时间
@property (nonatomic, retain)NSString *type;//状态

@end
