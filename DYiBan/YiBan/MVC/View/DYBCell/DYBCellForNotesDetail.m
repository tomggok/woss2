//
//  DYBCellForNotesDetail.m
//  DYiBan
//
//  Created by zhangchao on 13-11-5.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBCellForNotesDetail.h"
#import "noteModel.h"
#import "Tag.h"
#import "UITableViewCell+MagicCategory.h"
#import "DYBNoteDetailViewController.h"
#import "NSObject+KVO.h"
#import "UIView+MagicCategory.h"
#import "file_list.h"
#import "UIImageView+Init.h"
#import "tag_list_info.h"
#import "NSString+Count.h"
#import "UIImageView+Animation.h"
#import "UITextView+Property.h"
#import "NSObject+KVO.h"

@implementation DYBCellForNotesDetail

-(void)setContent:(id)data indexPath:(NSIndexPath *)indexPath tbv:(UITableView *)tbv
{
    //    self.accessoryType=UITableViewCellAccessoryDetailDisclosureButton;
    self.index=[[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section] retain];
    self.tbv=tbv;
    
    if (data) {
        noteModel *model=nil;
        file_list *model_file=nil;
//        tag_list_info *model_tag=nil;//标签cell的model

        if ([data isKindOfClass:[noteModel class]]) {
            model=data;
            self.model=model;
        }else if ([data isKindOfClass:[file_list class]]){
            model_file=data;
            self.model=model_file;
        }
//        else if ([data isKindOfClass:[tag_list_info class]]){
//            model_tag=data;
//        }
        
        {//检测con的isEditing
            DYBNoteDetailViewController *con=(DYBNoteDetailViewController *)[tbv.superview superCon];
            if (con) {
                [con addObserverObj:self forKeyPath:@"isEditing" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:[self class]];
                DLogInfo(@"");
            }
        }
        
        int i=(model)?([model type]):(model_file.type);
        self.i_type=[[[NSNumber numberWithInt:i] retain] intValue];
        switch (i) {
            case -4:// 标签cell
            {
                self.selectionStyle=UITableViewCellSelectionStyleNone;

                [self setFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
                 
                if (!_bt_AddTag) {//添加标签按钮
                    UIImage *img= [UIImage imageNamed:@"list_arrow.png"];
                    _bt_AddTag = [[MagicUIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-img.size.width/2-15, 0, img.size.width/2, img.size.height/2)];
                    _bt_AddTag.backgroundColor=[UIColor clearColor];
                    _bt_AddTag.tag=-1;
//                    [_bt_AddTag addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside];
                    [_bt_AddTag setImage:img forState:UIControlStateNormal];
                    [_bt_AddTag setImage:img forState:UIControlStateHighlighted];
                    //            [_bt_creatNote setTitle:@"更多"];
                    //            [_bt_creatNote setTitleFont:[DYBShareinstaceDelegate DYBFoutStyle:18]];
                    //            [_bt_creatNote setTitleColor:ColorBlue];
                    [self addSubview:_bt_AddTag];
                    [_bt_AddTag changePosInSuperViewWithAlignment:1];
                    RELEASE(_bt_AddTag);
//                    _bt_AddTag.hidden=YES;
//                    _bt_AddTag.hidden=(model._state==0)?YES:NO;
                }
                
                {
                    {/*标签的背景滚动*/
                        _scrV_Tip = [[MagicUIScrollView alloc] initWithFrame:CGRectMake(15, 0, CGRectGetWidth(self.frame)-15-CGRectGetWidth(_bt_AddTag.frame)-20, CGRectGetHeight(self.frame))];
                        [_scrV_Tip setBackgroundColor:[UIColor clearColor]];
                        [_scrV_Tip setContentSize:CGSizeMake(0, CGRectGetHeight(_scrV_Tip.frame))];
                        [_scrV_Tip setShowsHorizontalScrollIndicator:NO];
                        [_scrV_Tip setScrollEnabled:NO];
                        _scrV_Tip.userInteractionEnabled=YES;
                        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:tbv, @"tableView", indexPath, @"indexPath", nil];
                        [_scrV_Tip addSignal:[UIView TAP] object:dict target:[self superCon]];
                        _scrV_Tip.tag=2;
                        [self addSubview:_scrV_Tip];
                        RELEASE(_scrV_Tip);
                    }
                    
                    for (int i=0; i<model.taglist.count; i++) {
                        tag_list_info *model2=[model.taglist objectAtIndex:i];
                        
                        if (![[model.taglist objectAtIndex:i] isKindOfClass:[tag_list_info class]]) {
                            model2=[tag_list_info JSONReflection:[model.taglist objectAtIndex:i]];
                        }
                        
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
                            
                            {//蓝色背景
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
                        if (!_lb_addTag) {
                            DYBCustomLabel *lb=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(0, 0, 0,0)];
                            _lb_addTag=lb;
                            lb.backgroundColor=[UIColor clearColor];
                            lb.textAlignment=NSTextAlignmentLeft;
                            lb.font=[UIFont systemFontOfSize:14];//[DYBShareinstaceDelegate DYBFoutStyle:18];
//                            lb.text=@"添加标签";
                            if (model._state==0) {//非编辑状态
                                lb.text=@"无标签...";
                            }else{
                                lb.text=@"添加标签...";
                            }
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
                }
                
                {//标签下的分割线
                    UIView *v=[[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(_scrV_Tip.frame), CGRectGetMaxY(_scrV_Tip.frame), self.frame.size.width-CGRectGetMinX(_scrV_Tip.frame), 0.5)];
                    [v setBackgroundColor:ColorCellSepL];
                    [self addSubview:v];
                    RELEASE(v);
                }
                
//                {//右箭头
//                    UIImage *imgListArrow = [UIImage imageNamed:@"list_arrow.png"];
//                    MagicUIImageView *viewListArrow = [[MagicUIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-25, 10, imgListArrow.size.width/2, imgListArrow.size.height/2)];
//                    [viewListArrow setBackgroundColor:[UIColor clearColor]];
//                    [viewListArrow setImage:imgListArrow];
//                    [self addSubview:viewListArrow];
//                    RELEASE(viewListArrow);
//                }
                
//                {//选中色
//                    UIView *v=[[UIView alloc]initWithFrame:self.bounds];
//                    v.backgroundColor=ColorBlue;
//                    self.selectedBackgroundView=v;
//                    RELEASE(v);
//                }
            }
                break;
            case -5://输入内容cell
            {
//                self.backgroundColor=[UIColor blueColor];
                self.selectionStyle=UITableViewCellSelectionStyleNone;

//                self.tbv=tbv;

                [self setFrame:CGRectMake(0, 0, self.frame.size.width, 140)];
                if (!_textView) {
                    _textView = [[MagicUITextView alloc] initWithFrame:CGRectMake(15, 10, CGRectGetWidth(self.frame)-30-25, 0)];
                    [_textView setBackgroundColor:[UIColor clearColor]];
                    _textView.layer.borderWidth = 1;
                    _textView.layer.borderColor = [UIColor clearColor].CGColor;
                    _textView.font = [DYBShareinstaceDelegate DYBFoutStyle:16];
                    _textView.textColor = ColorBlack;
                    _textView.returnKeyType=UIReturnKeyDone;
                    _textView.maxLength=1000;
                    //                _textView.userInteractionEnabled=NO;
                    [self addSubview:_textView];
                    RELEASE(_textView);
                    _textView.maxSize=CGSizeMake(CGRectGetWidth(_textView.frame), CGRectGetHeight(tbv.frame)-40/*0号cell的高*/-50/*底部tabbar*/-40/*偏移量*/);
                    
                    [_textView initLbTextLength:CGRectMake(CGRectGetMaxX(_textView.frame)-50, CGRectGetMaxY(_textView.frame)+10, 0, 0)];
                    [self addSubview:_textView.lb_textLength];
                    RELEASE(_textView.lb_textLength);
                    [_textView freshLbTextLengthText:[NSString stringWithFormat:@"%d / %d",_textView.text.length,_textView.maxLength]];
//                    _textView.contentInset=UIEdgeInsetsMake(0, 0, CGRectGetHeight(_textView.lb_textLength.frame)+10, 0);//避免内容输入到和底部时和lb_textLength重合
                }
                
                {
                    if (!model.content || [model.content isEqualToString:@""]) {
                        if (model._state==0) {//非编辑状态
                            _textView.placeHolder=@"无内容...";
                        }else{
                            _textView.placeHolder=@"点击添加内容...";
                        }
                        //没内容时 默认 一行
                        [_textView setFrame:CGRectMake(CGRectGetMinX(_textView.frame), CGRectGetMinY(_textView.frame), _textView.maxSize.width, /*_textView.maxSize.height*/ 30)];
                    }else{
                        _textView.text=model.content;
                        [_textView sizeFitByText];
                        [_textView freshLbTextLengthText:[NSString stringWithFormat:@"%d / %d",_textView.text.length,_textView.maxLength]];

                    }
                    
                    [_textView.lb_textLength setFrame:CGRectMake(CGRectGetMinX(_textView.lb_textLength.frame), CGRectGetMaxY(_textView.frame)+10, CGRectGetWidth(_textView.lb_textLength .frame), CGRectGetHeight(_textView.lb_textLength .frame))];

//                    for (UIView *v in _textView.subviews) {
//                        if ([v isKindOfClass:[UIWebDocumentView class]]) {
//                            [v setFrame:CGRectMake(CGRectGetMinX(v.frame), CGRectGetMinY(v.frame), CGRectGetWidth(v.frame), CGRectGetHeight(_textView.frame)-CGRectGetHeight(_textView.lb_textLength.frame))];
//                        }
//                    }

                    
                    [self setFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetMaxY(_textView.lb_textLength.frame)+20)];
                    [_textView changePosInSuperViewWithAlignment:1];
                    [_textView.lb_textLength setFrame:CGRectMake(CGRectGetMinX(_textView.lb_textLength.frame), CGRectGetMaxY(_textView.frame)+10, CGRectGetWidth(_textView.lb_textLength .frame), CGRectGetHeight(_textView.lb_textLength .frame))];


                }
            }
                break;
            case -6://语音
            {
                self.selectionStyle=UITableViewCellSelectionStyleNone;
                _state=model_file.state;

                if (!_imgV_show) {
                    UIImage *img=[UIImage imageNamed:@"audiobox"];
                    _imgV_show=[[MagicUIImageView alloc]initWithFrame:CGRectMake(15, 0, img.size.width/2, img.size.height/2) backgroundColor:[UIColor clearColor] image:img isAdjustSizeByImgSize:NO userInteractionEnabled:YES masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:self Alignment:1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
                    RELEASE(_imgV_show);
                    _imgV_show.tag=5;
                    [_imgV_show addSignal:[UIView TAP] object:[NSDictionary dictionaryWithObjectsAndKeys:model_file,@"model",self,@"cell", nil] target:[self superCon]];
                    
                    if ([model_file.location hasPrefix:@"http"]) {//此model是从服务器下载的,非本地录音创建的,就把服务器的音频地址存在imageCache文件夹里
//                        UIImageView *img_sound = [[UIImageView alloc]init];
//                        [img_sound setImageWithURL:[NSURL URLWithString:model_file.location]];
                        
                        NSString *path=[NSString cachePathForfileName:[[((NSString *)[[model_file.location separateStrToArrayBySeparaterChar:@"/"] lastObject]) separateStrToArrayBySeparaterChar:@"."] objectAtIndex:0]/*取url里的文件名*/ fileType:@"ImageCache" dir:NSCachesDirectory];
                        if (![path hasFile]) {
                            //缓存服务器发的语音
                            [[NSData dataWithContentsOfURL:[NSURL URLWithString:model_file.location]] writeToFile:model_file.location=path atomically:YES];
                        }else{//找到了服务器发来的url对应的沙盒的缓存路径
                            model_file.location=path;
                        }
                    }
                    
                    {//喇叭
                        UIImage *img1=[UIImage imageNamed:@"voice_2"];
                        MagicUIImageView *imgV=[[MagicUIImageView alloc]initWithFrame:CGRectMake(15, 0, img1.size.width/2, img1.size.height/2) backgroundColor:[UIColor clearColor] image:img1 isAdjustSizeByImgSize:NO userInteractionEnabled:YES masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:_imgV_show Alignment:1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
                        _imgV_voice=imgV;
                        RELEASE(imgV);
                        
                        {//时长
                            DYBCustomLabel *lb=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imgV.frame)+15, 0, 0,0)];
                            lb.backgroundColor=[UIColor clearColor];
                            lb.textAlignment=NSTextAlignmentLeft;
                            lb.font=[UIFont systemFontOfSize:14];//[DYBShareinstaceDelegate DYBFoutStyle:18];
                            lb.text=[NSString stringWithFormat:@"%@''", ((model_file.duration && ![model_file.duration isEqualToString:@""])?(model_file.duration):(@""))];
                            lb.textColor=ColorBlue;
                            lb.numberOfLines=1;
                            lb.lineBreakMode=NSLineBreakByCharWrapping;
                            [lb sizeToFitByconstrainedSize:CGSizeMake(CGRectGetWidth(_imgV_show.frame), CGRectGetHeight(_imgV_show.frame))];
                            //                        [lb replaceEmojiandTarget:NO];
                            [_imgV_show addSubview:lb];
                            //                        int mouthLength=([NSString getDateComponentsByTimeStamp:[model.create_time integerValue]].month)/10+1;//月份有几位
                            //                        _lb_time.FONT(@"0",/*@"1"*/[NSString stringWithFormat:@"%d",mouthLength] ,@"20.f");
                            //                        _lb_time.COLOR(/*@"4"*/[NSString stringWithFormat:@"%d",mouthLength+3],@"1",ColorGray);
                            //                        [_lb_time setNeedCoretext:YES];
                            [lb changePosInSuperViewWithAlignment:1];
                            
                            RELEASE(lb);
                        }
                    }
                    
                    [self setFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(_imgV_show.frame)+20)];
                    [_imgV_show changePosInSuperViewWithAlignment:1];
                    
                    [self addDELBt:_imgV_show];
                    
                }
                
                {//选中色
                    UIView *v=[[UIView alloc]initWithFrame:self.bounds];
                    v.backgroundColor=ColorBlue;
                    self.selectedBackgroundView=v;
                    RELEASE(v);
                }
            }
                break;
            case -7://图片
            {
                self.selectionStyle=UITableViewCellSelectionStyleNone;

                _state=model_file.state;

                if (!_imgV_show) {
                    _imgV_show=[[MagicUIImageView alloc]initWithFrame:CGRectMake(15, 10, CGRectGetWidth(self.frame)-30, CGRectGetHeight(tbv.frame)) backgroundColor:[UIColor clearColor] image:Nil isAdjustSizeByImgSize:NO userInteractionEnabled:YES masksToBounds:NO cornerRadius:-1 borderWidth:-1 borderColor:nil superView:self Alignment:1 contentMode:UIViewContentModeScaleAspectFit stretchableImageWithLeftCapWidth:-1 topCapHeight:-1];
                    RELEASE(_imgV_show);
                    
                    [self addDELBt:_imgV_show];

                    
//                    if (!model_file.img)
                    {//不是自己创建的img,而是服务器发来的url
                        if ([model_file.location hasPrefix:@"http"]) {
                            [_imgV_show setImgWithUrl:model_file.location defaultImg:nil];
                        }else{//本地路径
                            _imgV_show.image=[UIImage imageWithContentsOfFile:model_file.location];
                            
                            CGFloat w=((_imgV_show.image.size.width>CGRectGetWidth(_imgV_show.frame))?(CGRectGetWidth(_imgV_show.frame)):(_imgV_show.image.size.width));
                            CGFloat h=((_imgV_show.image.size.height>CGRectGetHeight(_imgV_show.frame)/*最大高度*/)?(CGRectGetHeight(_imgV_show.frame)):(_imgV_show.image.size.height));
                            [_imgV_show setFrame:CGRectMake(CGRectGetMinX(_imgV_show.frame), CGRectGetMinY(_imgV_show.frame), w,h)];                            
                            CGPoint p=[self handleImgSize:_imgV_show];
                            _bt_del.center=CGPointMake(p.x+CGRectGetWidth(_bt_del.frame)/2, p.y+CGRectGetHeight(_bt_del.frame)/2);
                            
//                            CGSize size=[_imgV_show sizeToFitByImg];
//                            [_bt_del setFrame:CGRectMake(CGRectGetWidth(_imgV_show.frame)-size.width, -size.height, CGRectGetWidth(_bt_del.frame), CGRectGetHeight(_bt_del.frame))];
                            
                            [self setFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(_imgV_show.frame)+20)];
                            [_imgV_show changePosInSuperViewWithAlignment:1];
                        }

                    }
//                    else{
//                        
//                        CGFloat w=((model_file.img.size.width>CGRectGetWidth(_imgV_show.frame))?(CGRectGetWidth(_imgV_show.frame)):(model_file.img.size.width));
//                        CGFloat h=((model_file.img.size.height>CGRectGetHeight(_imgV_show.frame)/*最大高度*/)?(CGRectGetHeight(_imgV_show.frame)):(model_file.img.size.height));
//                        [_imgV_show setFrame:CGRectMake(CGRectGetMinX(_imgV_show.frame), CGRectGetMinY(_imgV_show.frame), w,h)];
//                        
////                        [_imgV_show sizeToFitByImg];
//                        
//                        CGPoint p=[self handleImgSize:_imgV_show];
//                        //    [_bt_del setFrame:CGRectMake(p.x, p.y-CGRectGetHeight(_bt_del.frame)/2, CGRectGetWidth(_bt_del.frame), CGRectGetHeight(_bt_del.frame))];
//                        _bt_del.center=CGPointMake(p.x+CGRectGetWidth(_bt_del.frame)/2, p.y+CGRectGetHeight(_bt_del.frame)/2);
//                        
//                        [self setFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(_imgV_show.frame)+20)];
//                        [_imgV_show changePosInSuperViewWithAlignment:1];
//                        
//                    }
                    

                }
                
                {//选中色
                    UIView *v=[[UIView alloc]initWithFrame:self.bounds];
                    v.backgroundColor=ColorBlue;
                    self.selectedBackgroundView=v;
                    RELEASE(v);
                }
            }
                break;
            default:
                break;
        }
        
    }
    
}

#pragma mark- 图片下载成功回调
- (void)handleViewSignal_MagicUIImageView_WEBDOWNSUCCESS:(MagicViewSignal *)signal
{
    MagicUIImageView *imgV = (MagicUIImageView *)[signal source];
    
    CGFloat w=((imgV.image.size.width>CGRectGetWidth(_imgV_show.frame))?(CGRectGetWidth(_imgV_show.frame)):(imgV.image.size.width));
    CGFloat h=((imgV.image.size.height>CGRectGetHeight(_imgV_show.frame)/*最大高度*/)?(CGRectGetHeight(_imgV_show.frame)):(imgV.image.size.height));
    [imgV setFrame:CGRectMake(CGRectGetMinX(imgV.frame), CGRectGetMinY(imgV.frame), w,h)];
    
    CGPoint p=[self handleImgSize:imgV];
    _bt_del.center=CGPointMake(p.x+CGRectGetWidth(_bt_del.frame)/2, p.y+CGRectGetHeight(_bt_del.frame)/2);
    
//    CGSize size=[_imgV_show sizeToFitByImg];
//    [_bt_del setFrame:CGRectMake(CGRectGetWidth(_imgV_show.frame)-size.width, -size.height, CGRectGetWidth(_bt_del.frame), CGRectGetHeight(_bt_del.frame))];
    
    [self setFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(imgV.frame)+20)];
    [imgV changePosInSuperViewWithAlignment:1];
    
    [[self tbv]reloadData];
}

//计算imgview中img的右上角的位置
- (CGPoint)handleImgSize:(MagicUIImageView *)imgV
{
    CGFloat imgHeigth = imgV.image.size.height;
    CGFloat imgWidth = imgV.image.size.width;
    
    CGFloat w = imgWidth >CGRectGetWidth(imgV.frame) ? (CGRectGetWidth(imgV.frame)) : (imgWidth);
    CGFloat h = imgHeigth > CGRectGetHeight(imgV.frame) ? (CGRectGetHeight(imgV.frame)) : (imgHeigth);
    
    CGFloat rateX = (imgV.image.size.width * h)/ (imgV.image.size.height * w);
    NSInteger imgType;
    if (rateX > 1)
    {//横向
        rateX = (imgV.image.size.height * w) / (imgV.image.size.width * h);
        imgType = 0;
    }else if(rateX < 1)
    {//纵向
        imgType = 1;
    }else
    {
        imgType = 2;
    }
    
    CGFloat imgHX;
    CGFloat imgWX;
    
    
    
    if (imgType == 1)
    {
        imgHX = 0;
        CGFloat imgW = w * rateX;
        imgWX = w -((w - imgW) / 2);
        
    }else if (imgType == 0)
    {
        imgWX = w;
        CGFloat imgH  = h * rateX;
        imgHX = (h - imgH) / 2;
    }else {
        imgWX = CGRectGetWidth(imgV.frame);
        imgHX = (CGRectGetHeight(imgV.frame)-CGRectGetWidth(imgV.frame) * rateX)/2;
    }
    
    return CGPointMake(imgWX, imgHX);
}

-(void)addDELBt:(UIView *)superV
{//删除按钮
    if (!_bt_del) {
        UIImage *img= [UIImage imageNamed:@"close"];
        _bt_del= [[MagicUIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(superV.frame), CGRectGetMinY(superV.frame)-img.size.height/4, img.size.width/2, img.size.height/2)];
        _bt_del.backgroundColor=[UIColor clearColor];
        _bt_del.tag=7;
        [_bt_del addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside object:[NSDictionary dictionaryWithObjectsAndKeys:self,@"cell",self.model,@"model", nil]];
        [_bt_del setImage:img forState:UIControlStateNormal];
        [_bt_del setImage:img forState:UIControlStateHighlighted];
        //            [_bt_creatNote setTitle:@"更多"];
        //            [_bt_creatNote setTitleFont:[DYBShareinstaceDelegate DYBFoutStyle:18]];
        //            [_bt_creatNote setTitleColor:ColorBlue];
        [self addSubview:_bt_del];
        //            [_bt_AddTag changePosInSuperViewWithAlignment:1];
        
//        [self bringSubviewToFront:_bt_del];
        RELEASE(_bt_del);
        if (_state==0) {
            _bt_del.hidden=YES;
        }
    }

}

-(void)changeState:(int)state   
{
    _state=state;
    switch (state) {
        case 0://正常状态
        {
            switch (self.i_type) {
                case -4://标签
                {
//                    _bt_AddTag.hidden=YES;
                }
                    break;
                case -6://音频cell
                case -7://图片cell
                {
//                    [_imgV_show viewWithTag:7].hidden=YES;
                    _bt_del.hidden=YES;

                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1://编辑状态
        {
            switch (self.i_type) {
                case -4://标签cell
                {
//                    _bt_AddTag.hidden=NO;
//                    _textView.userInteractionEnabled=YES;
//                    _textView.layer.borderColor = [ColorDivLine CGColor];
                    
                    
                }
                    break;
                case -6://音频cell
                case -7:
                {
                    _bt_del.hidden=NO;
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark- 改变textView的高度
-(void)changeTextView:(int)i
{
    switch (i) {
        case 0://收起键盘
        {            
            
            if (!_textView.text || [_textView.text isEqualToString:@""]) {//没内容时 默认 一行

                [_textView setFrame:CGRectMake(CGRectGetMinX(_textView.frame), CGRectGetMinY(_textView.frame), _textView.maxSize.width, /*_textView.maxSize.height*/30)];
            }else{
                [_textView sizeFitByText];
            }
            
            [_textView.lb_textLength setFrame:CGRectMake(CGRectGetMinX(_textView.lb_textLength.frame), CGRectGetMaxY(_textView.frame)+10, CGRectGetWidth(_textView.lb_textLength .frame), CGRectGetHeight(_textView.lb_textLength .frame))];

            [self setFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetMaxY(_textView.lb_textLength.frame)+20)];
            [_textView changePosInSuperViewWithAlignment:1];
            [_textView.lb_textLength setFrame:CGRectMake(CGRectGetMinX(_textView.lb_textLength.frame), CGRectGetMaxY(_textView.frame)+10, CGRectGetWidth(_textView.lb_textLength .frame), CGRectGetHeight(_textView.lb_textLength .frame))];
            
        }
            break;
        case 1://打开键盘
        {
            [_textView setFrame:CGRectMake(CGRectGetMinX(_textView.frame), CGRectGetMinY(_textView.frame), CGRectGetWidth(_textView.frame), CGRectGetHeight(self.tbv.frame)-CGRectGetMinY(_textView.frame)-keyBoardSizeForIp.height-kH_chineseItem-30)];
            [_textView.lb_textLength setFrame:CGRectMake(CGRectGetMinX(_textView.lb_textLength.frame), CGRectGetMaxY(_textView.frame)+10, CGRectGetWidth(_textView.lb_textLength .frame), CGRectGetHeight(_textView.lb_textLength .frame))];
            
            [self setFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetMaxY(_textView.lb_textLength.frame)+20)];
            [_textView changePosInSuperViewWithAlignment:1];
            [_textView.lb_textLength setFrame:CGRectMake(CGRectGetMinX(_textView.lb_textLength.frame), CGRectGetMaxY(_textView.frame)+10, CGRectGetWidth(_textView.lb_textLength .frame), CGRectGetHeight(_textView.lb_textLength .frame))];

        }
            break;
        default:
            break;
    }
}

#pragma mark- 观察者要实现此响应方法
- (void) observeValueForKeyPath:(NSString *)keyPath
					   ofObject:(id)object/*被观察者*/
						 change:(NSDictionary *)change
						context:(void *)context/*被观察者class*/{
    Class class=(Class)context;
    NSString *className=[NSString stringWithCString:object_getClassName(class) encoding:NSUTF8StringEncoding];
    
    if ([className isEqualToString:[NSString stringWithCString:object_getClassName([self class]) encoding:NSUTF8StringEncoding]]) {
        if ([[change objectForKey:@"new"] boolValue]) {
            [self changeState:1];
        }
        
    }else if([className isEqualToString:@"AVAudioPlayer"]){//被观察者是 AVAudioPlayer
        if ([keyPath isEqualToString:@"b_isPlaying"]) {//被观察的属性
            if ([[change objectForKey:@"new"] boolValue]) {
                [self PlayOrStopAudio:1];
            }else{
                [self PlayOrStopAudio:0];
            }
        }
    
    }else{//将不能处理的 key 转发给 super 的 observeValueForKeyPath 来处理
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
    
}

#pragma mark- 播放|停止 音频
-(void)PlayOrStopAudio:(int)i
{
    switch (i) {
        case 0://停止
        {
            if ([_imgV_voice isAnimating]) {
                [_imgV_voice stopAnimating];
            }
        }
            break;
        case 1://播放
        {
            NSMutableArray *muA=[NSMutableArray arrayWithObjects:[UIImage imageNamed:@"voice_0"],[UIImage imageNamed:@"voice_1"],[UIImage imageNamed:@"voice_2"], nil];
            [_imgV_voice creatAnAnimationImageViewByAnimationImages:muA animationRepeatCount:-1 animationDuration:muA.count];
        }
            break;
        default:
            break;
    }
}

-(void)dealloc
{
//    [self unobserveAllNotification];
    
    [_scrV_Tip removeAllSignal];
    [_imgV_show removeAllSignal];

    [super dealloc];
}

@end
