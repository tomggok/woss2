//
//  ChineseToPinyin.h
//  Yiban
//
//  Created by Hyde.Xu on 12-11-20.
//
//

#import <Foundation/Foundation.h>

@interface ChineseToPinyin : MagicJSONReflection

+ (NSString *) pinyinFromChiniseString:(NSString *)string;
+ (char) sortSectionTitle:(NSString *)string;

@end
