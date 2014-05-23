//
//  delete_item_delegate.h
//  Yiban
//
//  Created by 周 哲 on 12-12-20.
//
//

#import <Foundation/Foundation.h>

@protocol delete_item_delegate <NSObject>
@optional
-(void)delete_item:(int) postion; // 删除 item
@end
