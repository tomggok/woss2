//
//  buttonDelegate.h
//  Yiban
//
//  Created by 周 哲 on 12-12-10.
//
//

#import <Foundation/Foundation.h>

@protocol buttonDelegate <NSObject>
@optional
-(void)DoPicBig:(NSMutableArray *)arry; // 查看大图
-(void)hideDownView;
@end
