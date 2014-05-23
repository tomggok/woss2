//
//  DYBImagePickerGroupCell.m
//  DYiBan
//
//  Created by Song on 13-9-6.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBImagePickerGroupCell.h"

@implementation DYBImagePickerGroupCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self) {
        /* Initialization */
        // Title
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        titleLabel.font = [DYBShareinstaceDelegate DYBFoutStyle:17];
        titleLabel.textColor = ColorBlack;
        titleLabel.highlightedTextColor = [UIColor whiteColor];
        titleLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
        
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        [titleLabel release];
        
        // Count
        UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        countLabel.font = [DYBShareinstaceDelegate DYBFoutStyle:17];
        countLabel.textColor = [UIColor colorWithWhite:0.498 alpha:1.0];
        countLabel.highlightedTextColor = [UIColor whiteColor];
        countLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        
        [self.contentView addSubview:countLabel];
        self.countLabel = countLabel;
        [countLabel release];
        
        {
            UIImage *arrowImage = [UIImage imageNamed:@"list_arrow"];
            DragonUIImageView *_arrowImv = [[DragonUIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-24, (self.frame.size.height-arrowImage.size.height/2)/2+5, arrowImage.size.width/2, arrowImage.size.height/2)];
            _arrowImv.image = arrowImage;
            [self addSubview:_arrowImv];
            RELEASE(_arrowImv);
        }
        
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    self.titleLabel.highlighted = selected;
    self.countLabel.highlighted = selected;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat height = self.contentView.bounds.size.height;
    CGFloat imageViewSize = height - 1;
    CGFloat width = self.contentView.bounds.size.width - 20;
    
    CGSize titleTextSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font forWidth:width lineBreakMode:NSLineBreakByTruncatingTail];
    CGSize countTextSize = [self.countLabel.text sizeWithFont:self.countLabel.font forWidth:width lineBreakMode:NSLineBreakByTruncatingTail];
    
    CGRect titleLabelFrame;
    CGRect countLabelFrame;
    
    if((titleTextSize.width + countTextSize.width + 10) > width) {
        titleLabelFrame = CGRectMake(imageViewSize + 10, 0, width - countTextSize.width - 10, imageViewSize);
        countLabelFrame = CGRectMake(titleLabelFrame.origin.x + titleLabelFrame.size.width + 10, 0, countTextSize.width, imageViewSize);
    } else {
        titleLabelFrame = CGRectMake(imageViewSize + 10, 0, titleTextSize.width, imageViewSize);
        countLabelFrame = CGRectMake(titleLabelFrame.origin.x + titleLabelFrame.size.width + 10, 0, countTextSize.width, imageViewSize);
    }
    
    self.titleLabel.frame = titleLabelFrame;
    self.countLabel.frame = countLabelFrame;
    
    
}

- (void)dealloc
{
    [_titleLabel release];
    [_countLabel release];
    
    [super dealloc];
}


@end
