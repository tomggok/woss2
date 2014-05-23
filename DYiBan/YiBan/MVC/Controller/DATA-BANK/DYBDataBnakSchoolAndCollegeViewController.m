//
//  DYBDataBnakSchoolAndCollegeViewController.m
//  DYiBan
//
//  Created by tom zeng on 13-9-16.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBDataBnakSchoolAndCollegeViewController.h"
#import "Magic_Request.h"
#import "DYBHttpMethod.h"
#import "user.h"
#import "eclass.h"

@interface DYBDataBnakSchoolAndCollegeViewController (){
    
    MagicUITableView *tbDataBank;
    NSMutableArray *arrayResult;
    NSMutableArray *arrayCell;
    
    NSMutableDictionary *collectClass;
    NSMutableDictionary* selectDic;
}

@end

@implementation DYBDataBnakSchoolAndCollegeViewController
@synthesize docAddr = _docAddr ,type = _type,dictInfo = _dictInfo;
DEF_SIGNAL(RIGHTSIGNAL)

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
-(void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal{
    
    DLogInfo(@"name -- %@",signal.name);
    
    if ([signal is:[MagicViewController LAYOUT_VIEWS]])
    {
        [self.rightButton setHidden:NO];
//        [self setButtonImage:self.leftButton setImage:@"btn_back_def"];
        [self setButtonImage:self.leftButton setImage:@"btn_back_def" setHighString:@"btn_back_hlt"];
        if (_type == 0) { //学院
             [self.headview setTitle:@"选择学院"];
            
        }else{
            // 学校
             [self.headview setTitle:@"选择学校"];
        }
        
       
        [self setButtonImage:self.rightButton setImage:@"btn_ok_def"];
        
    }
    if ([signal is:[MagicViewController CREATE_VIEWS]]) {
        
        arrayResult = [[NSMutableArray alloc]init];
        arrayCell = [[NSMutableArray alloc]init];
        selectDic = [[NSMutableDictionary alloc]init];
        collectClass = [[NSMutableDictionary alloc]init];
        
        
        if (_type == 0) { //学院
            
            MagicRequest *request = [DYBHttpMethod source_departmentlist_isAlert:YES receive:self ];
            [request setTag:1];
        }else{
                // 学校
            MagicRequest *request = [DYBHttpMethod source_schoolview:YES receive:self ];
            [request setTag:1];
        }
        
        tbDataBank = [[MagicUITableView alloc]initWithFrame:CGRectMake(0.0f,   44, 320.0f, self.view.frame.size.height - 44) isNeedUpdate:YES];
//        [tbDataBank.headerView setHidden:YES];
        [tbDataBank.headerView setHidden:YES];
        [tbDataBank.footerView setHidden:YES];
        [self.view addSubview:tbDataBank];
        [tbDataBank setSeparatorColor:[UIColor clearColor]];
        [tbDataBank release];
        
//        [tbDataBank];
        
    }
}

-(void)handleViewSignal_DYBDataBnakSchoolAndCollegeViewController:(MagicViewSignal *)signal{
    if ([signal is:[DYBDataBnakSchoolAndCollegeViewController RIGHTSIGNAL]]) {
        
        DLogInfo(@"ffff");
    }if ([signal is:[DYBBaseViewController NEXTSTEPBUTTON]])
    {
        
        DLogInfo(@"gggg");
        
    }
    
    
    
}


#pragma mark- 
- (void)handleViewSignal_DYBBaseViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBBaseViewController BACKBUTTON]])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if ([signal is:[DYBBaseViewController NEXTSTEPBUTTON]])
    {
        
        NSArray *arrayClass = [selectDic allValues];
        NSString *strClass = [arrayClass componentsJoinedByString:@","];
        
        NSString * s = nil;
        if (_type == 0) {
            
            s = @"D";
        }else{
        
            s = @"S";
        }
        
        NSString *target = [NSString stringWithFormat:@"%@,%@",s,strClass];
        
        MagicRequest *request = [DYBHttpMethod document_share_doc:_docAddr target:target isAlert:YES receive:self ];
        [request setTag:5];
        
    }
    
    
}
-(UITableViewCell *)creatCell_string:(NSString *)str isSelect:(BOOL)isSelect tag:(int)tag{
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 320.0, CELLHIGHT)];
    [cell setBackgroundColor:[UIColor clearColor]];
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(20.0f, (CELLHIGHT - 40)/2, 250.0f, 40.0f)];
    [lable setText:str];
    //    [lable setFont: YIMOVINGCONTENTSIZE];
    [cell addSubview:lable];
    [lable setBackgroundColor:[UIColor clearColor]];
    [lable release];
    //    YBLogInfo(@"tag is %d",tag);
    
    UIButton *  btnisSelect = [[UIButton alloc]initWithFrame:CGRectMake(270.0f, (CELLHIGHT - 18)/2, 18, 18)];
    [btnisSelect setBackgroundImage:[UIImage imageNamed:@"btn_check_no"] forState:UIControlStateNormal];
    [btnisSelect setBackgroundImage:[UIImage imageNamed:@"btn_check_yes"] forState:UIControlStateSelected];
    [btnisSelect setBackgroundColor:[UIColor clearColor]];
    [btnisSelect setTag:88];
    [btnisSelect setUserInteractionEnabled:NO];
    [btnisSelect setSelected:NO];
    
    
    NSArray *array = [selectDic allKeys];
    
    for (NSString* i in array) {
        if ([i isEqualToString:[NSString stringWithFormat:@"%d",tag]]) {
            [btnisSelect setSelected:YES];
        }
    }
    
    [cell addSubview:btnisSelect];
    [btnisSelect release];
    
    UIImageView *footImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, CELLHIGHT - 3, 320.0f, 3)];
    [footImageView setImage:[UIImage imageNamed:@"line_padshadow"]];
    [cell addSubview:footImageView];
    RELEASE(footImageView);
    
    return  [cell autorelease];
}


#pragma mark- 只接受tbv信号
static NSString *reuseIdentifier = @"reuseIdentifier";

- (void)handleViewSignal_MagicUITableView:(MagicViewSignal *)signal{
    
    
    if ([signal is:[MagicUITableView TABLENUMROWINSEC]])//numberOfRowsInSection
    {
        NSNumber *s = [NSNumber numberWithInteger:arrayResult.count];
        [signal setReturnValue:s];
        
    }else if ([signal is:[MagicUITableView TABLENUMOFSEC]])//numberOfSectionsInTableView
    {
        NSNumber *s = [NSNumber numberWithInteger:1];
        [signal setReturnValue:s];
        
    }
    else if ([signal is:[MagicUITableView TABLEHEIGHTFORROW]])//heightForRowAtIndexPath
    {
        
        
        
        [signal setReturnValue:[NSNumber numberWithInteger:CELLHIGHT]];
    }
    else if ([signal is:[MagicUITableView TABLETITLEFORHEADERINSECTION]])//titleForHeaderInSection
    {
        [signal setReturnValue:nil];
        
    }
    else if ([signal is:[MagicUITableView TABLEVIEWFORHEADERINSECTION]])//viewForHeaderInSection
    {
        [signal setReturnValue:nil];
        
    }
    else if ([signal is:[MagicUITableView TABLETHEIGHTFORHEADERINSECTION]])//heightForHeaderInSection
    {
        [signal setReturnValue:[NSNumber numberWithFloat:0.0]];
    }
    else if ([signal is:[MagicUITableView TABLECELLFORROW]])//cell
    {
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        NSDictionary *dictSource = [arrayResult objectAtIndex:indexPath.row];
        NSString *strMSG = [dictSource objectForKey:@"name"];
        BOOL isShare = [[dictSource objectForKey:@"is_shared"] boolValue];
        
        if (isShare) {
            [selectDic setValue:[dictSource objectForKey:@"id"] forKey:[NSString stringWithFormat:@"%d",indexPath.row+1]];
        }
        
        UITableViewCell *cellView = [self creatCell_string:strMSG isSelect:isShare tag:indexPath.row + 1];
        [cellView setSelectionStyle:UITableViewCellSelectionStyleNone];
        [signal setReturnValue:cellView];
        
        
        
    }else if ([signal is:[MagicUITableView TABLEDIDSELECT]])//选中cell
    {
        
        
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        UITableView *tableView = [dict objectForKey:@"tableView"];
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UIButton *btn = (UIButton*)[cell viewWithTag:88];
        NSDictionary *dictSource = [arrayResult objectAtIndex:indexPath.row];
        
        if (btn.selected) {
            btn.selected = NO;
            [selectDic removeObjectForKey:[NSString stringWithFormat:@"%d",indexPath.row+1]];
        }else{
            btn.selected = YES;
            [selectDic setValue:[dictSource objectForKey:@"id"] forKey:[NSString stringWithFormat:@"%d",indexPath.row+1]];
        }
        [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
        
        
    }else if ([signal is:[MagicUITableView TABLESCROLLVIEWDIDENDDRAGGING]])//滚动停止
    {
        
    }else if ([signal is:[MagicUITableView TABLESCROLLVIEWDIDSCROLL]])
    {
//        [tbDataBank tableViewDidDragging];
    }
    else if ([signal is:[MagicUITableView TABLESCROLLVIEWDIDENDDRAGGING]])
    {
        DLogInfo(@"1111");
        
    }else if ([signal is:[MagicUITableView TABELVIEWBEGAINSCROLL]]){
        
        //        [sideController removeSideSwipeView:YES];
        
    }else if ([signal is:[MagicUITableView TAbLEVIEWSCROLLUP]]){
        
        
        
    }else if ([signal is:[MagicUITableView TAbLEVIEWSCROLLDOWN]]){
        
    }
    
}




#pragma mark- 只接受HTTP信号
- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj
{
    if (request.tag == 1) {
        
        
        
        if ([request succeed])
        {
            
            JsonResponse *response = (JsonResponse *)receiveObj;
            if ([response response] ==khttpsucceedCode)
            {
                
                NSDictionary *list=[response.data objectForKey:@"list"];
//                
//                for (NSDictionary *d in list) {
                
                    [arrayResult addObject:list];
                    
//                }
            }
            
        }
        [self.view setUserInteractionEnabled:YES];
        
        [tbDataBank reloadData];
        [tbDataBank reloadData:NO];
    }else if (request.tag == 2){
        
        if ([request succeed])
        {
            
            JsonResponse *response = (JsonResponse *)receiveObj;
            if ([response response] ==khttpsucceedCode)
            {
                
                
            }
        }
        
      
        
    }
    else if (request.tag == 5){
        
        if ([request succeed])
        {
            
            JsonResponse *response = (JsonResponse *)receiveObj;
            if ([response response] ==khttpsucceedCode)
            {
                [_dictInfo setValue:@"2" forKey:@"perm"];
                [self.drNavigationController popVCAnimated:YES];
                
            }
            NSString *MSG = [response.data objectForKey:@"msg"];
            
            //        [self.window setBackgroundColor:[UIColor redColor]];
            
            [DYBShareinstaceDelegate popViewText:MSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
            
        }
        
        
        
    }
}


- (void)dealloc
{
    RELEASE(arrayResult);
    RELEASE(arrayCell);
    RELEASEDICTARRAYOBJ(collectClass);
    RELEASEDICTARRAYOBJ(selectDic);
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
