//
//  ext.h
//  Yiban
//
//  Created by Hyde.Xu on 13-7-5.
//
//

#import <Foundation/Foundation.h>

//音频数据
@interface ext : MagicJSONReflection

@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *filename;
@property (nonatomic, retain) NSString *img_url;
@property (nonatomic, retain) NSString *lat;
@property (nonatomic, retain) NSString *lon;
@property (nonatomic, retain) NSString *msgid;
@property (nonatomic, retain) NSString *speech_length;
@property (nonatomic, retain) NSString *type;//1:正常lb和表情  2:定位  3:图片  4:语音


@end
