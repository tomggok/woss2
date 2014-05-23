//
//  DYBInputView.m
//  DYiBan
//
//  Created by Song on 13-8-13.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBInputView.h"

@implementation DYBInputView

@synthesize nameField = _nameField;

- (void)dealloc {
    RELEASEVIEW(_nameField);
    [super dealloc];
}


//设置输入框属性 默认显示字 输入框类型
- (void)setTextType:(MagicUITextField*)textFeild placeText:(NSString *)placeText textType:(int)type{
    
    textFeild.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textFeild.clearButtonMode = UITextFieldViewModeWhileEditing;
    [textFeild setType:type];
    [textFeild setReturnKeyType:UIReturnKeyDone];
    [textFeild setPlaceholder:placeText];
    textFeild.font = [DYBShareinstaceDelegate DYBFoutStyle:18];  //字体和大小设置
    textFeild.textColor = [MagicCommentMethod color:51 green:51 blue:51 alpha:1.0];
    //普通正常输入
    if (type == 0) {
        textFeild.secureTextEntry = NO;
    }
    //密码输入
    if (type == 1) {
        
        textFeild.secureTextEntry = YES;
        
    }
    
    [self addSubview:textFeild];
}


//初始化 view 默认显示字 输入框类型
- (id)initWithFrame:(CGRect)frame placeText:(NSString *)placeText textType:(int)type {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.borderWidth = 1;
        self.layer.borderColor = [[MagicCommentMethod color:229 green:229 blue:229 alpha:1.0] CGColor];
        self.backgroundColor = [UIColor whiteColor];

        _nameField = [[MagicUITextField alloc] initWithFrame:CGRectMake(5, 5, [self getWidth]-10, [self getHeight]-10)];
        [self setTextType:_nameField placeText:placeText textType:type];
    }
    return self;
}



- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    return NO;
}

-(BOOL) canBecomeFirstResponder{
    return NO;
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
