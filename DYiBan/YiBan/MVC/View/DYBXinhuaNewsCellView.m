//
//  DYBXinhuaNewsCellView.m
//  DYiBan
//
//  Created by Song on 13-9-11.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBXinhuaNewsCellView.h"

#define NewsLeftWith   15
#define NewsTopHeight  10
#define NewSIconsWith  85

#define NEIconWith     80
#define NEIconHeight   80

#define NewsAgencyCellHeight               107
#define NewsAgencyCellHeightOne             97

#define     SeWordColor     [UIColor colorWithRed:0/255.0 green:85/255.0 blue:113/255.0 alpha:1]//蓝色字统一色
#define     CoWordColor     [UIColor colorWithRed:40/255.0 green:40/255.0 blue:40/255.0 alpha:1]//内容字统一色

#define     BigFont17           [UIFont fontWithName:@"Helvetica" size:17]
#define     BigFont17Bold       [UIFont fontWithName:@"Helvetica-Bold" size:17]
#define     NormalFont16        [UIFont fontWithName:@"Helvetica" size:16]
#define     NormalFont15        [UIFont fontWithName:@"Helvetica" size:15]
#define     NormalFont15Bold    [UIFont fontWithName:@"Helvetica-Bold" size:15]
#define     NormalFont14        [UIFont fontWithName:@"Helvetica" size:14]
#define     NormalFont14Bold    [UIFont fontWithName:@"Helvetica-Bold" size:14]
#define     SmallFont13         [UIFont fontWithName:@"Helvetica" size:13]
#define     SmallFont13Bold     [UIFont fontWithName:@"Helvetica-Bold" size:13]
#define     SmallFont12         [UIFont fontWithName:@"Helvetica" size:12]
#define     SmallFont12Bold     [UIFont fontWithName:@"Helvetica-Bold" size:12]


#define NewsMaxWidth   200
#define NewsScanHeight 36

#define     IconWidth       41
#define     IconHeight      41
#define     IconBgWidth     47
#define     IconBgHeight    47
#define     IconBorderWidth 3
#define     IconBigWidth    60
#define     IconBigHeight   60
#define     IconBigBgWidth  70
#define     IconBigBgHeight 70
#define     IconBigBorderWidth 5
#define     Icon80BgWidth   86
#define     Icon80BgHeight  86
#define     Icon80BorderWidth 3


@implementation DYBXinhuaNewsCellView

- (id)initWithFrame:(CGRect)frame news_info:(news_list *)news;
{
    self = [super initWithFrame:frame];
    if (self) {
        if ([news.pics count] > 0) {
            //新闻题目
            UILabel *lbNewsTitle = [[[UILabel alloc] initWithFrame:CGRectMake(NewsLeftWith+NewSIconsWith+10, NewsTopHeight, 320-(NewsLeftWith+NewSIconsWith+10)-15, 20)] autorelease];
            [lbNewsTitle setText:news.title];
            [lbNewsTitle setTextColor:SeWordColor];
            [lbNewsTitle setFont:NormalFont14Bold];
            [lbNewsTitle setBackgroundColor:[UIColor clearColor]];
            [lbNewsTitle setTextAlignment:NSTextAlignmentLeft];
            [lbNewsTitle setLineBreakMode:NSLineBreakByTruncatingTail];
            [self addSubview:lbNewsTitle];
            
            
            //头像背景框
            UIImage *iconBg = [UIImage imageNamed:@"icon80_bg.png"];
            UIImageView *viewIconBg = [[[UIImageView alloc] initWithFrame:CGRectMake(NewsLeftWith-Icon80BorderWidth, NewsTopHeight-Icon80BorderWidth+3, Icon80BgWidth, Icon80BgHeight)] autorelease];
            [viewIconBg setImage:iconBg];
            [self addSubview:viewIconBg];
            viewIconBg.backgroundColor = [UIColor clearColor];
            
            
            //头像
            MagicUIImageView *imageViewUser = [[[MagicUIImageView alloc]initWithFrame:CGRectMake(NewsLeftWith, NewsTopHeight+3, NEIconWith, NEIconHeight)] autorelease];
            
            
            [imageViewUser setImageWithURL:[NSURL URLWithString:news.thumb]];
            //           [imageViewUser setImageWithURL:[NSURL URLWithString:@"http://img6.cache.netease.com/auto/2012/11/28/20121128075825c6a6f.jpg"]];
            
            if ( imageViewUser.image == nil) {
                [imageViewUser setImage:[UIImage imageNamed:@"backIcon80.png"]];
            }
            [imageViewUser setBackgroundColor:[UIColor clearColor]];
            
            [imageViewUser setFrame:CGRectMake(NewsLeftWith, NewsTopHeight+3, NEIconWith, NEIconHeight)];
            
            [self addSubview:imageViewUser];
            
            //内容
            if ([news.content length]==0) {
                news.content = @"";
            }
            
            CGSize contentSize;
            contentSize = [news.content sizeWithFont:SmallFont12
                                   constrainedToSize:CGSizeMake(NewsMaxWidth, NewsScanHeight)
                                       lineBreakMode:UILineBreakModeTailTruncation];
            
            UILabel *lbNewsContent = [[[UILabel alloc] initWithFrame:CGRectMake(NewsLeftWith+NewSIconsWith+10, NewsTopHeight+20+5, NewsMaxWidth, contentSize.height)] autorelease];
            [lbNewsContent setText:news.content];
            [lbNewsContent setFont:SmallFont12];
            [lbNewsContent setNumberOfLines:2];
            [lbNewsContent setBackgroundColor:[UIColor clearColor]];
            [lbNewsContent setTextAlignment:NSTextAlignmentLeft];
            [lbNewsContent setLineBreakMode:NSLineBreakByTruncatingTail];
            [self addSubview:lbNewsContent];
            
            //时间
            NSInteger timeInt = [news.time intValue];
            NSString *timeStr = [self getAgo:timeInt];
            
            UILabel *lbNewsTime = [[[UILabel alloc] initWithFrame:CGRectMake(190, NewsAgencyCellHeight-25, 55, 20)] autorelease];
            [lbNewsTime setText:timeStr];
            [lbNewsTime setTextColor:SeWordColor];
            [lbNewsTime setBackgroundColor:[UIColor clearColor]];
            [lbNewsTime setFont:[UIFont fontWithName:@"Helvetica" size:10]];
            [lbNewsTime setTextAlignment:UITextAlignmentRight];
            [lbNewsTime setLineBreakMode:NSLineBreakByTruncatingTail];
            [self addSubview:lbNewsTime];
            
            //点击
            UIImage *tuNumImage = [UIImage imageNamed:@"renNum.png"];
            NSString *newerNum = [NSString stringWithFormat:@"%@",news.hits];
            CGSize numSize = [newerNum sizeWithFont:[UIFont fontWithName:@"Helvetica" size:11]];
            
            UIImageView *tuNumImageView = [[UIImageView alloc] initWithFrame:CGRectMake(305-numSize.width-9-3, NewsAgencyCellHeight-19, 9, 9)];
            [tuNumImageView setImage:tuNumImage];
            [self addSubview:tuNumImageView];
            [tuNumImageView release];
            
            UILabel *lbNewsHits = [[[UILabel alloc] initWithFrame:CGRectMake(255, NewsAgencyCellHeight-25, 50, 20)] autorelease];
            [lbNewsHits setText:newerNum];
            [lbNewsHits setTextColor:SeWordColor];
            [lbNewsHits setBackgroundColor:[UIColor clearColor]];
            [lbNewsHits setFont:[UIFont fontWithName:@"Helvetica" size:10]];
            [lbNewsHits setTextAlignment:UITextAlignmentRight];
            [lbNewsHits setLineBreakMode:NSLineBreakByTruncatingTail];
            [self addSubview:lbNewsHits];
        }
        else{
            //新闻题目
            UILabel *lbNewsTitle = [[[UILabel alloc] initWithFrame:CGRectMake(NewsLeftWith, NewsTopHeight, 320-(NewsLeftWith)-15, 20)] autorelease];
            [lbNewsTitle setText:news.title];
            [lbNewsTitle setTextColor:SeWordColor];
            [lbNewsTitle setBackgroundColor:[UIColor clearColor]];
            [lbNewsTitle setFont:NormalFont14Bold];
            [lbNewsTitle setTextAlignment:NSTextAlignmentLeft];
            [lbNewsTitle setLineBreakMode:NSLineBreakByTruncatingTail];
            [self addSubview:lbNewsTitle];
            
            //内容
            if ([news.content length]==0) {
                news.content = @"";
            }
            
            CGSize contentSize;
            contentSize = [news.content sizeWithFont:SmallFont12
                                   constrainedToSize:CGSizeMake(320-30, NewsScanHeight)
                                       lineBreakMode:UILineBreakModeTailTruncation];
            
            UILabel *lbNewsContent = [[[UILabel alloc] initWithFrame:CGRectMake(NewsLeftWith, NewsTopHeight+20+5, 320-30, contentSize.height)] autorelease];
            [lbNewsContent setText:news.content];
            [lbNewsContent setBackgroundColor:[UIColor clearColor]];
            [lbNewsContent setFont:SmallFont12];
            [lbNewsContent setNumberOfLines:2];
            [lbNewsContent setTextAlignment:NSTextAlignmentLeft];
            [lbNewsContent setLineBreakMode:NSLineBreakByTruncatingTail];
            [self addSubview:lbNewsContent];
            
            //时间
            NSInteger timeInt = [news.time intValue];
            NSString *timeStr = [self getAgo:timeInt];
            
            UILabel *lbNewsTime = [[[UILabel alloc] initWithFrame:CGRectMake(190, NewsAgencyCellHeightOne-25, 55, 20)] autorelease];
            [lbNewsTime setText:timeStr];
            [lbNewsTime setTextColor:SeWordColor];
            [lbNewsTime setBackgroundColor:[UIColor clearColor]];
            [lbNewsTime setFont:[UIFont fontWithName:@"Helvetica" size:10]];
            [lbNewsTime setTextAlignment:UITextAlignmentRight];
            [lbNewsTime setLineBreakMode:NSLineBreakByTruncatingTail];
            [self addSubview:lbNewsTime];
            
            //点击
            UIImage *tuNumImage = [UIImage imageNamed:@"renNum.png"];
            NSString *newerNum = [NSString stringWithFormat:@"%@",news.hits];
            CGSize numSize = [newerNum sizeWithFont:[UIFont fontWithName:@"Helvetica" size:11]];
            
            UIImageView *tuNumImageView = [[UIImageView alloc] initWithFrame:CGRectMake(305-numSize.width-9-3, NewsAgencyCellHeight-29, 9, 9)];
            [tuNumImageView setImage:tuNumImage];
            [self addSubview:tuNumImageView];
            [tuNumImageView release];
            
            UILabel *lbNewsHits = [[[UILabel alloc] initWithFrame:CGRectMake(255, NewsAgencyCellHeightOne-25, 50, 20)] autorelease];
            [lbNewsHits setText:newerNum];
            [lbNewsHits setTextColor:SeWordColor];
            [lbNewsHits setBackgroundColor:[UIColor clearColor]];
            [lbNewsHits setFont:[UIFont fontWithName:@"Helvetica" size:10]];
            [lbNewsHits setTextAlignment:UITextAlignmentRight];
            [lbNewsHits setLineBreakMode:NSLineBreakByTruncatingTail];
            [self addSubview:lbNewsHits];
        }
        
    }
    return self;
}

- (NSString *)getAgo:(int)ago
{
	NSDate *begin = [NSDate dateWithTimeIntervalSince1970:ago];
    
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit| NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSCalendar *date = [NSCalendar currentCalendar];
    NSDateComponents *interval = [date components:unitFlags fromDate:begin toDate:[NSDate date] options:0];
	
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



@end
