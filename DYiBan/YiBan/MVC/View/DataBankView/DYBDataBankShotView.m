//
//  DYBDataBankShotView.m
//  DYiBan
//
//  Created by tom zeng on 13-8-19.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBDataBankShotView.h"
#import <Accelerate/Accelerate.h>
#import "DYBInputView.h"
#import "DYBScroller.h"
#import "scrollerData.h"
@implementation DYBDataBankShotView{

    id receive;
    UIView *bgView;
    DYBInputView*  _nameInput;
}

DEF_SIGNAL(LEFT)
DEF_SIGNAL(RIGHT)
DEF_SIGNAL(INPUTWORD)
DEF_SIGNAL(SINGLEBTN)

@synthesize type = _type , rowNum = _rowNum ,labelText = _labelText,strMsg = _strMsg,strTitlt = _strTitlt,labelTextView = _labelTextView;
@synthesize userInfo = _userInfo, noNeedRemove = _noNeedRemove,selectIndex = _selectIndex,indexPath = _indexPath;

- (id)initWithFrame:(CGRect)frame type:(NSUInteger)_nType 
{
    self = [super initWithFrame:frame];
    if (self) {

        self.type = [NSString stringWithFormat:@"%d",_nType];
        
        [self initView:_nType];
       
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame type:(NSUInteger)_nType title:(NSString *)title MSG:(NSString *)MSG{
    
    self.strTitlt = title;
    self.strMsg = MSG;
    [self setBlurSuperView:self];
    
    self =  [self initWithFrame:frame type:_nType];
    return self; 

}
-(void)initView:(NSUInteger)type{
    
    UIView *graybBG = [[UIView alloc]initWithFrame:self.bounds];
    [graybBG setBackgroundColor:[UIColor grayColor]];
    [graybBG setAlpha:0.6];
    [self addSubview:graybBG];
    RELEASE(graybBG);
        
    switch (type) {  // btn 区分 点击
            
        case BTNTAG_SINGLE:
        {
            [self creatBGview];
            
            int offset = 0.0f;
            
            if (_strTitlt.length != 0) {
                
                CGSize strSize = [_strTitlt sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(MAXFLOAT, 40)];
                UILabel *labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(10.0f, 25.0f , strSize.width, 40.0f)];
                [labelTitle setFont:[UIFont systemFontOfSize:16]];
                [labelTitle setText:_strTitlt];
                [labelTitle setCenter:CGPointMake(bgView.frame.size.width/2 , 25)];
                [labelTitle setBackgroundColor:[UIColor clearColor]];
                [bgView addSubview:labelTitle];
                RELEASE(labelTitle);
                
                offset = 40;
            }
            
            if (_strMsg.length != 0) {
                
                
                CGSize strSizeText = [_strMsg sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(MAXFLOAT, 40)];
                
                float width  = strSizeText.width;
                if (strSizeText.width > 240) {
                    width = 240;
                }
                _labelText=[[MagicUILabel alloc]initWithFrame:CGRectMake(15.0f, 40.0f + offset, width, 40.0f)];
                _labelText.backgroundColor=[UIColor clearColor];
                _labelText.textAlignment=NSTextAlignmentLeft;
                _labelText.font=[DYBShareinstaceDelegate DYBFoutStyle:16];
                _labelText.text=_strMsg;
                [_labelText setNeedCoretext:NO];
                _labelText.textColor=[MagicCommentMethod color:51 green:51 blue:51 alpha:1];
                _labelText.lineBreakMode = UILineBreakModeWordWrap;
                _labelText.numberOfLines = 2;
                [_labelText setCenter:CGPointMake(bgView.frame.size.width/2 , 90/2 + offset/2)];
                [bgView addSubview:_labelText];
                RELEASE(_labelText);
                
            }

            [self creatSingleBtn];
        }
            break;
        case BTNTAG_ADDFOLDER:// 添加文件夹和重命名格式相同
        case BTNTAG_RENAME:
        {
            
            [self creatBGview];
            
            _nameInput = [[DYBInputView alloc]initWithFrame:CGRectMake(15.0f, 30.0f, 240.0f, 40.0f) placeText:@"新名字" textType:0];
            [_nameInput setBackgroundColor:[UIColor whiteColor]];
            [_nameInput.nameField setText:_strMsg];
            [bgView addSubview:_nameInput];
            RELEASE(_nameInput);
            
            [self creatoOperationBTN];
        }
            break;
        case BTNTAG_DOWNLOAD:
            
            break;
        case BTNTAG_CANCELSHARE:
        case BTNTAG_DEL:
        {
            
            [self creatBGview];
            
            int offset = 0.0f;
            
            if (_strTitlt.length != 0) {
                
                CGSize strSize = [_strTitlt sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(MAXFLOAT, 40)];
                UILabel *labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(10.0f, 25.0f , strSize.width, 40.0f)];
                [labelTitle setFont:[UIFont systemFontOfSize:16]];
                [labelTitle setText:_strTitlt];
                [labelTitle setCenter:CGPointMake(bgView.frame.size.width/2 , 25)];
                [labelTitle setBackgroundColor:[UIColor clearColor]];
                [bgView addSubview:labelTitle];
                RELEASE(labelTitle);
                
                offset = 40;
            }
            
            if (_strMsg.length != 0) {
                
            
                CGSize strSizeText = [_strMsg sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(MAXFLOAT, 40)];
                
                float width  = strSizeText.width;
                if (strSizeText.width > 240) {
                    width = 240;
                }
                _labelText=[[MagicUILabel alloc]initWithFrame:CGRectMake(15.0f, 40.0f + offset, width, 40.0f)];
                _labelText.backgroundColor=[UIColor clearColor];
                _labelText.textAlignment=NSTextAlignmentLeft;
                _labelText.font=[DYBShareinstaceDelegate DYBFoutStyle:16];
                _labelText.text=_strMsg;
                [_labelText setNeedCoretext:NO];
                _labelText.textColor=[MagicCommentMethod color:51 green:51 blue:51 alpha:1];                
                _labelText.lineBreakMode = UILineBreakModeWordWrap;
                _labelText.numberOfLines = 2;
                [_labelText setCenter:CGPointMake(bgView.frame.size.width/2 , 90/2 + offset/2)];
                [bgView addSubview:_labelText];
                RELEASE(_labelText);

            }
            
            [self creatoOperationBTN];
        }
            
            break;
        case BTNTAG_GOONDOWNLOAD:
        {
            [self creatBGview];
            
            int offset = 0.0f;
            
            if (_strTitlt.length != 0) {
                
                CGSize strSize = [_strTitlt sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(MAXFLOAT, 40)];
                UILabel *labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(10.0f, 25.0f , strSize.width, 40.0f)];
                [labelTitle setFont:[UIFont systemFontOfSize:16]];
                [labelTitle setText:_strTitlt];
                [labelTitle setCenter:CGPointMake(bgView.frame.size.width/2 , 25)];
                [labelTitle setBackgroundColor:[UIColor clearColor]];
                [bgView addSubview:labelTitle];
                RELEASE(labelTitle);
                
                offset = 40;
            }
            
            if (_strMsg.length != 0) {
                
                CGSize strSizeText = [_strMsg sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(MAXFLOAT, 40)];
                
                float width  = strSizeText.width;
                if (strSizeText.width > 240) {
                    width = 240;
                }
                _labelText=[[MagicUILabel alloc]initWithFrame:CGRectMake(15.0f, 40.0f + offset, width, 40.0f)];
                _labelText.backgroundColor=[UIColor clearColor];
                _labelText.textAlignment=NSTextAlignmentLeft;
                _labelText.font=[DYBShareinstaceDelegate DYBFoutStyle:16];
                _labelText.text=_strMsg;
                [_labelText setNeedCoretext:NO];
                _labelText.textColor=[MagicCommentMethod color:51 green:51 blue:51 alpha:1];
                _labelText.lineBreakMode = UILineBreakModeWordWrap;
                _labelText.numberOfLines = 2;
                [_labelText setCenter:CGPointMake(bgView.frame.size.width/2 , 90/2 + offset/2)];
                [bgView addSubview:_labelText];
                RELEASE(_labelText);
                
            }
//            [self creatoOperationBTN];
        }
            break;
        case BTNTAG_TEXTVIEW://更新
        {
            _selectIndex = 1;
            [self addTextView:1];
        }
            break;
        case BTNTAG_TEXTVIEWSINGLE://强制更新
        {
            _selectIndex = 2;
            [self addTextView:2];
            
        }
            break;
        default:
            break;
    }    
}

//添加textview 1是更新 2是强制更新
- (void)addTextView:(int)type {
    
    
    [self creatBGviewTextView];
    
    int offset = 0.0f;
    
    if (_strTitlt.length != 0) {
        
        CGSize strSize = [_strTitlt sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(MAXFLOAT, 40)];
        UILabel *labelTitle = [[UILabel alloc]initWithFrame:CGRectMake((bgView.frame.size.width-strSize.width)/2, 10, strSize.width+20, 40.0f)];
        [labelTitle setFont:[UIFont systemFontOfSize:18]];
        [labelTitle setText:_strTitlt];
        [labelTitle setBackgroundColor:[UIColor clearColor]];
        [bgView addSubview:labelTitle];
        RELEASE(labelTitle);
        
        offset = 40;
    }
    
    if (_strMsg.length != 0) {
        
        
        CGSize strSizeText = [_strMsg sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(MAXFLOAT, 40)];
        
        float width  = strSizeText.width;
        if (strSizeText.width > 240) {
            width = 240;
        }
        _labelTextView=[[MagicUITextView alloc]initWithFrame:CGRectMake(0, 50, bgView.frame.size.width, 108.0f)];
        _labelTextView.backgroundColor=[UIColor clearColor];
        _labelTextView.font=[DYBShareinstaceDelegate DYBFoutStyle:18];
        _labelTextView.editable = NO;
        [_labelTextView setText:_strMsg];
        [_labelTextView setMaxSize:CGSizeMake(bgView.frame.size.width, 108.0f)];
        [_labelTextView sizeFitByText];
        _labelTextView.textColor=[MagicCommentMethod color:51 green:51 blue:51 alpha:1];
        [bgView addSubview:_labelTextView];
        RELEASE(_labelTextView);
        
    }

    [self creatoOperationBTNTextView:(_labelTextView.frame.origin.y+_labelTextView.frame.size.height)+10 type:type];
}


-(void)setUserInfo:(NSMutableDictionary *)mud{
    
    RELEASE(_userInfo);
    _userInfo=[mud retain];
    
    
    
    if (_selectIndex == 1) {
        MagicUIButton *btnLeft = nil;
        
        if ( [self.type isEqualToString:[NSString stringWithFormat:@"%d", BTNTAG_GOONDOWNLOAD]]) {
            
           btnLeft = [[MagicUIButton alloc]initWithFrame:CGRectMake(0.0f, 100, 270.0/2, 100/2)];
        }else{
            
         btnLeft = [[MagicUIButton alloc]initWithFrame:CGRectMake(0.0f, (_labelTextView.frame.origin.y+_labelTextView.frame.size.height)+10, 270.0/2, 100/2)];
        
        }
        
        
        [btnLeft setBackgroundColor:[UIColor clearColor]];
        [btnLeft  addSignal:[DYBDataBankShotView LEFT] forControlEvents:UIControlEventTouchUpInside];
        [btnLeft setImage:[UIImage imageNamed:@"alert_no_def"] forState:UIControlStateNormal];
        [btnLeft setImage:[UIImage imageNamed:@"alert_no_high"] forState:UIControlStateHighlighted];
        [bgView addSubview:btnLeft];
        [btnLeft release];
        
        MagicUIButton *rightBtn = nil;
        
        if ( [self.type isEqualToString:[NSString stringWithFormat:@"%d", BTNTAG_GOONDOWNLOAD]]) {
            
            rightBtn = [[MagicUIButton alloc]initWithFrame:CGRectMake(135,  100, 270.0/2, 100/2)];
        }else{
            
            rightBtn = [[MagicUIButton alloc]initWithFrame:CGRectMake(135,  (_labelTextView.frame.origin.y+_labelTextView.frame.size.height)+10, 270.0/2, 100/2)];
            
        }
        
//        MagicUIButton *rightBtn = [[MagicUIButton alloc]initWithFrame:CGRectMake(135,  (_labelTextView.frame.origin.y+_labelTextView.frame.size.height)+10, 270.0/2, 100/2)];
        [rightBtn setBackgroundColor:[UIColor clearColor]];
        [rightBtn setImage:[UIImage imageNamed:@"alert_yes_def"] forState:UIControlStateNormal];
        [rightBtn setImage:[UIImage imageNamed:@"alert_yes_high"] forState:UIControlStateHighlighted];
        [rightBtn  addSignal:[DYBDataBankShotView RIGHT] forControlEvents:UIControlEventTouchUpInside object:self.userInfo];
        [bgView addSubview:rightBtn];
        [rightBtn release];
    }else {
        MagicUIButton *rightBtn = [[MagicUIButton alloc]initWithFrame:CGRectMake(0,  (_labelTextView.frame.origin.y+_labelTextView.frame.size.height)+10, 540/2, 100/2)];
        [rightBtn setBackgroundColor:[UIColor clearColor]];
        [rightBtn setImage:[UIImage imageNamed:@"alert_onlyyes_def"] forState:UIControlStateNormal];
        [rightBtn setImage:[UIImage imageNamed:@"alert_onlyyes_hlt"] forState:UIControlStateHighlighted];
        [rightBtn  addSignal:[DYBDataBankShotView RIGHT] forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:rightBtn];
        [rightBtn release];
    }
    
    

}

-(void)creatSingleBtn{
    
    MagicUIButton *rightBtn = [[MagicUIButton alloc]initWithFrame:CGRectMake(0,  150-50, 540/2, 100/2)];
    [rightBtn setBackgroundColor:[UIColor clearColor]];
    [rightBtn setImage:[UIImage imageNamed:@"alert_onlyyes_def"] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"alert_onlyyes_hlt"] forState:UIControlStateHighlighted];
    [rightBtn  addSignal:[DYBDataBankShotView RIGHT] forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:rightBtn];
    [rightBtn release];
    
}

-(void)creatBGview{

    bgView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 540/2, 300/2)];
    [bgView setBackgroundColor:[UIColor colorWithRed:248/255.0f green:248/255.0f blue:248/255.0f alpha:1.0f]];
    
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 6.0;
    bgView.layer.borderWidth = 1.0;
    bgView.layer.borderColor = [[UIColor clearColor] CGColor];
    [[bgView layer] setShadowRadius:10];
//    [[bgView layer] setShadowOpacity:10];
    bgView.layer.shadowColor=[UIColor redColor].CGColor;
    bgView.layer.shadowOffset=CGSizeMake(20, 20);
    
    [bgView setCenter: CGPointMake(160, APPDELEGATE.window.center.y)];
    [self addSubview:bgView];
    [bgView release];

}

-(void)creatBGviewTextView{
    
    bgView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 540/2, 300/2+80)];
    [bgView setBackgroundColor:[UIColor colorWithRed:248/255.0f green:248/255.0f blue:248/255.0f alpha:1.0f]];
    
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 6.0;
    bgView.layer.borderWidth = 1.0;
    bgView.layer.borderColor = [[UIColor clearColor] CGColor];
    [[bgView layer] setShadowRadius:10];
    //    [[bgView layer] setShadowOpacity:10];
    bgView.layer.shadowColor=[UIColor redColor].CGColor;
    bgView.layer.shadowOffset=CGSizeMake(20, 20);
    
    [bgView setCenter: CGPointMake(160, APPDELEGATE.window.center.y)];
    [self addSubview:bgView];
    [bgView release];
    
}

-(void)creatoOperationBTNTextView:(CGFloat)floaty type:(int)type{
    
    if (type == 1) {
        
        MagicUIButton *btnLeft = [[MagicUIButton alloc]initWithFrame:CGRectMake(0.0f, floaty, 270.0/2, 100/2)];
        [btnLeft setBackgroundColor:[UIColor clearColor]];
        [btnLeft  addSignal:[DYBDataBankShotView LEFT] forControlEvents:UIControlEventTouchUpInside];
        [btnLeft setImage:[UIImage imageNamed:@"alert_no_def"] forState:UIControlStateNormal];
        [btnLeft setImage:[UIImage imageNamed:@"alert_no_high"] forState:UIControlStateHighlighted];
        [bgView addSubview:btnLeft];
        [btnLeft release];
        
        MagicUIButton *rightBtn = [[MagicUIButton alloc]initWithFrame:CGRectMake(135,  floaty, 270.0/2, 100/2)];
        [rightBtn setBackgroundColor:[UIColor clearColor]];
        [rightBtn setImage:[UIImage imageNamed:@"alert_yes_def"] forState:UIControlStateNormal];
        [rightBtn setImage:[UIImage imageNamed:@"alert_yes_high"] forState:UIControlStateHighlighted];
        [rightBtn  addSignal:[DYBDataBankShotView RIGHT] forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:rightBtn];
        [rightBtn release];
        
    }else {
        
        MagicUIButton *rightBtn = [[MagicUIButton alloc]initWithFrame:CGRectMake(0,  floaty, 540/2, 100/2)];
        [rightBtn setBackgroundColor:[UIColor clearColor]];
        [rightBtn setImage:[UIImage imageNamed:@"alert_onlyyes_def"] forState:UIControlStateNormal];
        [rightBtn setImage:[UIImage imageNamed:@"alert_onlyyes_hlt"] forState:UIControlStateHighlighted];
        [rightBtn  addSignal:[DYBDataBankShotView RIGHT] forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:rightBtn];
        [rightBtn release];
    }
    
    [bgView setFrame:CGRectMake(0.0f, 0.0f, 540/2, floaty+100/2)];
    [bgView setCenter: CGPointMake(160, APPDELEGATE.window.center.y)];
}


-(void)creatoOperationBTN{

    MagicUIButton *btnLeft = [[MagicUIButton alloc]initWithFrame:CGRectMake(0.0f, 150-50, 270.0/2, 100/2)];
    [btnLeft setBackgroundColor:[UIColor clearColor]];
    [btnLeft  addSignal:[DYBDataBankShotView LEFT] forControlEvents:UIControlEventTouchUpInside];
    [btnLeft setImage:[UIImage imageNamed:@"alert_no_def"] forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"alert_no_high"] forState:UIControlStateHighlighted];
    [bgView addSubview:btnLeft];
    [btnLeft release];
    
    MagicUIButton *rightBtn = [[MagicUIButton alloc]initWithFrame:CGRectMake(135,  150-50, 270.0/2, 100/2)];
    [rightBtn setBackgroundColor:[UIColor clearColor]];
    [rightBtn setImage:[UIImage imageNamed:@"alert_yes_def"] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"alert_yes_high"] forState:UIControlStateHighlighted];
    [rightBtn  addSignal:[DYBDataBankShotView RIGHT] forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:rightBtn];
    [rightBtn release];

}

#pragma mark- 选择滑动框

-(void)setMessage:(NSString *)message{
    
    if (_labelText != nil) {
        
    }
}


-(void)setReceive:(id)obj{

    receive = obj;

}
-(void)handleViewSignal_DYBDataBankShotView:(MagicViewSignal *)signal{

    NSMutableDictionary *sendDcit = nil;
    
    sendDcit = [[NSMutableDictionary alloc]init];
    [sendDcit setValue:self.type forKey:@"type"];
    [sendDcit setValue:_rowNum forKey:@"rowNum"];
    [sendDcit setValue:_nameInput.nameField.text forKey:@"text"];
    
    if ([signal is:[DYBDataBankShotView LEFT]]) {
        
        [self sendViewSignal:[DYBDataBankShotView LEFT] withObject:sendDcit from:self target:receive];
        [self removeFromSuperview];
        
    }else if([signal is:[DYBDataBankShotView RIGHT]]){
    
        [self sendViewSignal:[DYBDataBankShotView RIGHT] withObject:sendDcit from:self target:receive];
        if (!_noNeedRemove)
        {
           [self removeFromSuperview]; 
        }
        
    }
    
    RELEASEDICTARRAYOBJ(sendDcit);

}

-(void)changePlaceText:(NSString *)placeText{
    if (_nameInput) {
        [_nameInput.nameField setPlaceholder:placeText];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{



}
- (void)handleViewSignal_MagicUITextField:(MagicViewSignal *)signal
{
    if ([signal.source isKindOfClass:[MagicUITextField class]])//完成编辑
    {
        
        [bgView setCenter:CGPointMake(160.0f, 140.0)]; //test 
        
    }
}
- (void)dealloc
{
//    RELEASE(receive);
    RELEASEOBJ(_rowNum);
    RELEASEDICTARRAYOBJ(_userInfo);
    [super dealloc];
}

@end
