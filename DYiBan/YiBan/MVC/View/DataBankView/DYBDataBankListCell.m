

//
//  DYBDataBankListCell.m
//  DYiBan
//
//  Created by tom zeng on 13-8-9.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBDataBankListCell.h"
#import "Magic_UILabel.h"
#import "Magic_UIImageView.h"
#import "UITableView+property.h"
#import "UIView+Gesture.h"
#import "UIView+MagicCategory.h"
#import "UITableViewCell+MagicCategory.h"
#import "DYBUITabbarViewController.h"
#import "DYBDataBankSelectBtn.h"
#import "UIImageView+WebCache.h"
#import "NSObject+MagicRequestResponder.h"
#import "UIImageView+WebCache.h"
#import "Magic_Device.h"
#import "user.h"
#import "DYBDtaBankSearchView.h"
#import "NSObject+MagicDatabase.h"
#import "DYBDataBankChildrenListViewController.h"
#define  TAPVIEWTAG  110
@interface DYBDataBankListCell()
{
}
@property (nonatomic, retain)DYBDataBankSelectBtn* btnBottom;
@end

@implementation DYBDataBankListCell{

    UIView *swipView;
    CGPoint ptBegin;
    CGPoint currentCenter; //cell当前的中心
    BOOL isOpen;
    
    MagicUILabel *labelFrom;
    
    DYBDataBankSelectBtn* btnBottom;
    MagicUIImageView *swipIcan;
        
}

@synthesize cellBackground = _cellBackground,tb = _tb,indexPath = _indexPath;
@synthesize imageViewStats = _imageViewStats,labelProgress = _labelProgress;
@synthesize  cellType = _cellType,bSwip = _bSwip,sendMegTarget = _sendMegTarget;
@synthesize btnType = _btnType,progressView = _progressView,labelGood = _labelGood;
@synthesize labelName = _labelName,labelBad = _labelBad,strTag = _strTag;
@synthesize btnBottom, beginOrPause = _beginOrPause,imageViewDown = _imageViewDown;


DEF_SIGNAL(CANCEL)
DEF_SIGNAL(FINISHSWIP)

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    
        
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame object:(id)object
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.sendMegTarget = object ;
    }
    return self;
}
-(DYBDataBankListCell *)initViewCell_dict:(NSDictionary *)dict target:(id)_target{

   DYBDataBankListCell *cell = [self initViewCell_dict:dict];
    return cell;
}
-(DYBDataBankListCell *)initViewCell_dict:(NSDictionary *)dict{
    
    DLogInfo(@"DYBDataBankListCell ppppppp");
    
    self.index = _indexPath;
    isOpen = NO;
    
    [self setStrTag:[dict objectForKey:@"file_urlencode"]]; //设置tag 方便找到相应的cell对象
    
    if (![_bSwip isEqualToString:@"NO"] && ![[dict objectForKey:@"is_sys_folder"] boolValue]) {
        
        [self addSignal:[UIView PAN] object:[NSDictionary dictionaryWithObjectsAndKeys:_tb,@"tbv",_indexPath,@"indexPath", nil]];
    }
    
    _cellBackground = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 84.0f)];
    [_cellBackground setBackgroundColor:[UIColor clearColor]];
    [self addSubview:_cellBackground];
    RELEASE(_cellBackground);

    
    //屏蔽 Tap 事件
    UIButton *bgBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 84.0f)];
    [bgBtn setBackgroundColor:[UIColor clearColor]];
    [bgBtn addTarget:self action:@selector(justPinB) forControlEvents:UIControlEventTouchUpInside];
    [_cellBackground addSubview:bgBtn];
    RELEASE(bgBtn);
    
    [self setBtnBottomType:dict];
        
    swipView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 84.0f)];
    swipView.tag = 100;
    [swipView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:swipView];
    RELEASE(swipView);
    [swipView addSignal:[UIView TAP] object:[NSDictionary dictionaryWithObjectsAndKeys:_tb,@"tbv",_indexPath,@"indexPath", nil] target:self];

    
    // 文件，文件夹  区分  yes 文件夹，no 文件
    
    BOOL isFolder = [[dict objectForKey:@"is_dir"]boolValue];
    
    [self chooseDifferentCell:isFolder dictObj:dict];
    
    UIColor *color  = _tb.separatorColor;
    UIView *viewSep = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 84 - 1, 320.0f, 1)];
    [viewSep setBackgroundColor:color];
    [self addSubview:viewSep];
    RELEASE(viewSep);
    
    return  self;
}

-(void)setBtnBottomType:(NSDictionary *)dict{

    
    if ([[_tb superview] isKindOfClass:[DYBDtaBankSearchView class]]) {
        
        btnBottom = [[DYBDataBankSelectBtn alloc]initTarget:[_tb superview] index:_indexPath];
        
    }else{
        
        btnBottom = [[DYBDataBankSelectBtn alloc]initTarget:[_tb superCon] index:_indexPath];
    }
    
    btnBottom.beginOrPause = _beginOrPause;
    btnBottom.bFolder = [[dict objectForKey:@"is_dir"] boolValue];
    
    NSString *strUserID = SHARED.curUser.userid;
    
    if ([strUserID isEqualToString:[dict objectForKey:@"owner_id"]]) {
        
        btnBottom.bUserSelfFile = YES;
        
    }else{
        
        btnBottom.bUserSelfFile = NO;
    }
    
    BOOL systemFolder = [[dict objectForKey:@"is_sys_folder"]boolValue];
    
    int nType = _btnType;
    
    if (systemFolder) { // 是系统文件
        
        nType = SYSTEMFOLDER;
    }
    
    
    [btnBottom addBtnToCell:_cellBackground type:nType];
}



-(void)chooseDifferentCell:(BOOL)bDir dictObj:(NSDictionary *)dict{
    
    switch (_cellType) {
        case 0:{
            if (bDir) {
                
                [self addCommonFolder:dict];
                
            }else{
                
                [self addCommonDocument:dict];
                
            }
        }
            break;
        case 1:{

            [self addShareComment:dict];
        }
            break;
        case 5:{
            [self addDownLoadCell:dict]; //下载cell
        }
            break;
            
        default:
            break;
    }
}

-(void)addCommonDocument:(NSDictionary *)dict{
    
    UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ICAN_LEFT, ICAN_TOP, ICAN_WIDTH, ICAN_LENGHT)];
    NSString *strIcon = [self getFileIcon:[dict objectForKey:@"type"]];
    [iconImageView setImage:[UIImage imageNamed:strIcon]];
    [iconImageView setBackgroundColor:[UIColor clearColor]];
    [swipView addSubview:iconImageView];
    [iconImageView release];

    _imageViewDown = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 23, 23)];
    [_imageViewDown setImage:[UIImage imageNamed:@"icon_offline_corner" ]];
    [iconImageView addSubview:_imageViewDown];
    RELEASE(_imageViewDown);
    
    
    self.DB.FROM(kDATABANKDOWNDETAIL).WHERE(@"file_urlencode", [dict objectForKey:@"file_urlencode"]).WHERE(@"userid", SHARED.userId).GET();
    
    if ([self.DB.resultArray count] == 0)
    {
        
        [_imageViewDown setHidden:YES];
        
    }
    
    _labelName = [[MagicUILabel alloc]initWithFrame:CGRectMake(ICAN_LEFT + ICAN_WIDTH + LABELDISTANCEICAN, NUM_TOP + 5 + 3 , 200 , 20)];
    [_labelName setText:[dict objectForKey:@"title"]];
    [swipView addSubview:_labelName];
    [_labelName setFont:[DYBShareinstaceDelegate DYBFoutStyle:13]];
    [_labelName setTextAlignment:NSTextAlignmentLeft];
    [_labelName setBackgroundColor:[UIColor clearColor]];
    [_labelName release];

    
    MagicUILabel *labelSize = [[MagicUILabel alloc]initWithFrame:CGRectMake(ICAN_LEFT + ICAN_WIDTH + LABELDISTANCEICAN, NUM_TOP + NUM_HIGHT + DISTANCE_NUM_NAME + 5 + 5, 150 , 20)];
    [labelSize setText:[self strSize:[dict objectForKey:@"size"]]];
    [swipView addSubview:labelSize];
    [labelSize setTextAlignment:NSTextAlignmentLeft];
    [labelSize setFont:[DYBShareinstaceDelegate DYBFoutStyle:11]];
    [labelSize setTextColor:[MagicCommentMethod colorWithHex:@"0xaaaaaa"]];
    [labelSize setBackgroundColor:[UIColor clearColor]];
    [labelSize sizeToFit];
    [labelSize sizeToFit];
    [labelSize release];
    
    MagicUILabel *labelTime = [[MagicUILabel alloc]initWithFrame:CGRectMake(ICAN_LEFT + ICAN_WIDTH + LABELDISTANCEICAN + labelSize.frame.size.width + 10, NUM_TOP + NUM_HIGHT + DISTANCE_NUM_NAME + 5 + 7,  150 , 20)];
    [labelTime setText:[dict objectForKey:@"create_time"]];
    [swipView addSubview:labelTime];
    [labelTime setTextAlignment:NSTextAlignmentLeft];
    [labelTime setFont:[DYBShareinstaceDelegate DYBFoutStyle:11]];
    [labelTime setTextColor:[MagicCommentMethod colorWithHex:@"0xaaaaaa"]];
    [labelTime setBackgroundColor:[UIColor clearColor]];
    [labelTime sizeToFit];
    [labelTime release];

    
    if (![_bSwip isEqualToString:@"NO"]) {
        
        swipIcan = [[MagicUIImageView alloc]initWithFrame:CGRectMake(320 - SWIPICAN_WIDTH, (84 - SWIPICAN_HIGHT)/2, SWIPICAN_WIDTH,SWIPICAN_HIGHT )];
        [swipIcan setImage:[UIImage imageNamed:@"slide_more"]];
        [swipIcan setBackgroundColor:[UIColor clearColor]];
        [swipView addSubview:swipIcan];
        [swipIcan release];
    }
}

-(void)addDownLoadCell:(NSDictionary *)dict{

    MagicUIImageView *iconImageView = [[MagicUIImageView alloc]initWithFrame:CGRectMake(ICAN_LEFT, ICAN_TOP, ICAN_WIDTH, ICAN_LENGHT)];
    
    NSString *strIcon = [self getFileIcon:[dict objectForKey:@"type"]];
    
    [iconImageView setImage:[UIImage imageNamed:strIcon]];
    [iconImageView setBackgroundColor:[UIColor clearColor]];
    [swipView addSubview:iconImageView];
    [iconImageView release];
    
    
    _labelProgress = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 0.0f, ICAN_WIDTH, ICAN_LENGHT)];
    [_labelProgress setText:@"0%"];
    [_labelProgress setTag:600];
    [_labelProgress setBackgroundColor:[MagicCommentMethod colorWithHex:@"6eab44"]];
    [_labelProgress setTextColor:[UIColor whiteColor]];
    [_labelProgress setFont:[DYBShareinstaceDelegate DYBFoutStyle:13]];
    [_labelProgress setTextAlignment:NSTextAlignmentCenter];
    [_labelProgress setAlpha:0.5];
    [iconImageView addSubview:_labelProgress];
    [_labelProgress release];

    
    _labelName = [[MagicUILabel alloc]initWithFrame:CGRectMake(ICAN_LEFT + ICAN_WIDTH + LABELDISTANCEICAN, NUM_TOP , 160 , 20)];
    [_labelName setText:[dict objectForKey:@"title"]];
    [swipView addSubview:_labelName];
    [_labelName setFont:[DYBShareinstaceDelegate DYBFoutStyle:13]];
    [_labelName setTextAlignment:NSTextAlignmentLeft];
    [_labelName setBackgroundColor:[UIColor clearColor]];
    [_labelName release];

    _progressView = [[DYBProgressView alloc] initWithFrame:CGRectMake(ICAN_LEFT + ICAN_WIDTH + LABELDISTANCEICAN, NUM_TOP + NUM_HIGHT + DISTANCE_NUM_NAME,180, 10)];
    [_progressView setProgress:0.0];
    [_progressView setOuterColor: [UIColor clearColor]] ;
    [_progressView setInnerColor: [MagicCommentMethod colorWithHex:@"6eab44"]] ;
    [_progressView setEmptyColor: [MagicCommentMethod colorWithHex:@"f8f8f8"]] ;
    [swipView addSubview: _progressView] ;
    [_progressView release] ;
    
    _imageViewStats= [[UIImageView alloc]initWithFrame:CGRectMake(240 + 10, NUM_TOP, 20.0f, 20.0f)];
    [_imageViewStats setImage:[UIImage imageNamed:@"下载--1"] ];
    [_imageViewStats setBackgroundColor:[UIColor clearColor]];
    [swipView addSubview:_imageViewStats];
    RELEASE(_imageViewStats);

    swipIcan = [[MagicUIImageView alloc]initWithFrame:CGRectMake(320 - SWIPICAN_WIDTH, (84 - SWIPICAN_HIGHT)/2, SWIPICAN_WIDTH,SWIPICAN_HIGHT )];
    [swipIcan setImage:[UIImage imageNamed:@"slide_more"]];
    [swipIcan setBackgroundColor:[UIColor clearColor]];
    [swipView addSubview:swipIcan];
    [swipIcan release];
    
    
    if (_beginOrPause) { //暂停状态
        
        [_labelProgress setBackgroundColor:[MagicCommentMethod colorWithHex:@"aaaaaa"]];
        [_imageViewStats setImage:[UIImage imageNamed:@"下载--3"] ];
    }
    
} 

// 不可删除
-(void)justPinB{

    DLogInfo(@"dddd");

}

-(NSString *)strSize:(NSString *)size{

    if (size == nil) {
        return @"";
    }
    float fSize = [size floatValue];
    float fKSize = fSize/(1000);
    
    if (fKSize < 1000) {
        return [NSString stringWithFormat:@"%.2fK",fKSize];
    }

    float fMSzie = fKSize/1000;
    if (fMSzie < 1000) {
        return [NSString stringWithFormat:@"%.2fM",fMSzie];
    }
    
    
    float fGSzie = fKSize/1000;
    if (fGSzie < 1000) {
        return [NSString stringWithFormat:@"%.2fG",fGSzie];
    }
    
    float fTSzie = fKSize/1000;
    if (fTSzie < 1000) {
        return [NSString stringWithFormat:@"%.2fT",fTSzie];
    }
    
    return @"...";

}
-(void)addCommonFolder:(NSDictionary *)dict{


    MagicUIImageView *iconImageView = [[MagicUIImageView alloc]initWithFrame:CGRectMake(ICAN_LEFT, ICAN_TOP, ICAN_WIDTH, ICAN_LENGHT)];
    [iconImageView setImage:[UIImage imageNamed:[self getPicName:[dict objectForKey:@"icon"]]]];
    [iconImageView setBackgroundColor:[UIColor clearColor]];
    [swipView addSubview:iconImageView];
    [iconImageView release];
    
    
    MagicUIImageView *numImage = [[MagicUIImageView alloc]initWithFrame:CGRectMake(ICAN_LEFT + ICAN_WIDTH + LABELDISTANCEICAN, NUM_TOP, NUM_LENGHT, NUM_HIGHT )];
    [numImage setBackgroundColor:[UIColor clearColor]];
    [numImage setImage:[UIImage imageNamed:[self getNumIcon:[dict objectForKey:@"icon"]]]];
    [swipView addSubview:numImage];
    [numImage release];
    
    UILabel *labelNUM = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, NUM_LENGHT, NUM_HIGHT )];
    [labelNUM setText:[NSString stringWithFormat:@"%@",[dict objectForKey:@"count"]]];
    [labelNUM sizeToFit];
    [labelNUM setFont:[DYBShareinstaceDelegate DYBFoutStyle:15]];
    [labelNUM setTextColor:[UIColor whiteColor]];
    [labelNUM setTextAlignment:NSTextAlignmentCenter];
    [labelNUM setCenter:CGPointMake(NUM_LENGHT/2, NUM_HIGHT/1.7)];
    [labelNUM setBackgroundColor:[UIColor clearColor]];
    [numImage addSubview:labelNUM];
    [labelNUM release];
    
    _labelName = [[MagicUILabel alloc]initWithFrame:CGRectMake(ICAN_LEFT + ICAN_WIDTH + LABELDISTANCEICAN, NUM_TOP + NUM_HIGHT + DISTANCE_NUM_NAME, 150 , 20)];
    [_labelName setText:[dict objectForKey:@"title"]];
    [swipView addSubview:_labelName];
    [_labelName setFont:[DYBShareinstaceDelegate DYBFoutStyle:13]];
    [_labelName setBackgroundColor:[UIColor clearColor]];
    [_labelName release];
    
    
    if (![_bSwip isEqualToString:@"NO"]) {
        
        if (![[dict objectForKey:@"is_sys_folder"] boolValue]) {
            
            swipIcan = [[MagicUIImageView alloc]initWithFrame:CGRectMake(320 - SWIPICAN_WIDTH, (84 - SWIPICAN_HIGHT)/2, SWIPICAN_WIDTH,SWIPICAN_HIGHT )];
            [swipIcan setImage:[UIImage imageNamed:@"slide_more"]];
            [swipIcan setBackgroundColor:[UIColor clearColor]];
            [swipView addSubview:swipIcan];
            [swipIcan release];
        }
    }
}

-(NSString *)getNumIcon:(NSString *)type{

    if ([type isEqualToString:@"audio"]) {
        
        return @"bg_filenum_music";
        
    }else if([type isEqualToString:@"work"]){
        
        return @"bg_filenum_homework";
        
    }else if ([type isEqualToString:@"images"]){
        
        return @"bg_filenum_photo";
        
    }else if([type isEqualToString:@"document"]){
        
        return @"bg_filenum_doc";
        
    }else if([type isEqualToString:@"video"]){
        
        return @"bg_filenum_video";
        
    }else if([type isEqualToString:@"teaching material"]){
        
        return @"bg_filenum_tm";
        
    }
    
    else if ([type isEqualToString:@"other"]){
        
        return @"bg_filenum_others";
        
    }else{
        
        return @"bg_filenum_newfolder";
        
    }
}

-(void)addSharePubic:(NSDictionary *)dict{

    MagicUIImageView *iconImageView = [[MagicUIImageView alloc]initWithFrame:CGRectMake(ICAN_LEFT, ICAN_TOP, ICAN_WIDTH, ICAN_LENGHT)];
    
    NSString *strIcon = [self getFileIcon:[dict objectForKey:@"type"]];
    
    [iconImageView setImage:[UIImage imageNamed:strIcon]];
    [iconImageView setBackgroundColor:[UIColor clearColor]];
    [swipView addSubview:iconImageView];
    [iconImageView release];
    
    _labelName = [[MagicUILabel alloc]initWithFrame:CGRectMake(ICAN_LEFT + ICAN_WIDTH + LABELDISTANCEICAN, NUM_TOP , 200 , 20)];
    [_labelName setText:[dict objectForKey:@"title"]];
    [swipView addSubview:_labelName];
    [_labelName setTextAlignment:NSTextAlignmentLeft];
    [_labelName setFont:[DYBShareinstaceDelegate DYBFoutStyle:13]];
    [_labelName setTextAlignment:NSTextAlignmentLeft];
    [_labelName setBackgroundColor:[UIColor clearColor]];
    //    [_labelName sizeToFit];
    [_labelName release];
       
    if ([[dict objectForKey:@"is_estimate_up"] integerValue] == 1) {
        
        UIButton *btnGood = (UIButton *)[_cellBackground viewWithTag:BTNTAG_GOOD];
        [btnGood setEnabled:NO];
    }
    
    
    if ([[dict objectForKey:@"is_estimate_down"] integerValue]== 1) {
        
        UIButton *btnGood = (UIButton *)[_cellBackground viewWithTag:BTNTAG_BAD];
        [btnGood setEnabled:NO];
    }
    
    if ([[dict objectForKey:@"is_public"] boolValue]) {
        
    }
    
    
    MagicUILabel *labelSize = [[MagicUILabel alloc]initWithFrame:CGRectMake(ICAN_LEFT + ICAN_WIDTH + LABELDISTANCEICAN, NUM_TOP + NUM_HIGHT + DISTANCE_NUM_NAME - 5, 150 , 20)];
    [labelSize setText:[self strSize:[dict objectForKey:@"size"]]];
    [swipView addSubview:labelSize];
    //    [labelSize setTextAlignment:NSTextAlignmentCenter];
    [labelSize setTextAlignment:NSTextAlignmentLeft];
    [labelSize setFont:[DYBShareinstaceDelegate DYBFoutStyle:11]];
    [labelSize setTextColor:[MagicCommentMethod colorWithHex:@"0xaaaaaa"]];
    [labelSize setBackgroundColor:[UIColor clearColor]];
    [labelSize sizeToFit];
    [labelSize release];
    
    MagicUILabel *labelTime = [[MagicUILabel alloc]initWithFrame:CGRectMake(ICAN_LEFT + ICAN_WIDTH + LABELDISTANCEICAN + labelSize.frame.size.width - 25,  NUM_TOP + NUM_HIGHT + DISTANCE_NUM_NAME - 8, 150 , 20)];
    if (_btnType == 1) {
        
        [labelTime setText:[dict objectForKey:@"share_time"]];
    }else{
        
        [labelTime setText:[dict objectForKey:@"create_time"]];
    }
    [swipView addSubview:labelTime];
    [labelTime setTextAlignment:NSTextAlignmentCenter];
    [labelTime setFont:[DYBShareinstaceDelegate DYBFoutStyle:11]];
    [labelTime setTextColor:[MagicCommentMethod colorWithHex:@"0xaaaaaa"]];
    [labelTime setBackgroundColor:[UIColor clearColor]];
    //    [labelName sizeToFit];
    [labelTime release];
    
    
    
    if ([[dict objectForKey:@"is_public"] boolValue] ) {
        
        UIImageView *imageViewGood = [[UIImageView alloc]initWithFrame:CGRectMake(labelTime.frame.size.width + labelTime.frame.origin.x -25, NUM_TOP + NUM_HIGHT + DISTANCE_NUM_NAME - 7, 16, 16)];
        [imageViewGood setImage:[UIImage imageNamed:@"goodicon"]];
        [swipView addSubview:imageViewGood];
        RELEASE(imageViewGood);
        
        _labelGood = [[UILabel alloc]initWithFrame:CGRectMake(imageViewGood.frame.size.width + imageViewGood.frame.origin.x + 5, NUM_TOP+ NUM_HIGHT + DISTANCE_NUM_NAME - 7, 106, 16)];
        [_labelGood setText:[dict objectForKey:@"up"]];
        [_labelGood sizeToFit];
        [_labelGood setFont:[DYBShareinstaceDelegate DYBFoutStyle:11]];
        [_labelGood setBackgroundColor:[UIColor clearColor]];
        [_labelGood setTextColor:[MagicCommentMethod colorWithHex:@"0xaaaaaa"]];
        [swipView addSubview:_labelGood];
        RELEASE(_labelGood);
        
        
        UIImageView *imageViewBad = [[UIImageView alloc]initWithFrame:CGRectMake(_labelGood.frame.size.width + _labelGood.frame.origin.x + 5, NUM_TOP+ NUM_HIGHT + DISTANCE_NUM_NAME - 7, 16, 16)];
        [imageViewBad setImage:[UIImage imageNamed:@"badicon.png"]];
        [swipView addSubview:imageViewBad];
        RELEASE(imageViewBad);
        
        _labelBad = [[UILabel alloc]initWithFrame:CGRectMake(imageViewBad.frame.size.width + imageViewBad.frame.origin.x + 5, NUM_TOP+ NUM_HIGHT + DISTANCE_NUM_NAME - 7, 106, 16)];
        [_labelBad setText:[dict objectForKey:@"down"]];
        [_labelBad sizeToFit];
        [_labelBad setFont:[DYBShareinstaceDelegate DYBFoutStyle:11]];
        [_labelBad setTextColor:[MagicCommentMethod colorWithHex:@"0xaaaaaa"]];
        [_labelBad setBackgroundColor:[UIColor clearColor]];
        [swipView addSubview:_labelBad];
        RELEASE(_labelBad);
        
        
    }

    
    
    
    labelFrom = [[MagicUILabel alloc]initWithFrame:CGRectMake(ICAN_LEFT + ICAN_WIDTH + LABELDISTANCEICAN, NUM_TOP + NUM_HIGHT + DISTANCE_NUM_NAME + 5 + 3, 150 , 20)];
    
    if ([[dict objectForKey:@"is_public"] boolValue] || _btnType == 2 ) { //我的共享和共享给我的，没有来自
        
        NSString *strType = nil;
        
        NSString *strUserID = SHARED.curUser.userid;
        if ([strUserID isEqualToString:[dict objectForKey:@"owner_id"]]) {
            strType = @"来自：";
        }else{
            
            strType = @"来自：";
        }
        
        [labelFrom setText:[NSString stringWithFormat:@"%@ %@",strType,[dict objectForKey:@"author"]]];
        [swipView addSubview:labelFrom];
        [labelFrom setTextColor:[MagicCommentMethod colorWithHex:@"0xaaaaaa"]];
        [labelFrom setFont:[DYBShareinstaceDelegate DYBFoutStyle:11]];
        [labelFrom setBackgroundColor:[UIColor clearColor]];
        [labelFrom release];
        
    }else if (_btnType == 1){
        
     
        [self setPublicString:[dict objectForKey:@"perm"]];
        [swipView addSubview:labelFrom];
        [labelFrom setTextColor:[MagicCommentMethod colorWithHex:@"0xaaaaaa"]];
        [labelFrom setFont:[DYBShareinstaceDelegate DYBFoutStyle:11]];
        [labelFrom setBackgroundColor:[UIColor clearColor]];
        [labelFrom release];
        
    }
    
    if (![_bSwip isEqualToString:@"NO"]) {
        swipIcan = [[MagicUIImageView alloc]initWithFrame:CGRectMake(320 - SWIPICAN_WIDTH, (84 - SWIPICAN_HIGHT)/2, SWIPICAN_WIDTH,SWIPICAN_HIGHT )];
        [swipIcan setImage:[UIImage imageNamed:@"slide_more"]];
        [swipIcan setBackgroundColor:[UIColor clearColor]];
        [swipView addSubview:swipIcan];
        [swipIcan release];
    }
}


-(void)addShareComment:(NSDictionary *)dict{

    if ([[dict objectForKey:@"is_public"] boolValue]) {
        [self addSharePubic:dict];
        return;
    }
    
    MagicUIImageView *iconImageView = [[MagicUIImageView alloc]initWithFrame:CGRectMake(ICAN_LEFT, ICAN_TOP, ICAN_WIDTH, ICAN_LENGHT)];
    
     NSString *strIcon = [self getFileIcon:[dict objectForKey:@"type"]];
    
    [iconImageView setImage:[UIImage imageNamed:strIcon]];
    [iconImageView setBackgroundColor:[UIColor clearColor]];
    [swipView addSubview:iconImageView];
    [iconImageView release];
    
    _labelName = [[MagicUILabel alloc]initWithFrame:CGRectMake(ICAN_LEFT + ICAN_WIDTH + LABELDISTANCEICAN, NUM_TOP , 200 , 20)];
    [_labelName setText:[dict objectForKey:@"title"]]; 
    [swipView addSubview:_labelName];
    [_labelName setTextAlignment:NSTextAlignmentLeft];
    [_labelName setFont:[DYBShareinstaceDelegate DYBFoutStyle:13]];
    [_labelName setTextAlignment:NSTextAlignmentLeft];
    [_labelName setBackgroundColor:[UIColor clearColor]];
//    [_labelName sizeToFit];
    [_labelName release];

      if ([[dict objectForKey:@"is_public"] boolValue] ) {
          
        UIImageView *imageViewGood = [[UIImageView alloc]initWithFrame:CGRectMake(_labelName.frame.size.width + _labelName.frame.origin.x + 5, NUM_TOP , 16, 16)];
        [imageViewGood setImage:[UIImage imageNamed:@"goodicon"]];
        [swipView addSubview:imageViewGood];
        RELEASE(imageViewGood);
        
        _labelGood = [[UILabel alloc]initWithFrame:CGRectMake(imageViewGood.frame.size.width + imageViewGood.frame.origin.x + 5, NUM_TOP , 106, 16)];
        [_labelGood setText:[dict objectForKey:@"up"]];
        [_labelGood sizeToFit];
        [_labelGood setFont:[DYBShareinstaceDelegate DYBFoutStyle:11]];
        [_labelGood setBackgroundColor:[UIColor clearColor]];
        [_labelGood setTextColor:[MagicCommentMethod colorWithHex:@"0xaaaaaa"]];
        [swipView addSubview:_labelGood];
        RELEASE(_labelGood);
          
          
          UIImageView *imageViewBad = [[UIImageView alloc]initWithFrame:CGRectMake(_labelGood.frame.size.width + _labelGood.frame.origin.x + 5, NUM_TOP , 16, 16)];
          [imageViewBad setImage:[UIImage imageNamed:@"badicon.png"]];
          [swipView addSubview:imageViewBad];
          RELEASE(imageViewBad);
          
          _labelBad = [[UILabel alloc]initWithFrame:CGRectMake(imageViewBad.frame.size.width + imageViewBad.frame.origin.x + 5, NUM_TOP , 106, 16)];
          [_labelBad setText:[dict objectForKey:@"down"]];
          [_labelBad sizeToFit];
          [_labelBad setFont:[DYBShareinstaceDelegate DYBFoutStyle:11]];
          [_labelBad setTextColor:[MagicCommentMethod colorWithHex:@"0xaaaaaa"]];
          [_labelBad setBackgroundColor:[UIColor clearColor]];
          [swipView addSubview:_labelBad];
          RELEASE(_labelBad);

    
      }
    
    if ([[dict objectForKey:@"is_estimate_up"] integerValue] == 1) {
        
        UIButton *btnGood = (UIButton *)[_cellBackground viewWithTag:BTNTAG_GOOD];
        [btnGood setEnabled:NO];
    }
    
    
    if ([[dict objectForKey:@"is_estimate_down"] integerValue]== 1) {
        
        UIButton *btnGood = (UIButton *)[_cellBackground viewWithTag:BTNTAG_BAD];
        [btnGood setEnabled:NO];
    }
    
    if ([[dict objectForKey:@"is_public"] boolValue]) {
    
            }
    
    
    MagicUILabel *labelSize = [[MagicUILabel alloc]initWithFrame:CGRectMake(ICAN_LEFT + ICAN_WIDTH + LABELDISTANCEICAN, NUM_TOP + NUM_HIGHT + DISTANCE_NUM_NAME - 5, 150 , 20)];
    [labelSize setText:[self strSize:[dict objectForKey:@"size"]]];
    [swipView addSubview:labelSize];
    //    [labelSize setTextAlignment:NSTextAlignmentCenter];
    [labelSize setTextAlignment:NSTextAlignmentLeft];
    [labelSize setFont:[DYBShareinstaceDelegate DYBFoutStyle:11]];
    [labelSize setTextColor:[MagicCommentMethod colorWithHex:@"0xaaaaaa"]];
    [labelSize setBackgroundColor:[UIColor clearColor]];
    [labelSize sizeToFit];
    [labelSize release];
    
    MagicUILabel *labelTime = [[MagicUILabel alloc]initWithFrame:CGRectMake(ICAN_LEFT + ICAN_WIDTH + LABELDISTANCEICAN + labelSize.frame.size.width - 15,  NUM_TOP + NUM_HIGHT + DISTANCE_NUM_NAME - 8, 150 , 20)];
    if (_btnType == 1) {
  
        [labelTime setText:[dict objectForKey:@"share_time"]];
    }else{
  
        [labelTime setText:[dict objectForKey:@"create_time"]];
    }
        [swipView addSubview:labelTime];
    [labelTime setTextAlignment:NSTextAlignmentCenter];
    [labelTime setFont:[DYBShareinstaceDelegate DYBFoutStyle:11]];
    [labelTime setTextColor:[MagicCommentMethod colorWithHex:@"0xaaaaaa"]];
    [labelTime setBackgroundColor:[UIColor clearColor]];
    //    [labelName sizeToFit];
    [labelTime release];

    labelFrom = [[MagicUILabel alloc]initWithFrame:CGRectMake(ICAN_LEFT + ICAN_WIDTH + LABELDISTANCEICAN, NUM_TOP + NUM_HIGHT + DISTANCE_NUM_NAME + 5 + 3, 150 , 20)];
  
       if ([[dict objectForKey:@"is_public"] boolValue] || _btnType == 2 ) { //我的共享和共享给我的，没有来自
           
            NSString *strType = nil;
            
            NSString *strUserID = SHARED.curUser.userid;
            if ([strUserID isEqualToString:[dict objectForKey:@"owner_id"]]) {
                strType = @"来自：";
            }else{
            
                strType = @"来自：";
            }
            
            [labelFrom setText:[NSString stringWithFormat:@"%@ %@",strType,[dict objectForKey:@"author"]]];
            [swipView addSubview:labelFrom];
            [labelFrom setTextColor:[MagicCommentMethod colorWithHex:@"0xaaaaaa"]];
            [labelFrom setFont:[DYBShareinstaceDelegate DYBFoutStyle:11]];
            [labelFrom setBackgroundColor:[UIColor clearColor]];
            [labelFrom release];
    
       }else if (_btnType == 1){
           

           [self setPublicString:[dict objectForKey:@"perm"]];
           [swipView addSubview:labelFrom];
           [labelFrom setTextColor:[MagicCommentMethod colorWithHex:@"0xaaaaaa"]];
           [labelFrom setFont:[DYBShareinstaceDelegate DYBFoutStyle:11]];
           [labelFrom setBackgroundColor:[UIColor clearColor]];
           [labelFrom release];
       
       }
    
    if (![_bSwip isEqualToString:@"NO"]) {
        swipIcan = [[MagicUIImageView alloc]initWithFrame:CGRectMake(320 - SWIPICAN_WIDTH, (84 - SWIPICAN_HIGHT)/2, SWIPICAN_WIDTH,SWIPICAN_HIGHT )];
        [swipIcan setImage:[UIImage imageNamed:@"slide_more"]];
        [swipIcan setBackgroundColor:[UIColor clearColor]];
        [swipView addSubview:swipIcan];
        [swipIcan release];
    }
}

-(NSString *)setPublicString:(NSString *)perm{

    NSString *strType =@"共享：";
    NSString *perm1 = [DYBShareinstaceDelegate getPermType:[perm integerValue]];
    NSString *strRetuen = [NSString stringWithFormat:@"%@ %@",strType,perm1];
    
    [labelFrom setText:strRetuen];
    return strRetuen;


}

-(NSString *)getPicName:(NSString *)type{
    
    if ([type isEqualToString:@"audio"]) {
        
        return @"icon_music";
        
    }else if([type isEqualToString:@"work"]){
    
        return @"icon_homework";
        
    }else if ([type isEqualToString:@"images"]){
    
        return @"icon_photo";
    
    }else if([type isEqualToString:@"document"]){
    
        return @"icon_doc";
    
    }else if ([type isEqualToString:@"other"]){
    
        return @"icon_others";
    
    }
    
    else if([type isEqualToString:@"video"]){
        
        return @"icon_video";
        
    }else if([type isEqualToString:@"teaching material"]){
        
        return @"icon_tm";
        
    }else{
    
        return @"icon_newfolder";
    
    }    
}

-(NSString *)getFileIcon:(NSString *)key{

    key = [key lowercaseString]; //转小写
    
    if ([key isEqualToString:@"zip"]) {
        return @"xh_wj_1";
    }
    else if ([key isEqualToString:@"psd"]) {
        return @"xh_wj_2";
    }
    else if ([key isEqualToString:@"ai"]) {
        return @"xh_wj_3";
    }
    else if ([key isEqualToString:@"swf"]){
    
        return @"xh_wj_4";
    }
    else if ([key isEqualToString:@"fla"]) {
        return @"xh_wj_5";
    }
    else if ([key isEqualToString:@"mp3"]) {
        return @"xh_wj_6";
    }
    else if ([key isEqualToString:@"pdf"]) {
        return @"xh_wj_7";
    }
    else if ([key isEqualToString:@"wmv"]) {
        return @"xh_wj_8";
    }
    else if ([key isEqualToString:@"htm"]||[key isEqualToString:@"html"]) {
        return @"xh_wj_9";
    }
    else if ([key isEqualToString:@"doc"]||[key isEqualToString:@"docx"] ) {
        return @"xh_wj_10";
    }
    else if ([key isEqualToString:@"xls"]||[key isEqualToString:@"xlsx"]) {
        return @"xh_wj_11";
    }
    else if ([key isEqualToString:@"txt"]) {
        return @"xh_wj_12";
    }
    else if ([key isEqualToString:@"png"]) {
        return @"xh_wj_14";
    }
    else if ([key isEqualToString:@"jpg"]) {
        
        return @"xh_wj_15";
        
    }else if ([key isEqualToString:@"gif"]){
    
        return @"xh_wj_16";
    
    }else if ([key isEqualToString:@"ppt"] || [key isEqualToString:@"pptx"])
    {
    
        return @"xh_wj_ppt.png";
    }else if ([key isEqualToString:@"3gp"]){
        
        return @"xh_wj_3gp";
        
    }else if ([key isEqualToString:@"aac"]){
        
        return @"xh_wj_aac";
        
    }
    else if ([key isEqualToString:@"avi"]){
        
        return @"xh_wj_avi";
        
    }
    else if ([key isEqualToString:@"bmp"]){
        
        return @"xh_wj_bmp";
        
    }
    else if ([key isEqualToString:@"asf"]){
        
        return @"xh_wj_asf";
        
    }
    else if ([key isEqualToString:@"mov"]){
        
        return @"xh_wj_mov";
        
    }
    else if ([key isEqualToString:@"asx"]){
        
        return @"xh_wj_asx.png";
        
    }
    else{
        
        return @"xh_wj_13";
    
    }

}

- (void)setCellBackgroundColor:(UIColor *)color{
    
    [_cellBackground setBackgroundColor:color];
    [swipView setBackgroundColor:color];
}
-(void)setSwipViewBackColor:(UIColor *)color{

    [_cellBackground setBackgroundColor:[UIColor colorWithRed:248/255.0f green:248/255.0f blue:248/255.0f alpha:1.0f]];
    [swipView setBackgroundColor:color];
}

#pragma mark- 接受UIView信号
- (void)handleViewSignal_UIView:(MagicViewSignal *)signal{
//    DLogInfo(@"pan");
    if ([signal is:[UIView PAN]]) {//拖动信号
        NSDictionary *d=(NSDictionary *)signal.object;
        UIPanGestureRecognizer *recognizer=[d objectForKey:@"sender"];
        
        {
          
            if ([recognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
                UIPanGestureRecognizer *panRecognizer = (UIPanGestureRecognizer *)recognizer;
                
                CGPoint translation = [(UIPanGestureRecognizer *)panRecognizer translationInView:self];//移动距离及方向 x>0:右移
                
//                DLogInfo(@"currentTouchPositionX -- %f",self.initialTouchPositionX);

                if (translation.x > 0 &&   self.initialTouchPositionX!=0 && swipView.frame.origin.x >= 0) {
                    {/*此cell是否是在未展开状态右划*/
//                        NSLog(@"66666");
                        
                    //恢复swip view frame
                        [swipView setFrame:CGRectMake(0.0f, 0, swipView.frame.size.width, swipView.frame.size.height)];
                        
                        MagicViewController *con=(MagicViewController *)[self superCon];
                        if ([con isKindOfClass:[DYBDataBankChildrenListViewController class]])
                        {
                            [con.drNavigationController handleSwitchView:recognizer];
                        }else
                        {
                            DYBUITabbarViewController *tabbar=[DYBUITabbarViewController sharedInstace];
                            [[tabbar getThreeview] oneViewSwipe:panRecognizer];
                        }
                        
                        return;
                    }
                }
                
                
                CGPoint currentTouchPoint = [panRecognizer locationInView:self.contentView];
                CGFloat currentTouchPositionX = currentTouchPoint.x;
                
              
                
                if (recognizer.state == UIGestureRecognizerStateBegan) {
                    
                    
//                    NSLog(@"UIGestureRecognizerStateBegan---");
                     ptBegin = [recognizer translationInView:self];
                    currentCenter = swipView.center;
                    self.initialTouchPositionX = currentTouchPositionX;
                    
                } else if (recognizer.state == UIGestureRecognizerStateChanged) {
                    
                    CGPoint ptEnd = [recognizer translationInView:self];
//                    NSLog(@"UIGestureRecognizerStateChanged --- %f",ptEnd.x);
                    currentCenter.x = 160 + ptEnd.x - ptBegin.x;
//                    NSLog(@"swipview --- %@",swipView);
                    if (isOpen) {
                        UITableViewCell *cell = [_tb._muA_differHeightCellView objectAtIndex:_tb._selectIndex_now.row];
                        if (ptEnd.x < 0 && [cell isEqual:self]) { //打开的时候，不在左划
                            return;
                        }
                        
                        if (swipView.frame.origin.x + ptEnd.x - ptBegin.x <0 && [cell isEqual:self]) { //防止划过界
                            return;
                        }
                        
                        swipView.center = currentCenter;

                        isOpen = NO;
                        
                    }else{
                        swipView.center = currentCenter;
                    }
                } else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
                    
                    CGPoint ptEnter = swipView.center;
//                    NSLog(@"swipView.center --- %f",swipView.center.x);
                    if (isOpen) {
                        
                        
                        [self judgeSlideRange_Point:ptEnter parameter:-200];
//                        [self removeGestureRecognizer:t];
                        
                    }else{
                        
                        [self judgeSlideRange_Point:ptEnter parameter:120];
                        
                    }
                }
            }
        }
    }
    else if ([signal is:[UIView TAP]]) {
        
        isOpen = NO;
        NSDictionary *object=(NSDictionary *)signal.object;
        NSDictionary *d=[object objectForKey:@"object"];
        UITableView *tbv=[d objectForKey:@"tbv"];
                
        //关闭上次展开的cell
        if (tbv._selectIndex_now) {
            UITableViewCell *cell=[tbv._muA_differHeightCellView objectAtIndex:tbv._selectIndex_now.row];
            [cell resetContentView];
            tbv._selectIndex_now=nil;
        }else{//选中cell
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:tbv, @"tableView", [d objectForKey:@"indexPath"], @"indexPath", nil];
            [self sendViewSignal:[MagicUITableView TABLEDIDSELECT] withObject:dict];
        }
        
        [self resetContentView];
    }
        
}
-(void)tomgg{


}
-(void)judgeSlideRange_Point:(CGPoint )point parameter:(float)param{


    if (point.x > param) {
        
        [swipIcan setImage:[UIImage imageNamed:@"slide_more"]];
        [swipIcan setFrame:CGRectMake(320 - SWIPICAN_WIDTH, (84 - SWIPICAN_HIGHT)/2, SWIPICAN_WIDTH,SWIPICAN_HIGHT)];
        
        isOpen = NO;
            
        [self cellRemoveTapView];        
        [UIView animateWithDuration:0.3 animations:^{
            
            [swipView setFrame:CGRectMake(0.0f, 0, swipView.frame.size.width, swipView.frame.size.height)];
        }];
                
    }else{
        
        [swipIcan setImage:[UIImage imageNamed:@"close_more.png"]];
        
        [swipIcan setFrame:CGRectMake(320  - SWIPICAN_WIDTH - (25 - SWIPICAN_WIDTH), (84 - SWIPICAN_HIGHT)/2, SWIPICAN_WIDTH,SWIPICAN_HIGHT)];
        
        //发送信号到上层页面
        [self sendViewSignal:[DYBDataBankListCell FINISHSWIP] withObject:nil from:self target:_sendMegTarget];
        isOpen = YES;
                
        [UIView animateWithDuration:0.3 animations:^{
            
            [swipView setFrame:CGRectMake(- 295,0, swipView.frame.size.width, swipView.frame.size.height)];
        
            UITableView *tbv=((UITableView *)(self.superview));
            
            if (swipView.frame.origin.x<0) {//此cell已展开
                
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


-(void)closeCell{

    if (isOpen) {
        
        [self resetContentView];
        _tb._selectIndex_now = nil;
        
        isOpen = NO;
    }

}
-(void)cellRemoveTapView{

    UIView * view = [swipView viewWithTag:TAPVIEWTAG];
    if (view) {
        [view removeFromSuperview];
    
    }
    [swipIcan setImage:[UIImage imageNamed:@"slide_more"]];
    [swipIcan setFrame:CGRectMake(320 - SWIPICAN_WIDTH, (84 - SWIPICAN_HIGHT)/2, SWIPICAN_WIDTH,SWIPICAN_HIGHT)];
}

-(void)doTap{
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [swipView setFrame:CGRectMake(0.0f, 0, swipView.frame.size.width, swipView.frame.size.height)];
        
    }];

    isOpen = NO;
    [self cellRemoveTapView];

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
    if (swipView.frame.origin.x<0) {
        [UIView animateWithDuration:0.3
                              delay:0.
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                         animations:^
         {
             swipView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 84.0f);
         } completion:^(BOOL finished) {
         }];
    }
   
     [self cellRemoveTapView];
     
}

- (void)dealloc
{
    RELEASE(btnBottom);
    btnBottom = nil;
    
    RELEASE(_sendMegTarget);
    _sendMegTarget = nil;
    
    [super dealloc];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
