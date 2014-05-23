//
//  JsonResponse.h
//  Magic
//
//  Created by 周 哲 on 12-11-1.
//
//

#import <Foundation/Foundation.h>
//#import "Jastor.h"

//服务器返回的json数据格式封装成的对象
@interface JsonResponse : MagicJSONReflection

@property (assign,nonatomic) int response;
@property (retain ,nonatomic) NSString *message;
@property (retain ,nonatomic) NSString *sessID;
@property (retain , nonatomic) NSDictionary *data;

@end
