//
//  DYBCellForTagList.m
//  DYiBan
//
//  Created by Hyde.Xu on 13-10-30.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBCellForTagList.h"
#import "tag_list_info.h"

@implementation DYBCellForTagList

-(void)setContent:(id)data indexPath:(NSIndexPath *)indexPath tbv:(UITableView *)tbv{
    if (data){
        float fHeight = 32.0f;
        tag_list_info *_tlinfo = data;
        
        UIImage *imgTagIcon = [UIImage imageNamed:@"icon_tag.png"];
        MagicUIImageView *viewTagIcon = [[MagicUIImageView alloc] initWithFrame:CGRectMake(10, 10, imgTagIcon.size.width/2, imgTagIcon.size.height/2)];
        [viewTagIcon setBackgroundColor:[UIColor clearColor]];
        [viewTagIcon setImage:imgTagIcon];
        [self addSubview:viewTagIcon];
        RELEASE(viewTagIcon);

        MagicUILabel *_lbTagName = [[MagicUILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(viewTagIcon.frame)+10, 3, 100, 30)];
        [_lbTagName setBackgroundColor:[UIColor clearColor]];
        [_lbTagName setTextAlignment:NSTextAlignmentLeft];
        [_lbTagName setFont:[DYBShareinstaceDelegate DYBFoutStyle:16]];
        [_lbTagName setText:_tlinfo.tag];
        [_lbTagName setTextColor:ColorBlack];
        [_lbTagName setNumberOfLines:1];
        [_lbTagName setLineBreakMode:NSLineBreakByTruncatingTail];
        [self addSubview:_lbTagName];
        RELEASE(_lbTagName);
        
        MagicUILabel *_lbTagCount = [[MagicUILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-130, CGRectGetMinY(_lbTagName.frame), 100, 30)];
        [_lbTagCount setBackgroundColor:[UIColor clearColor]];
        [_lbTagCount setTextAlignment:NSTextAlignmentRight];
        [_lbTagCount setFont:[DYBShareinstaceDelegate DYBFoutStyle:16]];
        [_lbTagCount setText:[NSString stringWithFormat:@"共 %d 条", [_tlinfo.count intValue]]];
        [_lbTagCount setTextColor:ColorGray];
        [_lbTagCount setNumberOfLines:1];
        [_lbTagCount setLineBreakMode:NSLineBreakByTruncatingTail];
        _lbTagCount.COLOR([NSString stringWithFormat:@"%d", 2], [NSString stringWithFormat:@"%d", [_lbTagCount.text length]-4], ColorBlack);
        [self addSubview:_lbTagCount];
        RELEASE(_lbTagCount);
        
        UIImage *imgListArrow = [UIImage imageNamed:@"list_arrow.png"];
        MagicUIImageView *viewListArrow = [[MagicUIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-25, 10, imgListArrow.size.width/2, imgListArrow.size.height/2)];
        [viewListArrow setBackgroundColor:[UIColor clearColor]];
        [viewListArrow setImage:imgListArrow];
        [self addSubview:viewListArrow];
        RELEASE(viewListArrow);
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, fHeight-1, self.frame.size.width, .5f)];
        [lineView setBackgroundColor:ColorDivLine];
        [self addSubview:lineView];
        RELEASE(lineView);
        
        [self setFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), fHeight)];
    }
}
@end
