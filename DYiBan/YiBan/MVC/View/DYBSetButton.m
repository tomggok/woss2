//
//  DYBSetButton.m
//  DYiBan
//
//  Created by Song on 13-8-16.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBSetButton.h"

@implementation DYBSetButton
DEF_SIGNAL(SWITCHBTN);
@synthesize textLabel = _textLabel,switchButton = _switchButton,arrowImv = _arrowImv;


- (void)dealloc {
    RELEASEVIEW(_textLabel);
    RELEASEVIEW(_switchButton);
    RELEASEVIEW(_arrowImv);
    [super dealloc];
}


//初始化 view 默认显示字 输入框类型
- (id)initWithFrame:(CGRect)frame labelText:(NSString *)labelText isArrow:(BOOL)yesOn type:(int)type{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.borderWidth = 1;
        self.backgroundColor = [MagicCommentMethod colorWithHex:@"f8f8f8"];
        self.layer.borderColor = [MagicCommentMethod colorWithHex:@"e5e5e5"].CGColor;
        
        [self addsub:labelText isArrow:yesOn type:type];
    }
    return self;
}



- (void)addsub:(NSString *)labelText isArrow:(BOOL)yesOn type:(int)type{
    
    //按钮文字
    _textLabel = [[MagicUILabel alloc]initWithFrame:CGRectMake(15, 5, [self getWidth]-15, [self getHeight]-10)];
    _textLabel.textAlignment = UIControlContentVerticalAlignmentCenter;
    _textLabel.font = [DYBShareinstaceDelegate DYBFoutStyle:20];  //字体和大小设置
    _textLabel.text = labelText;
    _textLabel.textColor = [MagicCommentMethod colorWithHex:@"333333"];
    _textLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_textLabel];
    
    UIImage *arrowImage = [UIImage imageNamed:@"list_arrow"];
    _arrowImv = [[MagicUIImageView alloc]initWithFrame:CGRectMake([self getWidth]-24, ([self getHeight]-arrowImage.size.height/2)/2, arrowImage.size.width/2, arrowImage.size.height/2)];
    _arrowImv.image = arrowImage;
    _arrowImv.hidden = yesOn;
    [self addSubview:_arrowImv];
    
    
    _switchButton = [[DYBSwitchButton alloc] initWithFrame:CGRectMake(_textLabel.frame.origin.x+_textLabel.frame.size.width-60, ([self getHeight]-30)/2, 50, 30)];    
    _switchButton.onTintColor = ColorBlue;
    _switchButton.contrastColor = [MagicCommentMethod color:229 green:229 blue:229 alpha:1.0];
    [self addSubview:_switchButton];
    
    [_switchButton setOn: NO animated: NO];
    [_switchButton setDidChangeHandler:^(BOOL isOn) {
        
        
        NSString *isON = [NSString stringWithFormat:@"%d",isOn];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:_switchButton, @"switchButton",isON,@"isOn", nil];
        [self sendViewSignal:[DYBSetButton SWITCHBTN] withObject:dict from:self target:[self superview]];
        
    }];
    
    if (type == 0) {
        
        _switchButton.hidden = !yesOn;
        
    }else {
        
        _switchButton.hidden = yesOn;
        
    }
    
    [self addSubview:_switchButton];
}





- (void)setStatus:(BOOL)status {
    
    if (status == 0) {
        
        [_switchButton setOn: NO animated: NO];
    }else {
        
        [_switchButton setOn: YES animated: YES];
    }
    
    
}

//x坐标
- (CGFloat)getOrginx {
    
    return self.frame.origin.x;
}
//y坐标
- (CGFloat)getOrginy {
    
    return self.frame.origin.y;
}
//宽度
- (CGFloat)getWidth {
    
    return self.frame.size.width;
}
//高度
- (CGFloat)getHeight {
    
    return self.frame.size.height;
}
//获得视图最右边x坐标
- (CGFloat)getRightx {
    
    return self.frame.origin.x+self.frame.size.width;
}
//获得视图最下边y坐标
- (CGFloat)getLowy {
    
    return self.frame.origin.y+self.frame.size.height;
}

@end
