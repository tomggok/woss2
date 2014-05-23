//
//  DYBPagePickerView.m
//  DYiBan
//
//  Created by Song on 13-9-9.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBPagePickerView.h"
#import "PagePickerModel.h"
#import "college_list_all.h"
#import "college_list.h"
#import "NSDictionary+JSON.h"
#import "NSDate+Helpers.h"
#import "NSString+Count.h"

@interface DYBPagePickerView(){
    NSArray *provinces, *cities, *areas;
    
    NSMutableArray *year;//年的array
    NSMutableArray *day;//当月天数
    NSMutableArray *month;//几个月
    
    NSMutableArray *getInYear;//入学年的array
    
    NSMutableArray *privateArray;//权限array
    
    int *_rows[2];
}

@property (retain, nonatomic)PagePickerModel *pageModel;
@end


@implementation DYBPagePickerView
@synthesize delegate,pickerStyle;
@synthesize pickerView = _pickerView;
@synthesize pageModel = _pageModel;
@synthesize collegeList,isShowView,bt_Shade=_bt_Shade,bt_Ok=_bt_Ok;


- (void)dealloc
{
    [collegeList release];
    [_pageModel release];
    [super dealloc];
}

- (id)initWithdelegate:(CGRect)frame style:(PagePickerViewStyle)_pickerStyle delegate:(id<PagePickDelegate>)_delegate;
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor redColor]];
        [self setUserInteractionEnabled:YES];
        
        PagePickerModel *pageModel = [[PagePickerModel alloc] init];
        self.pageModel = pageModel;
        [pageModel release];
        
        self.delegate = _delegate;
        
        //        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        [_pickerView setUserInteractionEnabled:YES];
        [_pickerView setShowsSelectionIndicator:YES];
        [self addSubview:_pickerView];
        [_pickerView release];
        
        pickerStyle = _pickerStyle;
        
        //加载数据
        if (pickerStyle == PagePickerViewWithAreas) {//加载地区
            provinces = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil]];
            cities = [[provinces objectAtIndex:0] objectForKey:@"cities"];
            
            //            self.pageModel.state = [[provinces objectAtIndex:0] objectForKey:@"state"];
            //            self.pageModel.city = [[cities objectAtIndex:0] objectForKey:@"city"];
            
            areas = [[cities objectAtIndex:0] objectForKey:@"areas"];
            
            NSInteger pageList = -1;
            if (areas.count > 0) {
                //                self.pageModel.district = [areas objectAtIndex:0];
                pageList = 0;
            }
            
            [self areasInitString:0 areaNum:0 districtNum:pageList];
        }else if(pickerStyle == PagePickerViewWithDate){//加载日期
            year = [[NSMutableArray alloc] initWithCapacity:30];
            month = [[NSMutableArray alloc] initWithCapacity:12];
            day = [[NSMutableArray alloc] initWithCapacity:28];
            
            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
            NSDate *now = [NSDate new];
            [dateFormatter setDateFormat:@"yyyy"];
            NSString *yearString = [dateFormatter stringFromDate:now];
            NSInteger yearInt = [yearString integerValue];
            
            for (int i = 0; i < 100; i++) {//获得年
                [year addObject:[NSString stringWithFormat:@"%d", (yearInt-i-1)]];
            }
            
            for (int i = 1; i < 13; i++) {//获得月
                NSString *monthString = [NSString stringWithFormat:@"%d",i];
                if (monthString.length < 2) {
                    monthString = [NSString stringWithFormat:@"0%@",monthString];
                }
                
                [month addObject:monthString];
            }
            
            [dateFormatter release];
            
            [self refreshDayCount];
            
            //            self.pageModel.year = [year objectAtIndex:0];
            //            self.pageModel.month = [month objectAtIndex:0];
            //            self.pageModel.day = [day objectAtIndex:0];
            
            [self dateInitString:0 monthNum:0 dayNum:0];
            
        }else if (pickerStyle == PagePickerViewWithGetInSchool){//入学年份
            getInYear = [[NSMutableArray alloc] initWithCapacity:30];
            
            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
            NSDate *now = [NSDate new];
            [dateFormatter setDateFormat:@"yyyy"];
            NSString *yearString = [dateFormatter stringFromDate:now];
            NSInteger yearInt = [yearString integerValue];
            
            for (int i = 0; i < 12; i++) {
                [getInYear addObject:[NSString stringWithFormat:@"%d",(yearInt - i)]];
            }
            
            //            self.pageModel.getInYear = [getInYear objectAtIndex:0];
            [self getInSchoolInitString:0];
        }else if (pickerStyle == PagePickerViewWithNote){//笔记日历
            
            year = [[NSMutableArray alloc] initWithCapacity:30];
            month=[[NSMutableArray alloc] initWithCapacity:30];
            
            int lastYear=2010;//笔记最早的年
            int nowYear=[NSString getDateComponentsByNow].year;
            
            for (int i = 13; --i >0;) {//获得月数据源
                NSString *monthString = [NSString stringWithFormat:@"%d",i];
                if (monthString.length < 2) {
                    monthString = [NSString stringWithFormat:@"0%@",monthString];
                }
                
                [month addObject:monthString];
            }
            
            for (int i = nowYear; i>=lastYear;i--) {//获得年数据源
                [year addObject:[NSString stringWithFormat:@"%d",i]];
            }
            
//            _str_selectContent=[NSString stringWithFormat:@"%@-%@",[year objectAtIndex:0],[month objectAtIndex:0]];
//            [_str_selectContent retain];
            
            _rows[0]=_rows[1]=0;
            
        }else if (pickerStyle == PagePickerViewWithPageWhoCanSee ||
                  pickerStyle == PagePickerViewWithHometownWhoCanSee ||
                  pickerStyle == PagePickerViewWithMobileWhoCansee){//主页，家乡，手机
            
            privateArray = [[NSMutableArray alloc] initWithObjects:PICKERPRIVATEAP,PICKERPRIVATEFSS,PICKERPRIVATEOF,PICKERPRIVATEOM, nil];
            
            //            self.pageModel.privateType = [privateArray objectAtIndex:0];
            [self pageHomeMobileInitString:0];
        }else if (pickerStyle == PagePickerViewWithBirthdayWhoCanSee){//生日
            privateArray = [[NSMutableArray alloc] initWithObjects:PICKERPRIVATEAP,PICKERPRIVATESM,PICKERPRIVATESD,PICKERPRIVATEOM, nil];
            
            //            self.pageModel.privateType = [privateArray objectAtIndex:0];
            [self birthInitString:0];
        }
        
    }
    return self;
}

//主页，家乡，手机
- (void)pageHomeMobileInitString:(NSInteger)num{
    self.pageModel.privateType = [privateArray objectAtIndex:num];
}

//生日
- (void)birthInitString:(NSInteger)brithNum{
    self.pageModel.privateType = [privateArray objectAtIndex:brithNum];
}

//地区初始化
- (void)areasInitString:(NSInteger)stateNum areaNum:(NSInteger)areaNum districtNum:(NSInteger)districtNum{
    self.pageModel.state = [[provinces objectAtIndex:stateNum] objectForKey:@"state"];
    self.pageModel.city = [[cities objectAtIndex:areaNum] objectForKey:@"city"];
    if (districtNum == -1) {
        self.pageModel.district = @"";
    }else{
        self.pageModel.district = [areas objectAtIndex:0];
    }
}

//加载日期
- (void)dateInitString:(NSInteger)yearNum monthNum:(NSInteger)monthNum dayNum:(NSInteger)dayNum{
    self.pageModel.year = [year objectAtIndex:yearNum];
    self.pageModel.month = [month objectAtIndex:monthNum];
    self.pageModel.day = [day objectAtIndex:0];
}

//入学时间
- (void)getInSchoolInitString:(NSInteger)getInYearNum{
    self.pageModel.getInYear = [getInYear objectAtIndex:0];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerStyle == PagePickerViewWithAreas || pickerStyle == PagePickerViewWithDate) {
        return 3;
    }else if (pickerStyle == PagePickerViewWithCollege ||
              pickerStyle == PagePickerViewWithGetInSchool ||
              pickerStyle == PagePickerViewWithPageWhoCanSee ||
              pickerStyle == PagePickerViewWithHometownWhoCanSee ||
              pickerStyle == PagePickerViewWithMobileWhoCansee ||
              pickerStyle == PagePickerViewWithBirthdayWhoCanSee){
        return 1;
    }else if (pickerStyle == PagePickerViewWithNote) {//笔记日历
        return 2;
    }else{
        return 0;
    }
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerStyle == PagePickerViewWithAreas) {
        switch (component) {
            case 0:
                return [provinces count];
                break;
            case 1:
                return [cities count];
                break;
                
            case 2:
                return [areas count];
                break;
                
            default:
                return 0;
                break;
        }
    }else if (pickerStyle == PagePickerViewWithDate) {
        switch (component) {
            case 0:
                return [year count];
                break;
            case 1:
                return [month count];
                break;
                
            case 2:
                return [day count];
                break;
                
            default:
                return 0;
                break;
        }
    }else if (pickerStyle == PagePickerViewWithCollege){
        return [[collegeList college_list] count];
    }else if (pickerStyle == PagePickerViewWithGetInSchool){
        return [getInYear count];
        
    }else if (pickerStyle == PagePickerViewWithNote){//笔记日历
        switch (component) {
            case 0:
                return [year count];
                break;
            case 1:
                return [month count];
                break;
                
            default:
                return 0;
                break;
        }
        return [getInYear count];
        
    }else if (pickerStyle == PagePickerViewWithPageWhoCanSee ||
              pickerStyle == PagePickerViewWithHometownWhoCanSee ||
              pickerStyle == PagePickerViewWithMobileWhoCansee ||
              pickerStyle == PagePickerViewWithBirthdayWhoCanSee){
        return [privateArray count];
        
    }else{
        return 0;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (pickerStyle == PagePickerViewWithAreas) {
        switch (component) {
            case 0:
                return [[provinces objectAtIndex:row] objectForKey:@"state"];
                break;
            case 1:
                return [[cities objectAtIndex:row] objectForKey:@"city"];
                break;
            case 2:
                if ([areas count] > 0) {
                    return [areas objectAtIndex:row];
                    break;
                }
                
            default:
                return @"";
                break;
        }
    }else if (pickerStyle == PagePickerViewWithDate) {
        switch (component) {
            case 0:
                return [year objectAtIndex:row];
                break;
            case 1:
                return [month objectAtIndex:row];
                break;
            case 2:
                
                return [day objectAtIndex:row];
                break;
                
                
            default:
                return @"";
                break;
        }
    }else if (pickerStyle == PagePickerViewWithCollege){
        college_list *collegeListin = [[collegeList college_list] objectAtIndex:row];
        //        college_list *collegeListin = [[[collegeList college_list] objectAtIndex:row] initDictionaryTo:[college_list class]] ;
        return [collegeListin name];
        
    }else if (pickerStyle == PagePickerViewWithGetInSchool){
        return [getInYear objectAtIndex:row];
        
    }else if (pickerStyle == PagePickerViewWithNote){//笔记日历
        switch (component) {
            case 0:
                return [year objectAtIndex:row];
                break;
            case 1:
                return [month objectAtIndex:row];
                break;
                
            default:
                return @"";
                break;
        }
    }else if (pickerStyle == PagePickerViewWithPageWhoCanSee ||
              pickerStyle == PagePickerViewWithHometownWhoCanSee ||
              pickerStyle == PagePickerViewWithMobileWhoCansee ||
              pickerStyle == PagePickerViewWithBirthdayWhoCanSee){
        
        return [privateArray objectAtIndex:row];
        
    }else{
        return @"";
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component/*被操作的哪个列*/{
    if (pickerStyle == PagePickerViewWithAreas) {
        switch (component) {
            case 0:
                NSLog(@"[provinces objectAtIndex:row] === %@", [provinces objectAtIndex:row]);
                cities = [[provinces objectAtIndex:row] objectForKey:@"cities"];
                [_pickerView selectRow:0 inComponent:1 animated:YES];
                [_pickerView reloadComponent:1];
                
                areas = [[cities objectAtIndex:0] objectForKey:@"areas"];
                [_pickerView selectRow:0 inComponent:2 animated:YES];
                [_pickerView reloadComponent:2];
                
                self.pageModel.state = [[provinces objectAtIndex:row] objectForKey:@"state"];
                self.pageModel.city = [[cities objectAtIndex:0] objectForKey:@"city"];
                if ([areas count] > 0) {
                    self.pageModel.district = [areas objectAtIndex:0];
                }else{
                    self.pageModel.district = @"";
                }
                
                
                break;
                
            case 1:
                areas = [[cities objectAtIndex:row] objectForKey:@"areas"];
                [_pickerView selectRow:0 inComponent:2 animated:YES];
                [_pickerView reloadComponent:2];
                
                self.pageModel.city = [[cities objectAtIndex:row] objectForKey:@"city"];
                if ([areas count] > 0) {
                    self.pageModel.district = [areas objectAtIndex:0];
                }else{
                    self.pageModel.district = @"";
                }
                
                break;
                
            case 2:
                if ([areas count] > 0) {
                    self.pageModel.district = [areas objectAtIndex:row];
                }else{
                    self.pageModel.district = @"";
                }
                
                
                break;
                
            default:
                break;
        }
        
    }else if (pickerStyle == PagePickerViewWithDate) {
        switch (component) {
            case 0:
                
                self.pageModel.year = [year objectAtIndex:row];
                [self refreshDayCount];
                [_pickerView reloadComponent:2];
                
                break;
                
            case 1:
                
                
                self.pageModel.month = [month objectAtIndex:row];
                [self refreshDayCount];
                
                //                [_pickerView selectRow:0 inComponent:2 animated:YES];
                [_pickerView reloadComponent:2];
                
                
                break;
                
            case 2:
                self.pageModel.day = [day objectAtIndex:row];
                
                
                break;
                
            default:
                break;
        }
    }else if (pickerStyle == PagePickerViewWithCollege){
        college_list *collegeListin = [[collegeList college_list] objectAtIndex:row];
        //        college_list *collegeListin = [[[collegeList college_list] objectAtIndex:row] initDictionaryTo:[college_list class]] ;
        self.pageModel.college = [collegeListin name];
    }else if (pickerStyle == PagePickerViewWithGetInSchool){
        self.pageModel.getInYear = [getInYear objectAtIndex:row];
    }else if (pickerStyle == PagePickerViewWithPageWhoCanSee ||
              pickerStyle == PagePickerViewWithHometownWhoCanSee ||
              pickerStyle == PagePickerViewWithMobileWhoCansee ||
              pickerStyle == PagePickerViewWithBirthdayWhoCanSee){
        
        self.pageModel.privateType = [privateArray objectAtIndex:row];
        
    }else if (pickerStyle == PagePickerViewWithNote){
//        if (_str_selectContent) {
//            RELEASE(_str_selectContent);
//        }
//        _str_selectContent=[NSString stringWithFormat:@"%@-%@",[year objectAtIndex:component],[month objectAtIndex:row]];
//        [_str_selectContent retain];
        
        _rows[component]=(int *)row;
    }
}

//刷新day的天数
- (void)refreshDayCount{
    NSString *yearString = self.pageModel.year;
    if (!yearString) {
        yearString = [year objectAtIndex:0];
    }
    
    
    NSString *monthString = self.pageModel.month;
    if (!monthString) {
        monthString = [month objectAtIndex:0];
    }
    [self refreshDayCount:yearString monthString:monthString];
    
}
//刷新day的天数(带参数)
- (void)refreshDayCount:(NSString *)yearString monthString:(NSString *)monthString{
    NSString *yyyymmdd = [NSString stringWithFormat:@"%@-%@-%@",yearString, monthString, @"01"];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSInteger dayNum = [[dateFormatter dateFromString:yyyymmdd] numberOfDaysInMonth];
    
    [day removeAllObjects];
    for (int j = 1; j < (dayNum+1); j++) {
        NSString *dayString = [NSString stringWithFormat:@"%d",j];
        if (dayString.length < 2) {
            dayString = [NSString stringWithFormat:@"0%@",dayString];
        }
        
        [day addObject:dayString];
    }
    
    [dateFormatter release];
}


- (NSUInteger) numberOfDaysInMonth
{
    return [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit
                                              inUnit:NSMonthCalendarUnit
                                             forDate:(NSDate*)self].length;
}

#pragma mark - animation
//按照 特定  文字  初始化  pickerview
- (void)initShowView:(NSString *)initString{
    NSArray *lineStringArray = [initString componentsSeparatedByString:@"-"];
    if (pickerStyle == PagePickerViewWithAreas) {//加载地区
        
        NSString *state = @"";
        NSString *city = @"";
        NSString *area = @"";
        
        if ([lineStringArray count] > 1) {
            state = [lineStringArray objectAtIndex:0];
            city = [lineStringArray objectAtIndex:1];
            if ([lineStringArray count] == 3){
                area = [lineStringArray objectAtIndex:2];
            }
        }
        
        NSInteger stateNum = 0;
        NSInteger cityNum = 0;
        NSInteger areaNum = 0;
        for (int i = 0; i < [provinces count]; i++) {
            if ([[[provinces objectAtIndex:i] objectForKey:@"state"] isEqualToString:state]) {//省市判断
                stateNum = i;
                NSArray *inncites = [[provinces objectAtIndex:i] objectForKey:@"cities"];//城市
                
                for (int j = 0; j < [inncites count]; j++)
                {
                    if ([[[inncites objectAtIndex:j] objectForKey:@"city"] isEqualToString:city])
                    {//城市判断
                        cityNum = j;
                        NSArray *innAreas = [[inncites objectAtIndex:j] objectForKey:@"areas"];//区县
                        
                        for (int t = 0; t < [innAreas count]; t++)
                        {
                            if ([[innAreas objectAtIndex:t] isEqualToString:area])
                            {//区县判断
                                areaNum = t;
                                break;
                            }
                        }
                        
                        break;
                    }
                    
                }
                
                break;
            }
        }
        
        cities = [[provinces objectAtIndex:stateNum] objectForKey:@"cities"];
        areas = [[cities objectAtIndex:cityNum] objectForKey:@"areas"];
        
        self.pageModel.state = state;
        self.pageModel.city = city;
        self.pageModel.district = area;
        
        [_pickerView selectRow:stateNum inComponent:0 animated:NO];
        [_pickerView selectRow:cityNum inComponent:1 animated:NO];
        [_pickerView selectRow:areaNum inComponent:2 animated:NO];
        
        NSInteger pageList = -1;
        if (areas.count > 0) {
            pageList = 0;
        }
        
        [self areasInitString:stateNum areaNum:cityNum districtNum:pageList];
        
    }else if(pickerStyle == PagePickerViewWithDate){//加载日期
        
        
        if ([lineStringArray count] > 1) {
            self.pageModel.year = [lineStringArray objectAtIndex:0];
            self.pageModel.month = [lineStringArray objectAtIndex:1];
            if ([lineStringArray count] == 3){
                self.pageModel.day = [lineStringArray objectAtIndex:2];
            }
        }
        
        NSInteger yearNum = 0;
        NSInteger monthNum = 0;
        NSInteger dayNum = 0;
        for (int i = 0; i < [year count]; i++)
        {
            if ([[year objectAtIndex:i] isEqualToString:self.pageModel.year]) {
                yearNum = i;
                break;
            }
        }
        
        for (int j = 0 ; j < [month count]; j++)
        {
            if ([[month objectAtIndex:j] isEqualToString:self.pageModel.month]) {
                monthNum = j;
                break;
            }
        }
        
        for (int t = 0; t < [day count]; t++) {
            if ([[day objectAtIndex:t] isEqualToString:self.pageModel.day]) {
                dayNum = t;
                break;
            }
        }
        
        [_pickerView selectRow:yearNum inComponent:0 animated:NO];
        [_pickerView selectRow:monthNum inComponent:1 animated:NO];
        [_pickerView selectRow:dayNum inComponent:2 animated:NO];
        
        [self dateInitString:yearNum monthNum:monthNum dayNum:dayNum];
        //        self.pageModel.year = [year objectAtIndex:yearNum];
        //        self.pageModel.month = [month objectAtIndex:monthNum];
        //        self.pageModel.day = [month objectAtIndex:dayNum];
        
    }else if (pickerStyle == PagePickerViewWithGetInSchool){//入学年份
        
        self.pageModel.getInYear = initString;
        
        int getInNum = 0;
        for (int i = 0; i < [getInYear count]; i ++) {
            if ([[getInYear objectAtIndex:i] isEqualToString:self.pageModel.getInYear]) {
                [_pickerView selectRow:i inComponent:0 animated:NO];
                getInNum = i;
                
                break;
            }
        }
        
        [self getInSchoolInitString:getInNum];
    }else if (pickerStyle == PagePickerViewWithNote){//笔记日历
        
//        self.pageModel.getInYear = initString;
        
        int getInNum = 0;
        for (int i = 0; i < [year count]; i ++) {
            if ([[year objectAtIndex:i] isEqualToString:[[initString separateStrToArrayBySeparaterChar:@"-"] objectAtIndex:0]]) {
                [_pickerView selectRow:i inComponent:0 animated:NO];
                [_pickerView selectRow:0 inComponent:1 animated:NO];
                getInNum = i;
                
                break;
            }
        }
        
    }else if (pickerStyle == PagePickerViewWithPageWhoCanSee ||
              pickerStyle == PagePickerViewWithHometownWhoCanSee ||
              pickerStyle == PagePickerViewWithMobileWhoCansee ||
              pickerStyle == PagePickerViewWithBirthdayWhoCanSee){//主页，家乡，手机，生日
        
        self.pageModel.privateType = initString;
        
        NSInteger num = 0;
        
        for (int i = 0; i < [privateArray count]; i++) {
            if ([[privateArray objectAtIndex:i] isEqualToString:self.pageModel.privateType]) {
                [_pickerView selectRow:i inComponent:0 animated:NO];
                num = i;
                break;
            }
        }
        
        if (pickerStyle == PagePickerViewWithBirthdayWhoCanSee) {
            [self birthInitString:num];
        }else{
            [self pageHomeMobileInitString:num];
        }
        
        
    }else if (pickerStyle == PagePickerViewWithCollege){//所在学院
        
        self.pageModel.college = initString;
        
        NSInteger collegeNum = 0;
        for (int i = 0; i < [[collegeList college_list] count]; i++) {
            college_list *collegeListin = [[collegeList college_list] objectAtIndex:i];
            if ([initString isEqualToString:[collegeListin name]]) {
                [_pickerView selectRow:i inComponent:0 animated:NO];
                collegeNum = i;
                break;
            }
        }
        
        college_list *collegeListin = [[collegeList college_list] objectAtIndex:collegeNum];
        self.pageModel.college = [collegeListin name];
        
        
    }
}

//显示
- (void)showInView:(UIView *)view initString:(NSString *)initString
{
    if (!isShowView) {
        [self initShowView:initString];//初始化pickerview的选中状态
        
        isShowView = YES;
        self.frame = CGRectMake(0, view.frame.size.height, self.frame.size.width, self.frame.size.height);
        [view addSubview:self];
        
        [self initShadeBt];
        [self initOKBt];
        
        [self.superview bringSubviewToFront:self];

        [UIView animateWithDuration:.3f animations:^{
            self.frame = CGRectMake(0, view.frame.size.height-_pickerView.frame.size.height, self.frame.size.width, self.frame.size.height);
            [_bt_Ok setFrame:CGRectMake(CGRectGetMinX(_bt_Ok.frame), CGRectGetMinY(self.frame)-CGRectGetHeight(_bt_Ok.frame), CGRectGetWidth(_bt_Ok.frame), CGRectGetHeight(_bt_Ok.frame))];
        }];
    }
    
    
}
//消失
- (void)cancelPicker
{
    //    if (isShowVie      w)
    {
        isShowView = NO;
        
        //self._pageModel被release前交给delegate的_pickerModel管理,避免后边找不到此对象
        if (self.delegate && [self.delegate respondsToSelector:@selector(pickerDidEnd:pagePickertype:)]) {
            [self.delegate pickerDidEnd:self pagePickertype:pickerStyle];
        }
        
        [UIView animateWithDuration:.3f animations:^{
            self.frame = CGRectMake(0, self.frame.origin.y+self.frame.size.height, self.frame.size.width, self.frame.size.height);
        } completion:^(BOOL finished) {
            if (finished) {
                [self removeFromSuperview];
            }
            
        }];
        
        //        //回调代理
        //        if (delegate && [delegate respondsToSelector:@selector(pickerDidEnd:pagePickertype:)]) {
        //            [delegate pickerDidEnd:self pagePickertype:pickerStyle];
        //        }
    }
    
    
}


#pragma mark- 初始取消search的背景按钮
-(void)initShadeBt
{
    if (!_bt_Shade && pickerStyle==PagePickerViewWithNote) {
        _bt_Shade=[[MagicUIButton alloc]initWithFrame:self.superview.bounds];
        _bt_Shade.tag=k_tag_releaseBT;
        _bt_Shade.backgroundColor=[UIColor blackColor];
        [self.superview addSubview:_bt_Shade];
        RELEASE(_bt_Shade);
        _bt_Shade.alpha=0;
        
        [UIView animateWithDuration:0.3 animations:^{
            _bt_Shade.alpha=0.75;
//            [_bt_Shade setFrame:self.superview.bounds];
        }];
    }
    
}

-(void)initOKBt
{
    if (!_bt_Ok&& pickerStyle==PagePickerViewWithNote) {
        UIImage *img=[UIImage imageNamed:@"btn_confirm"];
        _bt_Ok = [[MagicUIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(self.frame)-img.size.height/2, img.size.width/2, img.size.height/2)];
        _bt_Ok.tag=k_tag_OKBT;
        _bt_Ok.backgroundColor=[UIColor clearColor];//self.headview.backgroundColor;
        //            _bt_DropDown.alpha=0.9;
        [_bt_Ok addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside];
        [_bt_Ok setImage:img forState:UIControlStateNormal];
        [_bt_Ok setImage:img forState:UIControlStateHighlighted];
        //            [_bt_DropDown setTitle:@"好友"];
        //        [_bt_DropDown setTitleColor:[UIColor blackColor]];
        //        [_bt_DropDown setTitleFont:[DYBShareinstaceDelegate DYBFoutStyle:16]];
        [self.superview addSubview:_bt_Ok];
        //        [_bt_DropDown changePosInSuperViewWithAlignment:2];
        RELEASE(_bt_Ok);
        
        
    }
    
}

-(void)releaseShadeBt
{
    if (_bt_Shade) {
        REMOVEFROMSUPERVIEW(_bt_Shade);
    }
}

-(void)releaseOKBt
{
    if (_bt_Ok) {
        REMOVEFROMSUPERVIEW(_bt_Ok);
    }
}

-(void)releaseSelf
{
    isShowView = NO;
    
    //self._pageModel被release前交给delegate的_pickerModel管理,避免后边找不到此对象
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerDidEnd:pagePickertype:)]) {
        [self.delegate pickerDidEnd:self pagePickertype:pickerStyle];
    }
    
    [self releaseShadeBt];
    [self releaseOKBt];
    
    [UIView animateWithDuration:.3f animations:^{
        self.frame = CGRectMake(0, self.frame.origin.y+self.frame.size.height, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        if (finished) {
            {
                [self setDelegate:nil];
                [self removeFromSuperview]; 
                RELEASE(self);
            }
        }
        
    }];
    
    
}

//当前选择的组合内容
-(NSString *)result
{
    return [NSString stringWithFormat:@"%@-%@",[year objectAtIndex:_rows[0]],[month objectAtIndex:_rows[1]]];
}

@end
