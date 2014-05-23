//
//  Dragon_UIAlertView.m
//  ShangJiaoYuXin
//
//  Created by NewM on 13-5-13.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "Dragon_UIAlertView.h"
#import "UIView+DragonViewSignal.h"
@interface DragonUIAlertView ()
{
    id recevie;
}

@end

@implementation DragonUIAlertView
DEF_SIGNAL(ALERTVIEW);
DEF_SIGNAL(ALERTVIEWCANCEL);
DEF_SIGNAL(WILLPRESENTALERTVIEW);
DEF_SIGNAL(DIDPRESENTALERTVIEW);
DEF_SIGNAL(ALERTVIEWWILLDISMISSWITHBUTTONINDEX);
DEF_SIGNAL(ALERTVIEWDIDDISMISSWITHBUTTONINDEX);
DEF_SIGNAL(ALERTVIEWSHOULDENABLEFIRSTOTHERBUTTON);

- (void)dealloc
{
    RELEASEOBJ(recevie);
    [super dealloc];
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{

    self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
    if (self)
    {
        recevie = [delegate retain];
        if (otherButtonTitles)
        {
            NSString *str;
            va_list args;
            NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:1];
            
            [array addObject:otherButtonTitles];
            va_start(args, otherButtonTitles);
            while ((str = va_arg(args, NSString *)))
            {
                if (str)
                {
                    [array addObject:str];
                }
                
            }
            va_end(args);
            for (NSString *itemName in array)
            {
                [self addButtonWithTitle:itemName];
            }
            RELEASEDICTARRAYOBJ(array);
        }
        
        
    }
    return self;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSNumber *btIn = [NSNumber numberWithInteger:buttonIndex];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dict setValue:alertView forKey:@"alertView"];
    [dict setValue:btIn forKey:@"buttonIndex"];
    [self sendViewSignal:[DragonUIAlertView ALERTVIEW] withObject:dict from:self target:recevie];
    
    RELEASEDICTARRAYOBJ(dict);

}

- (void)alertViewCancel:(UIAlertView *)alertView
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dict setValue:alertView forKey:@"alertView"];
    [self sendViewSignal:[DragonUIAlertView ALERTVIEWCANCEL] withObject:dict from:self target:recevie];
    
    RELEASEDICTARRAYOBJ(dict);
}

- (void)willPresentAlertView:(UIAlertView *)alertView
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dict setValue:alertView forKey:@"alertView"];
    [self sendViewSignal:[DragonUIAlertView WILLPRESENTALERTVIEW] withObject:dict from:self target:recevie];
    
    RELEASEDICTARRAYOBJ(dict);
}
- (void)didPresentAlertView:(UIAlertView *)alertView
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dict setValue:alertView forKey:@"alertView"];
    [self sendViewSignal:[DragonUIAlertView DIDPRESENTALERTVIEW] withObject:dict from:self target:recevie];
    
    RELEASEDICTARRAYOBJ(dict);
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dict setValue:alertView forKey:@"alertView"];
    NSNumber *btIn = [NSNumber numberWithInteger:buttonIndex];
    [dict setValue:btIn forKey:@"buttonIndex"];
    [self sendViewSignal:[DragonUIAlertView ALERTVIEWWILLDISMISSWITHBUTTONINDEX] withObject:dict from:self target:recevie];
    
    RELEASEDICTARRAYOBJ(dict);
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dict setValue:alertView forKey:@"alertView"];
    NSNumber *btIn = [NSNumber numberWithInteger:buttonIndex];
    [dict setValue:btIn forKey:@"buttonIndex"];
    [self sendViewSignal:[DragonUIAlertView ALERTVIEWDIDDISMISSWITHBUTTONINDEX] withObject:dict from:self target:recevie];
    
    RELEASEDICTARRAYOBJ(dict);
}

#
- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dict setValue:alertView forKey:@"alertView"];
    DragonViewSignal *viewSignal = [self sendViewSignal:[DragonUIAlertView ALERTVIEWSHOULDENABLEFIRSTOTHERBUTTON] withObject:dict from:self target:recevie];
    
    RELEASEDICTARRAYOBJ(dict);
    
    if (viewSignal.returnValue)
    {
        return viewSignal.boolValue;
    }
    return YES;
}

@end
