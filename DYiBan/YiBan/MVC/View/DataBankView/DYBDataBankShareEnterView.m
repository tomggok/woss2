//
//  DYBDataBankShareEnterView.m
//  DYiBan
//
//  Created by tom zeng on 13-9-16.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBDataBankShareEnterView.h"
#import "DYBSelectContactViewController.h"
#import "DYBDataBnakSchoolAndCollegeViewController.h"
#import "DYBDataBankEclassListsViewController.h"
#import "DYBParameter.h"
#import "user.h"


@implementation DYBDataBankShareEnterView

@synthesize targetObj = _targetObj,dictFileInfo = _dictFileInfo,arrayInfo = _arrayInfo,indexRow = _indexRow;
@synthesize cellDetail = _cellDetail,cellDetailSearch = _cellDetailSearch;

- (id)initWithFrame:(CGRect)frame target:(id)target info:(NSDictionary *)info arrayFolderList:(NSMutableArray *)array index:(NSUInteger)row
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
         [DYBShareinstaceDelegate opeartionTabBarShow:YES];
        
        
        _targetObj = target;
        _dictFileInfo = info;
        _arrayInfo = array;
        _indexRow = row;
        [self initView:info];
    }
    return self;
}

-(void)initView:(NSDictionary *)dict{

    UIView *viewBG = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, self.frame.size.height)];
    [viewBG setAlpha:0.7];
    [viewBG setBackgroundColor:[UIColor blackColor]];
    [self addSubview:viewBG];
    RELEASE(viewBG);
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideSelf)];
    [tap setNumberOfTapsRequired:1];
    [tap setNumberOfTouchesRequired:1];
    [viewBG addGestureRecognizer:tap];
    RELEASE(tap);
    
    
    UIImageView *imageViewShow = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 0,320.0f , 3)];
    [imageViewShow setImage:[UIImage imageNamed:@"txtbox_shadow.png"]];
    [imageViewShow setBackgroundColor:[UIColor clearColor]];
    [self addSubview:imageViewShow];
    RELEASE(imageViewShow);
    
    
    for (int i = 1; i<= 4; i++) {
        [self creatCell:dict index:i];
    }


}

-(void)hideSelf{

    [self removeFromSuperview];

}

-(void)creatCell:(NSDictionary *)dict index:(NSInteger)index{

    
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0.0f, ((index - 1) * 44) + 3 + self.frame.size.height - 44*4 , 320.0f, 44.0f)];
    [view setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:view];
    RELEASE(view);
    
    DLogInfo(@"creatCell ---- %@",view);
    
    UIButton *btnTouch  = [[UIButton alloc]initWithFrame:CGRectMake(0.0f, 0.0F, view.frame.size.width, view.frame.size.width)];
    [btnTouch setTag:index];
    [btnTouch addTarget:self action:@selector(doPush:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btnTouch];
    [btnTouch release];
    
    UILabel *laebelName = [[UILabel alloc]initWithFrame:CGRectMake(60.0f, (44-40)/2, 150.0f, 40.0f)];
    [view addSubview:laebelName];
    [laebelName setFont:[DYBShareinstaceDelegate DYBFoutStyle:16]];
    [laebelName setText:[self getName:index]];
    RELEASE(laebelName)
    
    if (index  == 1) {
        UIImageView *imageViewTop = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 1)];
        [imageViewTop setImage:[UIImage imageNamed:@""]];
        [view addSubview:imageViewTop];
        RELEASE(imageViewTop);
    }
    
    if (index >= 3) {
        UIImageView *iamgeViewPushIcon = [[UIImageView alloc]initWithFrame:CGRectMake(280.0f, (44.0 - 15)/2, 12.0f, 15.0f)];
        [iamgeViewPushIcon setImage:[UIImage imageNamed:@"list_arrow"]];
        [view addSubview:iamgeViewPushIcon];
        RELEASE(iamgeViewPushIcon);
    }
    

    BOOL bShare = NO;
    
    if (index  == [[dict objectForKey:@"perm"] integerValue]) {
     
        bShare = YES;
    }else{
    
        bShare = NO;
    
    }
    
    UIImageView *imageViewShare = [[UIImageView alloc]initWithFrame:CGRectMake(10.0f, (44 - 25)/2, 25.0f, 25.0f)];
    if (bShare) {
        [imageViewShare setImage:[UIImage imageNamed:@"radio_on"]];
        
    }else{
        
        [imageViewShare setImage:[UIImage imageNamed:@"radio_off"]];
        
    }
    
    [view addSubview:imageViewShare];
    RELEASE(imageViewShare);

    UIImageView *footImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 44.0f - 3, 320.0f, 3)];
    [footImageView setImage:[UIImage imageNamed:@"line_padshadow"]];
    [view addSubview:footImageView];
    RELEASE(footImageView);

}

-(void)doPush:(UIButton*)tap{

    UIButton *btn = (UIButton *)tap;
    
    switch (btn.tag) {
        case 1:
        {
            MagicRequest *request = [DYBHttpMethod document_share_doc:[_dictFileInfo objectForKey:@"file_path"] target:@"O" isAlert:YES receive:self ];
            [request setTag:5];
            
        }
            break;
        case 2:
        {
            NSString *strUserId = SHARED.curUser.userid;
            NSString *strTarget = [NSString stringWithFormat:@"U,%@",strUserId];
            MagicRequest *request = [DYBHttpMethod document_share_doc:[_dictFileInfo objectForKey:@"file_path"] target:strTarget isAlert:YES receive:self ];
            [request setTag:6];
            
        }
            break;
        case 3:
        {
            DYBSelectContactViewController *classM = [[DYBSelectContactViewController alloc]init];
            classM.bEnterDataBank = YES;
            classM.dictInfo = _dictFileInfo;
            classM.cellDetail = _cellDetail;
            classM.cellDetailSearch = _cellDetailSearch;
            classM.docAddr = [_dictFileInfo objectForKey:@"file_path"];
            [_targetObj.drNavigationController pushViewController:classM animated:YES];
            RELEASE(classM);
            
        }
            break;
        case 4:
        {
            // push ecless VC
            
            DYBDataBankEclassListsViewController *clessVC = [[DYBDataBankEclassListsViewController alloc]init];
            clessVC.docAddr = [_dictFileInfo objectForKey:@"file_path"];
            clessVC.dictInfo = _dictFileInfo;
            clessVC.cellDetail = _cellDetail;
            clessVC.cellDetailSearch = _cellDetailSearch;
            [_targetObj.drNavigationController pushViewController:clessVC animated:YES];
            RELEASE(clessVC);
            
        }
            break;
            
        default:
            break;
    }
    
    [self removeFromSuperview];

}

-(NSString *)getName:(NSUInteger)index{

    switch (index) {
        case 1:
            return @"公开";
            break;
        case 2:
            return @"共享给全部好友";
            break;
        case 3:
            return @"指定共享给";
            break;
        case 4:
            return @"共享给班级";
            break;
        case 5:
            return @"共享给学院";
            break;
        case 6:
            return @"共享给学校";
            break;

        default:
            break;
    }

    return @"";
}


#pragma mark- HTTP
- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj
{
    
    
    JsonResponse *response = (JsonResponse *)receiveObj;
    if (request.tag == 5) {
        
        if ([[response.data objectForKey:@"result"] boolValue]) {
            
            [self changeShareTypeForCell:@"1"];

        }
        
        NSString *MSG = [response.data objectForKey:@"msg"];
                
        [DYBShareinstaceDelegate popViewText:MSG target:self hideTime:-0.3f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
    }if (request.tag == 6) {
        
        if ([[response.data objectForKey:@"result"] boolValue]) {
            
            [self changeShareTypeForCell:@"2"];

        }
        
        NSString *MSG = [response.data objectForKey:@"msg"];
                
        [DYBShareinstaceDelegate popViewText:MSG target:self hideTime:-0.3f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
    }
}

-(void)changeShareTypeForCell:(NSString *)strType{

    [_dictFileInfo setValue:strType forKey:@"perm"];
    if (_cellDetail) {
        [_cellDetail setPublicString:strType];
        [_cellDetailSearch setPublicString:strType];
    }

    [self superCon];
}

- (void)dealloc
{
    RELEASE(_cellDetail);
    RELEASE(_cellDetailSearch);
    
    [super dealloc];
}

@end
