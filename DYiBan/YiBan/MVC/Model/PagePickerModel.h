//
//  PagePickerModel.h
//  Yiban
//
//  Created by NewM on 12-11-28.
//
//

#import <Foundation/Foundation.h>

@interface PagePickerModel : MagicJSONReflection
{

}
@property (retain, nonatomic) NSString *state;
@property (retain, nonatomic) NSString *city;
@property (retain, nonatomic) NSString *district;
@property (retain, nonatomic) NSString *allCity;//

@property (retain, nonatomic) NSString *day;
@property (retain, nonatomic) NSString *month;
@property (retain, nonatomic) NSString *year;
@property (retain, nonatomic) NSString *yyyymmdd;

@property (retain, nonatomic) NSString *college;//学院名称

@property (retain, nonatomic) NSString *getInYear;//入学年份

@property (copy, nonatomic) NSString *privateType;//个人隐私设置

@property (retain, nonatomic) NSString *monthValue;//星座

@end
