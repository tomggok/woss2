//
//  WOSShopDetail1ViewController.m
//  WOS
//
//  Created by apple on 14-4-19.
//  Copyright (c) 2014年 ZzL. All rights reserved.
//

#import "WOSShopDetail1ViewController.h"

@interface WOSShopDetail1ViewController ()

@end

@implementation WOSShopDetail1ViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal{
    
    DLogInfo(@"name -- %@",signal.name);
    
    if ([signal is:[MagicViewController LAYOUT_VIEWS]])
    {
        //        [self.rightButton setHidden:YES];
        [self.headview setTitle:@"餐厅详情"];
        
        [self setButtonImage:self.leftButton setImage:@"back"];
        [self.headview setBackgroundColor:[UIColor colorWithRed:97.0f/255 green:97.0f/255 blue:97.0f/255 alpha:1.0]];
        [self.headview setTitleColor:[UIColor colorWithRed:203.0f/255 green:203.0f/255 blue:203.0f/255 alpha:1.0f]];
        
        [self.view setBackgroundColor: ColorBG];
        
    }
    else if ([signal is:[MagicViewController CREATE_VIEWS]]) {
        
        [self.rightButton setHidden:YES];
        
        
        MagicUITableView *tabelViewList = [[MagicUITableView alloc]initWithFrame:CGRectMake(0.0f, self.headHeight, 320.0f, self.view.frame.size.height - self.headHeight)];
        
        [self.view addSubview:tabelViewList];
        RELEASE(tabelViewList)
        
        

        
        
//        MagicRequest *request = [DYBHttpMethod wosKitchenInfo_kitchenIndex:[_dictInfo objectForKey:@"kitchenIndex"] userIndex:SHARED.userId hotFoodCount:@"4" sAlert:YES receive:self];
//        [request setTag:3];
//        
        
        
        
    }
    
    
    else if ([signal is:[MagicViewController WILL_APPEAR]]) {
        
        DLogInfo(@"rrr");
        
        
    } else if ([signal is:[MagicViewController DID_DISAPPEAR]]){
        
        
    }
    
}


-(void)doCollent{
    
//    MagicRequest *request = [DYBHttpMethod wosKitchenInfo_favorite_userIndex:SHARED.userId kitchenIndex:[_dictInfo objectForKey:@"kitchenIndex"] sAlert:YES receive:self];
//    [request setTag:2];
    
}

-(void)doShare{
    
    
    
}


-(void)creatView:(NSDictionary *)dict{
    
    
    
//    UIScrollView *scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0.0f, self.headHeight, 320.0f, self.view.frame.size.height - self.headHeight)];
//    [scrollview setUserInteractionEnabled:YES];
//    [self.view addSubview:scrollview];
//    RELEASE(scrollview);
//    [scrollview setContentSize:CGSizeMake(320.0f, 524)];
//    
//    viewBG = [[UIScrollView alloc]initWithFrame:CGRectMake(10.0f, self.headHeight + 10, 300.0f, self.view.frame.size.height - self.headHeight + 10)];
//    [viewBG setBackgroundColor:[UIColor whiteColor]];
//    [scrollview addSubview:viewBG];
//    RELEASE(viewBG);
//    [viewBG setUserInteractionEnabled:YES];
//    [viewBG setScrollEnabled:NO];
//    
//    
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10.0f,  10, 300.0f, 70)];
//    [view setBackgroundColor:[UIColor whiteColor]];
//    [scrollview addSubview:view];
//    RELEASE( view);
//    
//    UIImageView *imageViewIcon = [[UIImageView alloc]initWithFrame:CGRectMake(5.0f, 5.0f, 80, 60)];
//    [imageViewIcon setBackgroundColor:[UIColor redColor]];
//    [imageViewIcon setImage:[UIImage imageNamed:@"food1.png"]];
//    [view addSubview:imageViewIcon];
//    RELEASE(imageViewIcon);
//    
//    UILabel *labelNum = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(imageViewIcon.frame) + CGRectGetMinX(imageViewIcon.frame) + 3 + 3, 5, 150, 15)];
//    [labelNum setBackgroundColor:[UIColor clearColor]];
//    [labelNum setTextColor:[UIColor blackColor]];
//    [labelNum setText:[dict objectForKey:@"kitchenName"]];
//    [view addSubview:labelNum];
//    RELEASE(labelNum);
//    
//    
//    
//    
//    UIImage *imageS = [UIImage imageNamed:@"22_06"];
//    
//    WOSStarView *starView = [[WOSStarView alloc]initWithFrame:CGRectMake(CGRectGetWidth(imageViewIcon.frame) + CGRectGetMinX(imageViewIcon.frame) + 3, CGRectGetHeight(labelNum.frame) + 5 + 3,imageS.size.width/2* 5, imageS.size.height/2) num:[[_dictInfo objectForKey:@"starLevel"] integerValue]];
//    [view addSubview:starView];
//    RELEASE(starView);
//    
//    
//    UILabel *labelPrice = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(starView.frame) + CGRectGetMinX(starView.frame) + 3,  CGRectGetHeight(labelNum.frame) + 5 + 7 , 100, 15)];
//    //        NSString *price = [_dictInfo objectForKey:@"kitchenName"];
//    //        [labelPrice setText:[NSString stringWithFormat:@"人均：%@",price]];
//    [labelPrice setTextColor:[UIColor redColor]];
//    [labelPrice setBackgroundColor:[UIColor clearColor]];
//    
//    UILabel *labelAddr = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(imageViewIcon.frame) + CGRectGetMinX(imageViewIcon.frame) + 3 + 2,   CGRectGetMinY(labelPrice.frame) +CGRectGetHeight(labelPrice.frame) + 3 + 2, 150, 15) ];
//    [labelAddr setTextColor:[UIColor redColor]];
//    [labelAddr setBackgroundColor:[UIColor clearColor]];
//    NSString *price = [dict objectForKey:@"pricePU"];
//    [labelAddr setText:[NSString stringWithFormat:@"人均：%@",price]];
//    [view addSubview:labelAddr];
//    RELEASE(labelAddr);
//    
//    
//    
//    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, CGRectGetHeight(labelAddr.frame) + CGRectGetMidY(labelAddr.frame)-40, 320.0f, 0.5)];
//    //        [imageView1 setImage:[UIImage imageNamed:@""]];
//    
//    [imageView1 setBackgroundColor:[UIColor grayColor]];
//    [viewBG addSubview:imageView1];
//    RELEASE(imageView1);
//    
//    
//    
//    [self creatCell:0 info:[dict objectForKey:@"location"]];
//    [self creatCell:1 info:[dict objectForKey:@"contactNumber"]];
//    [self creatCell:2 info:@"now,推荐给好友咖啡！"];
//    
//    [self creatPicBar:[dict objectForKey:@"hotFoodList"]];
//    
//    
//    
//    NSDictionary *newDcit = [dict objectForKey:@"comment"];
//    
//    
//    UIImageView *imageViewNewP = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 70 + 3* 40 + 10 , 320, 30)];
//    [imageViewNewP setBackgroundColor:[UIColor colorWithRed:237/255.0f green:237/255.0f blue:237/255.0f alpha:1.0f]];
//    [viewBG addSubview:imageViewNewP];
//    RELEASE(imageViewNewP);
//    
//    UILabel *labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(10.0f, 0.0f, 100.0f, 30.0f)];
//    [labelTitle setBackgroundColor:[UIColor clearColor]];
//    [labelTitle setTextColor:[UIColor redColor]];
//    [labelTitle setText:@"最新评论"];
//    [imageViewNewP addSubview:labelTitle];
//    RELEASE(labelTitle);
//    
//    
//    UILabel *labelPLName = [[UILabel alloc]initWithFrame:CGRectMake(10.0f, CGRectGetMidY(imageViewNewP.frame) + CGRectGetHeight(imageViewNewP.frame), 150, 20)];
//    
//    [labelPLName setBackgroundColor:[UIColor clearColor]];
//    [labelPLName setTextColor:[UIColor blackColor]];
//    [labelPLName setText:[newDcit objectForKey:@"userName"]];
//    [labelPLName sizeToFit];
//    [viewBG addSubview:labelPLName];
//    RELEASE(labelPLName);
//    
//    
//    WOSStarView *star = [[WOSStarView alloc]initWithFrame:CGRectMake(CGRectGetMidX(labelPLName.frame) + CGRectGetWidth(labelPLName.frame),CGRectGetMidY(imageViewNewP.frame) + CGRectGetHeight(imageViewNewP.frame), 100, 30) num:[[newDcit objectForKey:@"starLevel"] integerValue]];
//    [viewBG addSubview:star];
//    [star release];
//    
//    
//    
//    UILabel *lableTime = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMidX(star.frame) + CGRectGetWidth(star.frame)-80, CGRectGetMidY(imageViewNewP.frame) + CGRectGetHeight(imageViewNewP.frame) + 14, 250, 50)];
//    [lableTime setBackgroundColor:[UIColor clearColor]];
//    [lableTime setTextColor:[UIColor blackColor]];
//    [lableTime setText:[newDcit objectForKey:@"createTime"]];
//    [lableTime sizeToFit];
//    [lableTime setFont:[UIFont systemFontOfSize:13]];
//    [viewBG addSubview:lableTime];
//    RELEASE(lableTime);
//    
//    
//    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(10.0f, CGRectGetMidY(lableTime.frame) + CGRectGetHeight(lableTime.frame), 300, 40)];
//    [textView setBackgroundColor:[UIColor clearColor]];
//    [textView setTextColor:[UIColor blackColor]];
//    [textView setText:[newDcit objectForKey:@"comment"]];
//    [textView sizeToFit];
//    [textView setUserInteractionEnabled:NO];
//    [textView setEditable:NO];
//    [viewBG addSubview:textView];
//    RELEASE(textView);
//    
//    
//    UIImage *image1 = [UIImage imageNamed:@"button_l"];
//    UIButton *btnMore = [[UIButton alloc]initWithFrame:CGRectMake(200.0f,  CGRectGetMidY(textView.frame) + CGRectGetHeight(textView.frame) - 15,100, 30)];
//    [btnMore setBackgroundColor:[UIColor clearColor]];
//    [btnMore setTitle:@"更多评论＞＞" forState:UIControlStateNormal];
//    [btnMore.titleLabel setFont:[UIFont systemFontOfSize:15]];
//    [btnMore addTarget:self action:@selector(doMorePL) forControlEvents:UIControlEventTouchUpInside];
//    [btnMore setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    [viewBG addSubview:btnMore];
//    RELEASE(btnMore);
//    
//    [viewBG setFrame:CGRectMake(10.0f, viewBG.frame.origin.y, 300, CGRectGetMidY(textView.frame) + CGRectGetHeight(textView.frame) + 20)];
//    
//    UIImage *image2 = [UIImage imageNamed:@"031"];
//    UIButton *btnAction = [[UIButton alloc]initWithFrame:CGRectMake(10.0f, CGRectGetHeight(viewBG.frame) +30 + self.headHeight ,image2.size.width/2, image1.size.height/2)];
//    //        [btnAction setBackgroundColor:[UIColor yellowColor]];
//    [btnAction setImage:image1 forState:UIControlStateNormal];
//    [scrollview addSubview:btnAction];
//    
//    [btnAction addTarget:self action:@selector(doDian) forControlEvents:UIControlEventTouchUpInside];
//    RELEASE(btnAction);
//    [self addlabel_title:@"立即点餐" frame:btnAction.frame view:btnAction];
//    
//    
//    UIButton *btnPL = [[UIButton alloc]initWithFrame:CGRectMake(170.0f, + CGRectGetHeight(viewBG.frame) +30 + self.headHeight, image2.size.width/2, image2.size.height/2)];
//    [btnPL setBackgroundColor:[UIColor clearColor]];
//    [btnPL setImage:image2 forState:UIControlStateNormal];
//    [btnPL addTarget:self action:@selector(doComment) forControlEvents:UIControlEventTouchUpInside];
//    [scrollview addSubview:btnPL];
//    RELEASE(btnPL);
//    
//    //         [self addlabel_title:@"添加评论" frame:btnPL.frame view:btnPL];
//    
//    NSString *strName = [[NSString alloc]initWithFormat:@"tianji"];
//    UILabel *labelTitle1 = [[UILabel alloc]init];
//    [labelTitle1 setText:strName];
//    [labelTitle1 setTextColor:[UIColor redColor]];
//    [labelTitle1 setBackgroundColor:[UIColor yellowColor]];
//    [self.view addSubview:labelTitle1];
//    RELEASE(labelTitle1)
    
}


-(void)doComment{
//    
//    WOSAddCommentViewController *add = [[WOSAddCommentViewController alloc]init];
//    add.dictInfo = _dictInfo;
//    [self.drNavigationController pushViewController:add animated:YES];
//    RELEASE(add)
    
}

-(void)creatCell:(int)indexRow info:(NSString *)dict{
    
//    UIButton *view = [[UIButton alloc]initWithFrame:CGRectMake(0.0f, 70 + indexRow * 40 + 10 - self.headHeight, 320.0f, 40)];
//    [view setBackgroundColor:[UIColor clearColor]];
//    [view setTag:100 + indexRow];
//    [view addTarget:self action:@selector(doTapBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [viewBG addSubview:view];
//    RELEASE(view);
    
    
    
    //    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doTap)];
    //    [tap setNumberOfTapsRequired:1];
    //    [tap setNumberOfTouchesRequired:1];
    //    [view addGestureRecognizer:tap];
    //    RELEASE(tap);
    
//    
//    UIImage *image = nil;
//    
//    
//    switch (indexRow) {
//        case 0:
//            image = [UIImage imageNamed:@"22_02"];
//            break;
//        case 1:
//            image = [UIImage imageNamed:@"22_14"];
//            break;
//        case 2:
//            image = [UIImage imageNamed:@"22_16"];
//            break;
//        default:
//            break;
//    }
//    
//    UIImageView *imageVIewIcon = [[UIImageView alloc]initWithFrame:CGRectMake(5.0f, (40 - image.size.height/2)/2, image.size.width/2, image.size.height/2)];
//    [imageVIewIcon setUserInteractionEnabled:YES];
//    [imageVIewIcon setImage:image];
//    [imageVIewIcon setBackgroundColor:[UIColor whiteColor]];
//    [view addSubview:imageVIewIcon];
//    RELEASE(imageVIewIcon);
//    
//    UILabel *labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(60.0f, 5.0f, 200.0f, 30.0f)];
//    [labelTitle setText:dict];
//    [labelTitle setTextColor:[UIColor blackColor]];
//    [labelTitle setBackgroundColor:[UIColor clearColor]];
//    [view addSubview:labelTitle];
//    RELEASE(labelTitle);
//    
//    if (indexRow != 0) {
//        
//        UIImage *image = [UIImage imageNamed:@"01_04"];
//        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(280.0f, (self.headHeight - image.size.width/2)/2, image.size.width/2, image.size.height/2)];
//        [imageView setImage:image];
//        [view addSubview:imageView];
//        RELEASE(imageView);
//        
//    }else {
//        
//        UIButton *btnMap = [[UIButton alloc]initWithFrame:CGRectMake(60.0f, 5, CGRectGetWidth(labelTitle.frame), CGRectGetHeight(labelTitle.frame))];
//        [btnMap setBackgroundColor:[UIColor clearColor]];
//        [btnMap addTarget:self action:@selector(doTapMap) forControlEvents:UIControlEventTouchUpInside];
//        [view addSubview:btnMap];
//        RELEASE(btnMap);
//        
//    }
//    
//    
//    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, CGRectGetHeight(view.frame) -1, 320.0f, 0.5)];
//    //        [imageView1 setImage:[UIImage imageNamed:@""]];
//    [imageView1 setBackgroundColor:[UIColor grayColor]];
//    [view addSubview:imageView1];
//    RELEASE(imageView1);
}
//
//-(void)doTapBtn:(id)sender{
//    
//    UIButton *btn = (UIButton *)sender;
//    switch (btn.tag) {
//        case 100:
//        {
//            
//        }
//            break;
//        case 101:
//        {
//            
//            MagicUIPopAlertView *pop = [[MagicUIPopAlertView alloc] init];
//            //            [pop setDelegate:receiver];
//            [pop setMode:MagicPOPALERTVIEWNOINDICATOR];
//            [pop setText:@"拨打电话"];
//            [pop alertViewAutoHidden:.5f isRelease:YES];
//            
//        }
//            break;
//            
//        case 102:
//        {
//            
////            WOSActivityDetailViewController *activity = [[WOSActivityDetailViewController alloc]init];
////            
////            NSArray *arrayActivityList = [dictResult objectForKey:@"activityList"] ;
////            if (arrayActivityList.count > 0 ) {
////                NSDictionary *dict  = [arrayActivityList objectAtIndex:0];
////                activity.dictInfo = dict;
////                [self.drNavigationController pushViewController:activity animated:YES];
////                RELEASE(activity);
//            
//            }else{
//                
//                return;
//            }
//            
//        }
//            break;
//            
//            
//        default:
//            break;
//    }
//    
//}

//
//-(void)doTapMap{
//    
//    
//    WOSMapViewController *map = [[WOSMapViewController alloc]init];
//    map.iType = 3;
//    NSString *pgs = [dictResult objectForKey:@"gps"];
//    NSArray *arrayGPS = [pgs componentsSeparatedByString:@","];
//    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[arrayGPS objectAtIndex:1],@"latitude",[arrayGPS objectAtIndex:0],@"longitude",nil];
//    map.dictMap = dict;
//    [self.drNavigationController pushViewController:map animated:YES];
//    RELEASE(map);
//    
//    
//}
//
//-(void)creatPicBar:(NSArray *)foodList{
//    
//    UIView *viewBg = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 70 + 3 * 40 + 10 - self.headHeight, 300, self.headHeight)];
//    [viewBG addSubview:viewBg];
//    [viewBg release];
//    
//    UIImage *image = [UIImage imageNamed:@"22_24"];
//    
//    UIImageView *imageVIewIcon = [[UIImageView alloc]initWithFrame:CGRectMake(5.0f, (40 - image.size.height/2)/2, image.size.width/2, image.size.height/2)];
//    [imageVIewIcon setImage:image];
//    [imageVIewIcon setBackgroundColor:[UIColor clearColor]];
//    [viewBg addSubview:imageVIewIcon];
//    RELEASE(imageVIewIcon);
//    UIImage *image1 = [UIImage imageNamed:@"food3"];
//    for (int i = 0; i<foodList.count; i++) {
//        
//        NSDictionary *dict = [foodList objectAtIndex:i];
//        
//        UIImageView *imageVIewIcon = [[UIImageView alloc]initWithFrame:CGRectMake( image.size.width/2 + i* 60  + 30, 0, 50 , 40)];
//        [imageVIewIcon setBackgroundColor:[UIColor yellowColor]];
//        //        [imageVIewIcon setImage:image1];
//        NSURL *url = [NSURL URLWithString:[DYBShareinstaceDelegate addIPImage:[dict objectForKey:@"imgUrl"]]];
//        [imageVIewIcon setImageWithURL:url];
//        [imageVIewIcon setFrame:CGRectMake( image.size.width/2 + i* 60  + 30, 0, 50 , 40)];
//        //        [imageVIewIcon setBackgroundColor:[UIColor clearColor]];
//        [viewBg addSubview:imageVIewIcon];
//        RELEASE(imageVIewIcon);
//        
//        
//        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake( image.size.width/2 + i* 60  + 30, 0, 50 , 40)];
//        [btn addTarget:self action:@selector(doTouchFood:) forControlEvents:UIControlEventTouchUpInside];
//        [btn setBackgroundColor:[UIColor clearColor]];
//        [btn setTag:[[dict objectForKey:@"foodIndex"] integerValue]];
//        [viewBg addSubview:btn];
//        RELEASE(btn);
//        
//    }
//    
//    
//    
//}
//
//-(void)doTouchFood:(id)sender{
//    
//    UIButton *btn = (UIButton *)sender;
//    
//    WOSFoodDetailViewController *foodDetail = [[WOSFoodDetailViewController alloc]init];
//    [foodDetail setDictInfo:[NSString stringWithFormat:@"%d",btn.tag]];
//    [self.drNavigationController pushViewController:foodDetail animated:YES];
//    RELEASE(foodDetail);
//    
//}


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
//
//-(void)doDian{
//    
//    WOSALLOrderViewController *order = [[WOSALLOrderViewController alloc]init];
//    order.dictInfo = _dictInfo;
//    [self.drNavigationController pushViewController:order  animated:YES];
//    RELEASE(order);
//    
//}
//
//-(void)doMorePL{
//    
//    WOSMoreCommentViewController *more = [[WOSMoreCommentViewController alloc]init];
//    more.dictInfo = _dictInfo;
//    [self.drNavigationController pushViewController:more animated:YES];
//    RELEASE(more);
//    
//}

-(void)handleViewSignal_WOShopDetailViewController:(MagicViewSignal *)signal{
    
//    if ([signal is:[WOShopDetailViewController BTNONE]]) {
//        DLogInfo(@"DDDD");
//    }else if ([signal is:[WOShopDetailViewController BTNTWO]]){
//        
//        DLogInfo( @"fff");
//    }
    
    
}
#pragma mark - back button signal
- (void)handleViewSignal_DYBBaseViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBBaseViewController BACKBUTTON]])
    {
        [self.drNavigationController popViewControllerAnimated:YES];
        
    }else if ([signal is:[DYBBaseViewController NEXTSTEPBUTTON]]){
        
        
    }
}



#pragma mark- 只接受HTTP信号
- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj
{
//    if ([request succeed])
//    {
//        //        JsonResponse *response = (JsonResponse *)receiveObj;
//        if (request.tag == 2) {
//            
//            
//            NSDictionary *dict = [request.responseString JSONValue];
//            
//            if (dict) {
//                BOOL result = [[dict objectForKey:@"result"] boolValue];
//                if (!result) {
//                    
//                    _dictInfo = dict;
//                    [DYBShareinstaceDelegate popViewText:@"收藏成功！" target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
//                    
//                }else{
//                    NSString *strMSG = [dict objectForKey:@"message"];
//                    
//                    [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
//                    
//                    
//                }
//            }
//        }else if(request.tag == 3){
//            
//            NSDictionary *dict = [request.responseString JSONValue];
//            
//            if (dict) {
//                
//                BOOL result = [[dict objectForKey:@"result"] boolValue];
//                if (!result) {
//                    
//                    dictResult = [[NSDictionary alloc]initWithDictionary:dict];
//                    
//                    [self creatView:dict];
//                    //                    UIButton *btn = (UIButton *)[UIButton buttonWithType:UIButtonTypeCustom];
//                    //                    [btn setTag:10];
//                    //                    [self doChange:btn];
//                }
//                else{
//                    NSString *strMSG = [dict objectForKey:@"message"];
//                    
//                    [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
//                    
//                    
//                }
//            }
//            
//        } else{
//            NSDictionary *dict = [request.responseString JSONValue];
//            NSString *strMSG = [dict objectForKey:@"message"];
//            
//            [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
//            
//            
//        }
//    }
}


- (void)dealloc
{
    //    RELEASE(_dictInfo);
    [super dealloc];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
