//
//  Atmsg.h
//  Magic
//
//  Created by 周 哲 on 12-11-3.
//
//

#import <Foundation/Foundation.h>
//#import "Jastor.h"
@interface Atmsg : MagicJSONReflection
@property (assign,nonatomic) int havenext;//是否有下一页
@property (assign,nonatomic) int newcount;//新消息数量
@property (retain,nonatomic) NSArray *ma;// 评论提醒列表
//+(Class)ma_class;
@end
