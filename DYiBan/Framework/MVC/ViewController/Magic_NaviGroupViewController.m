//
//  Magic_NaviGroupViewController.m
//  MagicFramework
//
//  Created by NewM on 13-3-15.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "Magic_NaviGroupViewController.h"
#import "NSObject+Magic_Notification.h"
#import "Magic_NavigationController.h"
#import "UIViewController+MagicViewSignal.h"
#import "Magic_NavigationController.h"
#import "UIViewController+MagicViewSignal.h"


@interface MagicNaviGroupViewController ()

@end

@implementation MagicNaviGroupViewController
@synthesize arr_statcks = _arr_stacks;
@synthesize topStack,
            int_topIndex;
DEF_SIGNAL(INDEX_CHANGEN)

+ (MagicNaviGroupViewController *)naviStatckGroup
{
    return [[[MagicNaviGroupViewController alloc] init] autorelease];
}

+ (MagicNaviGroupViewController *)naviStatckGroupWithFirstStack:(MagicNavigationController *)navigation
{
    MagicNaviGroupViewController *group = [[[MagicNaviGroupViewController alloc] init] autorelease];
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

- (MagicNavigationController *)topStack
{
    if (_arr_stacks.count) {
        return (MagicNavigationController *)[_arr_stacks objectAtIndex:0];
    }else
    {
        return nil;
    }
}

- (void)remove:(MagicNavigationController *)nav
{
    
}

- (void)append:(MagicNavigationController *)nav
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

- (void)present:(MagicNavigationController *)nav
{
    if (!nav){
        return;
    }
    
    if (_arr_stacks.count == 0 || ![_arr_stacks containsObject:nav])
    {
        return;
    }
    
    MagicNavigationController *top = nil;
    if (_int_index >= 0)
    {
        top = [_arr_stacks objectAtIndex:_int_index];
        if (top == nav){
            return;
        }
        [top viewWillDisappear:NO];
        [top viewDidDisappear:NO];
    }
    
    for(MagicNavigationController *stack in _arr_stacks)
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
    
    [self sendViewSignal:MagicNaviGroupViewController.INDEX_CHANGEN];
}
        
- (void)handleNotification:(NSNotification *)notification
{
    if ([notification is:UIApplicationDidEnterBackgroundNotification])
    {
        for (MagicNavigationController *nav in _arr_stacks) {
            [nav enterBackground];
        }
    }else if ([notification is:UIApplicationWillEnterForegroundNotification])
    {
        for (MagicNavigationController *nav in _arr_stacks) {
            [nav enterForeground];
        }
    }
}

- (void)handleViewSignal:(MagicViewSignal *)signal
{
    [super handleViewSignal:signal];
    if (signal.source == self)
    {
        if ([signal isKindOf:[MagicViewController SIGNAL]])
        {
            if ([signal is:[MagicViewController WILL_APPEAR]]) {
                for (MagicNavigationController *nav in _arr_stacks)
                {
                    [nav viewWillAppear:NO];
                }
            }else if ([signal is:[MagicViewController DID_APPEAR]])
            {
                for (MagicNavigationController *nav in _arr_stacks)
                {
                    [nav viewDidAppear:NO];
                }
            }else if ([signal is:[MagicViewController WILL_DISAPPEAR]])
            {
                for (MagicNavigationController *nav in _arr_stacks)
                {
                    [nav viewWillDisappear:NO];
                }
            }else if ([signal is:[MagicViewController DID_DISAPPEAR]])
            {
                for (MagicNavigationController *nav in _arr_stacks)
                {
                    [nav viewDidDisappear:NO];
                }
            }
        }
    }
}





@end
