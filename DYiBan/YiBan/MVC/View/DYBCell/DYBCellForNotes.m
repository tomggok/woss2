//
//  DYBCellForNotes.m
//  DYiBan
//
//  Created by zhangchao on 13-10-30.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBCellForNotes.h"
#import "noteModel.h"
#import "UITableView+property.h"
#import "NSString+Count.h"
#import "UIView+MagicCategory.h"
#import "Tag.h"
#import "DYBUITabbarViewController.h"
#import "Magic_Device.h"
#import "UITableViewCell+MagicCategory.h"
#import "UILabel+ReSize.h"
@implementation DYBCellForNotes

@synthesize imgV_star=_imgV_star;

-(void)setContent:(id)data indexPath:(NSIndexPath *)indexPath tbv:(UITableView *)tbv
{
    //    self.accessoryType=UITableViewCellAccessoryDetailDisclosureButton;
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    self.index=[[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section] retain];

    if (data) {
        noteModel *model=data;
        
        switch (model.type) {
            case -1://月份cell
            {
                [self setFrame:CGRectMake(0, 0, self.frame.size.width, model.cellH)];
                self.backgroundColor=[UIColor yellowColor];

                if (!_lb_time) {
                    _lb_time=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(15, 0, 1000,30)];
                    _lb_time.backgroundColor=[UIColor whiteColor];
                    _lb_time.textAlignment=NSTextAlignmentLeft;
                    _lb_time.font=[UIFont systemFontOfSize:16];//[DYBShareinstaceDelegate DYBFoutStyle:18];
                    _lb_time.text=[NSString stringWithFormat:@"%d 月 • %d",[NSString getDateComponentsByTimeStamp:[model.create_time integerValue]].month,[NSString getDateComponentsByTimeStamp:[model.create_time integerValue]].year];
                    _lb_time.textColor=ColorBlack;
                    _lb_time.numberOfLines=0;
                    _lb_time.lineBreakMode=NSLineBreakByCharWrapping;
                    //        [_lb_content sizeToFitByconstrainedSize:CGSizeMake(200/*最宽*/, 1000)];
                    //        [_lb_content replaceEmojiandTarget:NO];
                    [self addSubview:_lb_time];
                    int mouthLength=([NSString getDateComponentsByTimeStamp:[model.create_time integerValue]].month)/10+1;//月份有几位
                    _lb_time.FONT(@"0",/*@"1"*/[NSString stringWithFormat:@"%d",mouthLength] ,@"20.f");
                    _lb_time.COLOR(/*@"4"*/[NSString stringWithFormat:@"%d",mouthLength+3],@"1",ColorGray);
                    [_lb_time setNeedCoretext:YES];
                    [_lb_time changePosInSuperViewWithAlignment:1];
                    
                    RELEASE(_lb_time);
                }
            }
                break;
            case -2://被搜索月无数据提示cell
            {
                [self setFrame:CGRectMake(0, 0, self.frame.size.width, model.cellH)];
                self.backgroundColor=[UIColor yellowColor];
                
                if (!_lb_time) {
                    _lb_time=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(15, 0, 1000,30)];
                    _lb_time.backgroundColor=[UIColor whiteColor];
                    _lb_time.textAlignment=NSTextAlignmentLeft;
                    _lb_time.font=[UIFont systemFontOfSize:16];//[DYBShareinstaceDelegate DYBFoutStyle:18];
                    _lb_time.text=[NSString stringWithFormat:@"以下是 %@ 之前的所有笔记",model.str_CalendarContent];
                    _lb_time.textColor=ColorBlack;
                    _lb_time.numberOfLines=1;
                    _lb_time.lineBreakMode=NSLineBreakByCharWrapping;
                    [_lb_time sizeToFitByconstrainedSize:CGSizeMake(400/*最宽*/, 100)];
                    //        [_lb_content replaceEmojiandTarget:NO];
                    [self addSubview:_lb_time];
//                    int mouthLength=([NSString getDateComponentsByTimeStamp:[model.create_time integerValue]].month)/10+1;//月份有几位
//                    _lb_time.FONT(@"0",/*@"1"*/[NSString stringWithFormat:@"%d",mouthLength] ,@"20.f");
//                    _lb_time.COLOR(/*@"4"*/[NSString stringWithFormat:@"%d",mouthLength+3],@"1",ColorGray);
//                    [_lb_time setNeedCoretext:YES];
                    [_lb_time changePosInSuperViewWithAlignment:1];
                    
                    RELEASE(_lb_time);
                }
                
                if (!_bt_delete) {
//                    UIImage *img= [UIImage imageNamed:@"note_del_def"];
                    _bt_delete = [[MagicUIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-60, 0,60, 30)];
                    _bt_delete.tag=-8;
                    _bt_delete.backgroundColor=[UIColor clearColor];//self.headview.backgroundColor;
                    //            _bt_DropDown.alpha=0.9;
                    [_bt_delete addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside object:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
//                    [_bt_delete setImage:img forState:UIControlStateNormal];
//                    [_bt_delete setImage:[UIImage imageNamed:@"note_del_def"] forState:UIControlStateHighlighted];
                    [_bt_delete setTitle:@"取消筛选"];
                    [_bt_delete setTitleColor:[UIColor blackColor]];
                    [_bt_delete setTitleFont:[DYBShareinstaceDelegate DYBFoutStyle:11]];
                    //            [_bt_delete setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
                    [self addSubview:_bt_delete];
                    [_bt_delete changePosInSuperViewWithAlignment:1];
                    RELEASE(_bt_delete);
                    //                    _bt_delete.hidden=YES;
                }
            }
                break;
            case -3://完全无数据
            {
                [self setFrame:CGRectMake(0, 0, self.frame.size.width, model.cellH)];
                self.backgroundColor=[UIColor yellowColor];
                
                if (!_lb_time) {
                    _lb_time=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(15, 0, 1000,30)];
                    _lb_time.backgroundColor=[UIColor whiteColor];
                    _lb_time.textAlignment=NSTextAlignmentLeft;
                    _lb_time.font=[UIFont systemFontOfSize:16];//[DYBShareinstaceDelegate DYBFoutStyle:18];
                    _lb_time.text=[NSString stringWithFormat:@"%@ 之前您没有笔记",model.str_CalendarContent];
                    _lb_time.textColor=ColorBlack;
                    _lb_time.numberOfLines=1;
                    _lb_time.lineBreakMode=NSLineBreakByCharWrapping;
                    [_lb_time sizeToFitByconstrainedSize:CGSizeMake(400/*最宽*/, 100)];
                    //        [_lb_content replaceEmojiandTarget:NO];
                    [self addSubview:_lb_time];
                    //                    int mouthLength=([NSString getDateComponentsByTimeStamp:[model.create_time integerValue]].month)/10+1;//月份有几位
                    //                    _lb_time.FONT(@"0",/*@"1"*/[NSString stringWithFormat:@"%d",mouthLength] ,@"20.f");
                    //                    _lb_time.COLOR(/*@"4"*/[NSString stringWithFormat:@"%d",mouthLength+3],@"1",ColorGray);
                    //                    [_lb_time setNeedCoretext:YES];
                    [_lb_time changePosInSuperViewWithAlignment:1];
                    
                    RELEASE(_lb_time);
                }
                
                if (!_bt_delete) {
                    //                    UIImage *img= [UIImage imageNamed:@"note_del_def"];
                    _bt_delete = [[MagicUIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-60, 0,60, 30)];
                    _bt_delete.tag=-8;
                    _bt_delete.backgroundColor=[UIColor clearColor];//self.headview.backgroundColor;
                    //            _bt_DropDown.alpha=0.9;
                    [_bt_delete addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside object:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
                    //                    [_bt_delete setImage:img forState:UIControlStateNormal];
                    //                    [_bt_delete setImage:[UIImage imageNamed:@"note_del_def"] forState:UIControlStateHighlighted];
                    [_bt_delete setTitle:@"取消筛选"];
                    [_bt_delete setTitleColor:[UIColor blackColor]];
                    [_bt_delete setTitleFont:[DYBShareinstaceDelegate DYBFoutStyle:11]];
//                    _bt_delete.layer.masksToBounds=YES;
//                    _bt_delete.layer.borderWidth=1;
//                    _bt_delete.layer.borderColor=ColorBlue.CGColor;
                    //            [_bt_delete setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
                    [self addSubview:_bt_delete];
                    [_bt_delete changePosInSuperViewWithAlignment:1];
                    RELEASE(_bt_delete);
                    //                    _bt_delete.hidden=YES;
                }
            }
                break;
            case 0://笔记cell
            {
                [self setFrame:CGRectMake(0, 0, self.frame.size.width, model.cellH)];
                
                if (!_bt_delete) {
                    UIImage *img= [UIImage imageNamed:@"note_del_def"];
                    _bt_delete = [[MagicUIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-img.size.width/2-15, 0,img.size.width/2, img.size.height/2)];
                    _bt_delete.tag=-3;
                    _bt_delete.backgroundColor=[UIColor clearColor];//self.headview.backgroundColor;
                    //            _bt_DropDown.alpha=0.9;
                    [_bt_delete addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside object:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
                    [_bt_delete setImage:img forState:UIControlStateNormal];
                    [_bt_delete setImage:[UIImage imageNamed:@"note_del_def"] forState:UIControlStateHighlighted];
                    //            [_bt_delete setTitle:@"删除"];
                    //            [_bt_delete setTitleColor:[UIColor blackColor]];
                    //            [_bt_delete setTitleFont:[DYBShareinstaceDelegate DYBFoutStyle:16]];
                    //            [_bt_delete setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
                    [self addSubview:_bt_delete];
                    [_bt_delete changePosInSuperViewWithAlignment:1];
                    RELEASE(_bt_delete);
//                    _bt_delete.hidden=YES;
                }
                
                if (!_bt_favorite) {//星标
                    UIImage *img= [UIImage imageNamed:@"note_star_def"];
                    _bt_favorite = [[MagicUIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(_bt_delete.frame)-30-img.size.width/2, CGRectGetMinY(_bt_delete.frame),img.size.width/2, img.size.height/2)];
                    _bt_favorite.tag=-4;
                    _bt_favorite.backgroundColor=[UIColor clearColor];//self.headview.backgroundColor;
                    //            _bt_DropDown.alpha=0.9;
                    [_bt_favorite addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside object:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
                    [_bt_favorite setImage:img forState:UIControlStateNormal];
                    [_bt_favorite setImage:[UIImage imageNamed:@"note_star_def"] forState:UIControlStateHighlighted];
                    //            [_bt_delete setTitle:@"删除"];
                    //            [_bt_delete setTitleColor:[UIColor blackColor]];
                    //            [_bt_delete setTitleFont:[DYBShareinstaceDelegate DYBFoutStyle:16]];
                    //            [_bt_delete setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
                    [self addSubview:_bt_favorite];
//                    [_bt_delete changePosInSuperViewWithAlignment:1];
                    RELEASE(_bt_favorite);
//                    _bt_favorite.hidden=YES;
                }
                
                if (!_bt_gotoDataBase) {//转存
                    UIImage *img= [UIImage imageNamed:@"note_move_def"];
                    _bt_gotoDataBase = [[MagicUIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(_bt_favorite.frame)-15-img.size.width/2, CGRectGetMinY(_bt_delete.frame),img.size.width/2, img.size.height/2)];
                    _bt_gotoDataBase.tag=-5;
                    _bt_gotoDataBase.backgroundColor=[UIColor clearColor];//self.headview.backgroundColor;
                    //            _bt_DropDown.alpha=0.9;
                    [_bt_gotoDataBase addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside object:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
                    [_bt_gotoDataBase setImage:img forState:UIControlStateNormal];
                    [_bt_gotoDataBase setImage:img forState:UIControlStateHighlighted];
                    //            [_bt_delete setTitle:@"删除"];
                    //            [_bt_delete setTitleColor:[UIColor blackColor]];
                    //            [_bt_delete setTitleFont:[DYBShareinstaceDelegate DYBFoutStyle:16]];
                    //            [_bt_delete setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
                    [self addSubview:_bt_gotoDataBase];
                    //                    [_bt_delete changePosInSuperViewWithAlignment:1];
                    RELEASE(_bt_gotoDataBase);
                    //                    _bt_favorite.hidden=YES;
                }
                
                if (!_bt_share) {//共享
                    UIImage *img= [UIImage imageNamed:@"note_share_def"];
                    _bt_share = [[MagicUIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(_bt_gotoDataBase.frame)-20-img.size.width/2, CGRectGetMinY(_bt_delete.frame),img.size.width/2, img.size.height/2)];
                    _bt_share.tag=-6;
                    _bt_share.backgroundColor=[UIColor clearColor];//self.headview.backgroundColor;
                    //            _bt_DropDown.alpha=0.9;
                    [_bt_share addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside object:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
                    [_bt_share setImage:img forState:UIControlStateNormal];
                    [_bt_share setImage:img forState:UIControlStateHighlighted];
                    //            [_bt_delete setTitle:@"删除"];
                    //            [_bt_delete setTitleColor:[UIColor blackColor]];
                    //            [_bt_delete setTitleFont:[DYBShareinstaceDelegate DYBFoutStyle:16]];
                    //            [_bt_delete setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
                    [self addSubview:_bt_share];
                    //                    [_bt_delete changePosInSuperViewWithAlignment:1];
                    RELEASE(_bt_share);
                    //                    _bt_favorite.hidden=YES;
                    
                }
                
                if (!_v_toBeSlidingView) {
                    _v_toBeSlidingView=[[MagicUIImageView alloc]initWithFrame:self.bounds];
                    _v_toBeSlidingView.image=[UIImage imageNamed:@"bg_note"];
                    _v_toBeSlidingView._originFrame=CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
//                    _v_toBeSlidingView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_note"]];
                    [self addSubview:_v_toBeSlidingView];
                    RELEASE(_v_toBeSlidingView);
                    _v_toBeSlidingView.userInteractionEnabled=YES;
                    _v_toBeSlidingView.moveMax_x=CGRectGetWidth(_v_toBeSlidingView.frame);
                    
                    [self addSignal:[UIView PAN] object:[NSDictionary dictionaryWithObjectsAndKeys:tbv,@"tbv",[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section],@"indexPath", nil] target:self];
                    [self addSignal:[UIView TAP] object:[NSDictionary dictionaryWithObjectsAndKeys:tbv,@"tbv",[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section],@"indexPath", nil] target:self];//此句执行完后,self.retainCount=3
                }
                
                {/*标签的背景滚动*/
                    _scrV_Tip = [[MagicUIScrollView alloc] initWithFrame:CGRectMake(15, 0, CGRectGetWidth(self.frame)-30, 40)];
                    [_scrV_Tip setBackgroundColor:[UIColor clearColor]];
                    [_scrV_Tip setContentSize:CGSizeMake(0, CGRectGetHeight(_scrV_Tip.frame))];
                    [_scrV_Tip setShowsHorizontalScrollIndicator:NO];
                    [_scrV_Tip setScrollEnabled:NO];
                    [_v_toBeSlidingView addSubview:_scrV_Tip];
                    RELEASE(_scrV_Tip);
                }
                
                for (int i=0; i<model.taglist.count; i++) {
                    Tag *model2=[Tag JSONReflection:[model.taglist objectAtIndex:i]];
                    
                    {
                        DYBCustomLabel *lb=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(_scrV_Tip.contentSize.width+10, 0, 0,0)];
                        lb.backgroundColor=[UIColor clearColor];
                        lb.textAlignment=NSTextAlignmentLeft;
                        lb.font=[UIFont systemFontOfSize:14];//[DYBShareinstaceDelegate DYBFoutStyle:18];
                        lb.text=model2.tag;
                        lb.textColor=ColorWhite;
                        lb.numberOfLines=1;
                        lb.lineBreakMode=NSLineBreakByCharWrapping;
                        [lb sizeToFitByconstrainedSize:CGSizeMake(CGRectGetWidth(_scrV_Tip.frame), CGRectGetHeight(_scrV_Tip.frame))];
//                        [lb replaceEmojiandTarget:NO];
                        [_scrV_Tip addSubview:lb];
//                        int mouthLength=([NSString getDateComponentsByTimeStamp:[model.create_time integerValue]].month)/10+1;//月份有几位
//                        _lb_time.FONT(@"0",/*@"1"*/[NSString stringWithFormat:@"%d",mouthLength] ,@"20.f");
//                        _lb_time.COLOR(/*@"4"*/[NSString stringWithFormat:@"%d",mouthLength+3],@"1",ColorGray);
//                        [_lb_time setNeedCoretext:YES];
                        [lb changePosInSuperViewWithAlignment:1];
                        
                        RELEASE(lb);
                        
                        {
                            UIView *v_lbBack=[[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(lb.frame)-3, CGRectGetMinY(lb.frame)-3, CGRectGetWidth(lb.frame)+6, CGRectGetHeight(lb.frame)+6)];
                            v_lbBack.layer.masksToBounds=YES;
                            v_lbBack.layer.cornerRadius=4;
                            v_lbBack.backgroundColor=ColorBlue;
                            [_scrV_Tip addSubview:v_lbBack];
                            RELEASE(v_lbBack);
                            [_scrV_Tip bringSubviewToFront:lb];
                        }
                        
                        _scrV_Tip.contentSize=CGSizeMake(CGRectGetMaxX(lb.frame)+10, CGRectGetHeight(_scrV_Tip.frame));
                        if (_scrV_Tip.contentSize.width>CGRectGetWidth(_scrV_Tip.frame)) {
                            _scrV_Tip.scrollEnabled=YES;
                        }
                    }
                    
                }
                
                if (model.taglist.count==0 || !model.taglist) {//没标签
                    {
                        DYBCustomLabel *lb=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(0, 0, 0,0)];
                        lb.backgroundColor=[UIColor clearColor];
                        lb.textAlignment=NSTextAlignmentLeft;
                        lb.font=[UIFont systemFontOfSize:14];//[DYBShareinstaceDelegate DYBFoutStyle:18];
                        //                            lb.text=@"添加标签";
                        lb.text=@"无标签...";

                        lb.textColor=ColorGray;
                        lb.numberOfLines=1;
                        lb.lineBreakMode=NSLineBreakByCharWrapping;
                        [lb sizeToFitByconstrainedSize:CGSizeMake(CGRectGetWidth(_scrV_Tip.frame), CGRectGetHeight(_scrV_Tip.frame))];
                        //                        [lb replaceEmojiandTarget:NO];
                        [_scrV_Tip addSubview:lb];
                        //                        int mouthLength=([NSString getDateComponentsByTimeStamp:[model.create_time integerValue]].month)/10+1;//月份有几位
                        //                        _lb_time.FONT(@"0",/*@"1"*/[NSString stringWithFormat:@"%d",mouthLength] ,@"20.f");
                        //                        _lb_time.COLOR(/*@"4"*/[NSString stringWithFormat:@"%d",mouthLength+3],@"1",ColorGray);
                        //                        [_lb_time setNeedCoretext:YES];
                        [lb changePosInSuperViewWithAlignment:1];
                        
                        RELEASE(lb);
                    }
                }
                
                {//标签下的横线
                    UIView *v=[[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(_scrV_Tip.frame), CGRectGetMaxY(_scrV_Tip.frame), self.frame.size.width-CGRectGetMinX(_scrV_Tip.frame), 0.5)];
                    [v setBackgroundColor:ColorCellSepL];
                    v_line=v;
                    [_v_toBeSlidingView addSubview:v];
                    v.hidden=YES;
                    RELEASE(v);
                    
                    {//内容
                        _lb_newContent=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_scrV_Tip.frame), CGRectGetMaxY(v.frame)+10, (([model.file_type intValue]==1 || [model.file_type intValue]==2)?(210):(290)),1110)];
                        _lb_newContent.backgroundColor=[UIColor clearColor];
                        _lb_newContent.textAlignment=NSTextAlignmentLeft;
                        _lb_newContent.font=[DYBShareinstaceDelegate DYBFoutStyle:13];
                        _lb_newContent.text=model.title ;  //@"dwqd我带我去的千万当前味道气味大青蛙大青蛙完全但我却完全但我却大青蛙完全但我却带我去的完全但我却完全大青蛙完全大青蛙大青蛙完全大青[难过][难过][难过][难过][难过][敲打][敲打][难过][敲打]蛙去我的但我却蛙去我的但我却蛙去我的但我却蛙去我的但我却蛙去我的但我却蛙去我的但我却蛙去我的但我却蛙去我的但我却";// ;
                        _lb_newContent.textColor=ColorBlack;
                        _lb_newContent.maxLineNum=3;//只一行
                        [_lb_newContent sizeToFitByconstrainedSize:CGSizeMake(CGRectGetWidth(_lb_newContent.frame), 1000)];
                        _lb_newContent.lineBreakMode=NSLineBreakByCharWrapping;
                        [_lb_newContent setImgType:-1];
                        [_lb_newContent replaceEmojiandTarget:NO];
                        
//                        if (![NSString isContainsEmoji:_lb_newContent.text]) {
//                            [_lb_newContent setFrame:CGRectMake(CGRectGetMinX(_lb_newContent.frame), CGRectGetMinY(_lb_newContent.frame)+3, CGRectGetWidth(_lb_newContent.frame), CGRectGetHeight(_lb_newContent.frame))];
//                        }
                        
                        [_v_toBeSlidingView addSubview:_lb_newContent];
                        //            [_lb_newContent setNeedCoretext:YES];
                        
                        //        [_lb_nickName changePosInSuperViewWithAlignment:1];
                        RELEASE(_lb_newContent);
                        
                        if (CGRectGetMaxY(_lb_newContent.frame)+10+20>CGRectGetHeight(self.frame)) {
                            [self setFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), /*CGRectGetHeight(self.frame)+(CGRectGetMaxY(_lb_newContent.frame)+10+20-CGRectGetHeight(self.frame))*/ 160)];
                            [_v_toBeSlidingView setFrame:self.bounds];
                            _v_toBeSlidingView._originFrame=CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
                            [_bt_delete changePosInSuperViewWithAlignment:1];
                        }
                    }
                    
                    if ([_lb_newContent.text isEqualToString:@""] || !_lb_newContent.text) {//无内容
                        {
                            DYBCustomLabel *lb=[[DYBCustomLabel alloc]initWithFrame:_lb_newContent.frame];
                            lb.backgroundColor=[UIColor clearColor];
                            lb.textAlignment=NSTextAlignmentLeft;
                            lb.font=[UIFont systemFontOfSize:13];//[DYBShareinstaceDelegate DYBFoutStyle:18];
                            //                            lb.text=@"添加标签";
                            lb.text=@"无内容...";
                            
                            lb.textColor=ColorGray;
                            lb.numberOfLines=1;
                            lb.lineBreakMode=NSLineBreakByCharWrapping;
                            [lb sizeToFitByconstrainedSize:CGSizeMake(CGRectGetWidth(_scrV_Tip.frame), CGRectGetHeight(_scrV_Tip.frame))];
                            //                        [lb replaceEmojiandTarget:NO];
                            [_v_toBeSlidingView addSubview:lb];
                            //                        int mouthLength=([NSString getDateComponentsByTimeStamp:[model.create_time integerValue]].month)/10+1;//月份有几位
                            //                        _lb_time.FONT(@"0",/*@"1"*/[NSString stringWithFormat:@"%d",mouthLength] ,@"20.f");
                            //                        _lb_time.COLOR(/*@"4"*/[NSString stringWithFormat:@"%d",mouthLength+3],@"1",ColorGray);
                            //                        [_lb_time setNeedCoretext:YES];
                            [lb changePosInSuperViewWithAlignment:1];
                            
                            RELEASE(lb);
                        }
                    }
                }
                
                if (!_lb_time) {//创建时间
                    _lb_time=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_scrV_Tip.frame), CGRectGetHeight(self.frame)-20, 0,0)];
                    _lb_time.backgroundColor=[UIColor clearColor];
                    _lb_time.textAlignment=NSTextAlignmentLeft;
                    _lb_time.font=[DYBShareinstaceDelegate DYBFoutStyle:13];//[DYBShareinstaceDelegate DYBFoutStyle:18];
                    _lb_time.text=[NSString stringWithFormat:@"%d-%d-%d %d:%d",[NSString getDateComponentsByTimeStamp:[model.create_time integerValue]].year,[NSString getDateComponentsByTimeStamp:[model.create_time integerValue]].month,[NSString getDateComponentsByTimeStamp:[model.create_time integerValue]].day,[NSString getDateComponentsByTimeStamp:[model.create_time integerValue]].hour,[NSString getDateComponentsByTimeStamp:[model.create_time integerValue]].minute];
                    _lb_time.textColor=ColorGray;
                    _lb_time.numberOfLines=1;
                    _lb_time.lineBreakMode=NSLineBreakByCharWrapping;
                    [_lb_time sizeToFitByconstrainedSize:CGSizeMake(200/*最宽*/, 100)];
//                    [_lb_time replaceEmojiandTarget:NO];
                    [_v_toBeSlidingView addSubview:_lb_time];
//                    int mouthLength=([NSString getDateComponentsByTimeStamp:[model.create_time integerValue]].month)/10+1;//月份有几位
//                    _lb_time.FONT(@"0",/*@"1"*/[NSString stringWithFormat:@"%d",mouthLength] ,@"20.f");
//                    _lb_time.COLOR(/*@"4"*/[NSString stringWithFormat:@"%d",mouthLength+3],@"1",ColorGray);
//                    [_lb_time setNeedCoretext:YES];
//                    [_lb_time changePosInSuperViewWithAlignment:1];
                    
                    RELEASE(_lb_time);
                }
                
                if (!_imgV_star) {
                    
                    NSString *imgName = @"";
                    if ([[model.favorite description] isEqualToString:@"1"])
                    {
                        imgName = @"star_note";
                    }else
                    {
                        imgName = @"star_none_note";
                    }
                    
                    UIImage *img=[UIImage imageNamed:imgName];
                    _imgV_star=[[MagicUIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_lb_time.frame)+15,CGRectGetMinY(_lb_time.frame)-1, img.size.width/2,img.size.height/2) backgroundColor:[UIColor clearColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:YES masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:_v_toBeSlidingView Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
                    RELEASE(_imgV_star);
                    
                    [_imgV_star creatExpandGestureAreaView];
                    _imgV_star.v_expandGestureArea.tag=1;
                    [_imgV_star.v_expandGestureArea addSignal:[UIView TAP] object:[NSDictionary dictionaryWithObjectsAndKeys:model,@"model",indexPath,@"indexPath", nil] target:[self viewController]];
                }
                
                if (!imgV_show) {//缩略图
                    UIImage *img=nil;
                    switch ([model.file_type intValue]) {
                        case 1://图片
                        {
                            img=[UIImage imageNamed:@"icon_photo.png"];

                        }
                            break;
                        case 2://音频
                        {
                            img=[UIImage imageNamed:@"icon_music.png"];
                        }
                            break;
                        default://没附件就不创建 缩略图,把内容加宽
                        {

                            {//指示箭头
                                UIImage *img=[UIImage imageNamed:@"arrow_more"];
                                MagicUIImageView *imgV=[[MagicUIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-65,CGRectGetMinY(_lb_time.frame), img.size.width/2,img.size.height/2) backgroundColor:[UIColor clearColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:YES masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:_v_toBeSlidingView Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
                                RELEASE(imgV);
                            }
                            
                            goto last;
                        }
                            break;
                    }
                    imgV_show=[[MagicUIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-80,CGRectGetMaxY(v_line.frame)+5, img.size.width/2,img.size.height/2) backgroundColor:[UIColor clearColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:YES masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:_v_toBeSlidingView Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
                    RELEASE(imgV_show);
                    
                    {//指示箭头
                        UIImage *img=[UIImage imageNamed:@"arrow_more"];
                        MagicUIImageView *imgV=[[MagicUIImageView alloc]initWithFrame:CGRectMake(CGRectGetMidX(imgV_show.frame)-img.size.width/4,CGRectGetMinY(_lb_time.frame), img.size.width/2,img.size.height/2) backgroundColor:[UIColor clearColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:YES masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:_v_toBeSlidingView Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
                        RELEASE(imgV);
                    }
                 
                }
                
            }
                break;
            case 1://共享
            {
                [self setFrame:CGRectMake(0, 0, self.frame.size.width, model.cellH)];
                
                if (!_bt_gotoDataBase) {//转存到笔记
                    UIImage *img= [UIImage imageNamed:@"note_tomynote_def"];
                    _bt_gotoDataBase = [[MagicUIButton alloc] initWithFrame:CGRectMake((self.frame.size.width-img.size.width/2)/2, (self.frame.size.height-img.size.height/2)/2,img.size.width/2, img.size.height/2)];
                    _bt_gotoDataBase.tag=-3;
                    _bt_gotoDataBase.backgroundColor=[UIColor clearColor];//self.headview.backgroundColor;
                    //            _bt_DropDown.alpha=0.9;
                    [_bt_gotoDataBase addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside object:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
                    [_bt_gotoDataBase setImage:img forState:UIControlStateNormal];
                    [_bt_gotoDataBase setImage:img forState:UIControlStateHighlighted];
                    [self addSubview:_bt_gotoDataBase];
                    RELEASE(_bt_gotoDataBase);
                }
                
                if (!_v_toBeSlidingView) {
                    _v_toBeSlidingView=[[MagicUIImageView alloc]initWithFrame:self.bounds];
                    _v_toBeSlidingView.image=[UIImage imageNamed:@"bg_note"];
                    _v_toBeSlidingView._originFrame=CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
                    _v_toBeSlidingView.backgroundColor=ColorGray;
                    [self addSubview:_v_toBeSlidingView];
                    RELEASE(_v_toBeSlidingView);
                    _v_toBeSlidingView.userInteractionEnabled=YES;
                    _v_toBeSlidingView.moveMax_x=CGRectGetWidth(_v_toBeSlidingView.frame);
                    
                    [self addSignal:[UIView PAN] object:[NSDictionary dictionaryWithObjectsAndKeys:tbv,@"tbv",[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section],@"indexPath", nil] target:self];
                    [self addSignal:[UIView TAP] object:[NSDictionary dictionaryWithObjectsAndKeys:tbv,@"tbv",[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section],@"indexPath", nil] target:self];//此句执行完后,self.retainCount=3
                }
                
                {/*标签的背景滚动*/
                    _scrV_Tip = [[MagicUIScrollView alloc] initWithFrame:CGRectMake(15, 0, CGRectGetWidth(self.frame)-30, 40)];
                    [_scrV_Tip setBackgroundColor:[UIColor clearColor]];
                    [_scrV_Tip setContentSize:CGSizeMake(0, CGRectGetHeight(_scrV_Tip.frame))];
                    [_scrV_Tip setShowsHorizontalScrollIndicator:NO];
                    [_scrV_Tip setScrollEnabled:NO];
                    [_v_toBeSlidingView addSubview:_scrV_Tip];
                    RELEASE(_scrV_Tip);
                }
                
                for (int i=0; i<model.taglist.count; i++) {
                    Tag *model2=[Tag JSONReflection:[model.taglist objectAtIndex:i]];
                    
                    {
                        DYBCustomLabel *lb=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(_scrV_Tip.contentSize.width+10, 0, 0,0)];
                        lb.backgroundColor=[UIColor clearColor];
                        lb.textAlignment=NSTextAlignmentLeft;
                        lb.font=[UIFont systemFontOfSize:14];//[DYBShareinstaceDelegate DYBFoutStyle:18];
                        lb.text=model2.tag;
                        lb.textColor=ColorWhite;
                        lb.numberOfLines=1;
                        lb.lineBreakMode=NSLineBreakByCharWrapping;
                        [lb sizeToFitByconstrainedSize:CGSizeMake(CGRectGetWidth(_scrV_Tip.frame), CGRectGetHeight(_scrV_Tip.frame))];
                        //                        [lb replaceEmojiandTarget:NO];
                        [_scrV_Tip addSubview:lb];
                        //                        int mouthLength=([NSString getDateComponentsByTimeStamp:[model.create_time integerValue]].month)/10+1;//月份有几位
                        //                        _lb_time.FONT(@"0",/*@"1"*/[NSString stringWithFormat:@"%d",mouthLength] ,@"20.f");
                        //                        _lb_time.COLOR(/*@"4"*/[NSString stringWithFormat:@"%d",mouthLength+3],@"1",ColorGray);
                        //                        [_lb_time setNeedCoretext:YES];
                        [lb changePosInSuperViewWithAlignment:1];
                        
                        RELEASE(lb);
                        
                        {
                            UIView *v_lbBack=[[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(lb.frame)-3, CGRectGetMinY(lb.frame)-3, CGRectGetWidth(lb.frame)+6, CGRectGetHeight(lb.frame)+6)];
                            v_lbBack.layer.masksToBounds=YES;
                            v_lbBack.layer.cornerRadius=4;
                            v_lbBack.backgroundColor=ColorBlue;
                            [_scrV_Tip addSubview:v_lbBack];
                            RELEASE(v_lbBack);
                            [_scrV_Tip bringSubviewToFront:lb];
                        }
                        
                        _scrV_Tip.contentSize=CGSizeMake(CGRectGetMaxX(lb.frame)+10, CGRectGetHeight(_scrV_Tip.frame));
                        if (_scrV_Tip.contentSize.width>CGRectGetWidth(_scrV_Tip.frame)) {
                            _scrV_Tip.scrollEnabled=YES;
                        }
                    }
                    
                }
                
                if (model.taglist.count==0 || !model.taglist) {//没标签
                    {
                        DYBCustomLabel *lb=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(0, 0, 0,0)];
                        lb.backgroundColor=[UIColor clearColor];
                        lb.textAlignment=NSTextAlignmentLeft;
                        lb.font=[UIFont systemFontOfSize:14];//[DYBShareinstaceDelegate DYBFoutStyle:18];
                        //                            lb.text=@"添加标签";
                        lb.text=@"无标签...";
                        
                        lb.textColor=ColorGray;
                        lb.numberOfLines=1;
                        lb.lineBreakMode=NSLineBreakByCharWrapping;
                        [lb sizeToFitByconstrainedSize:CGSizeMake(CGRectGetWidth(_scrV_Tip.frame), CGRectGetHeight(_scrV_Tip.frame))];
                        //                        [lb replaceEmojiandTarget:NO];
                        [_scrV_Tip addSubview:lb];
                        //                        int mouthLength=([NSString getDateComponentsByTimeStamp:[model.create_time integerValue]].month)/10+1;//月份有几位
                        //                        _lb_time.FONT(@"0",/*@"1"*/[NSString stringWithFormat:@"%d",mouthLength] ,@"20.f");
                        //                        _lb_time.COLOR(/*@"4"*/[NSString stringWithFormat:@"%d",mouthLength+3],@"1",ColorGray);
                        //                        [_lb_time setNeedCoretext:YES];
                        [lb changePosInSuperViewWithAlignment:1];
                        
                        RELEASE(lb);
                    }
                }
                
                {//标签下的横线
                    UIView *v=[[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(_scrV_Tip.frame), CGRectGetMaxY(_scrV_Tip.frame), self.frame.size.width-CGRectGetMinX(_scrV_Tip.frame), 0.5)];
                    [v setBackgroundColor:ColorCellSepL];
                    v_line=v;
                    [_v_toBeSlidingView addSubview:v];
                    RELEASE(v);
                    
                    {//内容
                        _lb_newContent=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_scrV_Tip.frame), CGRectGetMaxY(v.frame)+10, (([model.file_type intValue]==1 || [model.file_type intValue]==2)?(210):(290)),0)];
                        _lb_newContent.backgroundColor=[UIColor clearColor];
                        _lb_newContent.textAlignment=NSTextAlignmentLeft;
                        _lb_newContent.font=[DYBShareinstaceDelegate DYBFoutStyle:13];
                        _lb_newContent.text=model.title ; //@"dwqd我带我去的千万当前味道气味大青蛙大青蛙完全但我却完全但我却大青蛙完全但我却带我去的完全但我却完全大青蛙完全大青蛙大青蛙完全大青[难过][难过][难过][难过][难过][敲打][敲打][难过][敲打]蛙去我的但我却";// ;
                        _lb_newContent.textColor=ColorBlack;
                        _lb_newContent.maxLineNum=3;//只一行
                        [_lb_newContent sizeToFitByconstrainedSize:CGSizeMake(CGRectGetWidth(_lb_newContent.frame), 1000)];
                        _lb_newContent.lineBreakMode=NSLineBreakByCharWrapping;
                        [_lb_newContent setImgType:-1];
                        [_lb_newContent replaceEmojiandTarget:NO];
                        
                        //                        if (![NSString isContainsEmoji:_lb_newContent.text]) {
                        //                            [_lb_newContent setFrame:CGRectMake(CGRectGetMinX(_lb_newContent.frame), CGRectGetMinY(_lb_newContent.frame)+3, CGRectGetWidth(_lb_newContent.frame), CGRectGetHeight(_lb_newContent.frame))];
                        //                        }
                        
                        [_v_toBeSlidingView addSubview:_lb_newContent];
                        //            [_lb_newContent setNeedCoretext:YES];
                        
                        //        [_lb_nickName changePosInSuperViewWithAlignment:1];
                        RELEASE(_lb_newContent);
                        
                        if (CGRectGetMaxY(_lb_newContent.frame)+10+20>CGRectGetHeight(self.frame)) {
                            [self setFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), /*CGRectGetHeight(self.frame)+(CGRectGetMaxY(_lb_newContent.frame)+10+20-CGRectGetHeight(self.frame))*/ 160)];
                            [_v_toBeSlidingView setFrame:self.bounds];
                            _v_toBeSlidingView._originFrame=CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
                            [_bt_delete changePosInSuperViewWithAlignment:1];
                        }
                    }
                    if ([_lb_newContent.text isEqualToString:@""] || !_lb_newContent.text) {//无内容
                        {
                            DYBCustomLabel *lb=[[DYBCustomLabel alloc]initWithFrame:_lb_newContent.frame];
                            lb.backgroundColor=[UIColor clearColor];
                            lb.textAlignment=NSTextAlignmentLeft;
                            lb.font=[UIFont systemFontOfSize:13];//[DYBShareinstaceDelegate DYBFoutStyle:18];
                            //                            lb.text=@"添加标签";
                            lb.text=@"无内容...";
                            
                            lb.textColor=ColorGray;
                            lb.numberOfLines=1;
                            lb.lineBreakMode=NSLineBreakByCharWrapping;
                            [lb sizeToFitByconstrainedSize:CGSizeMake(CGRectGetWidth(_scrV_Tip.frame), CGRectGetHeight(_scrV_Tip.frame))];
                            //                        [lb replaceEmojiandTarget:NO];
                            [_v_toBeSlidingView addSubview:lb];
                            //                        int mouthLength=([NSString getDateComponentsByTimeStamp:[model.create_time integerValue]].month)/10+1;//月份有几位
                            //                        _lb_time.FONT(@"0",/*@"1"*/[NSString stringWithFormat:@"%d",mouthLength] ,@"20.f");
                            //                        _lb_time.COLOR(/*@"4"*/[NSString stringWithFormat:@"%d",mouthLength+3],@"1",ColorGray);
                            //                        [_lb_time setNeedCoretext:YES];
                            [lb changePosInSuperViewWithAlignment:1];
                            
                            RELEASE(lb);
                        }
                    }
                }
                
                if (!_lb_time) {//创建时间
                    _lb_time=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_scrV_Tip.frame), CGRectGetHeight(self.frame)-20, 0,0)];
                    _lb_time.backgroundColor=[UIColor clearColor];
                    _lb_time.textAlignment=NSTextAlignmentLeft;
                    _lb_time.font=[DYBShareinstaceDelegate DYBFoutStyle:13];//[DYBShareinstaceDelegate DYBFoutStyle:18];
                    _lb_time.text=[NSString stringWithFormat:@"%d-%d-%d",[NSString getDateComponentsByTimeStamp:[model.create_time integerValue]].year,[NSString getDateComponentsByTimeStamp:[model.create_time integerValue]].month,[NSString getDateComponentsByTimeStamp:[model.create_time integerValue]].day];
                    _lb_time.textColor=ColorGray;
                    _lb_time.numberOfLines=1;
                    _lb_time.lineBreakMode=NSLineBreakByCharWrapping;
                    [_lb_time sizeToFitByconstrainedSize:CGSizeMake(200/*最宽*/, 100)];
                    //                    [_lb_time replaceEmojiandTarget:NO];
                    [_v_toBeSlidingView addSubview:_lb_time];
                    //                    int mouthLength=([NSString getDateComponentsByTimeStamp:[model.create_time integerValue]].month)/10+1;//月份有几位
                    //                    _lb_time.FONT(@"0",/*@"1"*/[NSString stringWithFormat:@"%d",mouthLength] ,@"20.f");
                    //                    _lb_time.COLOR(/*@"4"*/[NSString stringWithFormat:@"%d",mouthLength+3],@"1",ColorGray);
                    //                    [_lb_time setNeedCoretext:YES];
                    //                    [_lb_time changePosInSuperViewWithAlignment:1];
                    
                    RELEASE(_lb_time);
                    
                    
                    _lb_nickName = [[DYBCustomLabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_lb_time.frame)+10+CGRectGetWidth(_lb_time.frame), CGRectGetHeight(self.frame)-20, 0,0)];
                    
                    _lb_nickName.backgroundColor=[UIColor clearColor];
                    _lb_nickName.textAlignment=NSTextAlignmentLeft;
                    _lb_nickName.font=[DYBShareinstaceDelegate DYBFoutStyle:13];//[DYBShareinstaceDelegate DYBFoutStyle:18];
                    _lb_nickName.text=[@"来源：" stringByAppendingString:model.userinfo.name];
                    _lb_nickName.textColor=ColorGray;
                    _lb_nickName.numberOfLines=1;
                    _lb_nickName.lineBreakMode=NSLineBreakByCharWrapping;
                    [_lb_nickName sizeToFitByconstrainedSize:CGSizeMake(200/*最宽*/, 100)];
                    //                    [_lb_time replaceEmojiandTarget:NO];
                    [_v_toBeSlidingView addSubview:_lb_nickName];
                    //                    int mouthLength=([NSString getDateComponentsByTimeStamp:[model.create_time integerValue]].month)/10+1;//月份有几位
                    //                    _lb_time.FONT(@"0",/*@"1"*/[NSString stringWithFormat:@"%d",mouthLength] ,@"20.f");
                    //                    _lb_time.COLOR(/*@"4"*/[NSString stringWithFormat:@"%d",mouthLength+3],@"1",ColorGray);
                    //                    [_lb_time setNeedCoretext:YES];
                    //                    [_lb_time changePosInSuperViewWithAlignment:1];
                    
                    RELEASE(_lb_nickName);

                }
                if (!imgV_show) {//缩略图
                    UIImage *img=nil;
                    switch ([model.file_type intValue]) {
                        case 1://图片
                        {
                            img=[UIImage imageNamed:@"icon_photo.png"];
                            
                        }
                            break;
                        case 2://音频
                        {
                            img=[UIImage imageNamed:@"icon_music.png"];
                        }
                            break;
                        default://没附件就不创建 缩略图,把内容加宽
                        {
                            
                            {//指示箭头
                                UIImage *img=[UIImage imageNamed:@"arrow_more"];
                                MagicUIImageView *imgV=[[MagicUIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-65,CGRectGetMinY(_lb_time.frame), img.size.width/2,img.size.height/2) backgroundColor:[UIColor clearColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:YES masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:_v_toBeSlidingView Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
                                RELEASE(imgV);
                            }
                            
                            goto last;
                        }
                            break;
                    }
                    imgV_show=[[MagicUIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-80,CGRectGetMaxY(v_line.frame)+5, img.size.width/2,img.size.height/2) backgroundColor:[UIColor clearColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:YES masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:_v_toBeSlidingView Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
                    RELEASE(imgV_show);
                }

                {//指示箭头
                    UIImage *img=[UIImage imageNamed:@"arrow_more"];
                    MagicUIImageView *imgV=[[MagicUIImageView alloc]initWithFrame:CGRectMake(CGRectGetMidX(imgV_show.frame)-img.size.width/4,CGRectGetMinY(_lb_time.frame), img.size.width/2,img.size.height/2) backgroundColor:[UIColor clearColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:YES masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:_v_toBeSlidingView Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
                    RELEASE(imgV);
                }

                
                
            }
                break;
            case 2://我共享的笔记
            {
                [self setFrame:CGRectMake(0, 0, self.frame.size.width, model.cellH)];
                
                if (!_bt_delete) {//取消共享
                    UIImage *img= [UIImage imageNamed:@"note_cancelshare_def"];
                    _bt_delete = [[MagicUIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-img.size.width/2-60, 0,img.size.width/2, img.size.height/2)];
                    _bt_delete.tag=-4;
                    _bt_delete.backgroundColor=[UIColor clearColor];//self.headview.backgroundColor;
                    //            _bt_DropDown.alpha=0.9;
                    [_bt_delete addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside object:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
                    [_bt_delete setImage:img forState:UIControlStateNormal];
                    [_bt_delete setImage:[UIImage imageNamed:@"note_del_def"] forState:UIControlStateHighlighted];
                    //            [_bt_delete setTitle:@"删除"];
                    //            [_bt_delete setTitleColor:[UIColor blackColor]];
                    //            [_bt_delete setTitleFont:[DYBShareinstaceDelegate DYBFoutStyle:16]];
                    //            [_bt_delete setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
                    [self addSubview:_bt_delete];
                    [_bt_delete changePosInSuperViewWithAlignment:1];
                    RELEASE(_bt_delete);
                    //                    _bt_delete.hidden=YES;
                }
                
                
                if (!_bt_share) {//修改共享
                    UIImage *img= [UIImage imageNamed:@"note_editshare_def"];
                    _bt_share = [[MagicUIButton alloc] initWithFrame:CGRectMake(60, CGRectGetMinY(_bt_delete.frame),img.size.width/2, img.size.height/2)];
                    _bt_share.tag=-5;
                    _bt_share.backgroundColor=[UIColor clearColor];//self.headview.backgroundColor;
                    //            _bt_DropDown.alpha=0.9;
                    [_bt_share addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside object:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
                    [_bt_share setImage:img forState:UIControlStateNormal];
                    [_bt_share setImage:img forState:UIControlStateHighlighted];
                    //            [_bt_delete setTitle:@"删除"];
                    //            [_bt_delete setTitleColor:[UIColor blackColor]];
                    //            [_bt_delete setTitleFont:[DYBShareinstaceDelegate DYBFoutStyle:16]];
                    //            [_bt_delete setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
                    [self addSubview:_bt_share];
                    //                    [_bt_delete changePosInSuperViewWithAlignment:1];
                    RELEASE(_bt_share);
                    //                    _bt_favorite.hidden=YES;
                }
                
                if (!_v_toBeSlidingView) {
                    _v_toBeSlidingView=[[MagicUIImageView alloc]initWithFrame:self.bounds];
                    _v_toBeSlidingView.image=[UIImage imageNamed:@"bg_note"];
                    _v_toBeSlidingView._originFrame=CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
                    _v_toBeSlidingView.backgroundColor=ColorGray;
                    [self addSubview:_v_toBeSlidingView];
                    RELEASE(_v_toBeSlidingView);
                    _v_toBeSlidingView.userInteractionEnabled=YES;
                    _v_toBeSlidingView.moveMax_x=CGRectGetWidth(_v_toBeSlidingView.frame);
                    
                    [self addSignal:[UIView PAN] object:[NSDictionary dictionaryWithObjectsAndKeys:tbv,@"tbv",[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section],@"indexPath", nil] target:self];
                    [self addSignal:[UIView TAP] object:[NSDictionary dictionaryWithObjectsAndKeys:tbv,@"tbv",[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section],@"indexPath", nil] target:self];//此句执行完后,self.retainCount=3
                }
                
                {/*标签的背景滚动*/
                    _scrV_Tip = [[MagicUIScrollView alloc] initWithFrame:CGRectMake(15, 0, CGRectGetWidth(self.frame)-30, 40)];
                    [_scrV_Tip setBackgroundColor:[UIColor clearColor]];
                    [_scrV_Tip setContentSize:CGSizeMake(0, CGRectGetHeight(_scrV_Tip.frame))];
                    [_scrV_Tip setShowsHorizontalScrollIndicator:NO];
                    [_scrV_Tip setScrollEnabled:NO];
                    [_v_toBeSlidingView addSubview:_scrV_Tip];
                    RELEASE(_scrV_Tip);
                }
                
                for (int i=0; i<model.taglist.count; i++) {
                    Tag *model2=[Tag JSONReflection:[model.taglist objectAtIndex:i]];
                    
                    {
                        DYBCustomLabel *lb=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(_scrV_Tip.contentSize.width+10, 0, 0,0)];
                        lb.backgroundColor=[UIColor clearColor];
                        lb.textAlignment=NSTextAlignmentLeft;
                        lb.font=[UIFont systemFontOfSize:14];//[DYBShareinstaceDelegate DYBFoutStyle:18];
                        lb.text=model2.tag;
                        lb.textColor=ColorWhite;
                        lb.numberOfLines=1;
                        lb.lineBreakMode=NSLineBreakByCharWrapping;
                        [lb sizeToFitByconstrainedSize:CGSizeMake(CGRectGetWidth(_scrV_Tip.frame), CGRectGetHeight(_scrV_Tip.frame))];
                        //                        [lb replaceEmojiandTarget:NO];
                        [_scrV_Tip addSubview:lb];
                        //                        int mouthLength=([NSString getDateComponentsByTimeStamp:[model.create_time integerValue]].month)/10+1;//月份有几位
                        //                        _lb_time.FONT(@"0",/*@"1"*/[NSString stringWithFormat:@"%d",mouthLength] ,@"20.f");
                        //                        _lb_time.COLOR(/*@"4"*/[NSString stringWithFormat:@"%d",mouthLength+3],@"1",ColorGray);
                        //                        [_lb_time setNeedCoretext:YES];
                        [lb changePosInSuperViewWithAlignment:1];
                        
                        RELEASE(lb);
                        
                        {
                            UIView *v_lbBack=[[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(lb.frame)-3, CGRectGetMinY(lb.frame)-3, CGRectGetWidth(lb.frame)+6, CGRectGetHeight(lb.frame)+6)];
                            v_lbBack.layer.masksToBounds=YES;
                            v_lbBack.layer.cornerRadius=4;
                            v_lbBack.backgroundColor=ColorBlue;
                            [_scrV_Tip addSubview:v_lbBack];
                            RELEASE(v_lbBack);
                            [_scrV_Tip bringSubviewToFront:lb];
                        }
                        
                        _scrV_Tip.contentSize=CGSizeMake(CGRectGetMaxX(lb.frame)+10, CGRectGetHeight(_scrV_Tip.frame));
                        if (_scrV_Tip.contentSize.width>CGRectGetWidth(_scrV_Tip.frame)) {
                            _scrV_Tip.scrollEnabled=YES;
                        }
                    }
                    
                }
                if (model.taglist.count==0 || !model.taglist) {//没标签
                    {
                        DYBCustomLabel *lb=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(0, 0, 0,0)];
                        lb.backgroundColor=[UIColor clearColor];
                        lb.textAlignment=NSTextAlignmentLeft;
                        lb.font=[UIFont systemFontOfSize:14];//[DYBShareinstaceDelegate DYBFoutStyle:18];
                        //                            lb.text=@"添加标签";
                        lb.text=@"无标签...";
                        
                        lb.textColor=ColorGray;
                        lb.numberOfLines=1;
                        lb.lineBreakMode=NSLineBreakByCharWrapping;
                        [lb sizeToFitByconstrainedSize:CGSizeMake(CGRectGetWidth(_scrV_Tip.frame), CGRectGetHeight(_scrV_Tip.frame))];
                        //                        [lb replaceEmojiandTarget:NO];
                        [_scrV_Tip addSubview:lb];
                        //                        int mouthLength=([NSString getDateComponentsByTimeStamp:[model.create_time integerValue]].month)/10+1;//月份有几位
                        //                        _lb_time.FONT(@"0",/*@"1"*/[NSString stringWithFormat:@"%d",mouthLength] ,@"20.f");
                        //                        _lb_time.COLOR(/*@"4"*/[NSString stringWithFormat:@"%d",mouthLength+3],@"1",ColorGray);
                        //                        [_lb_time setNeedCoretext:YES];
                        [lb changePosInSuperViewWithAlignment:1];
                        
                        RELEASE(lb);
                    }
                }

                
                {//标签下的横线
                    UIView *v=[[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(_scrV_Tip.frame), CGRectGetMaxY(_scrV_Tip.frame), self.frame.size.width-CGRectGetMinX(_scrV_Tip.frame), 0.5)];
                    [v setBackgroundColor:ColorCellSepL];
                    v_line=v;
                    [_v_toBeSlidingView addSubview:v];
                    RELEASE(v);
                    
                    {//内容
                        _lb_newContent=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_scrV_Tip.frame), CGRectGetMaxY(v.frame)+10, (([model.file_type intValue]==1 || [model.file_type intValue]==2)?(210):(290)),0)];
                        _lb_newContent.backgroundColor=[UIColor clearColor];
                        _lb_newContent.textAlignment=NSTextAlignmentLeft;
                        _lb_newContent.font=[DYBShareinstaceDelegate DYBFoutStyle:13];
                        _lb_newContent.text=model.title ; //@"dwqd我带我去的千万当前味道气味大青蛙大青蛙完全但我却完全但我却大青蛙完全但我却带我去的完全但我却完全大青蛙完全大青蛙大青蛙完全大青[难过][难过][难过][难过][难过][敲打][敲打][难过][敲打]蛙去我的但我却";// ;
                        _lb_newContent.textColor=ColorBlack;
                        _lb_newContent.maxLineNum=3;//只一行
                        [_lb_newContent sizeToFitByconstrainedSize:CGSizeMake(CGRectGetWidth(_lb_newContent.frame), 1000)];
                        _lb_newContent.lineBreakMode=NSLineBreakByCharWrapping;
                        [_lb_newContent setImgType:-1];
                        [_lb_newContent replaceEmojiandTarget:NO];
                        
                        //                        if (![NSString isContainsEmoji:_lb_newContent.text]) {
                        //                            [_lb_newContent setFrame:CGRectMake(CGRectGetMinX(_lb_newContent.frame), CGRectGetMinY(_lb_newContent.frame)+3, CGRectGetWidth(_lb_newContent.frame), CGRectGetHeight(_lb_newContent.frame))];
                        //                        }
                        
                        [_v_toBeSlidingView addSubview:_lb_newContent];
                        //            [_lb_newContent setNeedCoretext:YES];
                        
                        //        [_lb_nickName changePosInSuperViewWithAlignment:1];
                        RELEASE(_lb_newContent);
                        
                        if (CGRectGetMaxY(_lb_newContent.frame)+10+20>CGRectGetHeight(self.frame)) {
                            [self setFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), /*CGRectGetHeight(self.frame)+(CGRectGetMaxY(_lb_newContent.frame)+10+20-CGRectGetHeight(self.frame))*/ 160)];
                            [_v_toBeSlidingView setFrame:self.bounds];
                            _v_toBeSlidingView._originFrame=CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
                            [_bt_delete changePosInSuperViewWithAlignment:1];
                        }
                    }
                    
                    if ([_lb_newContent.text isEqualToString:@""] || !_lb_newContent.text) {//无内容
                        {
                            DYBCustomLabel *lb=[[DYBCustomLabel alloc]initWithFrame:_lb_newContent.frame];
                            lb.backgroundColor=[UIColor clearColor];
                            lb.textAlignment=NSTextAlignmentLeft;
                            lb.font=[UIFont systemFontOfSize:13];//[DYBShareinstaceDelegate DYBFoutStyle:18];
                            //                            lb.text=@"添加标签";
                            lb.text=@"无内容...";
                            
                            lb.textColor=ColorGray;
                            lb.numberOfLines=1;
                            lb.lineBreakMode=NSLineBreakByCharWrapping;
                            [lb sizeToFitByconstrainedSize:CGSizeMake(CGRectGetWidth(_scrV_Tip.frame), CGRectGetHeight(_scrV_Tip.frame))];
                            //                        [lb replaceEmojiandTarget:NO];
                            [_v_toBeSlidingView addSubview:lb];
                            //                        int mouthLength=([NSString getDateComponentsByTimeStamp:[model.create_time integerValue]].month)/10+1;//月份有几位
                            //                        _lb_time.FONT(@"0",/*@"1"*/[NSString stringWithFormat:@"%d",mouthLength] ,@"20.f");
                            //                        _lb_time.COLOR(/*@"4"*/[NSString stringWithFormat:@"%d",mouthLength+3],@"1",ColorGray);
                            //                        [_lb_time setNeedCoretext:YES];
                            [lb changePosInSuperViewWithAlignment:1];
                            
                            RELEASE(lb);
                        }
                    }
                }
                
                if (!_lb_time) {//创建时间
                    _lb_time=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_scrV_Tip.frame), CGRectGetHeight(self.frame)-20, 0,0)];
                    _lb_time.backgroundColor=[UIColor clearColor];
                    _lb_time.textAlignment=NSTextAlignmentLeft;
                    _lb_time.font=[DYBShareinstaceDelegate DYBFoutStyle:13];//[DYBShareinstaceDelegate DYBFoutStyle:18];
                    _lb_time.text=[NSString stringWithFormat:@"%d-%d-%d",[NSString getDateComponentsByTimeStamp:[model.create_time integerValue]].year,[NSString getDateComponentsByTimeStamp:[model.create_time integerValue]].month,[NSString getDateComponentsByTimeStamp:[model.create_time integerValue]].day];
                    _lb_time.textColor=ColorGray;
                    _lb_time.numberOfLines=1;
                    _lb_time.lineBreakMode=NSLineBreakByCharWrapping;
                    [_lb_time sizeToFitByconstrainedSize:CGSizeMake(200/*最宽*/, 100)];
                    //                    [_lb_time replaceEmojiandTarget:NO];
                    [_v_toBeSlidingView addSubview:_lb_time];
                    //                    int mouthLength=([NSString getDateComponentsByTimeStamp:[model.create_time integerValue]].month)/10+1;//月份有几位
                    //                    _lb_time.FONT(@"0",/*@"1"*/[NSString stringWithFormat:@"%d",mouthLength] ,@"20.f");
                    //                    _lb_time.COLOR(/*@"4"*/[NSString stringWithFormat:@"%d",mouthLength+3],@"1",ColorGray);
                    //                    [_lb_time setNeedCoretext:YES];
                    //                    [_lb_time changePosInSuperViewWithAlignment:1];
                    
                    RELEASE(_lb_time);
                }
                
                if (!_imgV_star) {
                    UIImage *img=[UIImage imageNamed:(([model.favorite isEqualToString:@"1"])?(@"star_note"):(@"star_none_note"))];
                    _imgV_star=[[MagicUIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_lb_time.frame)+15,CGRectGetMinY(_lb_time.frame)-1, img.size.width/2,img.size.height/2) backgroundColor:[UIColor clearColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:YES masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:_v_toBeSlidingView Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
                    RELEASE(_imgV_star);
                    
//                    [_imgV_star creatExpandGestureAreaView];
//                    _imgV_star.v_expandGestureArea.tag=1;
//                    [_imgV_star.v_expandGestureArea addSignal:[UIView TAP] object:[NSDictionary dictionaryWithObjectsAndKeys:model,@"model",indexPath,@"indexPath", nil] target:[self viewController]];
                }
                if (!imgV_show) {//缩略图
                    UIImage *img=nil;
                    switch ([model.file_type intValue]) {
                        case 1://图片
                        {
                            img=[UIImage imageNamed:@"icon_photo.png"];
                            
                        }
                            break;
                        case 2://音频
                        {
                            img=[UIImage imageNamed:@"icon_music.png"];
                        }
                            break;
                        default://没附件就不创建 缩略图,把内容加宽
                        {
                            
                            {//指示箭头
                                UIImage *img=[UIImage imageNamed:@"arrow_more"];
                                MagicUIImageView *imgV=[[MagicUIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-65,CGRectGetMinY(_lb_time.frame), img.size.width/2,img.size.height/2) backgroundColor:[UIColor clearColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:YES masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:_v_toBeSlidingView Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
                                RELEASE(imgV);
                            }
                            
                            goto last;
                        }
                            break;
                    }
                    imgV_show=[[MagicUIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-80,CGRectGetMaxY(v_line.frame)+5, img.size.width/2,img.size.height/2) backgroundColor:[UIColor clearColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:YES masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:_v_toBeSlidingView Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
                    RELEASE(imgV_show);
                }
                
                {//指示箭头
                    UIImage *img=[UIImage imageNamed:@"arrow_more"];
                    MagicUIImageView *imgV=[[MagicUIImageView alloc]initWithFrame:CGRectMake(CGRectGetMidX(imgV_show.frame)-img.size.width/4,CGRectGetMinY(_lb_time.frame), img.size.width/2,img.size.height/2) backgroundColor:[UIColor clearColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:YES masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:Nil superView:_v_toBeSlidingView Alignment:-1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
                    RELEASE(imgV);
                }

                
            }
                break;
            default:
                break;
        }
        
    }
    
    last:
    {//分割线
        UIView *v=[[UIView alloc]initWithFrame:CGRectMake(0, (self.frame.size.height-1), self.frame.size.width, 1)];
        [v setBackgroundColor:ColorDivLine];
        [self addSubview:v];
        RELEASE(v);
    }
    
//    {//选中色
//        UIView *v=[[UIView alloc]initWithFrame:self.bounds];
//        v.backgroundColor=BKGGray;
//        self.selectedBackgroundView=v;
//        RELEASE(v);
//    }
}

-(void)changeStar:(int)i
{
    switch (i) {
        case 0://未收藏
        {
            [_imgV_star setImage:[UIImage imageNamed:@"star_none_note"]];
        }
            break;
        case 1:
        {
            [_imgV_star setImage:[UIImage imageNamed:@"star_note"]];
        }
            break;
        default:
            break;
    }
}

#pragma mark- 接受UIView信号
- (void)handleViewSignal_UIView:(MagicViewSignal *)signal{
    if ([signal is:[UIView PAN]]) {//拖动信号
        NSDictionary *d=(NSDictionary *)signal.object;
        UIPanGestureRecognizer *recognizer=[d objectForKey:@"sender"];
        
        {
            _bt_delete.hidden=NO;
            
            if ([recognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
                UIPanGestureRecognizer *panRecognizer = (UIPanGestureRecognizer *)recognizer;
                
                CGPoint translation = [(UIPanGestureRecognizer *)panRecognizer translationInView:self];//移动距离及方向 x>0:右移
                
                if (translation.x>0&& self.initialTouchPositionX!=0 &&CGRectEqualToRect(_v_toBeSlidingView.frame, _v_toBeSlidingView._originFrame) && !(((UITableView *)(self.superview))._selectIndex_now)/*避免 朝右拖动未关闭的cell时 把viewCon.view朝右拖动*/ ) {/*此cell是否是在未展开状态右划*/
                    
                    DYBUITabbarViewController *tabbar=[DYBUITabbarViewController sharedInstace];
                    [[tabbar getThreeview] oneViewSwipe:panRecognizer];
                    return;
                }
                
                CGPoint currentTouchPoint = [panRecognizer locationInView:self.contentView];
                CGFloat currentTouchPositionX = currentTouchPoint.x;
                
                if (recognizer.state == UIGestureRecognizerStateBegan) {
                    self.initialTouchPositionX = currentTouchPositionX;
                    
                } else if (recognizer.state == UIGestureRecognizerStateChanged) {
                    //            CGPoint velocity = [recognizer velocityInView:self.contentView];//滑动速度
                    //            if (!self.contextMenuHidden || (velocity.x > 0. /*|| [self.delegate shouldShowMenuOptionsViewInCell:self]*/))
                    {
                        if (self.selected) {
                            [self setSelected:NO animated:NO];
                        }
                        //                self.contextMenuView.hidden = NO;
                        CGFloat panAmount = currentTouchPositionX - self.initialTouchPositionX;//移动的距离(正负表示方向)
                        self.moveDir=panAmount;
                        self.initialTouchPositionX = currentTouchPositionX;
                        CGFloat minOriginX = /*-CGRectGetWidth(_v_toBeSlidingView.frame)*/ -_v_toBeSlidingView.moveMax_x;//能左移到的最左位置
                        CGFloat maxOriginX = 0.;
                        CGFloat originX = CGRectGetMinX(_v_toBeSlidingView.frame) + panAmount;//被移动的view当前的x
                        originX = MIN(maxOriginX, originX);
                        originX = MAX(minOriginX, originX);
                        
                        if (panAmount<0) {//向左移
                            if(fabs(originX)</*CGRectGetWidth(_v_toBeSlidingView.frame)*/ _v_toBeSlidingView.moveMax_x){//被移动view.x左移到多少后就不左移了
                                _v_toBeSlidingView.frame = CGRectMake(originX, 0., CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
                            }
                        }else{//右移
                            if((originX)<0){//被移动view.x右移到多少后就不右移了
                                _v_toBeSlidingView.frame = CGRectMake(originX, 0., CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
                            }
                        }
                    
                    }
                } else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
                    [UIView animateWithDuration:0.2
                                          delay:0.
                                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                                     animations:^
                     {
                         if (self.moveDir<0) {//左移
                             _v_toBeSlidingView.frame = CGRectMake(((fabs(_v_toBeSlidingView.frame.origin.x)>/*CGRectGetWidth(_v_toBeSlidingView.frame)*/  _v_toBeSlidingView.moveMax_x/5 /*左滑动的距离超过多少后就全部展开*/)?(-_v_toBeSlidingView.moveMax_x /*CGRectGetWidth(_v_toBeSlidingView.frame)*/ ):(0)), 0, CGRectGetWidth(_v_toBeSlidingView.bounds), CGRectGetHeight(_v_toBeSlidingView.bounds));
                         }else{//右移
                             _v_toBeSlidingView.frame = CGRectMake(((fabs(_v_toBeSlidingView.frame.origin.x)</*CGRectGetWidth(_v_toBeSlidingView.frame)*/ _v_toBeSlidingView.moveMax_x-50/*右滑动的距离超过多少后就全部合上*/)?(0):(-_v_toBeSlidingView.moveMax_x /*CGRectGetWidth(_v_toBeSlidingView.frame)*/)), 0, CGRectGetWidth(_v_toBeSlidingView.bounds), CGRectGetHeight(_v_toBeSlidingView.bounds));
                         }
                         
                     } completion:^(BOOL finished) {
                         UITableView *tbv=((UITableView *)(self.superview));
                         
                         if (_v_toBeSlidingView.frame.origin.x<0) {//此cell被展开
                             
                             //关闭上次展开的cell
                             if (tbv._selectIndex_now&&tbv._selectIndex_now!=self.index) {
                                 UITableViewCell *cell=[tbv._muA_differHeightCellView objectAtIndex:tbv._selectIndex_now.row];
                                 [cell resetContentView];
                             }
                             
                             tbv._selectIndex_now=self.index;
                             
                         }else if(tbv._selectIndex_now==self.index){//关闭上次展开的cell
                             UITableView *tbv=((UITableView *)(self.superview));
                             [tbv set_selectIndex_now:nil];
                             
                         }
                     }];
                }
            }
        }
        
    }else if ([signal is:[UIView TAP]]) {
        NSDictionary *object=(NSDictionary *)signal.object;
        
        NSDictionary *d=[object objectForKey:@"object"];
        
        switch (((UIView *)signal.source).tag) {//区分点击了cell还是点击cell里的 添加了TAP事件的子视图
            case 0://默认点击cell
            {
                UITableView *tbv=[d objectForKey:@"tbv"];
                
                if (tbv) {//点击tbv
                    
                    //关闭上次展开的cell
                    if (tbv._selectIndex_now) {
                        if ([MagicDevice sysVersion]<6) {//IOS 6以下检测不准 添加了单击事件的view上加了子视图后 单击事件的重叠
                            UITapGestureRecognizer *tap=[object objectForKey:@"sender"];
                            CGPoint p=[tap locationInView:self];
                            if (/*p.x>CGRectGetMinX(_bt_delete.frame) && p.y>CGRectGetMinY(_bt_delete.frame)*/ CGRectContainsPoint(_bt_delete.frame,p)) {//删除
                                [_bt_delete didTouchUpInside];
                                return;
                            }else if(CGRectContainsPoint(_bt_favorite.frame,p)){//星标
                                [_bt_favorite didTouchUpInside];
                                return;
                            }else if(CGRectContainsPoint(_bt_gotoDataBase.frame,p)){
                                [_bt_gotoDataBase didTouchUpInside];
                                return;
                            }else if(CGRectContainsPoint(_bt_share.frame,p)){
                                [_bt_share didTouchUpInside];
                                return;
                            }
                        }
                        UITableViewCell *cell=[tbv._muA_differHeightCellView objectAtIndex:tbv._selectIndex_now.row];
                        [cell resetContentView];
                        //            [tbv._selectIndex_now release];
                        tbv._selectIndex_now=nil;
                    }else{//选中cell
                        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:tbv, @"tableView", [d objectForKey:@"indexPath"], @"indexPath", nil];
                        [self sendViewSignal:[MagicUITableView TABLEDIDSELECT] withObject:dict from:signal.source target:[self superCon]];
                    }
                }
                
                
                [self resetContentView];
            }
                break;
            case 1://点击了收藏视图
            {
                [self sendViewSignal:[UIView TAP] withObject:object from:signal.source target:[self superCon]];
                
            }
                break;
            default:
                break;
        }
        
    }
    
}

#pragma mark - UIPanGestureRecognizer delegate

//不重写这个,tbv的滚动手势就被UIPanGestureRecognizer的手势覆盖了
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:self];
        return fabs(translation.x)/*浮点数的绝对值*/ > fabs(translation.y);
    }
    return YES;
}

//恢复正常视图布局
-(void)resetContentView
{
    if (_v_toBeSlidingView.frame.origin.x<0) {
        [UIView animateWithDuration:0.2
                              delay:0.
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                         animations:^
         {
             _v_toBeSlidingView.frame=_v_toBeSlidingView._originFrame;
         } completion:^(BOOL finished) {
             _bt_delete.hidden=YES;
         }];
    }
    
}

-(void)dealloc
{
    [super dealloc];
}
@end
