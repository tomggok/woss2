//
//  NSString+Count.m
//  MagicFramework
//
//  Created by zhangchao on 13-4-12.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "NSString+Count.h"
#import "RegexKitLite.h" //用于字数统计CountStrWord函数
//#import "ChineseToPinyin.h"

@implementation NSString (Count)

#pragma mark-去掉字符串中的前后空格和换行
-(NSString *)TrimmingStringBywhitespaceCharacterSet/*:(NSString *)str*/
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

#pragma mark-把字符串用分割数切割成一个数组
-(NSArray *)separateStrToArrayBySeparaterChar:(NSString *)str1
{
    return [self componentsSeparatedByString:str1];
}

#pragma mark-把数组里的元素用分隔符合并成一个字符串
+(NSString *)joinedArrayToStr:(NSArray *)array separaterChar:(NSString *)separaterChar
{

    return [array componentsJoinedByString:separaterChar];
}

#pragma mark-字数统计
-(int)CountStrWord/*:(NSString *)str*/
{
	int nResult = 0;
	NSString *strSourceCpy = [self copy];
	NSMutableString *strCopy =[[NSMutableString alloc] initWithString: strSourceCpy];
    NSArray *array = [strCopy componentsMatchedByRegex:@"((news|telnet|nttp|file|http|ftp|https)://){1}(([-A-Za-z0-9]+(\\.[-A-Za-z0-9]+)*(\\.[-A-Za-z]{2,5}))|([0-9]{1,3}(\\.[0-9]{1,3}){3}))(:[0-9]*)?(/[-A-Za-z0-9_\\$\\.\\+\\!\\*\\(\\),;:@&=\\?/~\\#\\%]*)*"];
	if ([array count] > 0) {
		for (NSString *itemInfo in array) {
			NSRange searchRange = {0};
			searchRange.location = 0;
			searchRange.length = [strCopy length];
			[strCopy replaceOccurrencesOfString:itemInfo withString:@"aaaaaaaaaaaa" options:NSCaseInsensitiveSearch range:searchRange];
		}
	}

	char *pchSource = (char *)[strCopy cStringUsingEncoding:NSUTF8StringEncoding];
	int sourcelen = strlen(pchSource);

	int nCurNum = 0;		// 当前已经统计的字数
	for (int n = 0; n < sourcelen; ) {
		if( *pchSource & 0x80 ) {
			pchSource += 3;		// NSUTF8StringEncoding编码汉字占３字节
			n += 3;
			nCurNum += 2;
		}
		else {
			pchSource++;
			n += 1;
			nCurNum += 1;
		}
	}
        // 字数统计规则，不足一个字(比如一个英文字符)，按一个字算
	nResult = nCurNum / 2 + nCurNum % 2;

	[strSourceCpy release];
	[strCopy release];
	return nResult;
}

#pragma mark-从字符串中获取字数个数为N的字符串，单字节字符占半个字数，双字节占一个字数
- (NSString *)getSubStringWithCharCounts:(NSInteger)number
{
        // 一个字符以内，不处理
	if (self == nil || [self length] <= 1) {
		return self;
	}
	char *pchSource = (char *)[self cStringUsingEncoding:NSUTF8StringEncoding];
	int sourcelen = strlen(pchSource);
	int nCharIndex = 0;		// 字符串中字符个数,取值范围[0, [strSource length]]
	int nCurNum = 0;		// 当前已经统计的字数
	for (int n = 0; n < sourcelen; ) {
		if( *pchSource & 0x80 ) {
			if ((nCurNum + 2) > number * 2) {
				break;
			}
			pchSource += 3;		// NSUTF8StringEncoding编码汉字占３字节
			n += 3;
			nCurNum += 2;
		}
		else {
			if ((nCurNum + 1) > number * 2) {
				break;
			}
			pchSource++;
			n += 1;
			nCurNum += 1;
		}
		nCharIndex++;
	}
	assert(nCharIndex > 0);
	return [self substringToIndex:nCharIndex];
}

#pragma mark-把字符串里的几种字符(保存在一号参数数组里)用2号参数替换掉(不可去掉转义符)
-(NSString *)changeStrToBeChangesStr:(NSArray *)array/*要被替换的几种字符串*/ ByStr:(NSString *)ByStr/*要替换成的字符串*/
{
    for (NSString *str in array) {
        self=[self stringByReplacingOccurrencesOfString:str withString:ByStr];
    }
        //        NSLog(@"%@",str);
//    NSLog(@"%@",orStr);
    
   
    return self;
}

#pragma mark- 去掉字符串中的转义符
-(NSMutableString *)deleteEscapeCharacter:(NSString *)EscapeCharacter/*要被去掉的转义符*/
{
    NSMutableString *mus=[NSMutableString stringWithString:self];
    [mus deleteEscapeCharacterByEscapeCharacter:EscapeCharacter];
    return mus;
}


#pragma mark- 替换字符串中的转义符
-(NSString *)replaceEscapeCharacter
{
//    (self=[self stringByReplacingOccurrencesOfString:@"'" withString:@"\\'" options:NSCaseInsensitiveSearch range:NSMakeRange(0, self.length)]);
//    (self=[self stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, self.length)]);
//    self=[self stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\" options:NSCaseInsensitiveSearch range:NSMakeRange(0, self.length)];//把一个\转化成2个
//    self=[self stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r" options:NSCaseInsensitiveSearch range:NSMakeRange(0, self.length)];
//    self=[self stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, self.length)];
    self=[self stringByReplacingOccurrencesOfString:@"<" withString:@"\\\\<" options:NSCaseInsensitiveSearch range:NSMakeRange(0, self.length)];
    return self;
}

#pragma mark- 还原字符串中的转义符
-(NSString *)restoreEscapeCharacter
{
    //    (self=[self stringByReplacingOccurrencesOfString:@"'" withString:@"\\'" options:NSCaseInsensitiveSearch range:NSMakeRange(0, self.length)]);
    //    (self=[self stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, self.length)]);
    //    self=[self stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\" options:NSCaseInsensitiveSearch range:NSMakeRange(0, self.length)];//把一个\转化成2个
    //    self=[self stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r" options:NSCaseInsensitiveSearch range:NSMakeRange(0, self.length)];
    //    self=[self stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, self.length)];
    self=[self stringByReplacingOccurrencesOfString:@"\\\\<" withString:@"<" options:NSCaseInsensitiveSearch range:NSMakeRange(0, self.length)];
    return self;
}

#pragma mark- 把str里的 "" ,‘:’, ‘/’, ‘%’, ‘#’, ‘;’, ‘@’, ‘%’  转成 UTF-8. 避免服务器发的url里有这些特殊字符从而导致 ([NSURL URLWithString:self] == nil)
-(NSString *)stringByAddingPercentEscapesUsingEncoding
{
    return [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

#pragma mark- 禁止输入表情
+(BOOL)isContainsEmoji:(NSString *)string {
    
    
    
    __block BOOL isEomji = NO;
    
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         
         
         const unichar hs = [substring characterAtIndex:0];
         
         // surrogate pair
         
         if (0xd800 <= hs && hs <= 0xdbff) {
             
             if (substring.length > 1) {
                 
                 const unichar ls = [substring characterAtIndex:1];
                 
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     
                     isEomji = YES;
                     
                 }
                 
             }
             
         } else if (substring.length > 1) {
             
             const unichar ls = [substring characterAtIndex:1];
             
             if (ls == 0x20e3) {
                 
                 isEomji = YES;
                 
             }
             
             
             
         } else {
             
             // non surrogate
             
             if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                 
                 isEomji = YES;
                 
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 
                 isEomji = YES;
                 
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 
                 isEomji = YES;
                 
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 
                 isEomji = YES;
                 
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
                 
                 isEomji = YES;
                 
             }
             
         }
         
     }];
    
    
    
    return isEomji;
    
}

#pragma mark- 打开浏览器网页
-(void)openWebPage:(NSString *)Website/*网址*/
{
    [[UIApplication sharedApplication]openURL:[[NSURL alloc]initWithString:Website]];
}

#pragma mark- 发起电话呼叫
-(void)LaunchPhoneCall/*:(NSString *)phoneNum*/
{
    NSString *str=@"tel:";//通话协议前缀
    str=[str stringByAppendingString:self];
    
    [self openWebPage:str];
}

#pragma mark- 上传URL编码时里面可能包含某些字符，比如‘$‘ ‘&’ ‘？’...等，这些字符在 URL 语法中是具有特殊语法含义的,需要把这些字符 转化为 “%+ASCII” (如 $ 被转化为 %24 ($的16进制ASCII是24) )形式，以免造成冲突
//http://www.cnblogs.com/meyers/archive/2012/04/26/2471669.html
- (NSString*)encodeURL/*:(NSString *)string*/
{
    NSString *newString1 = [NSMakeCollectable(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding))) autorelease];
    if (newString1) {
		return newString1;
	}
	return @"";
}

#pragma mark- 根据内容和内容的字体还有换行模式在指定的size里创建一个新size
-(CGSize)createActiveFrameByfontSize:(UIFont *)font constrainedSize:(CGSize)constrainedSize/*在此size的边界内*/ lineBreakMode:(UILineBreakMode)lineBreakMode/*换行模式,一般都是按UILineBreakModeCharacterWrap字符换行,如果按单词换行,可能出现最右边空出来*/
{
    return [self sizeWithFont:font constrainedToSize:constrainedSize lineBreakMode:lineBreakMode];
}

#pragma mark- 转化服务器发来的int类型时间戳成("M-d HH:mm")等格式
+(NSString *)transFormTimeStampToDateFormatter:(int)ago
{
    NSDateFormatter* df = [[[NSDateFormatter alloc] init] autorelease];
    [df setDateFormat:@"M-d HH:mm"];//设定时间格式
    [df setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease]];//设置本地化信息
    return [NSString stringWithFormat:@"%@",[df stringFromDate:[NSDate dateWithTimeIntervalSince1970:ago]]];
    
}

#pragma mark- 转化服务器发来的int类型时间戳成NSDateComponents格式已分别得到其year,month等信息
+(NSDateComponents *)getDateComponentsByTimeStamp:(int)ago{
    
    //取得当前用户的逻辑日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:ago];

    NSDateComponents *todayComponents = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit |kCFCalendarUnitHour |kCFCalendarUnitMinute|kCFCalendarUnitSecond fromDate:date];
    return todayComponents; //todayComponents.year是int值
}

#pragma mark- 得到当前系统时间是NSDateComponents
+(NSDateComponents *)getDateComponentsByNow{
    
    //取得当前用户的逻辑日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSDateComponents *todayComponents = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit |kCFCalendarUnitHour |kCFCalendarUnitMinute|kCFCalendarUnitSecond fromDate:date];
    return todayComponents; //todayComponents.year是int值
}

#pragma mark- 创建距离现在多少秒("M-d HH:mm")等时间格式
+(NSString *)crearDateFormatter:(int)ago
{
    NSDateFormatter* df = [[[NSDateFormatter alloc] init] autorelease];
//    [df setDateFormat:@"M-d HH:mm"];//设定时间格式
    if (ago == 0) {
        [df setDateFormat:@"Y-M-d hh:mm"];//设定时间格式
    }else {
        [df setDateFormat:@"M-d HH:mm"];//设定时间格式
    }

    [df setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease]];//设置本地化信息
    return [NSString stringWithFormat:@"%@",[df stringFromDate:[NSDate dateWithTimeIntervalSinceNow:ago]]];
    
}

#pragma mark- 转化服务器发来的int类型时间戳成(...前)格式
+(NSString *)transFormTimeStamp:(int)ago
{
	NSDate *begin = [NSDate dateWithTimeIntervalSince1970:ago];
    
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit| NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSCalendar *calender = [NSCalendar currentCalendar];//当前用户的逻辑日历

    NSDateComponents *interval = [calender components:unitFlags fromDate:begin toDate:[NSDate date] options:0];//获得起始-终止时间之间的间隔
	
	int year  = [interval year];
	int month = [interval month];
	int week  = [interval week];
	int day   = [interval day];
	int hour  = [interval hour];
	int min   = [interval minute];
	int sec   = [interval second];
	
	NSString *time = @"";
	if (year > 0)
	{
		time = [time stringByAppendingFormat:@"%d年前", year];
		return time;
	}
	else if (month > 0)
	{
		time = [time stringByAppendingFormat:@"%d个月前", month];
		return time;
	}
	else if (week > 0)
	{
		time = [time stringByAppendingFormat:@"%d周前", week];
		return time;
	}
	else if (day > 0)
	{
		time = [time stringByAppendingFormat:@"%d天前", day];
		return time;
	}
	else if (hour > 0)
	{
		time = [time stringByAppendingFormat:@"%d小时前", hour];
		return time;
	}
	else if (min > 0)
	{
		time = [time stringByAppendingFormat:@"%d分钟前", min];
		return time;
	}
	else if (sec > 0)
	{
		time = [time stringByAppendingFormat:@"%d秒前", sec];
		return time;
	}
	else
	{
		return @"刚刚";
	}
    
	return @"";
}

#pragma mark- 判断是否是汉字
-(BOOL)IsChinese:(NSRange)range
{
//    NSRange range = NSMakeRange(0, 1);
    NSString *subString = [self substringWithRange:range];
    const char *cString = [subString UTF8String];
    return (strlen(cString) == 3); //名字首字母是汉字
}

//#pragma mark- 把字符转化成对应的谐音汉字
//+(NSString *)transToPinYin:(unichar)charP
//{
//    return [[NSString stringWithFormat:@"%c",pinyinFirstLetter(charP)] uppercaseString];
//}

#pragma mark- 判断字符串中有几个数字
-(int)numOfIntInStr
{
    int count=0;
    for(int i=0;i<self.length;i++)
    {
        if([self characterAtIndex:i]>47&&[self characterAtIndex:i]<58)//数字0-9在ACS码中对应的值为48~57
        {
            count++;
        }
    }
    return count;
}

#pragma mark- 在沙盒的NSSearchPathDirectory目录创建fileType类型文件的目录路径
+(NSString *)cachePathForfileName:(NSString *)fileName fileType:(NSString *)fileType dir:(NSSearchPathDirectory)dir
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(dir, NSUserDomainMask, YES);
    NSString *diskCachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileType];
    
    return [diskCachePath stringByAppendingPathComponent:[MagicCommentMethod md5:fileName]];
}

#pragma mark- 删除沙盒里self路径的文件
-(BOOL)deleteFile{
    
    NSFileManager* fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:self/*文件路径*/]) {
       return [fileManager removeItemAtPath:self error:nil];
    }
    return NO;
}

#pragma mark- 沙盒里self路径是否有文件
-(BOOL)hasFile{
   
    return [[NSFileManager defaultManager] fileExistsAtPath:self/*文件路径*/];
}

@end


//==================================================================================
#pragma mark-
@implementation NSMutableString (Count)

#pragma mark- 去掉字符串中的转义符
-(void)deleteEscapeCharacterByEscapeCharacter:(NSString *)EscapeCharacter/*要被去掉的转义符
\a - Sound alert
\b - 退格
\f - Form feed
\n - 换行
\r - 回车
\t - 水平制表符
\v - 垂直制表符
\\ - 表示要删除一个\(反斜杠),但参数要传\\,因为一个\是转义符
\" - 双引号
\' - 单引号
*/
{
    NSString *character = nil;
    for (int i = 0; i < self.length; i ++) {
        character = [self substringWithRange:NSMakeRange(i, 1)];
        if ([character isEqualToString:EscapeCharacter])
            [self deleteCharactersInRange:NSMakeRange(i, 1)];
    }
}



@end

