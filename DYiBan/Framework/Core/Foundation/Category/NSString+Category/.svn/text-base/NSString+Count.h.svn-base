//
//  NSString+Count.h
//  DragonFramework
//
//  Created by zhangchao on 13-4-12.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <Foundation/Foundation.h>

    //计算相关
@interface NSString (Count)

-(NSString *)TrimmingStringBywhitespaceCharacterSet/*:(NSString *)str*/;
-(NSArray *)separateStrToArrayBySeparaterChar:(NSString *)str1;
+(NSString *)joinedArrayToStr:(NSArray *)array separaterChar:(NSString *)separaterChar;
-(int)CountStrWord/*:(NSString *)str*/;
- (NSString *)getSubStringWithCharCounts:(NSInteger)number;
-(NSString *)changeStrToBeChangesStr:(NSArray *)array/*要被替换的几种字符串*/ ByStr:(NSString *)ByStr/*要替换成的字符串*/;
-(NSMutableString *)deleteEscapeCharacter:(NSString *)EscapeCharacter/*要被去掉的转义符*/;
-(NSString *)stringByAddingPercentEscapesUsingEncoding;
+(BOOL)isContainsEmoji:(NSString *)string;//禁止输入表情
-(NSString *)replaceEscapeCharacter;
+(NSString *)transFormTimeStamp:(int)ago;
-(void)openWebPage:(NSString *)Website/*网址*/;
- (NSString*)encodeURL/*:(NSString *)string*/;
-(CGSize)createActiveFrameByfontSize:(UIFont *)font constrainedSize:(CGSize)constrainedSize/*在此size的边界内*/ lineBreakMode:(UILineBreakMode)lineBreakMode/*换行模式,一般都是按UILineBreakModeCharacterWrap字符换行,如果按单词换行,可能出现最右边空出来*/;
-(BOOL)IsChinese:(NSRange)range;
//+(NSString *)transToPinYin:(unichar)charP;
-(void)LaunchPhoneCall/*:(NSString *)phoneNum*/;
+(NSString *)transFormTimeStampToDateFormatter:(int)ago;
-(NSString *)restoreEscapeCharacter;
+(NSString *)crearDateFormatter:(int)ago;
+(NSDateComponents *)getDateComponentsByTimeStamp:(int)ago;
-(int)numOfIntInStr;
+(NSDateComponents *)getDateComponentsByNow;
+(NSString *)cachePathForfileName:(NSString *)fileName fileType:(NSString *)fileType dir:(NSSearchPathDirectory)dir;
-(BOOL)deleteFile;
-(BOOL)hasFile;

@end



@interface NSMutableString (Count)

-(void)deleteEscapeCharacterByEscapeCharacter:(NSString *)EscapeCharacter/*要被去掉的转义符*/;

@end

