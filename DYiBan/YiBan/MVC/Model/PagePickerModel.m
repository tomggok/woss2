//
//  PagePickerModel.m
//  Yiban
//
//  Created by NewM on 12-11-28.
//
//

#import "PagePickerModel.h"

@implementation PagePickerModel
@synthesize city,district,state,day,month,year,yyyymmdd,college,getInYear,privateType,allCity,monthValue;

- (NSString *)allCity{
    if (district && district.length > 0) {
        allCity = [NSString stringWithFormat:@"%@-%@-%@",state,city,district];
    }else{
        allCity = [NSString stringWithFormat:@"%@-%@",state,city];
    }
    return allCity;
}
- (NSString *)yyyymmdd{
    yyyymmdd = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
    [yyyymmdd retain];
    [self setMonthValue:yyyymmdd];
    return yyyymmdd;
}

- (void)setMonthValue:(NSString *)_monthValue{
    [monthValue release];
    monthValue = [[self getMonthType:_monthValue] retain];
}

//获得星座
- (NSString *)getMonthType:(NSString *)_year{
    
    NSString *monthType = @"星座";
    
    NSArray *stringArray = [_year componentsSeparatedByString:@"-"];
    int monthint = [[stringArray objectAtIndex:1] intValue];
    int dayint = [[stringArray objectAtIndex:2] intValue];
    switch (monthint) {
        case 1:
            if (dayint >= 20) {
                monthType = @"水瓶座";
            }else if (dayint <=19){
                monthType = @"摩羯座";
            }
            
            break;
        case 2:
            if (dayint >= 19) {
                monthType = @"双鱼座";
            }else if (dayint <= 18){
                monthType = @"水瓶座";
            }
            break;
        case 3:
            if (dayint <= 20) {
                monthType = @"双鱼座";
            }else if (dayint >= 21){
                monthType = @"白羊座";
            }
            break;
        case 4:
            if (dayint <= 19) {
                monthType = @"白羊座";
            }else if (dayint >= 20){
                monthType = @"金牛座";
            }
            break;
        case 5:
            if (dayint <= 20) {
                monthType = @"金牛座";
            }else if (dayint >= 21){
                monthType = @"双子座";
            }
            break;
        case 6:
            if (dayint <= 21) {
                monthType = @"双子座";
            }else if (dayint >= 22){
                monthType = @"巨蟹座";
            }
            break;
        case 7:
            if (dayint <= 22) {
                monthType = @"巨蟹座";
            }else if (dayint >= 23){
                monthType = @"狮子座";
            }
            break;
        case 8:
            if (dayint <= 22) {
                monthType = @"狮子座";
            }else if (dayint >= 23){
                monthType = @"处女座";
            }
            break;
        case 9:
            if (dayint <= 22) {
                monthType = @"处女座";
            }else if (dayint >= 23){
                monthType = @"天枰座";
            }
            break;
        case 10:
            if (dayint <= 23) {
                monthType = @"天枰座";
            }else if (dayint >= 24){
                monthType = @"天蝎座";
            }
            break;
        case 11:
            if (dayint <= 22) {
                monthType = @"天蝎座";
            }else if (dayint >= 23){
                monthType = @"射手座";
            }
            break;
        case 12:
            if (dayint <= 21) {
                monthType = @"射手座";
            }else if (dayint >= 22){
                monthType = @"摩羯座";
            }
            break;
        default:
            break;
    }
    
    return monthType;
}

- (void)dealloc
{
    RELEASE(privateType);
    RELEASE(day);
    RELEASE(month);
    RELEASE(year);
    RELEASE(yyyymmdd);
    
    RELEASE(college);
    
    RELEASE(getInYear);
    
    RELEASE(city);
    RELEASE(district);
    RELEASE(state);
    [super dealloc];
}

@end
