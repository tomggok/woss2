    //
//  RightViewController.m
//  splitViewTest
//
//  Created by zeng tom on 12-10-8
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "RightViewController.h"
//#import "review_ControllerView.h"
//#import "AboutMeControllerView.h"
//#import "MessageForMeViewController.h"
//#import "notice_ViewController.h"
//#import "Friend_request_ViewController.h"
//#import "Msg_content_Controller.h"
//#import "Publish.h"
#import "LLSplitViewController.h"
//#import "tip_num_View.h"
//#import "Message_count_top_view.h"
//#import "HttpHelp.h"
//#import "Rrequest_Data.h"
//#import "Static.h"
//#import "CommonHelper.h"
//#import "RegisetSchoolViewController.h"
#import "UserLoginModel.h"
#import "MainViewController.h"
//#import "YiBanHeadBarView.h"
@implementation RightViewController
{
//    Message_count_top_view * mctv;
    UIButton * btn1,*btn2,*btn3,*btn4,*btn5;
    BOOL pageControlUsed;
    NSMutableArray *view_array;
//    review_ControllerView * review_cv;
//    MessageForMeViewController *messgae_cv;
//    AboutMeControllerView *about_cv;
//    notice_ViewController *ncv;
//    Friend_request_ViewController *fcv;
}
@synthesize yb_new_at;
@synthesize yb_new_comment;
@synthesize yb_new_message;
@synthesize yb_new_notice;
@synthesize yb_new_request;

static RightViewController *share = nil;
+(RightViewController *)share{
    if (!share) {
        share = [[RightViewController alloc] init];
    }
    
    return share;
}

-(void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal{
    
    DLogInfo(@"name -- %@",signal.name);
    
    if ([signal is:[MagicViewController LAYOUT_VIEWS]])
    {
        
        [self.headview setTitle:@"分类全"];
        [self.headview setTitleColor:[UIColor colorWithRed:203.0f/255 green:203.0f/255 blue:203.0f/255 alpha:1.0f]];
        
        [self setButtonImage:self.leftButton setImage:@"back"];
        [self.headview setBackgroundColor:[UIColor yellowColor]];
        
        [self.view setBackgroundColor:[UIColor colorWithRed:61.0f/255 green:61.0f/255  blue:61.0f/255  alpha:1.0f]];
        DYBUITabbarViewController *tabBatC = [DYBUITabbarViewController sharedInstace];
        
        [tabBatC hideTabBar:YES animated:NO];
        
        
    }
    else if ([signal is:[MagicViewController CREATE_VIEWS]]) {
        
        
    }
    
    
    else if ([signal is:[MagicViewController DID_APPEAR]]) {
        

    } else if ([signal is:[MagicViewController DID_DISAPPEAR]]){
        
    }
}





- (void)dealloc
{
    
    [super dealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];

//    HttpHelp *help = [[HttpHelp alloc]init:self progress_show:false page:0];
//    
//    [help startHttpEX:MESSAGE_COUNT :[Rrequest_Data messageCount]];
//    
//    //声明一个背景图片
//    view_array = [[NSMutableArray alloc]init];
//    UIImage *backgroundImage = [UIImage imageNamed:@"bg_right.png"];
//    
//    UIImageView * sbg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
//    [sbg setImage:backgroundImage];
//    [self.view addSubview:sbg];
////Add by Hyde 20130218 #memoryleaks
//    [sbg release];
//    mctv = [[Message_count_top_view alloc]initWithFrame:CGRectMake(40, 0, 280, 25)];
//    [mctv init_view:@""];
//    {
//        review_cv = [[review_ControllerView alloc]init];
//        [review_cv.view setFrame:CGRectMake(40, 44, 280, self.view.frame.size.height-44)];
//        [self.view addSubview:review_cv.view];
//        [view_array addObject:review_cv];
//        
//
//        
//        about_cv= [[AboutMeControllerView alloc]init];
//        [about_cv.view setFrame:CGRectMake(40, 44, 280, self.view.frame.size.height-44)];
////        [view_array addObject:cv];
//        [about_cv.view setHidden:YES];
//        [self.view addSubview:about_cv.view];
//        
//        YBLogInfo(@"aboutCV === %d", about_cv.retainCount);
//
//        
//       messgae_cv = [[MessageForMeViewController alloc]init];
//        messgae_cv.view.frame = CGRectMake(40, 44, 280, self.view.frame.size.height-44);
//        [self.view addSubview:messgae_cv.view];
//        [messgae_cv.view setHidden:YES];     
//        
//
//
//        ncv = [[notice_ViewController alloc]init];
//        ncv.view.frame = CGRectMake(40, 44, 280, self.view.frame.size.height-44);
//        [self.view addSubview:ncv.view];
//        [ncv.view setHidden:YES];        
//        
//        
//       fcv = [[Friend_request_ViewController alloc]init];
//        fcv.view.frame = CGRectMake(40, 44, 280, self.view.frame.size.height-44);
//        [self.view addSubview:fcv.view];
//        [fcv.view setHidden:YES];        
//        
//    }
//        [self.view addSubview:mctv];
//    {
//        UIImage * titlebg =  [UIImage imageNamed:@"right_topbar"];
//        UIImageView * titlebg_v = [[UIImageView alloc]initWithImage:titlebg];
//        titlebg_v.frame = CGRectMake(0, 0, 320, 48);
//        [self.view addSubview:titlebg_v];
////Add by Hyde 20130218 #memoryleaks
//        [titlebg_v release];
//        btn1 = [[UIButton alloc]initWithFrame:CGRectMake(40, 0, 56, 44)];
//        [btn1 setTag:1];
//        [btn1 setBackgroundImage:[UIImage imageNamed:@"menu1a"] forState:UIControlStateNormal];
//        [btn1 setBackgroundImage:[UIImage imageNamed:@"menu1b"] forState:UIControlStateSelected];
//        //        [btn1 setTitle:[NSString stringWithFormat:@"评论我"] forState:UIControlStateNormal];
//        [btn1 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
//        [btn1 setSelected:true];
//        [self.view addSubview:btn1];
//        [btn1 release];
//        
////        tip_num_View * num_view_1 = [[tip_num_View alloc]initWithFrame:CGRectMake(70, 5, 56, 16)];
////        [num_view_1 init:100];
////        [num_view_1 setUserInteractionEnabled: NO];
////        [self.view addSubview:num_view_1];
//        
//        
//        btn2 = [[UIButton alloc]initWithFrame:CGRectMake(96, 0, 56, 44)];
//        [btn2 setTag:2];
//        [btn2 setBackgroundImage:[UIImage imageNamed:@"menu2a"] forState:UIControlStateNormal];
//        [btn2 setBackgroundImage:[UIImage imageNamed:@"menu2b"] forState:UIControlStateSelected];
//        //        [btn2 setTitle:[NSString stringWithFormat:@"@我"] forState:UIControlStateNormal];
//        [btn2 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
//        [btn2 setSelected:false];
//        [self.view addSubview:btn2];
//        [btn2 release];
//        
////        tip_num_View * num_view_2 = [[tip_num_View alloc]initWithFrame:CGRectMake(128, 5, 56, 16)];
////        [num_view_2 init:100];
////        [num_view_2 setUserInteractionEnabled: NO];
////        [self.view addSubview:num_view_2];
//        
//        btn3 = [[UIButton alloc]initWithFrame:CGRectMake(152, 0, 56, 44)];
//        [btn3 setTag:3];
//        [btn3 setBackgroundImage:[UIImage imageNamed:@"menu3a"] forState:UIControlStateNormal];
//        [btn3 setBackgroundImage:[UIImage imageNamed:@"menu3b"] forState:UIControlStateSelected];
//        //        [btn3 setTitle:[NSString stringWithFormat:@"私信"] forState:UIControlStateNormal];
//        [btn3 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
//        //        [btn3 setBackgroundColor:[UIColor orangeColor]];
//        [btn3 setSelected:false];
//        [self.view addSubview:btn3];
//        [btn3 release];
//        
//        
////        tip_num_View * num_view_3 = [[tip_num_View alloc]initWithFrame:CGRectMake(185, 5, 56, 16)];
////        [num_view_3 init:100];
////        [num_view_3 setUserInteractionEnabled: NO];
////        [self.view addSubview:num_view_3];
//        
//        btn4 = [[UIButton alloc]initWithFrame:CGRectMake(208, 0, 56, 44)];
//        [btn4 setTag:4];
//        [btn4 setBackgroundImage:[UIImage imageNamed:@"menu4a"] forState:UIControlStateNormal];
//        [btn4 setBackgroundImage:[UIImage imageNamed:@"menu4b"] forState:UIControlStateSelected];
//        //        [btn4 setTitle:[NSString stringWithFormat:@"通知"] forState:UIControlStateNormal];
//        [btn4 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
//        //        [btn4 setBackgroundColor:[UIColor orangeColor]];
//        [btn4 setSelected:false];
//        [self.view addSubview:btn4];
//        [btn4 release];
//        
////        tip_num_View * num_view_4 = [[tip_num_View alloc]initWithFrame:CGRectMake(240, 5, 56, 16)];
////        [num_view_4 init:100];
////        [num_view_4 setUserInteractionEnabled: NO];
////        [self.view addSubview:num_view_4];
//        
//        btn5 = [[UIButton alloc]initWithFrame:CGRectMake(264, 0, 56, 44)];
//        [btn5 setTag:5];
//        [btn5 setBackgroundImage:[UIImage imageNamed:@"menu5a"] forState:UIControlStateNormal];
//        [btn5 setBackgroundImage:[UIImage imageNamed:@"menu5b"] forState:UIControlStateSelected];
//        //        [btn5 setTitle:[NSString stringWithFormat:@"好友请求"] forState:UIControlStateNormal];
//        [btn5 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
//        [btn5 setSelected:false];
//        [self.view addSubview:btn5];
//        
////        tip_num_View * num_view_5 = [[tip_num_View alloc]initWithFrame:CGRectMake(32, 3, 21, 16)];
////        [num_view_5 init:99];
////        [num_view_5 setUserInteractionEnabled: NO];
////        [btn5 addSubview:num_view_5];
    
//    }
}

- (void)unVerifyUser{
    viewCover = [UIButton buttonWithType:UIButtonTypeCustom];
    [viewCover setFrame:self.view.bounds];
    [viewCover setBackgroundColor:[UIColor blackColor]];
    [viewCover setAlpha:0.7];
    [viewCover setUserInteractionEnabled:YES];
    [viewCover addTarget:self action:@selector(verifyAlert) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:viewCover];
}

- (void)removeVerifyWarning{
    [viewCover removeFromSuperview];
}

//-(void)verifyAlert{
//    [CommonHelper alertView:NORESETALLTYPE tag:1 warning:NO view:self.view alertdelegate:self];
//}

//#pragma mark - yibanAlertViewDelegate
//- (void)YibanAlertViewCancelButton:(YIBanAlertView *)alertView
//{
//    [alertView removeFromSuperview];
//}
//
//- (void)YibanAlertViewConfirmButton:(YIBanAlertView *)alertView
//{
//    NSString *strUID = [[[YiBanLocalDataManager sharedInstance] currentUser] userid];
//    UserLoginModel *u = [[YiBanLocalDataManager sharedInstance] getUserInfoMessage:strUID];
//    
//    RegisetSchoolViewController *school = [[RegisetSchoolViewController alloc] init];
//    [school setReusername:u.userName];
//    [school setIsInApp:YES];
//    [[LLSplitViewController getmainController].navigationController pushViewController:school animated:YES];
//    [school release];
//    [alertView removeFromSuperview];
//}
//
//- (void)YiBanAlertViewClickOuterView:(YIBanAlertView *)alertView touch:(UITouch *)touch
//{
////    [alertView removeFromSuperview];
//}
//
//-(void)goto_notice{
//    Publish *pulish = [[Publish alloc]init];
//    [[LLSplitViewController getmainController].navigationController pushViewController:pulish animated:YES];
////Add by Hyde 20130218 #memoryleaks    
//    [pulish release];
//}
//
//-(void)click:(id)sender{
//    [[CommonHelper shareInstance]playSound:5];
//    UIButton* btn = (UIButton*)sender;
//
//    switch (btn.tag) {
//        case 1:
//            [btn setSelected:true];
//            [btn2 setSelected:false];
//            [btn3 setSelected:false];
//            [btn4 setSelected:false];
//            [btn5 setSelected:false];
//            [review_cv.view setHidden:NO];
//            [messgae_cv.view setHidden:YES];
//            [about_cv.view setHidden:YES];
//            [ncv.view setHidden:YES];
//            [fcv.view setHidden:YES];
//            if ([yb_new_comment intValue]<=0) {
//                return ;
//            }
//            [mctv.title setText:[NSString stringWithFormat:@"您有%@条未读评论",self.yb_new_comment]];
//            break;
//        case 2:
//            [btn setSelected:true];
//            [btn1 setSelected:false];
//            [btn3 setSelected:false];
//            [btn4 setSelected:false];
//            [btn5 setSelected:false];
//            [about_cv.view setHidden:NO];
//            [review_cv.view setHidden:YES];
//            [messgae_cv.view setHidden:YES];
//            [ncv.view setHidden:YES];
//            [fcv.view setHidden:YES];
//            if ([yb_new_at intValue]<=0) {
//                return ;
//            }
//            [mctv.title setText:[NSString stringWithFormat:@"您有%@人AT你啦",self.yb_new_at]];
//            break;
//            
//        case 3://私信按钮
//            YBLogInfo(@"about_cv === %d",about_cv.retainCount);
//            [btn setSelected:true];
//            [btn1 setSelected:false];
//            [btn2 setSelected:false];
//            [btn4 setSelected:false];
//            [btn5 setSelected:false];
//            [messgae_cv.view setHidden:NO];
//            [about_cv.view setHidden:YES];
//            [review_cv.view setHidden:YES];
//            [ncv.view setHidden:YES];
//            [fcv.view setHidden:YES];
//
//            if ([yb_new_message intValue]<=0) {
//                return ;
//            }
//            [mctv.title setText:[NSString stringWithFormat:@"您有%@条未读私信",self.yb_new_message]];
//            break;
//            
//        case 4: 
//            [btn setSelected:true];
//            [btn1 setSelected:false];
//            [btn2 setSelected:false];
//            [btn3 setSelected:false];
//            [btn5 setSelected:false];
//            [ncv.view setHidden:NO];
//            [messgae_cv.view setHidden:YES];
//            [about_cv.view setHidden:YES];
//            [review_cv.view setHidden:YES];
//            [fcv.view setHidden:YES];
//            
//            [ncv sendnotice];
//
//            if ([yb_new_notice intValue]<=0) {
//                return ;
//            }
//            [mctv.title setText:[NSString stringWithFormat:@"您有%@条未读通知",self.yb_new_notice]];
//            break;
//            
//        case 5:
//            [btn setSelected:true];
//            [btn1 setSelected:false];
//            [btn2 setSelected:false];
//            [btn3 setSelected:false];
//            [btn4 setSelected:false];
//            
//            [fcv.view setHidden:NO];
//            [ncv.view setHidden:YES];
//            [messgae_cv.view setHidden:YES];
//            [about_cv.view setHidden:YES];
//            [review_cv.view setHidden:YES];
//
//            if ([yb_new_request intValue]<=0) {
//                return ;
//            }
//            [mctv.title setText:[NSString stringWithFormat:@"您有%@条好友请求未验证",self.yb_new_request]];
//            break;
//    }
//            [self startAnim];
//}

//scrollview滚动时候调用的方法,也是实现滑动翻页效果的主题方法

- (void)scrollViewDidScroll:(UIScrollView *)sender {

//    YBLogInfo(@"x: %f",sender.contentOffset.x);//往左滑动是正值，往右是负值
    
    if (pageControlUsed) {
        
        return;
        
    }
    
    CGFloat pageWidth = sender.frame.size.width;
    
    //判断滑动的幅度来决定page值大小,floor取小于括号内数的最大的整数
    
    int page = floor((sender.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    switch (page) {
        case 0:
            [btn1 setSelected:true];
            [btn2 setSelected:false];
            [btn3 setSelected:false];
            [btn4 setSelected:false];
            [btn5 setSelected:false];
            break;
        case 1:
            [btn2 setSelected:true];
            [btn1 setSelected:false];
            [btn3 setSelected:false];
            [btn4 setSelected:false];
            [btn5 setSelected:false];
            break;
        case 2:
            [btn3 setSelected:true];
            [btn1 setSelected:false];
            [btn2 setSelected:false];
            [btn4 setSelected:false];
            [btn5 setSelected:false];
            break;
        case 3:
            [btn4 setSelected:true];
            [btn1 setSelected:false];
            [btn2 setSelected:false];
            [btn3 setSelected:false];
            [btn5 setSelected:false];
            break;
        case 4:
            [btn5 setSelected:true];
            [btn1 setSelected:false];
            [btn2 setSelected:false];
            [btn3 setSelected:false];
            [btn4 setSelected:false];
            break;
    }

    
}
#pragma mark -
#pragma mark  uitableview datasource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *identifier = @"cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	
	if(cell == nil)
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
//		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:identifier] autorelease];
	}
	
	
	cell.textLabel.textColor = [UIColor whiteColor];
	cell.textLabel.font = [UIFont	boldSystemFontOfSize:16];
//	cell.textLabel.text = @"酒店管家";
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
//	otherViewController *lvc = [[otherViewController alloc] init];
//	[theApp.viewController pushViewController:lvc animated:YES];
//	[lvc release];
	 
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)startAnim{
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.8];
    [UIView setAnimationDidStopSelector:@selector(animation_stop)];
//    mctv.frame = CGRectMake(40, 44, 280, 25);
    [UIView commitAnimations];
    [self performSelector:@selector(stopAnim) withObject:nil afterDelay:2.0f];
}

#pragma mark -
#pragma mark - httpdelegate
//#pragma mark -
//- (void)requestSuccess:(NSDictionary *)data message:(NSString *)message http:(HttpHelp *)http
//{
//    self.yb_new_at = [data objectForKey:@"new_at"];
//    self.yb_new_message = [data objectForKey:@"new_message"];
//    self.yb_new_comment = [data objectForKey:@"new_comment"];
//    self.yb_new_notice = [data objectForKey:@"new_notice"];
//    self.yb_new_request = [data objectForKey:@"new_request"];
//    
//    [self refreashHeadBarMessageCount];
//
//    [http release];
//}
//
//
//- (void)refreashHeadBarMessageCount{
//    YBLogInfo(@"new_at = %@   new_message= %@   new_comment = %@   new_notice= %@  new_request= %@",yb_new_at,yb_new_message,yb_new_comment,yb_new_notice,yb_new_request);
//    
//    NSArray *arrCount = [[NSArray alloc] initWithObjects:yb_new_comment, yb_new_at, yb_new_message, yb_new_notice, yb_new_request, nil];
//    NSArray *arrBtn = [[NSArray alloc] initWithObjects:btn1, btn2, btn3, btn4, btn5, nil];
//    
//    
//    for (int i = 0; i < 5; i++) {
//        for(UIView *viewtip in [[arrBtn objectAtIndex:i] subviews]){
//            if ([viewtip isKindOfClass:[tip_num_View class]]) {
//                [viewtip removeFromSuperview];
//            }
//        }
//        
//        if ([[arrCount objectAtIndex:i] intValue] > 0) {
//            tip_num_View * num_view = [[tip_num_View alloc]initWithFrame:CGRectMake(32, 3, 21, 16)];
//            [num_view init:[[arrCount objectAtIndex:i] intValue]];
//            [num_view setUserInteractionEnabled: NO];
//            [[arrBtn objectAtIndex:i] addSubview:num_view];
//            [num_view release];
//        }
//    }
//    
//    [arrCount release];
//    [arrBtn release];
//   
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreashMessageCount" object:nil];
//}
//
//-(void)stopAnim{
//    [UIView beginAnimations:@"" context:nil];
//    [UIView setAnimationDuration:0.8];
//    [UIView setAnimationDidStopSelector:@selector(animation_stop)];
//    mctv.frame = CGRectMake(40, 0, 280, 25);
//    [UIView commitAnimations];
//}

- (void)releaseShare{
    
//    [review_cv release];
//    [about_cv release];
//    [messgae_cv release];
//    [ncv release];
//    [fcv release];
    
    [share release];
    share = nil;
    
//    [super release]; 此句导致 在易友动态和消息中心做刷新操作注销后，登陆界面点击忘记密码和注册时出现闪退, LLSplitViewController类的showLeftView:函数里的_controllerRight.view提前被dealloc
    
}

@end
