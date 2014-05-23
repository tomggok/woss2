//
//  Magic_UITextField.m
//  MagicFramework
//
//  Created by NewM on 13-3-26.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "Magic_UITextField.h"


@interface MagicUITextFieldAgent : NSObject<UITextFieldDelegate>
{
    MagicUITextField *_target;
}
@property (nonatomic, assign)MagicUITextField *target;
@end

@implementation MagicUITextFieldAgent
@synthesize target=_target;
#pragma mark - textFieldDelete
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:textField, @"textField", nil];
    
    MagicViewSignal *signal = [_target sendViewSignal:[MagicUITextField TEXTFIELDSHOULDBEGINEDITING] withObject:dict];
    
    RELEASEDICTARRAYOBJ(dict);
    
    if (signal && [signal returnValue]) {
        return signal.boolValue;
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:textField, @"textField", nil];
    DLogInfo(@"dict == %@", dict);
    [_target sendViewSignal:[MagicUITextField TEXTFIELDDIDBEGINEDITING] withObject:dict];
    RELEASEDICTARRAYOBJ(dict);
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:textField, @"textField", nil];
    MagicViewSignal *signal = [_target sendViewSignal:[MagicUITextField TEXTFIELDSHOULDENDEDITING] withObject:dict];
    RELEASEDICTARRAYOBJ(dict);
    
    if (signal && [signal returnValue]) {
        return signal.boolValue;
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:textField, @"textField", nil];
    
    [_target sendViewSignal:[MagicUITextField TEXTFIELDDIDENDEDITING] withObject:dict];
    RELEASEDICTARRAYOBJ(dict);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *length = [NSString stringWithFormat:@"%d",range.length];
    NSString *location = [NSString stringWithFormat:@"%d", range.location];
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:length,@"length",location, @"location", textField, @"textField", string, @"string", nil];
    
    NSString *text = [_target.text stringByReplacingCharactersInRange:range withString:string];
    
    if (_target.maxLength > 0 && text.length > _target.maxLength && ![text isEqualToString:@"\n"]) {
        MagicViewSignal *signal = [_target sendViewSignal:[MagicUITextField TEXT_OVERFLOW]];
        
        if (signal && [signal returnValue]) {
            return signal.boolValue;
        }
        
        return YES;
    }
    MagicViewSignal *signal = [_target sendViewSignal:[MagicUITextField TEXTFIELD] withObject:userInfo];
    RELEASEDICTARRAYOBJ(userInfo);
    
    if (signal && [signal returnValue]) {
        return signal.boolValue;
    }
    return YES;
    
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    
    MagicViewSignal *signal = [_target sendViewSignal:[MagicUITextField TEXTFIELDSHOULDCLEAR]];
    if (signal && signal.returnValue) {
        return signal.boolValue;
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    MagicViewSignal *signal = [_target sendViewSignal:[MagicUITextField TEXTFIELDSHOULDRETURN]];
    if (signal && signal.returnValue) {
        return signal.boolValue;
    }
    return YES;
}


@end

@interface MagicUITextField ()

- (void)initSelf;

@end

@implementation MagicUITextField


DEF_SIGNAL(TEXTFIELDSHOULDBEGINEDITING)
DEF_SIGNAL(TEXTFIELDDIDBEGINEDITING)
DEF_SIGNAL(TEXTFIELDSHOULDENDEDITING)
DEF_SIGNAL(TEXTFIELDDIDENDEDITING)
DEF_SIGNAL(TEXTFIELD)
DEF_SIGNAL(TEXTFIELDSHOULDCLEAR)
DEF_SIGNAL(TEXTFIELDSHOULDRETURN)
DEF_SIGNAL(TEXT_OVERFLOW)//文字超长

@synthesize maxLength = _maxLength,type = _type;
@synthesize active;


- (id)init
{
    self = [super init];
    if (self) {
        [self initSelf];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSelf];
    }
    return self;
}

- (void)initSelf
{
    _maxLength = 0;
    
    RELEASEOBJ(_agent);
    _agent = [[MagicUITextFieldAgent alloc] init];
    _agent.target = self;
    
    self.opaque = NO;
    self.backgroundColor = [UIColor clearColor];
    self.delegate = _agent;
}

- (void)dealloc
{
    RELEASEOBJ(_agent);
    [super dealloc];
}

- (BOOL)active
{
    return [self isFirstResponder];
}

- (void)setActive:(BOOL)_active
{
    if (_active)
    {
        [self becomeFirstResponder];
    }else
    {
        [self resignFirstResponder];
    }
}

//重写 禁止密码输入框粘贴
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    
    if (_type == 1) {
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        if (menuController) {
             [UIMenuController sharedMenuController].menuVisible = NO;
        }
        
    }else {
        
        if (action ==@selector(copy:)){
            return YES;
        }
        else if (action ==@selector(paste:)){
            return YES;
        }
        else if (action ==@selector(cut:)){
            return NO;
        }
        else if(action ==@selector(selectAll:)){
            return YES;
        }
        else if (action ==@selector(delete:)){
            return NO;
        }
    }
    
    
    return NO;
}


@end
