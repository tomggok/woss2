//
//  DYBXinhuaNewsContentCellView.h
//  DYiBan
//
//  Created by Song on 13-9-11.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "news.h"
@interface DYBXinhuaNewsContentCellView : UIView<SDWebImageManagerDelegate>{
    UILabel *contentLabel;
    UIImageView *picView;
}

AS_SIGNAL(IMAGECLICKEEND);//点击图片
- (id)initWithFrame:(CGRect)frame news_info:(news *)news;
+(CGFloat )getHeightByNewsModel:(news *)model;

- (void)setImageWithURLXH:(NSURL *)url;

@end
