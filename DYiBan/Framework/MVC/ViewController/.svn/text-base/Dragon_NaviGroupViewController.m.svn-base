//
//  Dragon_NaviGroupViewController.m
//  DragonFramework
//
//  Created by NewM on 13-3-15.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "Dragon_NaviGroupViewController.h"
#import "NSObject+Dragon_Notification.h"
#import "Dragon_NavigationController.h"
#import "UIViewController+DragonViewSignal.h"
#import "Dragon_NavigationController.h"
#import "UIViewController+DragonViewSignal.h"


@interface DragonNaviGroupViewController ()

@end

@implementation DragonNaviGroupViewController
@synthesize arr_statcks = _arr_stacks;
@synthesize topStack,
            int_topIndex;
DEF_SIGNAL(INDEX_CHANGEN)

+ (DragonNaviGroupViewController *)naviStatckGroup
{
    return [[[DragonNaviGroupViewController alloc] init] autorelease];
}

+ (DragonNaviGroupViewController *)naviStatckGroupWithFirstStack:(DragonNavigationController *)navigation
{
    DragonNaviGroupViewController *group = [[[DragonNaviGroupViewController alloc] init] autorelease];
    [group append:navigation];
    return group;
}

- (void)load
{
    [super load];
    
    _arr_stacks = [[NSMutableArray alloc] init];
    _int_index = -1;
    
    [self observeNotification:UIApplicationDidEnterBackgroundNotification];
    [self observeNotification:UIApplicationWillEnterForegroundNotification];
}

- (void)unload
{
    [self unobserveAllNotification];
    
    [_arr_stacks removeAllObjects];
    [_arr_stacks release];
    
    [super unload];
}

- (NSInteger)topIndex
{
    return _int_index;
}

- (DragonNavigationController *)topStack
{
    if (_arr_stacks.count) {
        return (DragonNavigationController *)[_arr_stacks objectAtIndex:0];
    }else
    {
        return nil;
    }
}

- (void)remove:(DragonNavigationController *)nav
{
    
}

- (void)append:(DragonNavigationController *)nav
{
    if (!nav) {
        return;
    }
    
    if (![_arr_stacks containsObject:nav]) {
        [_arr_stacks addObject:nav];
        [self.view addSubview:nav.view];
        [self present:nav];
    }
}

- (void)present:(DragonNavigationController *)nav
{
    if (!nav){
        return;
    }
    
    if (_arr_stacks.count == 0 || ![_arr_stacks containsObject:nav])
    {
        return;
    }
    
    DragonNavigationController *top = nil;
    if (_int_index >= 0)
    {
        top = [_arr_stacks objectAtIndex:_int_index];
        if (top == nav){
            return;
        }
        [top viewWillDisappear:NO];
        [top viewDidDisappear:NO];
    }
    
    for(DragonNavigationController *stack in _arr_stacks)
    {
        if (stack != nav) {
            [self.view setHidden:YES];
        }
    }
    
    _int_index = [_arr_stacks indexOfObject:nav];
    _int_index = (_int_index >= _arr_stacks.count) ? (_arr_stacks.count - 1) : _int_index;
    
    [self.view bringSubviewToFront:nav.view];
    
    [nav.view setHidden:NO];
    [nav viewWillAppear:NO];
    [nav viewDidAppear:NO];
    
    [self sendViewSignal:DragonNaviGroupViewController.INDEX_CHANGEN];
}
        
- (void)handleNotification:(NSNotification *)notification
{
    if ([notification is:UIApplicationDidEnterBackgroundNotification])
    {
        for (DragonNavigationController *nav in _arr_stacks) {
            [nav enterBackground];
        }
    }else if ([notification is:UIApplicationWillEnterForegroundNotification])
    {
        for (DragonNavigationController *nav in _arr_stacks) {
            [nav enterForeground];
        }
    }
}

- (void)handleViewSignal:(DragonViewSignal *)signal
{
    [super handleViewSignal:signal];
    if (signal.source == self)
    {
        if ([signal isKindOf:[DragonViewController SIGNAL]])
        {
            if ([signal is:[DragonViewController WILL_APPEAR]]) {
                for (DragonNavigationController *nav in _arr_stacks)
                {
                    [nav viewWillAppear:NO];
                }
            }else if ([signal is:[DragonViewController DID_APPEAR]])
            {
                for (DragonNavigationController *nav in _arr_stacks)
                {
                    [nav viewDidAppear:NO];
                }
            }else if ([signal is:[DragonViewController WILL_DISAPPEAR]])
            {
                for (DragonNavigationController *nav in _arr_stacks)
                {
                    [nav viewWillDisappear:NO];
                }
            }else if ([signal is:[DragonViewController DID_DISAPPEAR]])
            {
                for (DragonNavigationController *nav in _arr_stacks)
                {
                    [nav viewDidDisappear:NO];
                }
            }
        }
    }
}





@end
