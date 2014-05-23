//
//  tags.h
//  Magic
//
//  Created by tom zeng on 12-11-10.
//
//

#import <Foundation/Foundation.h>
//#import "Jastor.h"
@interface tags : MagicJSONReflection
@property(nonatomic,assign)int id;//标签
@property(nonatomic,retain)NSString *color;//颜色 1--12
@property(nonatomic,retain)NSString*content;//内容
@end
/**
android    iphone
-1 #4e4f50    [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1]
0  #2A91B3    [UIColor colorWithRed:41/255.0 green:145/255.0 blue:178/255.0 alpha:1]
1  #942995    [UIColor colorWithRed:148/255.0 green:41/255.0 blue:149/255.0 alpha:1]
2  #909090    [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1]
3  #000000    [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1]
4  #98B96A    [UIColor colorWithRed:118/255.0 green:161/255.0 blue:56/255.0 alpha:1]
5  #0D455C    [UIColor colorWithRed:13/255.0 green:69/255.0 blue:92/255.0 alpha:1]
6  #FF3B3B    [UIColor colorWithRed:225/255.0 green:59/255.0 blue:59/255.0 alpha:1]
7  #F18E00    [UIColor colorWithRed:241/255.0 green:142/255.0 blue:0/255.0 alpha:1]
8  #7A7DC6    [UIColor colorWithRed:122/255.0 green:125/255.0 blue:298/255.0 alpha:1]
9  #A31414    [UIColor colorWithRed:163/255.0 green:20/255.0 blue:20/255.0 alpha:1]
10 #9F6D17    [UIColor colorWithRed:159/255.0 green:109/255.0 blue:23/255.0 alpha:1]
11 #4BBBC2    [UIColor colorWithRed:75/255.0 green:185/255.0 blue:194/255.0 alpha:1]
12 #E53A6F    [UIColor colorWithRed:229/255.0 green:58/255.0 blue:111/255.0 alpha:1]
**/