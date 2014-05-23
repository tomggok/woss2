//
//  DYBCellForPersonalProfile.m
//  DYiBan
//
//  Created by zhangchao on 13-9-8.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBCellForPersonalProfile.h"
#import "user.h"
#import "UITableView+property.h"
#import "UIView+MagicCategory.h"

@interface DYBCellForPersonalProfile()
{
}
@property (nonatomic, retain)user *model;
@end

@implementation DYBCellForPersonalProfile
@synthesize model = _model;

- (void)dealloc
{
    RELEASEOBJ(_model);
    [super dealloc];
}

-(void)setContent:(id)data indexPath:(NSIndexPath *)indexPath tbv:(UITableView *)tbv{
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    
    self.model=data;
    
    [self setFrame:CGRectMake(0, 0, tbv.frame.size.width, tbv._cellH)];
//    self.layer.borderWidth=0.5;
    self.backgroundColor = [UIColor redColor];
//    self.layer.borderColor = ColorDivLine.CGColor;
    
    switch (indexPath.section) {
        case 0://基本资料
        {
            switch (indexPath.row) {
                case 0://用户名
                {
                    [self initBackView];
                    
                    [self initTitle:@"用户名 :"];
                    
                    [self initContent:_lbTitle content:_model.username textColor:ColorGray];
                    
                    [self initRightView:[UIImage imageNamed:@"grzy_12"] btnTag:-1 model:_model];
                }
                    break;
                    
                case 1://邮箱
                {
                    [self initBackView];

                    [self initTitle:@"邮箱 :"];

                    [self initContent:_lbTitle content:_model.email textColor:ColorGray];
                    
                    [self initRightView:[UIImage imageNamed:@"grzy_12"] btnTag:-1 model:_model];
                }
                    break;
                case 2://昵称
                {
                    [self initBackView];
                    
                    [self initTitle:@"昵称 :"];
                    
                    _nameInput = [[MagicUITextField alloc]initWithFrame:CGRectMake(_lbTitle.frame.origin.x+_lbTitle.frame.size.width+10, _lbTitle.frame.origin.y, 0, 0)];
                    _nameInput.text = _model.name;
                    [_vBack addSubview:_nameInput];
                    [self initContent1:_lbTitle content:_model.name textColor:ColorBlack];
                    
                    [self initRightView:[UIImage imageNamed:@"grzy_13"] btnTag:02 model:_model];
                }
                    break;
                case 3://性别
                {
                    [self initBackView];
                    
                    [self initTitle:@"性别 :"];
                    
                    [self initContent:_lbTitle content:(([_model.sex intValue]==0)?(@"男"):(@"女")) textColor:ColorGray];
                    
                    [self initRightView:[UIImage imageNamed:@"grzy_12"] btnTag:-1 model:_model];
                }
                    break;
                case 4://生日
                {
                    [self initBackView];
                    
                    [self initTitle:@"生日 :"];
                    
                    {
                        NSString *b = [NSString stringWithFormat:@"%@(%@)",_model.birthday,_model.sx];
                        if ((!_model.birthday || _model.birthday.length == 0) && (!_model.sx || _model.sx.length == 0)) {
                            b = _model.userInfoPirvateString;
                            
                        }else if(!_model.birthday || _model.birthday.length == 0){
                            b = _model.sx;
                        }else if (!_model.sx || _model.sx.length == 0){
                            b = _model.birthday;
                        }
                        
                        [self initContent:_lbTitle content:b textColor:ColorBlack];
                    }
                    
                    [self initRightView:[UIImage imageNamed:@"grzy_13"] btnTag:04 model:_model];
                }
                    break;
                case 5://家乡
                {
                    [self initBackView];
                    
                    [self initTitle:@"家乡 :"];
                    
                    {
                        NSString *hometown = _model.hometown;
                        if ([hometown stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] == 0) {
                            hometown = @"未填写";
                        }
                        
                        [self initContent:_lbTitle content:hometown textColor:ColorBlack];
                    }
                    
                    [self initRightView:[UIImage imageNamed:@"grzy_13"] btnTag:05 model:_model];
                }
                    break;
                case 6://手机
                {
                    [self initBackView];
                    
                    [self initTitle:@"手机 :"];
                    
                    {
                        NSString *phone = _model.phone;
                        if ([phone stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] == 0) {
                            phone = @"未填写";
                        }
                        
                        [self initContent:_lbTitle content:phone textColor:ColorBlack];
                    }
                    
                    [self initRightView:[UIImage imageNamed:@"list_arrow"] btnTag:06 model:_model];
//                    self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1://教育信息
        {
            switch (indexPath.row) {
         
                case 0://认证信息
                {
                    [self initBackView];
                    
                    [self initTitle:@"认证信息 :"];
                    
                    {
                        NSString *type = @"未认证";
                        if ([_model.verify isEqualToString:@"2"]) {
                            type = @"校园认证用户";
                        }else if ([_model.verify isEqualToString:@"1"]){
                            type = @"实名认证用户";
                        }else {
                            
                        }
                        
                        [self initContent:_lbTitle content:type textColor:ColorGray];
                    }
                    
                    [self initRightView:[UIImage imageNamed:@"grzy_12"] btnTag:-1 model:_model];
                }
                    break;
                case 1://所在学校
                {
                    [self initBackView];
                    
                    [self initTitle:@"所在学校 :"];
                    
                    [self initContent:_lbTitle content:_model.user_schoolname textColor:ColorGray];
                    
                    [self initRightView:[UIImage imageNamed:@"grzy_12"] btnTag:-1 model:_model];
                }
                    break;
                case 2://所在学院
                {
                    [self initBackView];
                    
                    [self initTitle:@"所在学院 :"];
                    
                    [self initContent:_lbTitle content:_model.college textColor:ColorBlack];
                    
                    [self initRightView:[UIImage imageNamed:@"grzy_13"]  btnTag:12 model:_model];
                }
                    break;
                case 3://入学年份
                {
                    [self initBackView];
                    
                    [self initTitle:@"入学年份 :"];
                    
                    [self initContent:_lbTitle content:_model.joinyear textColor:ColorBlack];
                    
                    [self initRightView:[UIImage imageNamed:@"grzy_13"] btnTag:13 model:_model];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 2://个人隐私|社区信息
        {
            if ([_model.userid isEqualToString:SHARED.curUser.userid]) {
                SHARED.curUser = _model;
                switch (indexPath.row) {
                        
                    case 0://主页
                    {
                        [self initBackView];
                        
                        [self initTitle:@"主页 :"];
                        
                        {
                            NSString *type = PICKERPRIVATEAP;
                            if ([/**/_model.visit_private isEqualToString:@"0"]) {
                                type = PICKERPRIVATEAP;
                            }else if ([/**/_model.visit_private isEqualToString:@"1"]){
                                type = PICKERPRIVATEOF;
                            }else if ([/**/_model.visit_private isEqualToString:@"2"]){
                                type = PICKERPRIVATEOM;
                            }else if ([/**/_model.visit_private isEqualToString:@"3"]){
                                type = PICKERPRIVATEFSS;
                            }
                            [self initContent:_lbTitle content:type textColor:ColorBlack];
                        }
                        
                        [self initRightView:[UIImage imageNamed:@"grzy_13"] btnTag:20 model:_model];
                    }
                        break;
                    case 1://生日
                    {
                        [self initBackView];
                        
                        [self initTitle:@"生日 :"];
                        
                        {
                            NSString *type = PICKERPRIVATEOM;
                            if ([/**/_model.birthday_private isEqualToString:@"0"]) {
                                type = PICKERPRIVATEOM;
                            }else if ([/**/_model.birthday_private isEqualToString:@"1"]){
                                type = PICKERPRIVATEAP;
                            }else if ([/**/_model.birthday_private isEqualToString:@"2"]){
                                type = PICKERPRIVATESM;
                            }else if ([/**/_model.birthday_private isEqualToString:@"3"]){
                                type = PICKERPRIVATESD;
                            }
                            
                            [self initContent:_lbTitle content:type textColor:ColorBlack];
                            
                        }
                        
                        [self initRightView:[UIImage imageNamed:@"grzy_13"] btnTag:21 model:_model];
                    }
                        break;
                    case 2://家乡
                    {
                        [self initBackView];
                        
                        [self initTitle:@"家乡 :"];
                        
                        {
                            NSString *type = PICKERPRIVATEOM;
                            if ([/**/_model.hometown_private isEqualToString:@"0"]) {
                                type = PICKERPRIVATEOM;
                            }else if ([/**/_model.hometown_private isEqualToString:@"1"]){
                                type = PICKERPRIVATEAP;
                            }else if ([/**/_model.hometown_private isEqualToString:@"2"]){
                                type = PICKERPRIVATEFSS;
                            }else if ([/**/_model.hometown_private isEqualToString:@"3"]){
                                type = PICKERPRIVATEOF;
                            }
                            
                            [self initContent:_lbTitle content:type textColor:ColorBlack];
                        }
                        
                        [self initRightView:[UIImage imageNamed:@"grzy_13"] btnTag:22 model:_model];
                    }
                        break;
                    case 3://手机
                    {
                        [self initBackView];
                        
                        [self initTitle:@"手机 :"];
                        
                        {
                            NSString *type = PICKERPRIVATEOM;
                            if ([/**/_model.phone_private isEqualToString:@"0"]) {
                                type = PICKERPRIVATEOM;
                            }else if ([/**/_model.phone_private isEqualToString:@"1"]){
                                type = PICKERPRIVATEAP;
                            }else if ([/**/_model.phone_private isEqualToString:@"2"]){
                                type = PICKERPRIVATEFSS;
                            }else if ([/**/_model.phone_private isEqualToString:@"3"]){
                                type = PICKERPRIVATEOF;
                            }
                            
                            [self initContent:_lbTitle content:type textColor:ColorBlack];
                        }
                        
                        [self initRightView:[UIImage imageNamed:@"grzy_13"] btnTag:23 model:_model];
                    }
                        break;
                    default:
                        break;
                }
            }else{
                {
                    BOOL b=([_model.points intValue]>INT32_MAX);//是否有贡献值
                    
                    switch (indexPath.row) {
                            
                        case 0://贡献值|社区排名
                        {
                            [self initBackView];
                            
                            [self initTitle:(b?(@"贡献值 :"):(@"社区排名 :"))];
                            
                            [self initContent:_lbTitle content:(b?(_model.points):(_model.community_sort)) textColor:(b?(ColorBlack):(ColorGray))];
                            
                            [self initRightView:(b?[UIImage imageNamed:@"list_arrow"]:[UIImage imageNamed:@"grzy_12"])  btnTag:(b?31:-1 ) model:_model];
                        }
                            break;
                        case 1://社区排名|综合实力
                        {
                            [self initBackView];
                            
                            [self initTitle:(b?(@"社区排名 :"):(@"综合实力 :"))];
                            
                            [self initContent:_lbTitle content:(b?(_model.community_sort):(_model.total_up)) textColor:ColorGray];
                            
                            [self initRightView: [UIImage imageNamed:@"grzy_12"] btnTag:-1 model:_model];
                        }
                            break;
                        case 2://综合实力|注册时间
                        {
                            [self initBackView];
                            
                            [self initTitle:(b?(@"综合实力 :"):(@"注册时间 :"))];
                            
                            [self initContent:_lbTitle content:(b?(_model.total_up):(_model.register_time)) textColor:ColorGray];
                            
                            [self initRightView:[UIImage imageNamed:@"grzy_12"] btnTag:-1 model:_model];
                        }
                            break;
                        case 3://注册时间
                        {
                            [self initBackView];
                            
                            [self initTitle:@"注册时间 :"];
                            
                            [self initContent:_lbTitle content:(_model.register_time) textColor:ColorGray];
                            
                            [self initRightView:[UIImage imageNamed:@"grzy_12"] btnTag:-1 model:_model];
                        }
                            break;
                        default:
                            break;
                    }
                }
            }

        }
            break;
        case 3://社区信息
        {
            BOOL b=([_model.points intValue]>INT32_MAX);//是否有贡献值

            switch (indexPath.row) {
                    
                case 0://贡献值|社区排名
                {
                    [self initBackView];
                    
                    [self initTitle:(b?(@"贡献值 :"):(@"社区排名 :"))];
                    
                    [self initContent:_lbTitle content:(b?(_model.points):(_model.community_sort)) textColor:(b?(ColorBlack):(ColorGray))];
                    
                    [self initRightView:[UIImage imageNamed:@"grzy_12"]  btnTag:(b?31:-1 ) model:_model];
                }
                    break;
                case 1://社区排名|综合实力
                {
                    [self initBackView];
                    
                    [self initTitle:(b?(@"社区排名 :"):(@"综合实力 :"))];
                    
                    [self initContent:_lbTitle content:(b?(_model.community_sort):(_model.total_up)) textColor:ColorGray];
                    
                    [self initRightView: [UIImage imageNamed:@"grzy_12"] btnTag:-1 model:_model];
                }
                    break;
                case 2://综合实力|注册时间
                {
                    [self initBackView];
                    
                    [self initTitle:(b?(@"综合实力 :"):(@"注册时间 :"))];
                    
                    [self initContent:_lbTitle content:(b?(_model.total_up):(_model.register_time)) textColor:ColorGray];
                    
                    [self initRightView:[UIImage imageNamed:@"grzy_12"] btnTag:-1 model:_model];
                }
                    break;
                case 3://注册时间
                {
                    [self initBackView];
                    
                    [self initTitle:@"注册时间 :"];
                    
                    [self initContent:_lbTitle content:(_model.register_time) textColor:ColorGray];
                    
                    [self initRightView:[UIImage imageNamed:@"grzy_12"] btnTag:-1 model:_model];
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

-(void)initBackView
{
    if(!_vBack){
        _vBack=[[UIView alloc]initWithFrame:CGRectMake(15, 0, self.frame.size.width-30, self.frame.size.height)];
        _vBack.layer.borderWidth=0.5;
        _vBack.backgroundColor = [MagicCommentMethod colorWithHex:@"f8f8f8"];
        _vBack.layer.borderColor = ColorDivLine.CGColor;
        [self addSubview:_vBack];
        _vBack.userInteractionEnabled = YES;
        RELEASE(_vBack);
    }
}

-(void)initContent:(MagicUILabel *)lb content:(NSString *)content textColor:(UIColor *)textColor
{
    if (!_lb_content) {//
        _lb_content=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(lb.frame.origin.x+lb.frame.size.width+10, lb.frame.origin.y, 0,0)];
        _lb_content.backgroundColor=[UIColor clearColor];
        _lb_content.textAlignment=NSTextAlignmentLeft;
        _lb_content.font=[DYBShareinstaceDelegate DYBFoutStyle:15];
        _lb_content.text=content;
        _lb_content.textColor=textColor;
        _lb_content.numberOfLines=1;
        _lb_content.lineBreakMode=NSLineBreakByTruncatingTail;
        [_lb_content sizeToFitByconstrainedSize:CGSizeMake(_vBack.frame.size.width-_lb_content.frame.origin.x-30, _vBack.frame.size.height)];
        //                        [_lb_sign setNeedCoretext:YES];
        [_vBack addSubview:_lb_content];
        [_lb_content changePosInSuperViewWithAlignment:1];
        RELEASE(_lb_content);
        
    }
    
    
}

- (void)setTextType:(MagicUITextField*)textFeild placeText:(NSString *)placeText textType:(int)type{
    
    
   
    
    [self addSubview:textFeild];
}

-(void)initContent1:(MagicUILabel *)lb content:(NSString *)content textColor:(UIColor *)textColor
{
     _lb_content=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(lb.frame.origin.x+lb.frame.size.width+10, lb.frame.origin.y, 0,0)];
    _lb_content.text=content;
    [_lb_content sizeToFitByconstrainedSize:CGSizeMake(_vBack.frame.size.width-_lb_content.frame.origin.x-20, _vBack.frame.size.height)];
    
    //输入用户名
    _nameInput.frame = CGRectMake(lb.frame.origin.x+lb.frame.size.width+10, lb.frame.origin.y, _vBack.frame.size.width-120,_lb_content.frame.size.height);
    _nameInput.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_nameInput setReturnKeyType:UIReturnKeyDone];
    _nameInput.userInteractionEnabled = NO;
    _nameInput.font = [DYBShareinstaceDelegate DYBFoutStyle:15];  //字体和大小设置
    _nameInput.textColor = textColor;
//    _nameInput.layer.borderWidth = 0;
//    _nameInput.layer.borderColor = [UIColor clearColor];
    
}

-(void)initRightView:(UIImage *)img btnTag:(int)tag model:(user *)model
{//
    if (![SHARED.curUser.userid isEqualToString:model.userid]) {
        return;
    }
    _btIcon=[[MagicUIButton alloc]initWithFrame:CGRectMake(_vBack.frame.size.width-img.size.width-10, 0, img.size.width, img.size.height)];
    _btIcon.tag=tag;
    
    NSString *_vBackOrginy = [@"" stringByAppendingFormat:@"%f",self.frame.origin.y];
    DLogInfo(@"========gaodu========%@",_vBackOrginy);
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:_nameInput, @"textfeild",_vBackOrginy, @"Orginy", nil];
    
    [_btIcon addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside object:dict];
    [_btIcon setImage:img forState:UIControlStateNormal];
    //                            [_bt_pushUpNumsArea setTitle:@"80"];
    _btIcon.showsTouchWhenHighlighted=YES;
    //                            [_bt_pushUpNumsArea setTitleColor:[UIColor whiteColor]];
    //                            [_bt_pushUpNumsArea setTitleFont:/*[DYBShareinstaceDelegate DYBFoutStyle:15]*/ [UIFont systemFontOfSize:15]];
    //        [_bt_pushUpNumsArea setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 5, 0)];
    _btIcon.backgroundColor=[UIColor clearColor];
    [_btIcon setImageEdgeInsets:UIEdgeInsetsMake(img.size.width/4, img.size.width/4, img.size.width/4,img.size.width/4)];
    [_vBack addSubview:_btIcon];
    [_btIcon changePosInSuperViewWithAlignment:1];
    RELEASE(_btIcon);
}

-(void)initTitle:(NSString *)title
{
    if(!_lbTitle){//
        _lbTitle=[[DYBCustomLabel alloc]initWithFrame:CGRectMake(10, 0, 1000,1000)];
        _lbTitle.backgroundColor=[UIColor clearColor];
        _lbTitle.textAlignment=NSTextAlignmentLeft;
        _lbTitle.font=[DYBShareinstaceDelegate DYBFoutStyle:18];
        _lbTitle.text=title;
        _lbTitle.textColor=ColorBlack;
        _lbTitle.numberOfLines=1;
        _lbTitle.lineBreakMode=NSLineBreakByTruncatingTail;
        [_lbTitle sizeToFitByconstrainedSize:CGSizeMake(_lbTitle.frame.size.width, _lbTitle.frame.size.height)];
        //                        [_lb_sign setNeedCoretext:YES];
        [_vBack addSubview:_lbTitle];
        [_lbTitle changePosInSuperViewWithAlignment:1];
        RELEASE(_lbTitle);
    }
}
@end
