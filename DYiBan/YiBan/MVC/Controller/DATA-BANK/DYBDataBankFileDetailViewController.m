//
//  DYBDataBankFileDetailViewController.m
//  DYiBan
//
//  Created by tom zeng on 13-9-8.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBDataBankFileDetailViewController.h"
#import "scrollerData.h"
#import "DYBDataBankChildrenListViewController.h"
#import "DYBScroller.h"
#import "DYBSelectContactViewController.h"
#import "DYBDataBankEclassListsViewController.h"
#import "Magic_UIScrollListView.h"
#import "DYBGifView.h"
#import "NSObject+MagicRequestResponder.h"
#import "NSObject+MagicDatabase.h"
#import "DYBDataBankShareEnterView.h"
#import "DYBDataBankSelectBtn.h"
#import "DYBDataBankDownloadManageViewController.h"
#import "Magic_Sandbox.h"
#import "NSString+Count.h"
#import "DYBLoadingView.h"
#import "PDColoredProgressView.h"
#import "Magic_Device.h"
#import "UserSettingMode.h"
#import "DYBGuideView.h"
#import "DYBSignViewController.h"
#import "UILabel+ReSize.h"
#import "NSString+Count.h"
#include<AssetsLibrary/AssetsLibrary.h> 
#import "DYBDataBankDetailRightView.h"
#import "DYBDataBankListController.h"

#define BARVIEW           101
#define SCROLLEVIEW       102
#define INDICATORTAG      1000
#define OPEARTIONTAG      99
#define SHARERIGHTVIEW    88
#define COMMENTRIGHTVIEW  78

@interface DYBDataBankFileDetailViewController (){

    BOOL bChangeOk;
    
    UILabel *public;
    UILabel *labelPro;
    NSString *strOldURL;
    UIImageView *imageViewMid;

    DYBGifView *dataView;
    DYBLoadingView *popView;
    PDColoredProgressView *_progressView;
    DYBDataBankDetailRightView *detailRightView;
    
}

@end

@implementation DYBDataBankFileDetailViewController

@synthesize  strFileURL = _strFileURL,dictFileInfo = _dictFileInfo,cellOperater = _cellOperater;
@synthesize  targetObj = _targetObj,index = _index,iPublicType = _iPublicType; //1.我的共享 2.共享给我，3公共资源
@synthesize  arraySource = _arraySource,cellOperaterSearch = _cellOperaterSearch;


DEF_SIGNAL(OPEATTIONMORE)
DEF_SIGNAL(NEWNAME)
DEF_SIGNAL(DELFILE)
DEF_SIGNAL(CHANGEINFO)
DEF_SIGNAL(CANCELSHARE)

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


-(void)checkHaveSource{

    NSString *encodeURL = [_dictFileInfo objectForKey:@"file_urlencode"];
    NSString *strSourceType = [[_dictFileInfo objectForKey:@"type"] lowercaseString];
    self.DB.FROM(KDATABANKDOWNLIST).WHERE(@"url", encodeURL).GET();
    DLogInfo(@"self.DB.resultArray === %@", self.DB.resultArray);
    if ([self.DB.resultArray count] > 0)
    {
        
        NSDictionary * userDict = [self.DB.resultArray objectAtIndex:0];
        if ([[userDict objectForKey:@"url"] isEqualToString:[_dictFileInfo objectForKey:@"file_urlencode"]]) {
            
            DLogInfo(@"已经有");
           
            [self showSource:strSourceType];
           
        }
    }else if ([[strSourceType lowercaseString]isEqualToString:@"png"] ||[[strSourceType lowercaseString]isEqualToString:@"jpg"] ||[[strSourceType lowercaseString]isEqualToString:@"bmp"]){
        
        
        if ([MagicDevice hasInternetConnection] == NO) {
            
            [self checkNET];
            return;
        }

        [self addIndicatorView];
        
        
        if (SHARED.currentUserSetting.wifiForPush &&![[MagicDevice networkType] isEqualToString:@"wifi"] && [[MagicDevice networkType] isEqualToString:@"2g"]){
            
            
            [DYBShareinstaceDelegate addConfirmViewTitle:@"提示" MSG:@"您当前为2G/3G网络，需要消耗流量，是否继续操作？" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_GOONDOWNLOAD dic:nil ];
            
            return;
        }
        [self showPic];
    }
    else{
    
        if ([MagicDevice hasInternetConnection] == NO) {
            
            [self checkNET];
            return;
        }
        
        if (SHARED.currentUserSetting.wifiForPush &&![[MagicDevice networkType] isEqualToString:@"wifi"] && [[MagicDevice networkType] isEqualToString:@"2g"]){
        
        
            [DYBShareinstaceDelegate addConfirmViewTitle:@"提示" MSG:@"您当前为2G/3G网络，需要消耗流量，是否继续操作？" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_GOONDOWNLOAD dic:nil ];
            
            return;

        }
        
        [self.rightButton setUserInteractionEnabled:NO];
        
        [self addIndicatorView];
       
        self.HTTP_GET_DOWN(encodeURL);
                
        DLogInfo(@"meiyou");
        
    }
}

-(void)back{

    [self.drNavigationController popViewControllerAnimated:YES];

}
- (NSString *)downFileName:(NSString *)url
{
    NSArray *typeArr = [url componentsSeparatedByString:@"."];
    NSString *type = [typeArr lastObject];
    NSString *downFileName = [NSString stringWithFormat:@"%@.%@", [MagicCommentMethod md5:url], type];
    return downFileName;
}

-(void)showSource:(NSString *)strSourceType{

    if ([strSourceType isEqualToString:@"gif"]) {
        
        [self showGifView];
        
    }else if ([[strSourceType lowercaseString]isEqualToString:@"png"] ||[[strSourceType lowercaseString]isEqualToString:@"jpg"] ||[[strSourceType lowercaseString]isEqualToString:@"bmp"]){
        
        [self showPic];
        
    }else if ([strSourceType isEqualToString:@"html"] || [strSourceType isEqualToString:@"doc"]|| [strSourceType isEqualToString:@"docx"]|| [strSourceType isEqualToString:@"xls"]|| [strSourceType isEqualToString:@"xlsx"]|| [strSourceType isEqualToString:@"pdf"]|| [strSourceType isEqualToString:@"ppt"]|| [strSourceType isEqualToString:@"pptx"]|| [strSourceType isEqualToString:@"txt"]||[strSourceType isEqualToString:@"htm"]||[strSourceType isEqualToString:@"mp3"] || [strSourceType isEqualToString:@"mp4"]||[strSourceType isEqualToString:@"3gp"]||[strSourceType isEqualToString:@"avi"]||[strSourceType isEqualToString:@"avc"]||[strSourceType isEqualToString:@"arm"]){
        
        [self showOfficeOrHtml];
        
    }
}

-(void)addIndicatorView{

    UIView *view = [[UIView alloc]initWithFrame:self.view.frame];
    [view setTag:INDICATORTAG];
    [view setBackgroundColor:[UIColor blackColor]];
    [self.view insertSubview:view atIndex:0];
    [view release];
    
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [indicatorView startAnimating];
    [indicatorView setCenter:CGPointMake(320/2, 200)];
    [view addSubview:indicatorView];
    RELEASE(indicatorView);

}

-(void)checkNET{

        MagicUIPopAlertView *pop = [[MagicUIPopAlertView alloc] init];
        [pop setDelegate:self];
        [pop setMode:MagicPOPALERTVIEWNOINDICATOR];
        [pop setText:@"检测不到网络连接！"];
        [pop alertViewAutoHidden:.5f isRelease:YES];
        
        [self performSelector:@selector(back) withObject:nil afterDelay:0.5f];
        return;

}
- (void)downloadProgress:(CGFloat)newProgress request:(MagicRequest *)request
{
    DLogInfo(@"request -- %@ newProgress %f",request.downloadName,newProgress);
        
    if (newProgress == 1.0f) {
        
        NSString *encodeURL = [_dictFileInfo objectForKey:@"file_urlencode"];
        NSString *downFileName = [self downFileName:encodeURL];
        
        self.DB.FROM(KDATABANKDOWNLIST)
        .SET(@"url",encodeURL )
        .SET(@"filename", downFileName)
        .SET(@"type", @"3")
        .SET(@"show", @"1")
        .SET(@"deCodeUerl",[_dictFileInfo objectForKey:@"file_url"])
        .SET(@"userid", SHARED.userId)
        .SET(@"strType",[_dictFileInfo objectForKey:@"type"])
        .SET(@"filelength", @"0")
        .SET(@"stopDowning", @"0")
        .SET(@"downprogress", @"0")
        .INSERT();
        
        
        NSString *strSourceType = [[_dictFileInfo objectForKey:@"type"] lowercaseString];
        if ([strSourceType isEqualToString:@"gif"]) {
            
            [self performSelector:@selector(showGifView) withObject:nil afterDelay:2];
            DLogInfo(@"finish");
        }else if ([strSourceType isEqualToString:@"html"]
                  || [strSourceType isEqualToString:@"doc"]
                  || [strSourceType isEqualToString:@"docx"]
                  || [strSourceType isEqualToString:@"xls"]
                  || [strSourceType isEqualToString:@"xlsx"]
                  || [strSourceType isEqualToString:@"pdf"]
                  || [strSourceType isEqualToString:@"ppt"]
                  || [strSourceType isEqualToString:@"pptx"]
                  || [strSourceType isEqualToString:@"txt"]
                  || [strSourceType isEqualToString:@"mp3"]
                  || [strSourceType isEqualToString:@"mp4"]
                  || [strSourceType isEqualToString:@"wmv"]
                  || [strSourceType isEqualToString:@"htm"]){
            
            
             [self performSelector:@selector(showOfficeOrHtml) withObject:nil afterDelay:2];
            
        }else if ([strSourceType isEqualToString:@"png"]
                  ||[strSourceType isEqualToString:@"bmp"]
                  ||[strSourceType isEqualToString:@"jpg"]){
            
            [self showPic];
        
        }
    }
}



-(void)handleViewSignal:(MagicViewSignal *)signal{
    
    if ([signal is:[MagicViewController CREATE_VIEWS]]) {
        
        bChangeOk = NO;
        
        [self.view setBackgroundColor:[UIColor blackColor]];

        strOldURL = [_dictFileInfo objectForKey:@"file_urlencode"];
        
        detailRightView = [[DYBDataBankDetailRightView alloc]init];
        detailRightView.dictFileInfo = _dictFileInfo;
        
        [self checkHaveSource];

        [self creatBottonView];
        
       }else if ([signal is:[MagicViewController LAYOUT_VIEWS]]){
        
           [self setButtonImage:self.leftButton setImage:@"btn_back_def" setHighString:@"btn_back_hlt"];

           [self.headview setTitle:[_dictFileInfo objectForKey:@"title"]];
           
           if (![_targetObj isKindOfClass:[DYBDataBankDownloadManageViewController class]]) {
               
                [self setButtonImage:self.rightButton setImage:@"btn_more_def"];
               
           }else{
           
               [self.rightButton setHidden:YES];
           }
       


        if ([_targetObj isKindOfClass:[DYBDataBankChildrenListViewController class]]) { //移动和转存 隐藏
            
            DYBDataBankChildrenListViewController* children = (DYBDataBankChildrenListViewController *)_targetObj;
            
            if(children.bChangeFolder || children.bChangeSave){
                [self.rightButton setHidden:YES];
            }
        }

       }else if ([signal is:[MagicViewController WILL_DISAPPEAR]]){
       
//           NSString *url = [_dictFileInfo objectForKey:@"file_urlencode"]; //暂停下载
//           [self cancelRequestWithUrl:url];
           
       }else if ([signal is:[MagicViewController WILL_APPEAR]])
       {
           if (![[NSUserDefaults standardUserDefaults] stringForKey:@"DYBDataBankFileDetailViewController"] || [[[NSUserDefaults standardUserDefaults] stringForKey:@"DYBDataBankFileDetailViewController"] intValue]==0) {
               
               [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"DYBDataBankFileDetailViewController"];
               
               {
                   DYBGuideView *guideV=[[DYBGuideView alloc]initWithFrame:self.view.frame];
                   guideV.AddImgByName(@"databasehelp6", nil);
                   [self.drNavigationController.view addSubview:guideV];
                   RELEASE(guideV);
               }
           }
       }
}

-(void)touchShowBar{

    UIScrollView *view = (UIScrollView *)[self.view viewWithTag:BARVIEW];
    DLogInfo(@"barview %f",view.frame.origin.y);
    DLogInfo(@"view %f",self.view.bounds.size.height - 200);
    DLogInfo(@"view %f",self.view.bounds.size.height - 20 - 32);
    if (view) {
        
        if (view.frame.origin.y == self.view.bounds.size.height - 180) {
            
            [UIView animateWithDuration:0.3 animations:^{
            
            
                [view setFrame:CGRectMake(0.0f, self.view.bounds.size.height - 20 - 32 + 20, 320.0f, 250)];
            
//                [view setContentOffset:CGPointMake(0.0f, 0.0f)];
            
            } completion:^(BOOL finish){
            
            }];
            
            UIView *viewRight = [self.view viewWithTag:COMMENTRIGHTVIEW];
            
            if (viewRight) {
                
                
                [UIView animateWithDuration:0.4 animations:^{
                    
                    [viewRight setFrame:CGRectMake(0.0f, -190 + 44, 320.0F, viewRight.frame.size.height)];
                    
                    
                }completion:^(BOOL finish){
                
                
                    [viewRight setHidden:YES];
                }];
            }
            
            [imageViewMid setImage:[UIImage imageNamed:@"btn_unfold"]];
            

        }else if (view.frame.origin.y == self.view.bounds.size.height - 20 - 32 + 20){
            
            [UIView animateWithDuration:0.3 animations:^{
                
                
                [view setFrame:CGRectMake(0.0f, self.view.bounds.size.height - 180, 320.0f, 180)];
                
                
            }];
            
            UIView *viewRight = [self.view viewWithTag:COMMENTRIGHTVIEW];
            
            if (viewRight) {
                
                [UIView animateWithDuration:0.4 animations:^{
                    
                    [viewRight setFrame:CGRectMake(0.0f, -190 + 44, 320.0F, viewRight.frame.size.height)];
                    
                }completion:^(BOOL finish){
                    
                    [viewRight setHidden:YES];
                }];
            }
            
            [imageViewMid setImage:[UIImage imageNamed:@"btn_fold"]];
        }
    }
}

-(void)showGifView{

    NSString *encodeURL = [_dictFileInfo objectForKey:@"file_urlencode"];
    NSString *downFileName = [MagicCommentMethod md5:encodeURL];
    NSString *downloadPath = [NSString stringWithFormat:@"%@%@", [MagicCommentMethod downloadPath],    [downFileName stringByAppendingString:@".gif"]];
    NSData *localData = [NSData dataWithContentsOfFile:downloadPath];
    UIImage *image = [[UIImage alloc]initWithData:localData];
    
    if (localData.length > 0) {
    
        dataView = [[DYBGifView alloc] initWithFrame:CGRectMake(0.0f, 44, image.size.width, image.size.height) data:localData];
        [dataView setBackgroundColor:[UIColor whiteColor]];
        [dataView setCenter: CGPointMake(160.0f, self.view.frame.size.height/2 - 44)];
        [self.view insertSubview:dataView atIndex:0];
        
        
    }else{
    
         [DYBShareinstaceDelegate popViewText:@"读取数据失败！" target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
    }
    
    
    [image release];
    
    UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[self.view viewWithTag:INDICATORTAG];
    
    if (indicator) {
        [indicator removeFromSuperview];
    }
}


-(void)showPic{

    [self.rightButton setUserInteractionEnabled:YES];
    
    NSMutableArray *_imgArray = [[NSMutableArray alloc]init];
    [_imgArray addObject:[_dictFileInfo objectForKey:@"file_url"]];
    NSMutableArray *array = [[NSMutableArray alloc]init];;
    for (int i = 0; i < [_imgArray count]; i++) {
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[_imgArray objectAtIndex:i], kSHOWIMGKEY, @"s_left_def", kDEFAULTIMGKEY ,nil];
        [array addObject:dict];
        RELEASE(dict);
    }
    
    RELEASE(_imgArray);
     
    MagicUIScrollListView *scroller = [[MagicUIScrollListView alloc] initWithFrame:CGRectMake(0, self.headHeight,SCREEN_WIDTH, SCREEN_HEIGHT-self.headHeight-20)];
    [self.view addSubview:scroller];
    
    [scroller setImgArr:array];
    [scroller setSelectIndex:0];
    [scroller setBackgroundColor:[UIColor blackColor]];
    RELEASE(scroller);
    RELEASE(array);

    UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[self.view viewWithTag:INDICATORTAG];
   
    if (indicator) {
//        [indicator stopAnimating];
        [indicator removeFromSuperview];
    }
    
}


-(void)showOfficeOrHtml{
    
    NSString *encodeURL = [_dictFileInfo objectForKey:@"file_urlencode"];
    NSString *downFileName = [MagicCommentMethod md5:encodeURL];
    downFileName = [downFileName stringByAppendingString:[NSString stringWithFormat:@".%@",[_dictFileInfo objectForKey:@"type"]]];
    NSString *downloadPath = [NSString stringWithFormat:@"%@%@", [MagicCommentMethod downloadPath], downFileName];

    DLogInfo(@"down -- %@",downFileName);
    NSURL *url = [NSURL fileURLWithPath:downloadPath];

    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height - 44 )];
    [webView setBackgroundColor:[UIColor whiteColor]];
    [webView  setScalesPageToFit:YES];
    webView.delegate = self;
        
    if([[downloadPath lowercaseString] hasSuffix:@".txt"]){//处理txt文件,否则txt文件会显示乱码
        NSString *body = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        if(!body){//gb2312编码后再尝试打开
            NSStringEncoding enc =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            body = [NSString stringWithContentsOfURL:url encoding:enc error:nil];
        }
        if(body){
//            webView.scalesPageToFit = NO;
            NSString *resourcePath = [ [NSBundle mainBundle] resourcePath];

            NSString *modelPath = [resourcePath stringByAppendingPathComponent:@"TxtModel.html"];
            
            //读入html模板
            NSMutableString *htmlString = [[NSMutableString alloc] initWithContentsOfFile:modelPath encoding:NSUTF8StringEncoding error:nil];
            //插入内容
            [htmlString replaceOccurrencesOfString:@"<htmlContent>" withString:body options:nil range:NSMakeRange(0, [htmlString length])];
            
            [webView loadHTMLString:htmlString baseURL:nil];
        }
        else{
            NSURLRequest *request =[NSURLRequest requestWithURL:url];
            [webView loadRequest:request];
        }
    }
    else{
        NSURLRequest *request =[NSURLRequest requestWithURL:url];
        [webView loadRequest:request];
    }

        [self.view insertSubview:webView atIndex:0];
    RELEASE(webView);

   
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{

    
    [self.rightButton setUserInteractionEnabled:YES];
    UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[self.view viewWithTag:INDICATORTAG];
    
    if (indicator) {
        [indicator removeFromSuperview];
    }
}


-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[self.view viewWithTag:INDICATORTAG];
    
    if (indicator) {
        [indicator removeFromSuperview];
    }
}

-(void)creatShareControllerRightDownView{

    UIView *viewRight = [self.view viewWithTag:COMMENTRIGHTVIEW];

        if (viewRight) {
            
            
            if (viewRight.hidden) {
                
                [viewRight setHidden:NO];
                [UIView animateWithDuration:0.4 animations:^{
                    
                    [viewRight setFrame:CGRectMake(0.0f, 44.0f, 320.0F, viewRight.frame.size.height)];
                }];
                
            }else{
                
                [UIView animateWithDuration:0.4 animations:^{
                    
                    [viewRight setFrame:CGRectMake(0.0f, -190 + 44, 320.0F, viewRight.frame.size.height)];
                    
                }completion:^(BOOL finished) {
                    
                    [viewRight setHidden:YES];
                }];
            }        
            
            return;
        }

    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0.0f, -190 + 44, 320.0F, 115.0f)];
    [view setTag:COMMENTRIGHTVIEW];
    [view setBackgroundColor:[UIColor whiteColor]];
    [view setAlpha:0.9];
    [self.view insertSubview:view atIndex:1];
    RELEASE(view);
    
    
   
    detailRightView.viewRight = [self.view viewWithTag:COMMENTRIGHTVIEW];
    switch (_iPublicType) {
        case 1:
            [detailRightView creatBTNMyShare:view];
            break;
        case 2:
            [detailRightView creatBTNShareSomethingForMe:view];
            break;
        case 3:{
            [detailRightView creatBTNPublicSomething:view];
            
            
        }
            break;
            
        default:
            break;
    }
        
    [UIView animateWithDuration:0.4 animations:^{
        
        [view setFrame:CGRectMake(0.0f, 44.0f, 320.0F, view.frame.size.height)];
        
    }];
  
}

-(void)creatRightDownView{

    UIView *viewRight = [self.view viewWithTag:COMMENTRIGHTVIEW];
    
    if (viewRight) {
        
        
        if (viewRight.hidden) {
            
            [viewRight setHidden:NO];
            [UIView animateWithDuration:0.4 animations:^{
                
                [viewRight setFrame:CGRectMake(0.0f, 44.0f, 320.0F, viewRight.frame.size.height)];                
            }];
            
        }else{
                    
            [UIView animateWithDuration:0.4 animations:^{
                
                [viewRight setFrame:CGRectMake(0.0f, -190 + 44, 320.0F, viewRight.frame.size.height)];
                
            }completion:^(BOOL finished) {
                
                [viewRight setHidden:YES];
            }];
        }        
        
        return;
    }
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0.0f, -190 + 44, 320.0F, 190)];
    [view setTag:COMMENTRIGHTVIEW];
    [view setBackgroundColor:[UIColor whiteColor]];
    [view setAlpha:0.9];
    [self.view insertSubview:view atIndex:1];
    RELEASE(view);
    
    [UIView animateWithDuration:0.4 animations:^{
    
        [view setFrame:CGRectMake(0.0f, 44.0f, 320.0F, view.frame.size.height)];
    
    }];
    
    
    [detailRightView creatBTNCommentView:view];
    
    
}


-(void)creatBottonView{

    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0.0f, self.view.bounds.size.height -20 - 32 , 320.0f, 180.0)];
    [view2 setBackgroundColor:[UIColor whiteColor]];
    [view2 setAlpha:0.9];
    [view2 setTag:BARVIEW];
    [self.view addSubview:view2];
    RELEASE(view2);

    imageViewMid = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 32.0f)];
    [imageViewMid setImage:[UIImage imageNamed:@"btn_unfold"]];
    [imageViewMid setUserInteractionEnabled:YES];
    [view2 addSubview:imageViewMid];
    RELEASE(imageViewMid);
    [imageViewMid setBackgroundColor:[UIColor clearColor]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchShowBar)];
    [imageViewMid addGestureRecognizer:tap];
    RELEASE( tap);
    
    
    UIScrollView *view1 = [[UIScrollView alloc]initWithFrame:CGRectMake(0.0f, 32 , 320.0f, 180.0 - 32)];
    [view1 setBackgroundColor:[UIColor clearColor]];
    [view1 setAlpha:0.9];
    [view1 setTag:BARVIEW];
    [view2 addSubview:view1];
    RELEASE(view1);
    
    NSString *strTitle = [NSString stringWithFormat:@"文件名：%@",[_dictFileInfo objectForKey:@"title"]];
    CGSize strSize = [strTitle sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(300, MAXFLOAT)];
    
    if (strSize.height < 40) {
        strSize.height = 35;
    }
    
    MagicUILabel *labelName = [[MagicUILabel alloc]initWithFrame:CGRectMake(10.0f, 0.0, 300.0f, strSize.height)];
    labelName.lineBreakMode = UILineBreakModeCharacterWrap;
    [labelName setText:strTitle];
    [labelName setFont:[DYBShareinstaceDelegate DYBFoutStyle:15]];
    [labelName setTextAlignment:NSTextAlignmentLeft];
    labelName.numberOfLines = 200;
    [labelName setTextColor:[MagicCommentMethod colorWithHex:@"0x333333"]];
    [labelName setBackgroundColor:[UIColor clearColor]];
    [view1 addSubview:labelName];
    RELEASE(labelName);
    
    UILabel *newTime = [[UILabel alloc]initWithFrame:CGRectMake(10.0f, labelName.frame.origin.y + labelName.frame.size.height + 3  , 300.0f, 30.0)];
    
    if (_iPublicType == 1 && [_targetObj isKindOfClass:[DYBDataBankShareViewController class]]) {
        [newTime setText:[NSString stringWithFormat:@"共享时间：%@",[_dictFileInfo objectForKey:@"share_time"]]];
    }else{
        [newTime setText:[NSString stringWithFormat:@"创建时间：%@",[_dictFileInfo objectForKey:@"create_time"]]];
    }
    [newTime setFont:[DYBShareinstaceDelegate DYBFoutStyle:15]];
    [newTime setTextColor:[MagicCommentMethod colorWithHex:@"0x333333"]];
    [view1 addSubview:newTime];
     [newTime setBackgroundColor:[UIColor clearColor]];
    RELEASE(newTime);
    
    UILabel *shareTime = [[UILabel alloc]initWithFrame:CGRectMake(10.0f, newTime.frame.origin.y + newTime.frame.size.height , 300.0f, 30.0)];
    
    NSString *strKey = [_dictFileInfo objectForKey:@"tag_info"];
    DLogInfo(@"dict --- %@",_dictFileInfo);
    if (strKey.length == 0) {
        strKey = @"无";
    }
    
    [shareTime setText:[NSString stringWithFormat:@"标签：%@",strKey]];
    [shareTime setFont:[DYBShareinstaceDelegate DYBFoutStyle:15]];
    [shareTime setTextColor:[MagicCommentMethod colorWithHex:@"0x333333"]];
    [view1 addSubview:shareTime];
    [shareTime setBackgroundColor:[UIColor clearColor]];
    RELEASE(shareTime);

    
    public = [[UILabel alloc]initWithFrame:CGRectMake(10.0f, shareTime.frame.origin.y + shareTime.frame.size.height , 300.0f, 30.0)];
    switch (_iPublicType) {
        case 1:
        {
            [self changeShareType];
        }
            break;
        case 2:
        case 3:
        {
        
            [public setText:[NSString stringWithFormat:@"来自：%@",[_dictFileInfo objectForKey:@"author"]]];
        }
            break; 
        default:
            break;
    }
    [public setFont:[DYBShareinstaceDelegate DYBFoutStyle:15]];
    [public setTextColor:[MagicCommentMethod colorWithHex:@"0x333333"]];
    [view1 addSubview:public];
    [public setBackgroundColor:[UIColor clearColor]];
    RELEASE(public);
    
    view1.contentSize = CGSizeMake(300, public.frame.size.height + public.frame.origin.y);
   
    
}
-(void)changeShareType{

    NSString *perm = [DYBShareinstaceDelegate getPermType:[[_dictFileInfo objectForKey:@"perm"] integerValue]];

    [public setText:[NSString stringWithFormat:@"共享：%@",perm]];

}

-(void)handleViewSignal_DYBDataBankFileDetailViewController:(MagicViewSignal *)signal{
    
    if ([signal is:[DYBDataBankFileDetailViewController OPEATTIONMORE]]) {
   
        UIButton *btn = (UIButton *)[signal object];
        switch (btn.tag) {
                
            case BTNTAG_SHARE:
                
            {
                DYBDataBankShareEnterView * shareView = [[DYBDataBankShareEnterView alloc]initWithFrame:CGRectMake(0.0f, 0.0f , 320.0f, self.view.frame.size.height) target:self info:_dictFileInfo arrayFolderList:nil index:1];
                shareView.cellDetail = _cellOperater;
                [self.view addSubview:shareView];
                RELEASE(shareView);
                
            }
                break;
            case BTNTAG_CHANGE:
            {
                DYBDataBankChildrenListViewController *childr = [[DYBDataBankChildrenListViewController alloc]init];
                childr.folderID = @"";
                childr.dictInfo = _dictFileInfo;
                childr.strFromDir = [NSString stringWithFormat:@"%@",[_dictFileInfo objectForKey:@"id"]];
                childr.bChangeFolder = YES;
                childr.popController = self;
            
                [self.drNavigationController pushViewController:childr animated:YES];
                RELEASE(childr);
            }
                
                break;
            case BTNTAG_RENAME:
            {
                NSString *title = [_dictFileInfo objectForKey:@"title"];
                
                NSString *type = [_dictFileInfo objectForKey:@"type"];
                strOldURL = [_dictFileInfo objectForKey:@"file_urlencode"];
                
                NSString *name = nil;
                if (type.length > 0 && type) {
                    name = [[title componentsSeparatedByString:[NSString stringWithFormat:@".%@",type]] objectAtIndex:0];
                }else{
                    
                    name = title;
                }
                

                [DYBShareinstaceDelegate addConfirmViewTitle:@"" MSG:name targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_RENAME rowNum:[NSString stringWithFormat:@"%d",1-1]];
            }
                break;
            case BTNTAG_SINGLE:{ //报存本地
            
                [self savePic];
            
            }
                break;
            case BTNTAG_DEL:
            {
                
                [DYBShareinstaceDelegate addConfirmViewTitle:@"" MSG:@"真的要删除吗？" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_DEL rowNum:[NSString stringWithFormat:@"%d",1]];
            }
                break;
            case BTNTAG_DOWNLOAD:
            {
                
                //删除记录
                
                DYBDataBankDownloadManageViewController *downLoad = [DYBDataBankDownloadManageViewController shareDownLoadInstance];
                [downLoad insertCell:_dictFileInfo ];
            }
                break;
            case BTNTAG_GOONDOWNLOAD:{
                        
                [self.rightButton setUserInteractionEnabled:NO];
                NSString *encodeURL = [_dictFileInfo objectForKey:@"file_urlencode"];
                self.HTTP_GET_DOWN(encodeURL);
            
            }
                break;
            case BTNTAG_CANCELSHARE:{
                
                
                 [DYBShareinstaceDelegate addConfirmViewTitle:@"" MSG:@"真的要取消共享吗？" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_CANCELSHARE rowNum:[NSString stringWithFormat:@"%d",0]];
                
            }
                
                break;
            case BTNTAG_BAD:
            {
                
                [btn setEnabled:NO];                
                [self creatGoodANDBadIMG:@"cai"];
                
                MagicRequest *request = [DYBHttpMethod document_estimate_id:[_dictFileInfo objectForKey:@"oid"] type:@"2" isAlert:NO receive:self];
                [request setTag:BTNTAG_BAD];
            }
                break;
            case BTNTAG_GOOD:
            {
                
                [self creatGoodANDBadIMG:@"ding"];
                
                [btn setEnabled:NO];                
                MagicRequest *request = [DYBHttpMethod document_estimate_id:[_dictFileInfo objectForKey:@"oid"] type:@"1" isAlert:NO receive:self];
                [request setTag:BTNTAG_GOOD];
            }
                break;
            case BTNTAG_REPORT:
            {
                DYBSignViewController *vc = [[DYBSignViewController alloc]init];
                vc.bDataBank = YES;
                vc.dictInfo = _dictFileInfo;
                [self.drNavigationController pushViewController:vc animated:YES];
                RELEASE(vc);
                
            }
                break;
            case BTNTAG_EDITSHARE:
                
            {
                DYBDataBankShareEnterView * shareView = [[DYBDataBankShareEnterView alloc]initWithFrame:CGRectMake(0.0f, 0.0f , 320.0f, self.view.frame.size.height) target:self info:_dictFileInfo arrayFolderList:nil index:1];
                shareView.cellDetail = _cellOperater;
                shareView.cellDetailSearch = _cellOperaterSearch;
                [self.view addSubview:shareView];
                RELEASE(shareView);
                
            }
                break;
            case BTNTAG_CHANGESAVE:
            {
                
                DYBDataBankChildrenListViewController *childr = [[DYBDataBankChildrenListViewController alloc]init];
                
                childr.dictInfo = _dictFileInfo;
                childr.folderID = @"";
                
                if (_iPublicType == SomeoneShowToME) {
                    
                    childr.strChangeType = @"SHARE";
                }else{
                    
                    childr.strChangeType = @"O";
                }
                childr.popController = self;
                childr.bChangeSave = YES;
                childr.strFromDir = [NSString stringWithFormat:@"%@",[_dictFileInfo objectForKey:@"file_path"]];
                childr.bChangeFolder = YES;
                
                [self.drNavigationController pushViewController:childr animated:YES];
                RELEASE(childr);
            }

            default:
                break;
        }

        UIView *viewRight = [self.view viewWithTag:COMMENTRIGHTVIEW];
        
        if (viewRight) {
        
            [UIView animateWithDuration:0.4 animations:^{
                
                [viewRight setFrame:CGRectMake(0.0f, -190 + 44, 320.0F, viewRight.frame.size.height)];
                
            }completion:^(BOOL finished) {
                
                [viewRight setHidden:YES];
            }];
        }
    }else if ([signal is:[DYBDataBankFileDetailViewController DELFILE]]){
        
        NSDictionary  *dict = (NSDictionary *)[signal object];
        NSString *strMsg = [dict objectForKey:@"strEncode"];
        
        if ([[dict objectForKey:@"bRoot"] boolValue]) {
            bChangeOk = YES;
        }
        
        [self sendViewSignal:[DYBDataBankFileDetailViewController DELFILE]
                  withObject:strMsg from:self target:_targetObj] ;

    }
}

-(void)savePic{


    if ([[[_dictFileInfo objectForKey:@"type"] lowercaseString] isEqualToString:@"png"] ||[[[_dictFileInfo objectForKey:@"type"] lowercaseString] isEqualToString:@"jpg"]||[[[_dictFileInfo objectForKey:@"type"] lowercaseString] isEqualToString:@"bmp"]
        ||[[[_dictFileInfo objectForKey:@"type"] lowercaseString] isEqualToString:@"gif"]) {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString * diskCachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"ImageCache"];
        NSString *encoderUrl= [[_dictFileInfo objectForKey:@"file_url"] stringByAddingPercentEscapesUsingEncoding];
        NSString *md5 =  [MagicCommentMethod dataBankMD5:encoderUrl];
        NSString *pathtt = [diskCachePath stringByAppendingPathComponent:md5];
        UIImage *im = [[UIImage alloc]initWithContentsOfFile:pathtt];
        
        if ([[[_dictFileInfo objectForKey:@"type"] lowercaseString] isEqualToString:@"gif"]) {
            
            NSString *encodeURL = [_dictFileInfo objectForKey:@"file_urlencode"];
            NSString *downFileName = [MagicCommentMethod md5:encodeURL];
            NSString *downloadPath = [NSString stringWithFormat:@"%@%@", [MagicCommentMethod downloadPath],    [downFileName stringByAppendingString:@".gif"]];
            NSData *localData = [NSData dataWithContentsOfFile:downloadPath];
            
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            [library writeImageDataToSavedPhotosAlbum:localData metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
                
                DLogInfo(@"%@",error);
                NSString *msg = nil ;
                
                if(error != NULL){
                    
                    msg = @"保存图片失败，请打开隐私权限：设置 -> 隐私 ->照片 -> 易班" ;
                    
                }else{
                    
                    msg = @"保存成功" ;
                    
                }
                
                [DYBShareinstaceDelegate addConfirmViewTitle:@"提示" MSG:msg targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_SINGLE rowNum:@"0"];
            }];
            [library release];
            
        }else{
            
            [self saveImageToPhotos:im];
        }
        
    }
}

- (void)saveImageToPhotos:(UIImage*)savedImage

{
 
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
   
}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo

{
   
    NSString *msg = nil ;
  
    if(error != NULL){
     
        msg = @"保存图片失败，请打开隐私权限：设置 -> 隐私 ->照片 -> 易班" ;
       
    }else{
       
        msg = @"保存成功" ;
       
    }
    
    [DYBShareinstaceDelegate addConfirmViewTitle:@"提示" MSG:msg targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_SINGLE rowNum:@"0"];
}


#pragma mark- 鸡肋点击按钮
- (void)handleViewSignal_DYBBaseViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBBaseViewController BACKBUTTON]])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if ([signal is:[DYBBaseViewController NEXTSTEPBUTTON]])
    {
        
        DLogInfo(@"不能为空");               
        if ([_targetObj isKindOfClass:[DYBDataBankShareViewController class]]) {
                        
            [self creatShareControllerRightDownView];
             
        }else if(![_targetObj isKindOfClass:[UIView class]]){
            
             [self creatRightDownView];
        }else{
        
            if ([[_targetObj superCon] isKindOfClass:[DYBDataBankShareViewController class]]) {
                [self creatShareControllerRightDownView];
                
            }else if([[_targetObj superCon] isKindOfClass:[DYBDataBankListController class]]
                     || [[_targetObj superCon] isKindOfClass:[DYBDataBankChildrenListViewController class]]){
                
            [self creatRightDownView];
            
            }
        }
        
        UIView *view = [self.view viewWithTag:BARVIEW];
        
        if (view.frame.origin.y == self.view.bounds.size.height - 180) {
            
            [UIView animateWithDuration:0.3 animations:^{
                
                
                [view setFrame:CGRectMake(0.0f, self.view.bounds.size.height - 20 - 32 + 20, 320.0f, 250)];
                
            }];
        }
        [imageViewMid setImage:[UIImage imageNamed:@"btn_unfold"]];
    }
}

- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj
{
    
    JsonResponse *response = (JsonResponse *)receiveObj;
    if (request.tag == BTNTAG_DEL) {
        
        if ([[response.data objectForKey:@"result"] boolValue]) {

            strOldURL = [_dictFileInfo objectForKey:@"file_urlencode"];
             [self sendViewSignal:[DYBDataBankFileDetailViewController DELFILE] withObject:strOldURL from:self target:_targetObj] ;
            [self.drNavigationController popViewControllerAnimated:YES];
        }
        NSString *strMSG = [response.data objectForKey:@"msg"];
        [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
        
    }if (request.tag == BTNTAG_RENAME) {
        
        if ([[response.data objectForKey:@"result"] boolValue]) {
            
            DLogInfo(@"dddd");
            [self.headview setTitle:[response.data objectForKey:@"new_name"]];
            
            NSDictionary *dictList = [response.data objectForKey:@"list"];
            
            _dictFileInfo = dictList;
            [_dictFileInfo retain];
            NSDictionary *sendDict = [[NSDictionary alloc]initWithObjectsAndKeys:dictList,@"dict",strOldURL,@"url", nil];
            
            [self sendViewSignal:[DYBDataBankFileDetailViewController NEWNAME] withObject:sendDict from:self target:_targetObj] ;
            RELEASE(sendDict);
            
            if (bChangeOk) { //移动后,重命名
                
                DYBDataBankListController *list = [DYBDataBankListController creatShareInstance];
                [list refreshList];
            }
           

        }else{
        
            [DYBShareinstaceDelegate popViewText:@"重命名失败！" target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
        
        }
    }
    
    else if (request.tag ==1){
        
        
        if ([response response] ==khttpsucceedCode)
        {

            NSArray *list=[response.data objectForKey:@"list"];
            
            DLogInfo(@"list -- %@",list);
            
        }
        
    }else if (request.tag == BTNTAG_CANCELSHARE){
    
        if ([[response.data objectForKey:@"result"] boolValue]) {
            
            NSNumber *num = [NSNumber numberWithInt:_index];
            [self sendViewSignal:[DYBDataBankFileDetailViewController CANCELSHARE] withObject:num from:self
                          target:_targetObj];
            
            [self.drNavigationController popViewControllerAnimated:YES];
        }
        NSString *MSG = [response.data objectForKey:@"msg"];
        [DYBShareinstaceDelegate popViewText:MSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
    }else if (request.tag == BTNTAG_BAD){
        
        
        if ([[response.data objectForKey:@"result"] boolValue]) { //操作ok
            
            DYBDataBankListCell *cell = _cellOperater;
            [self opeaterCellObj:cell response:response opeaterIndex:0];
            
        }else{
            UIButton *badBtn = (UIButton *)[_cellOperater viewWithTag:BTNTAG_BAD];
            [self hideGoodeANDDadIMG:badBtn];
            
        }
    }else if (request.tag == BTNTAG_GOOD){
        
        
        if ([[response.data objectForKey:@"result"] boolValue]) { //没有操作ok
            DYBDataBankListCell *cell = _cellOperater;
            [self opeaterCellObj:cell response:response opeaterIndex:0];
            
        }else{
            
            UIButton *goodBtn = (UIButton *)[_cellOperater viewWithTag:BTNTAG_GOOD];
            [self hideGoodeANDDadIMG:goodBtn];
        }
        
    }    
}

-(void)handleViewSignal_DYBDataBankShotView:(MagicViewSignal *)signal{
    
    if ([signal is:[DYBDataBankShotView LEFT]]) {
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSString *text = [dict objectForKey:@"text"];
        NSString *type = [dict objectForKey:@"type"];
        NSNumber *row = [dict objectForKey:@"rowNum"];
        NSDictionary *dictResult = _dictFileInfo;
        switch ([type integerValue]) {
            case BTNTAG_GOONDOWNLOAD:{
                
                [self.drNavigationController popViewControllerAnimated:YES];
            }
        }
    }
    
    else if ([signal is:[DYBDataBankShotView RIGHT]]) {
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSString *text = [dict objectForKey:@"text"];
        NSString *type = [dict objectForKey:@"type"];
        NSNumber *row = [dict objectForKey:@"rowNum"];
        NSDictionary *dictResult = _dictFileInfo;
        NSString *fileURL = [dictResult objectForKey:@"file_path"];
        switch ([type integerValue]) {
            case BTNTAG_DEL:{
                
                MagicRequest *request = [DYBHttpMethod document_deldoc_doc:fileURL indexDataBack:[NSString stringWithFormat:@"%@",row] isAlert:YES receive:self];
                
                
                [request setTag:BTNTAG_DEL];
                
            }
                break;
                
            case BTNTAG_CHANGE:
                
                
                break;
                
            case BTNTAG_RENAME:
            {
                
                NSString *doc_id = [dictResult objectForKey:@"id"];
                NSString *dir = [dictResult objectForKey:@"dir"];
                strOldURL = [_dictFileInfo objectForKey:@"file_urlencode"];
                BOOL bOK = [DYBShareinstaceDelegate isOKName:text];
                
                NSString *type = [dictResult objectForKey:@"type"];
                if (type.length > 0 && type) {
                    text= [NSString stringWithFormat:@"%@.%@",text,type];
                }
                
                int lenght = text.length;
                if (!bOK|| lenght > 255) {
                    
                    [DYBShareinstaceDelegate addConfirmViewTitle:@"" MSG:@"输入的名称不符合要求" targetView:APPDELEGATE.window targetObj:self btnType:BTNTAG_SINGLE rowNum:[NSString stringWithFormat:@"%d",0]];
                    
                    return;
                }
                
                MagicRequest *request = [DYBHttpMethod document_rename_doc_id:doc_id name:text is_dir:dir indexDataBank:[NSString stringWithFormat:@"%@",row]  sAlert:YES receive:self ];                
                [request setTag:BTNTAG_RENAME];
            }
                break;
            case BTNTAG_SHARE:
                
                break;
            case BTNTAG_GOONDOWNLOAD:{
                
                [self.rightButton setUserInteractionEnabled:NO];
                
                NSString *encodeURL = [_dictFileInfo objectForKey:@"file_urlencode"];
                self.HTTP_GET_DOWN(encodeURL);
            }
                break;
            case BTNTAG_CANCELSHARE:{
            
                
                NSString *strDoc = [_dictFileInfo objectForKey:@"file_path"];
                MagicRequest *request = [DYBHttpMethod document_share_doc:strDoc target:@"" isAlert:YES receive:self ];
                [request setTag:BTNTAG_CANCELSHARE];
            
            }
                break;
            default:
                break;
        }
    }
}

-(void)creatGoodANDBadIMG:(NSString *)strImgName{
    
    UIImageView *imageViewOperation = (UIImageView *)[self.view viewWithTag:OPEARTIONTAG];
    
    if (!imageViewOperation) {
        
        imageViewOperation = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 100.0)];
        [imageViewOperation setTag:OPEARTIONTAG];
        [imageViewOperation setCenter:CGPointMake(320.0f/2, self.view.frame.size.height/2)];
        [imageViewOperation setImage:[UIImage imageNamed:strImgName]];
        [self.view addSubview:imageViewOperation];
        RELEASE(imageViewOperation);
    }else{
        
        [imageViewOperation setImage:[UIImage imageNamed:strImgName]];
    }
}
-(void)opeaterCellObj:(DYBDataBankListCell *)cell response:(JsonResponse *)response opeaterIndex:(int)opeaterIndex{
    
    NSMutableDictionary *dictNew = [response.data objectForKey:@"list"];
    
   
    
    cell.labelGood.text = [dictNew objectForKey:@"up"];
    cell.labelBad.text = [dictNew objectForKey:@"down"];
    
    UIButton *btnGood = (UIButton *)[cell viewWithTag:BTNTAG_GOOD];
    
    UIView *viewRight = [self.view viewWithTag:COMMENTRIGHTVIEW];
    UIButton *btnGoodDeatil = (UIButton *)[viewRight viewWithTag:BTNTAG_GOOD];
    
    if ([[dictNew objectForKey:@"is_estimate_up"] boolValue] ) {
        
        [btnGood setEnabled:NO];
        [btnGoodDeatil setEnabled:NO];
    }else{
        [btnGoodDeatil setEnabled:YES];
        [btnGood setEnabled:YES];
    }
    
    UIButton *btnBad = (UIButton *)[cell viewWithTag:BTNTAG_BAD];
    UIButton *btnBadDeatil = (UIButton *)[viewRight viewWithTag:BTNTAG_BAD];
    if ([[dictNew objectForKey:@"is_estimate_down"] boolValue] ) {
        
        [btnBadDeatil setEnabled:NO];
        [btnBad setEnabled:NO];
    }else{
        [btnBadDeatil setEnabled:YES];
        [btnBad setEnabled:YES];
    }
    
//    [arrayFolderList replaceObjectAtIndex:opeaterIndex withObject:dictNew];  //替换 array中的dict
    
    UIView *opeationView = [self.view viewWithTag:OPEARTIONTAG];
    
    [UIView animateWithDuration:.5f animations:^{
        
        opeationView.alpha = .0f;
        
    } completion:^(BOOL finished) {
        
        [opeationView removeFromSuperview];
//        [btnBad setEnabled:YES];
    }];
//    [dictNew removeObjectForKey:@"count"];
//    [_arraySource replaceObjectAtIndex:_index withObject:dictNew];
//     _dictFileInfo = dictNew;
    [_dictFileInfo setValue:[dictNew objectForKey:@"is_estimate_down"] forKey:@"is_estimate_down"];
    [_dictFileInfo setValue:[dictNew objectForKey:@"is_estimate_up"] forKey:@"is_estimate_up"];
    [_dictFileInfo retain];
}

-(void)hideGoodeANDDadIMG:(UIButton *)btnOperater{
    
    UIView *opeationView = [self.view viewWithTag:OPEARTIONTAG];
    
    [UIView animateWithDuration:.5f animations:^{
        
        opeationView.alpha = .0f;
        
    } completion:^(BOOL finished) {
        
        [opeationView removeFromSuperview];
        [btnOperater setEnabled:YES];
        
    }];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

//    UIView *view = [self.view viewWithTag:BARVIEW];
//    if(view){
//        
//        [view setHidden:YES];
//    }
}

- (void)dealloc
{
//    RELEASE(strOldURL);
    RELEASE(_dictFileInfo);
    RELEASE(detailRightView);
    RELEASE( _targetObj);
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
