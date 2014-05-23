//
//  status_notice_model.h
//  Yiban
//
//  Created by tom zeng on 12-11-27.
//
//

//#import "Jastor.h"
#import "status.h"

//通知详情
@interface status_notice_model : MagicJSONReflection
@property(nonatomic,retain)status* status;
@property (nonatomic,retain)NSString *havenext;
@property (nonatomic,retain)NSString* eclass_num;
@property(nonatomic,retain)NSString *notice_num;
@property(nonatomic,retain)NSString *response_num;
@property(nonatomic,retain)NSArray  *notice;

//+(Class)notice_class;
@end
