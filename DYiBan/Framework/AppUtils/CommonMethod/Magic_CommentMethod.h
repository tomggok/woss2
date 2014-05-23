//
//  MagicCommentMethod.h
//  ShangJiaoYuXin
//
//  Created by NewM on 13-5-6.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#define KEY_WINDOW  [[UIApplication sharedApplication]keyWindow]
#define k_W_moveOffsetX 50 //view向右移动的偏移量

#define screen  [[UIScreen mainScreen]bounds]//整个物理屏幕的边界,包括状态栏在内,viewController.frame等于此,因为屏幕翻转时是viewController负责转换包括状态栏的所有视图和控件,所以视图控制器包括状态栏
#define screenShows [[UIScreen mainScreen]applicationFrame]//整个屏幕的可显示区域,在顶部状态下边,不包括状态栏那20的高,常用于设置UIView.frame
#define keyBoardSizeForIpad  CGSizeMake(screen.size.width, 768/2) //横屏时ipad上的keyboard的size
#define keyBoardSizeForIp  CGSizeMake(screen.size.width, 216) //竖屏时ip上的keyboard的size
#define kH_UINavigationController 44 //顶部导航栏的高
#define kH_UITabBarController 47 //底部标签栏控制器的高
#define kH_UISearchBar 44//搜索栏的高
#define kH_UIPickerView 216//选取器高
#define kH_StateBar 20//顶部状态栏高
#define kSeconds_pre_year (60*60*24*365ul) //一年有多少秒,后边加ul是因为计算结果在16位电脑上会溢出,故表明此结果是无符号的长整数
#define k_icon_iphone 57 //iphone应用程序图标默认大小,4s以上的翻倍
#define k_icon_ipad2 72 //Ipad2应用程序图标默认大小
#define k_icon_ipad3 144 //Ipad3应用程序图标默认大小
#define k_Notification_SuccessDownImg @"图片下载完毕通知"
#define kH_chineseItem 40 //中文输入法时键盘上边的选项栏的高
#define kH_photoEditoredImgCutSize 75 //图片经过滤镜或者拍照后上下被裁减的高


#import <Foundation/Foundation.h>
//NSString *const kNetworkConnectTypeChange = @"kNetworkConnectTypeChange";
@interface MagicCommentMethod : NSObject


//GBK编码
+ (NSStringEncoding)GBKENCODING;
//md5加密
+ (NSString *)md5:(NSString *)inPutText;
//压缩gzip
+(NSData*)gzipData:(NSData*)pUncompressedData;
//解压Gzip
+(NSData *)ungzipData:(NSData *)compressedData;
//得到中英文混合字符串长度
+ (NSInteger)convertToInt:(NSString*)strtemp;
//得到中英文混合字符串长度
+ (NSInteger)getToInt:(NSString*)strtemp;
//实时检查网络连接方式
+ (MagicCommentMethod *)reachForDefaultHost;
//获得ip地址
+ (NSString *)getIPAddress;
//十六进制转RGB
+ (UIColor *)colorWithHex:(NSString *)hexString;
//RGB颜色
+ (UIColor *)color:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(float)alpha;
//处理url
+ (NSString*)encodeURL:(NSString *)string;
//获得屏幕Frame
+ (CGRect)mainFrame;
//获得屏幕大小
+ (CGSize)mainSize;
//计算时间与当前时间的差
+ (NSMutableDictionary *)intervalSinceAgoTime:(float)ago;
//下载文件地址
+ (NSString *)downloadPath;

+ (NSString *)dataBankMD5:(NSString *)key;

+(NSDateComponents *)getCurSystemTimeZonesDateComponentsByAddingTimeInterval:(NSInteger)TimeInterval;
+(NSDate *)getCurSystemTimeZonesDateByAddingTimeInterval:(NSInteger)TimeInterval;
+(NSString *)getDateWithoutTimeZone:(NSDate *)d;

//+(NSString *)transToPinYin:(unichar)charP;

@end
