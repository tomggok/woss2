//
//  WOSAdrrDrtailView.m
//  WOS
//
//  Created by apple on 14-5-18.
//  Copyright (c) 2014年 ZzL. All rights reserved.
//


#import "WOSAdrrDrtailView.h"
#import "Magic_Request.h"
#import "DYBHttpMethod.h"
#import "JSONKit.h"
#import "JSON.h"


@implementation WOSAdrrDrtailView{

    NSDictionary *dictResult;

}
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)addView:(NSDictionary *)dict{
    
    
    dictResult = [[NSDictionary alloc]initWithDictionary:dict];
    
    UIView *viewBG = [[UIView alloc]initWithFrame:self.frame];
    [viewBG setBackgroundColor:[UIColor blackColor]];
    [self addSubview:viewBG];
    [viewBG release];
    [viewBG setAlpha:0.8];

    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(12, 48/2, 56/2, 56/2)];
    [btn addTarget:self action:@selector(doHidden) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"返回键"] forState:UIControlStateNormal];
    [self addSubview:btn];
    RELEASE(btn);
    
    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(34/2, 64, 320.0f - 34, 450/2)];
    [imageView1 setImage:[UIImage imageNamed:@"圆角矩形1"]];
    [imageView1 setUserInteractionEnabled:YES];
    [self addSubview:imageView1];
    [imageView1 release];
    
    UILabel *labelName = [[UILabel alloc]initWithFrame:CGRectMake(15, 28/2, 100, 33/2)];
    [labelName setTextColor:[UIColor whiteColor]];

    [labelName setText:@"收货人"];
    [labelName sizeToFit];
    [labelName setBackgroundColor:[UIColor clearColor]];
    [imageView1 addSubview:labelName];
    [labelName release];

    UILabel *labelName1 = [[UILabel alloc]initWithFrame:CGRectMake(120, 28/2, 100, 33/2)];
    [labelName1 setTextColor:[UIColor whiteColor]];

    [labelName1 setText:[dict objectForKey:@"receiverName"]];
    [labelName1 setBackgroundColor:[UIColor clearColor]];
    [imageView1 addSubview:labelName1];
    [labelName1 release];

    
    UILabel *labelPh = [[UILabel alloc]initWithFrame:CGRectMake(15, 110/2, 100, 33/2)];
    [labelPh setTextColor:[UIColor whiteColor]];
    [labelPh setText:@"手机号码"];
    [labelPh setBackgroundColor:[UIColor clearColor]];
    [imageView1 addSubview:labelPh];
    [labelPh release];

    
    
    UILabel *labelPh1 = [[UILabel alloc]initWithFrame:CGRectMake(120, 110/2, 100, 33/2)];
    [labelPh1 setText:[dict objectForKey:@"receiverPhoneNo"]];
    [labelPh1 setBackgroundColor:[UIColor clearColor]];
    [labelPh1 setTextColor:[UIColor whiteColor]];

    [imageView1 addSubview:labelPh1];
    [labelPh1 release];

    
    UILabel *labeladdr = [[UILabel alloc]initWithFrame:CGRectMake(15, 190/2, 100, 33/2)];
    [labeladdr setText:@"详细地址"];
    [labeladdr setTextColor:[UIColor whiteColor]];

    [labeladdr setBackgroundColor:[UIColor clearColor]];
    [imageView1 addSubview:labeladdr];
    [labeladdr release];

    
    UILabel *labeladdr1 = [[UILabel alloc]initWithFrame:CGRectMake(120, 100, 100, 33/2)];
    [labeladdr1 setText:[dict objectForKey:@"receiverAddress"]];
    [labeladdr1 setBackgroundColor:[UIColor clearColor]];
    [labeladdr1 setTextColor:[UIColor whiteColor]];

    [imageView1 addSubview:labeladdr1];
    [labeladdr1 release];

    UIImage *imageDel = [UIImage imageNamed:@"删除"];
    UIButton *btnDel = [[UIButton alloc]initWithFrame:CGRectMake(88/2, 649/2, imageDel.size.width/2, imageDel.size.height/2)];
    [btnDel addTarget:self action:@selector(doDel) forControlEvents:UIControlEventTouchUpInside];
    [btnDel setImage:imageDel forState:UIControlStateNormal];
    [self addSubview:btnDel];
    RELEASE(btnDel);

    
    UIImage *imageMake = [UIImage imageNamed:@"确定"];
    UIButton *btnDel1 = [[UIButton alloc]initWithFrame:CGRectMake(398/2, 649/2, imageMake.size.width/2, imageMake.size.height/2)];
    [btnDel1 addTarget:self action:@selector(doMakeSure) forControlEvents:UIControlEventTouchUpInside];
    [btnDel1 setImage:imageMake forState:UIControlStateNormal];
    [self addSubview:btnDel1];
    RELEASE(btnDel1);
    
    
}

-(void)doHidden{
    [self removeFromSuperview];

}

-(void)doDel{


    
    MagicRequest *request = [DYBHttpMethod wosFoodInfo_addressDel_userIndex:SHARED.userId addrIndex:[dictResult objectForKey:@"addrIndex"] sAlert:YES receive:self];
    [request setTag:4];
}

-(void)doMakeSure{

    [self removeFromSuperview];

}

#pragma mark- 只接受HTTP信号
- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj
{
    
    if ([request succeed])
    {
        //        JsonResponse *response = (JsonResponse *)receiveObj;
        if (request.tag == 4) {
            
            if ([delegate respondsToSelector:@selector(delSueese:)]) {
                [delegate delSueese:[dictResult objectForKey:@"addrIndex"]];
                
                [self removeFromSuperview];
            }
//            [self su];
            NSDictionary *dict = [request.responseString JSONValue];
            
            if (dict) {
                BOOL result = [[dict objectForKey:@"result"] boolValue];
                if (!result) {
                    
                    
                }else{
                    NSString *strMSG = [dict objectForKey:@"message"];
                    
                    [DYBShareinstaceDelegate popViewText:strMSG target:self hideTime:.5f isRelease:YES mode:MagicPOPALERTVIEWINDICATOR];
                    
                    
                }
            }
        }
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
