//
//  DYBXinhuaNewsTopicCellView.m
//  DYiBan
//
//  Created by Song on 13-9-11.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBXinhuaNewsTopicCellView.h"
#define NewsLeftWith   15
#define NewsTopHeight  10
#define NewSIconsWith  85

#define NewsTopCellLeftWidth    18
#define NewsTopCellTopWidth     10
#define NewsTopCellMidWidth     10
#define TimeLabelHeight         18

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

#define     ScreenWidth     320
#define     ScreenHeight    480
#define     NavHeight       44
#define     NormalScHeight   ScreenHeight-NavHeight-20


#define NewsMaxWidth   200
#define NewsScanHeight 36


@implementation DYBXinhuaNewsTopicCellView

- (id)initWithFrame:(CGRect)frame news_info:(news *)news;
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UILabel *titleLabel = [[[UILabel alloc] init] autorelease];
        UILabel *timeLabel = [[[UILabel alloc] init] autorelease];
        UIImageView *cellLine = [[[UIImageView alloc] init] autorelease];
        
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = SeWordColor;
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.text = news.title;
        titleLabel.font = NormalFont15Bold;
        titleLabel.numberOfLines = 5;
        CGSize titleSize = [titleLabel.text sizeWithFont:titleLabel.font
                                       constrainedToSize:CGSizeMake(ScreenWidth-2*NewsTopCellLeftWidth, 100)
                                           lineBreakMode:UILineBreakModeTailTruncation];
        titleLabel.frame = CGRectMake(NewsTopCellLeftWidth, NewsTopCellTopWidth, ScreenWidth-2*NewsTopCellLeftWidth, titleSize.height);
        
        
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.textColor = [UIColor colorWithRed:112/255.0 green:153/255.0 blue:165/255.0 alpha:1];
        timeLabel.textAlignment = UITextAlignmentCenter;
        
        NSDateFormatter* df = [[[NSDateFormatter alloc] init] autorelease];
        [df setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease]];
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//[inputFormatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm"];2010-08-03 22:46:01
        NSString *timeStr = [df stringFromDate:[NSDate dateWithTimeIntervalSince1970:[news.time intValue]]];
        
        if ([news.author length] > 0)
        {
            timeStr = [timeStr stringByAppendingFormat:@"  %@",news.author];
        }
        else
        {
            timeStr = timeStr;
        }
        
        timeLabel.text = timeStr;
        timeLabel.font = NormalFont14;
        timeLabel.frame = CGRectMake(NewsTopCellLeftWidth, titleLabel.frame.origin.y+titleLabel.frame.size.height+NewsTopCellMidWidth, ScreenWidth-2*NewsTopCellLeftWidth, TimeLabelHeight);
        
        cellLine.backgroundColor = [UIColor clearColor];
        cellLine.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cellLineSmall" ofType:@"png"]];
        cellLine.frame = CGRectMake(NewsTopCellLeftWidth, timeLabel.frame.origin.y+timeLabel.frame.size.height+NewsTopCellMidWidth, ScreenWidth-2*NewsTopCellLeftWidth, 2);
        
        
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self addSubview:titleLabel];
        [self addSubview:timeLabel];
        [self addSubview:cellLine];
    }
    return self;
}

+(CGFloat )getHeightByNewsModel:(news *)model
{
    CGFloat height = 0;
    
    CGSize titleSize = [model.title sizeWithFont:NormalFont15Bold
                               constrainedToSize:CGSizeMake(ScreenWidth-2*NewsTopCellLeftWidth, 100)
                                   lineBreakMode:UILineBreakModeTailTruncation];
    height = NewsTopCellTopWidth*3+titleSize.height+TimeLabelHeight+2;
    
    return height;
}


@end
