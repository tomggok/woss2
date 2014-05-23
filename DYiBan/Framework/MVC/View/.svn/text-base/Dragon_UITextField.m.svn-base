//
//  Dragon_UITextField.m
//  DragonFramework
//
//  Created by NewM on 13-3-26.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "Dragon_UITextField.h"


@interface DragonUITextFieldAgent : NSObject<UITextFieldDelegate>
{
    DragonUITextField *_target;
}
@property (nonatomic, assign)DragonUITextField *target;
@end

@implementation DragonUITextFieldAgent
@synthesize target=_target;
#pragma mark - textFieldDelete
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:textField, @"textField", nil];
    
    DragonViewSignal *signal = [_target sendViewSignal:[DragonUITextField TEXTFIELDSHOULDBEGINEDITING] withObject:dict];
    
    RELEASEDICTARRAYOBJ(dict);
    
    if (signal && [signal returnValue]) {
        return signal.boolValue;
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:textField, @"textField", nil];
    DLogInfo(@"dict == %@", dict);
    [_target sendViewSignal:[DragonUITextField TEXTFIELDDIDBEGINEDITING] withObject:dict];
    RELEASEDICTARRAYOBJ(dict);
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:textField, @"textField", nil];
    DragonViewSignal *signal = [_target sendViewSignal:[DragonUITextField TEXTFIELDSHOULDENDEDITING] withObject:dict];
    RELEASEDICTARRAYOBJ(dict);
    
    if (signal && [signal returnValue]) {
        return signal.boolValue;
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:textField, @"textField", nil];
    
    [_target sendViewSignal:[DragonUITextField TEXTFIELDDIDENDEDITING] withObject:dict];
    RELEASEDICTARRAYOBJ(dict);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *length = [NSString stringWithFormat:@"%d",range.length];
    NSString *location = [NSString stringWithFormat:@"%d", range.location];
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:length,@"length",location, @"location", textField, @"textField", string, @"string", nil];
    
    NSString *text = [_target.text stringByReplacingCharactersInRange:range withString:string];
    
    if (_target.maxLength > 0 && text.length > _target.maxLength && ![text isEqualToString:@"\n"]) {
        DragonViewSignal *signal = [_target sendViewSignal:[DragonUITextField TEXT_OVERFLOW]];
        
        if (signal && [signal returnValue]) {
            return signal.boolValue;
        }
        
        return YES;
    }
    DragonViewSignal *signal = [_target sendViewSignal:[DragonUITextField TEXTFIELD] withObject:userInfo];
    RELEASEDICTARRAYOBJ(userInfo);
    
    if (signal && [signal returnValue]) {
        return signal.boolValue;
    }
    return YES;
    
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    
    DragonViewSignal *signal = [_target sendViewSignal:[DragonUITextField TEXTFIELDSHOULDCLEAR]];
    if (signal && signal.returnValue) {
        return signal.boolValue;
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    DragonViewSignal *signal = [_target sendViewSignal:[DragonUITextField TEXTFIELDSHOULDRETURN]];
    if (signal && signal.returnValue) {
        return signal.boolValue;
    }
    return YES;
}


@end

@interface DragonUITextField ()

- (void)initSelf;

@end

@implementation DragonUITextField


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
    _agent = [[DragonUITextFieldAgent alloc] init];
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
