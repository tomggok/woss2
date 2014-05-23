//
//  WOSAddrViewController.m
//  DYiBan
//
//  Created by tom zeng on 13-11-28.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "WOSAddrViewController.h"
#import "WOSAddrCell.h"
#import "WOSAddAddrViewController.h"
#import "JSONKit.h"
#import "JSON.h"

@interface WOSAddrViewController ()
{
    NSMutableArray *arrayAddrList;
    UITableView *tableView1;
    
    int delIndex;

}
@end

@implementation WOSAddrViewController

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
        [self.headview setTitle:@"送餐地址管理"];
        
        [self.headview setTitleColor:[UIColor colorWithRed:193.0f/255 green:193.0f/255 blue:193.0f/255 alpha:1.0f]];
        
        [self.view setBackgroundColor:ColorBG];
        [self setButtonImage:self.leftButton setImage:@"back"];
    }
    else if ([signal is:[MagicViewController CREATE_VIEWS]]) {
        
        [self.view setBackgroundColor:[UIColor clearColor]];
        NSLog(@"useid -- %@",SHARED.userId);
        
//        arrayAddrList = [[NSMutableArray alloc]init];
        delIndex = 0;
        MagicRequest *request = [DYBHttpMethod wosKitchenInfo_addrList_userIndex:SHARED.userId page:@"0" count:@"3" sAlert:YES receive:self];
        [request setTag:3];
        
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20.0f, 44 + 20 , 280,self.view.frame.size.height - 44 - 100 - 80)];
        UIImage *imageNew = [[UIImage imageNamed:@"text_area"] resizableImageWithCapInsets:UIEdgeInsetsMake(10.5, 10.5 , 10.5,10.5)];
        [imageView setImage:imageNew];
        [self.view addSubview:imageView];
        RELEASE(imageView);
        
       
        
        tableView1 = [[UITableView alloc]initWithFrame:CGRectMake(20.0f, 44 + 20 , 280,self.view.frame.size.height - 44 - 100 - 80)];
        [tableView1 setBackgroundColor:[UIColor clearColor]];
        [tableView1 setDelegate:self];
        [tableView1 setDataSource:self];
        [tableView1 setSeparatorColor:[UIColor clearColor]];
        [self.view addSubview:tableView1];
        RELEASE(tableView1);
        
        UIButton *btnBack = [[UIButton alloc]initWithFrame:CGRectMake(10.0f, CGRectGetHeight(tableView1.frame) + CGRectGetMinY(tableView1.frame) + 20, 300, 44)];
        [btnBack addTarget:self action:@selector(addNewAddr) forControlEvents:UIControlEventTouchUpInside];
        [btnBack setBackgroundColor:[UIColor clearColor]];
         [self.view addSubview:btnBack];
        [btnBack release];
        [btnBack setImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
        [self addlabel_title:@"添加地址" frame:btnBack.frame view:btnBack];
    }
    
    else if ([signal is:[MagicViewController DID_APPEAR]]) {
        
        DLogInfo(@"rrr");
    } else if ([signal is:[MagicViewController DID_DISAPPEAR]]){
        
        
    }
}


-(void)addlabel_title:(NSString *)title frame:(CGRect)frame view:(UIView *)view{
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame))];
    [label1 setText:title];
    [label1 setTag:100];
    [label1 setTextAlignment:NSTextAlignmentCenter];
    [view bringSubviewToFront:label1];
    [label1 setTextColor:[UIColor whiteColor]];
    [label1 setBackgroundColor:[UIColor clearColor]];
    [view addSubview:label1];
    RELEASE(label1);
    
}

-(void)addNewAddr{
    
    WOSAddAddrViewController *addAddr = [[WOSAddAddrViewController alloc]init];
    
    addAddr.addView = self;
    [self.drNavigationController pushViewController:addAddr animated:YES];
    RELEASE(addAddr);

}

-(void)reloadData{




}


//- (void)handleViewSignal_MagicUITableView:(MagicViewSignal *)signal{
//    
//    
//    if ([signal is:[MagicUITableView TABLENUMROWINSEC]])//numberOfRowsInSection
//    {
//        NSNumber *s = [NSNumber numberWithInteger:arrayAddrList.count];
//        [signal setReturnValue:s];
//        
//    }else if ([signal is:[MagicUITableView TABLENUMOFSEC]])//numberOfSectionsInTableView
//    {
//        NSNumber *s = [NSNumber numberWithInteger:1];
//        [signal setReturnValue:s];
//        
//    }
//    else if ([signal is:[MagicUITableView TABLEHEIGHTFORROW]])//heightForRowAtIndexPath
//    {
//        
//        
//        
//        [signal setReturnValue:[NSNumber numberWithInteger:80]];
//    }
//    else if ([signal is:[MagicUITableView TABLETITLEFORHEADERINSECTION]])//titleForHeaderInSection
//    {
//        [signal setReturnValue:nil];
//        
//    }
//    else if ([signal is:[MagicUITableView TABLEVIEWFORHEADERINSECTION]])//viewForHeaderInSection
//    {
//        [signal setReturnValue:nil];
//        
//    }
//    else if ([signal is:[MagicUITableView TABLETHEIGHTFORHEADERINSECTION]])//heightForHeaderInSection
//    {
//        [signal setReturnValue:[NSNumber numberWithFloat:0.0]];
//    }
//    else if ([signal is:[MagicUITableView TABLECELLFORROW]])//cell
//    {
//        NSDictionary *dict = (NSDictionary *)[signal object];
//        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
//        
//        WOSAddrCell *cell = [[WOSAddrCell alloc]init];
//        [cell setBackgroundColor:[UIColor colorWithRed:46/255 green:46/255 blue:46/255 alpha:1.0f]];
//        [cell creatCell:[arrayAddrList objectAtIndex:indexPath.row]];
//        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//        
//        [signal setReturnValue:cell];
//        
//        
//    }else if ([signal is:[MagicUITableView TABLEDIDSELECT]])//选中cell
//    {
//        
//        return;
//        
//    }else if([signal is:[MagicUITableView TABLESCROLLVIEWDIDENDDRAGGING]])/*滚动停止*/{
//        
//        
//    }else if([signal is:[MagicUITableView TABLESCROLLVIEWDIDSCROLL]])/*滚动*/{
//        
//    }else if ([signal is:[MagicUITableView TABLEVIEWUPDATA]]) //刷新
//    {
//        //        MagicUIUpdateView *uptableview = (MagicUIUpdateView *)[signal object];
//        
//        
//    }else if([signal is:[MagicUITableView TAbLEVIEWLODATA]]) //加载更多
//    {
//        
//        
//    }else if ([signal is:[MagicUITableView TAbLEVIEWSCROLLUP]]){ //上滑动
//        
//        //        [tbDataBank StretchingUpOrDown:0];
//        //        [DYBShareinstaceDelegate opeartionTabBarShow:YES];
//        
//    }else if ([signal is:[MagicUITableView TAbLEVIEWSCROLLDOWN]]){ //下滑动
//        
//        //        [tbDataBank StretchingUpOrDown:1];
//        //        [DYBShareinstaceDelegate opeartionTabBarShow:NO];
//    }
//    
//}


#pragma mark - tableviewdelete
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section/*第一次回调时系统传的section是数据源里section数量的最大值-1*/
{
    
    
    
    return arrayAddrList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    
    WOSAddrCell *cell = [[WOSAddrCell alloc]init];
    [cell setBackgroundColor:[UIColor colorWithRed:46/255 green:46/255 blue:46/255 alpha:1.0f]];
    [cell creatCell:[arrayAddrList objectAtIndex:indexPath.row]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:tableView, @"tableView", indexPath, @"indexPath", nil];
//    [self sendViewSignal:[MagicUITableView TABLEDIDSELECT] withObject:dict];
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setEditing:YES animated:YES];
    return UITableViewCellEditingStyleDelete;
}

//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setEditing:NO animated:YES];
    
    delIndex = indexPath.row;
    
    MagicRequest *request = [DYBHttpMethod wosFoodInfo_addressDel_userIndex:SHARED.userId addrIndex:[[arrayAddrList objectAtIndex:indexPath.row] objectForKey:@"addrIndex"] sAlert:YES receive:self];
    [request setTag:4];
    
    
    
    
}

//以下方法可以不是必须要实现，添加如下方法可实现特定效果：

//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}


- (void)handleViewSignal_DYBBaseViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBBaseViewController BACKBUTTON]])
    {
        [self.drNavigationController popViewControllerAnimated:YES];
    }else if ([signal is:[DYBBaseViewController NEXTSTEPBUTTON]]){
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    
    [super dealloc];
}

#pragma mark- 只接受HTTP信号
- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj
{
    if ([request succeed])
    {
        if (request.tag == 4) {
            
            
            NSDictionary *dict = [request.responseString JSONValue];
            
            if (dict) {
                BOOL result = [[dict objectForKey:@"result"] boolValue];
                if (!result) {
                    
                    
                    [arrayAddrList removeObjectAtIndex:delIndex];
                    [tableView1 reloadData];

                    
                }else{
                    NSString *strMSG = [dict objectForKey:@"message"];
                    
                    [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    
                    
                }
            }
        }else if(request.tag == 3){
            
            NSDictionary *dict = [request.responseString JSONValue];
            
            if (dict) {
                BOOL result = [[dict objectForKey:@"result"] boolValue];
                if (!result) {
                    
                    arrayAddrList = [[NSMutableArray alloc]initWithArray:[dict objectForKey:@"userAddressList"]];
//                    [self creatView:dict];
                    [tableView1 reloadData];
                    //                    UIButton *btn = (UIButton *)[UIButton buttonWithType:UIButtonTypeCustom];
                    //                    [btn setTag:10];
                    //                    [self doChange:btn];
                }
                else{
                    NSString *strMSG = [dict objectForKey:@"message"];
                    
                    [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    
                    
                }
            }
            
        } else{
            NSDictionary *dict = [request.responseString JSONValue];
            NSString *strMSG = [dict objectForKey:@"message"];
            
            [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
            
            
        }
    }
}


@end
