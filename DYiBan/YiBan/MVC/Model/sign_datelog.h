//
//  sign_datelog.h
//  Yiban
//
//  Created by Hyde.Xu on 12-11-29.
//
//

//#import "Jastor.h"
#import "sgin_days.h"
#import "sgin_list.h"

@interface sign_datelog : MagicJSONReflection
@property(nonatomic, retain) NSString *result;
@property(nonatomic, retain) NSString *sgin_allday;
@property(nonatomic, retain) NSString *sign_realline;
@property(nonatomic, retain) sgin_list *sign;

@end
