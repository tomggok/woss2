//
//  DYBCustomLabel.m
//  DYiBan
//
//  Created by Hyde.Xu on 13-8-16.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBCustomLabel.h"
#import "RegexKitLite.h"
#import "target.h"
#import "XiTongFaceCode.h"
#import "DYBDynamicDetailViewController.h"
#import "DYBPersonalHomePageViewController.h"
#import "DYBDynamicViewController.h"
#import "DYBActivityViewController.h"
#import "DYBSendPrivateLetterViewController.h"

@implementation DYBCustomLabel
@synthesize typeIndex = _typeIndex;
-(void)dealloc{
    RELEASE(_arrTarget);
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame target:(NSArray *)arrTarget{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _arrTarget = [[NSArray alloc] initWithArray:arrTarget];
    }
    return self;
}


-(void)replaceTargetText{
    NSString *strTar = @"\\#tar_[0-9]+\\#";
    NSArray *arr_tar = [self.text componentsMatchedByRegex:strTar];
    NSMutableString *strText = [[NSMutableString alloc] initWithString:self.text];
 
    for (NSString *strReplace in arr_tar) {
        for (target *dicTag in _arrTarget) {
            if ([dicTag isKindOfClass:[target class]] && [dicTag.id isEqualToString:strReplace]) {
                NSRange range = [strText rangeOfString:strReplace options:NSCaseInsensitiveSearch];
                [strText replaceOccurrencesOfString:strReplace withString:dicTag.targetname options:NSCaseInsensitiveSearch range:NSMakeRange(0, [strText length])];
                self.COLOR([NSString stringWithFormat:@"%d", (int)range.location], [NSString stringWithFormat:@"%d", [dicTag.targetname length]], ColorBlue);
//                self.CLICK([NSString stringWithFormat:@"%d", (int)range.location], [NSString stringWithFormat:@"%d", [dicTag.targetname length]], ColorBlack);
            }
        }
    }
    
   [self setText:strText];
   RELEASE(strText);
}

- (void)replaceEmojiandTarget:(BOOL)bHaveTarget{
    if (!self.text) {//避免 崩溃
        return;
    }
    NSString *strEmoji = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    NSString *strTar = @"\\#tar_[0-9]+\\#";
    NSArray *arr_emoji = [self.text componentsMatchedByRegex:strEmoji];
    NSRange rangeStar = NSMakeRange(0, 0);
    
    NSMutableArray *arrIMAGEPostion = [[NSMutableArray alloc] init];
    NSMutableArray *arr_YBemoji= [[NSMutableArray alloc] init];
    
    XiTongFaceCode *code = [[XiTongFaceCode alloc]init];
    NSMutableDictionary *XiTongFace = [code XiTongToServer];
    RELEASE(code);

    NSMutableDictionary * dic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"emoji_num" ofType:@"plist"]];
    
    
    for (NSString *strReplace in arr_emoji) {
        NSString *emojiValue = [XiTongFace objectForKey:strReplace];
        
        if ([emojiValue length] > 0){
            NSMutableString *strText = [[NSMutableString alloc] initWithString:self.text];
            [strText replaceOccurrencesOfString:strReplace withString:emojiValue  options:NSCaseInsensitiveSearch range:NSMakeRange(0, [strText length])];
            [self setText:strText];
            RELEASE(strText);
        }else{
            [arr_YBemoji addObject:strReplace];
        }
    }
    
    int j= 0;
    
    for (int i = 0; i < [arr_YBemoji count]; i++) {
        NSString *strReplace = [arr_YBemoji objectAtIndex:i];
        NSRange range = [self.text rangeOfString:strReplace];
        int nLocL = 0;
        
        if (range.location > rangeStar.location) {
            rangeStar = NSMakeRange(rangeStar.location, range.location-rangeStar.location);
            NSString *strSub = [self.text substringWithRange:rangeStar];
            NSArray *arr_tar = [strSub componentsMatchedByRegex:strTar];
            
            for (NSString *strReplace in arr_tar){
                for (target *dicTag in _arrTarget){
                    if ([dicTag isKindOfClass:[target class]] && [dicTag.id isEqualToString:strReplace]) {
                        int nLoc = [dicTag.targetname length]-[strReplace length];
                        nLocL = nLocL + nLoc;
                    }
                }
            }
        }
        
        NSString *strImage = [NSString stringWithFormat:@"%@.png", [dic objectForKey:strReplace]];
        
        if (![strImage isEqualToString:@"(null).png"]) {
            self.text = [self.text stringByReplacingCharactersInRange:NSMakeRange(range.location, [strReplace length]) withString:@""];
            [arrIMAGEPostion addObject:[NSString stringWithFormat:@"%@,%d", strImage, range.location+j*2+nLocL]];
        }else{
            j--;
        }
        
        j++;
    }
    
    if (bHaveTarget) {
        NSMutableArray *arrTagetPostion = [[NSMutableArray alloc] init];
        
        NSArray *arr_tar = [self.text componentsMatchedByRegex:strTar];
        NSMutableString *strText = [[NSMutableString alloc] initWithString:self.text];
        
        for (NSString *strReplace in arr_tar) {
            for (target *dicTag in _arrTarget) {
                if ([dicTag isKindOfClass:[target class]] && [dicTag.id isEqualToString:strReplace]) {
                    NSRange range = [strText rangeOfString:strReplace options:NSCaseInsensitiveSearch];
                    [strText replaceOccurrencesOfString:strReplace withString:dicTag.targetname options:NSCaseInsensitiveSearch range:range];
                    
                    NSString *strLink = nil;
                    if ([dicTag.type isEqualToString:@"0"]) {
                        strLink = [NSString stringWithFormat:@"%@|%@",dicTag.type, dicTag.targetlink];
                    }else if([dicTag.type isEqualToString:@"1"]){
                        strLink = [NSString stringWithFormat:@"%@|%@|%@",dicTag.type, dicTag.targetid, dicTag.targetname];
                    }else if([dicTag.type isEqualToString:@"3"]){
                        strLink = [NSString stringWithFormat:@"%@|%@",dicTag.type, dicTag.targetid];
                    }
                    
                    [arrTagetPostion addObject:[NSString stringWithFormat:@"%@,%@,%@", [NSString stringWithFormat:@"%d", (int)range.location], [NSString stringWithFormat:@"%d", [dicTag.targetname length]], strLink]];
                }
            }
        }
        
        [self setText:strText];
        RELEASE(strText);
        
        for (int i = 0; i < [arrTagetPostion count]; i++) {
            NSArray* array = [[arrTagetPostion objectAtIndex:i] componentsSeparatedByString:@","];
            self.CLICK([array objectAtIndex:0] ,[array objectAtIndex:1], ColorBlack, [array objectAtIndex:2]);
            if (_typeIndex == 1) {
                self.COLOR([array objectAtIndex:0] ,[array objectAtIndex:1], [UIColor blueColor]);
            }else {
                self.COLOR([array objectAtIndex:0] ,[array objectAtIndex:1], ColorBlue);
            }
            
            DLogInfo(@"%@", [array objectAtIndex:2]);
        }
        
        
        RELEASEDICTARRAYOBJ(arrTagetPostion);
    }

    for (int i = 0; i < [arrIMAGEPostion count]; i++) {
        NSArray* array = [[arrIMAGEPostion objectAtIndex:i] componentsSeparatedByString:@","];
        self.IMGA([array objectAtIndex:0] ,[[array objectAtIndex:1] intValue], [NSString stringWithFormat:@"%d",20+i*0], [NSString stringWithFormat:@"%d",20+i*0]);
    }
    
    [self setNeedCoretext:YES];

    RELEASEDICTARRAYOBJ(arrIMAGEPostion);
    RELEASEDICTARRAYOBJ(arr_YBemoji);
    
 
}

- (void)handleViewSignal_MagicUILabel:(MagicViewSignal *)signal
{
    if ([signal is:[MagicUILabel TOUCHESBEGAN]]){
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSString *strValue = [dict objectForKey:@"value"];
        DLogInfo(@"%@", strValue);
        
        NSArray* array = [strValue componentsSeparatedByString:@"|"];
        
        if ([array count] > 0) {
            if ([[array objectAtIndex:0] isEqualToString:@"0"]) {
                
                [self sendViewSignal:[DYBDynamicDetailViewController OPENURL] withObject:[array objectAtIndex:1]];
                [self sendViewSignal:[DYBDynamicViewController OPENURL] withObject:[array objectAtIndex:1]];
                [self sendViewSignal:[DYBActivityViewController OPENURL] withObject:[array objectAtIndex:1]];
                [self sendViewSignal:[DYBSendPrivateLetterViewController OPENURL] withObject:[array objectAtIndex:1]];
            }else if ([[array objectAtIndex:0] isEqualToString:@"1"]){
                NSDictionary *dicUser = [[NSDictionary alloc] initWithObjectsAndKeys:[array objectAtIndex:1], @"userid", [array objectAtIndex:2], @"username", nil];
                [self sendViewSignal:[DYBDynamicDetailViewController OPENPERSONPAGE] withObject:[dicUser retain]];
                [self sendViewSignal:[DYBDynamicViewController PERSONALPAGE] withObject:[dicUser retain]];
                [self sendViewSignal:[DYBPersonalHomePageViewController ATUILABLEACTION] withObject:dicUser];
                [self sendViewSignal:[DYBActivityViewController PERSONALPAGE] withObject:[dicUser retain]];

                RELEASE(dicUser);
            }else if ([[array objectAtIndex:0] isEqualToString:@"3"]){
                [self sendViewSignal:[DYBDynamicViewController ACTIVITYPAGE] withObject:[array objectAtIndex:1]];
                [self sendViewSignal:[DYBDynamicDetailViewController ACTIVITYPAGE] withObject:[array objectAtIndex:1]];
            }
        }
    }
}

@end
