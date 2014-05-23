//
//  DYBSendNoticeViewController.m
//  DYiBan
//
//  Created by zhangchao on 13-9-10.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBSendNoticeViewController.h"
#import "UITextView+Property.h"
#import "NSString+Count.h"
#import "UIView+MagicCategory.h"
#import "DYBClassListViewController.h"
#import "XiTongFaceCode.h"
#import "DYBImagePickerController.h"
#import "DYBCheckImageViewController.h"
#import "user.h"
#import "DYBPhotoEditorView.h"
#import "UIImage+MagicCategory.h"

@interface DYBSendNoticeViewController ()
{
    
    MagicUITextView *_textView;
    MagicUILabel *_lb_nums/*当前字数*/;
    DYBFaceView *_viewFace;
    NSMutableArray *_muA_SelPic;//保存选择的展示图
    UIScrollView *_scrV_showImg;//展示图滚动背景
    MagicUIButton *_bt_send,*_bt_face/*表情*/,*_bt_addImg/*加图片按钮*/,*_bt_noticeArea;
    DYBPhotoEditorView *_photoEditor;
}
@end

@implementation DYBSendNoticeViewController

@synthesize muA_noticeArea=_muA_noticeArea;

#pragma mark- ViewController信号
- (void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal
{
    [super handleViewSignal:signal];
    
    if ([signal is:MagicViewController.CREATE_VIEWS]) {
        
        [self observeNotification:[DYBPhotoEditorView DOSAVEIMAGE]];//添加 选滤镜成功信号
        [self observeNotification:[DYBCheckImageViewController DELETEMAGE]];//添加 查看大图页删除图片信号

        _textView = [[MagicUITextView alloc] initWithFrame:CGRectMake(15, self.headHeight+15, CGRectGetWidth(self.view.frame)-30, 90)];
        [_textView setBackgroundColor:[UIColor whiteColor]];
        _textView.layer.borderWidth = 1;
        _textView.layer.borderColor = [ColorDivLine CGColor];
        _textView.font = [DYBShareinstaceDelegate DYBFoutStyle:16];
        _textView.textColor = ColorBlack;
        _textView.returnKeyType=UIReturnKeyDone;
        [_textView setMaxLength:140];
        [self.view addSubview:_textView];
        RELEASE(_textView);
        [_textView initLbTextLength:CGRectMake(CGRectGetMinX(_textView.frame)+10, CGRectGetMaxY(_textView.frame)-20, 0, 0)];
        [self.view addSubview:_textView.lb_textLength];
        RELEASE(_textView.lb_textLength);
        [_textView freshLbTextLengthText:[NSString stringWithFormat:@"%d / %d",_textView.text.length,_textView.maxLength]];
        _textView.contentInset=UIEdgeInsetsMake(0, 0, CGRectGetHeight(_textView.lb_textLength.frame)+10, 0);//避免内容输入到和底部时和lb_textLength重合
//        [_textView becomeFirstResponder];

        if (!_bt_face) {//表情
            UIImage *img= [UIImage imageNamed:@"ftz6"];
            _bt_face = [[MagicUIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_textView.frame)-10-img.size.width/2, CGRectGetMaxY(_textView.lb_textLength.frame)-img.size.height/2, img.size.width/2, img.size.height/2)];
            _bt_face.backgroundColor=[UIColor clearColor];
            _bt_face.tag=-2;
            [_bt_face addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside];
            [_bt_face setImage:img forState:UIControlStateNormal];
//            [_bt_face setImage:img forState:UIControlStateHighlighted];
            [self.view addSubview:_bt_face];
            _bt_send.showsTouchWhenHighlighted=YES;
//            [_bt_face changePosInSuperViewWithAlignment:1];
            RELEASE(_bt_face);
        }
        
//        {//图片灰色背景
//            _v_imgBack=[[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(_textView.frame), CGRectGetMaxY(_textView.frame)+10, CGRectGetWidth(_textView.frame), 60)];
//            _v_imgBack.backgroundColor=ColorCellSepL;
//            [self.view addSubview:_v_imgBack];
//            RELEASE(_v_imgBack);
//        }
        
        {//展示图滚动背景  每张图片上下左右间距5
            _scrV_showImg = [[UIScrollView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_textView.frame)+10, CGRectGetWidth(_textView.frame), 60)];
            [_scrV_showImg setBackgroundColor:ColorCellSepL];
            [_scrV_showImg setContentSize:CGSizeMake(349, 60)];
            [_scrV_showImg setShowsHorizontalScrollIndicator:NO];
            [_scrV_showImg setScrollEnabled:NO];
            [self.view addSubview:_scrV_showImg];
            RELEASE(_scrV_showImg);
        }
        
        if (!_bt_addImg) {//加图片
            UIImage *img= [UIImage imageNamed:@"ftz3"];
            _bt_addImg = [[MagicUIButton alloc] initWithFrame:CGRectMake(5, 0, img.size.width/2, img.size.height/2)];
            _bt_addImg.backgroundColor=[UIColor clearColor];
            _bt_addImg.tag=-3;
            [_bt_addImg addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside];
            [_bt_addImg setImage:img forState:UIControlStateNormal];
            //            [_bt_face setImage:img forState:UIControlStateHighlighted];
            [_scrV_showImg addSubview:_bt_addImg];
//            _bt_addImg.showsTouchWhenHighlighted=YES;
            [_bt_addImg changePosInSuperViewWithAlignment:1];
            RELEASE(_bt_addImg);
        }
        
        if (!_bt_noticeArea) {//通知范围
            UIImage *img= [UIImage imageNamed:@"ftz10"];
            _bt_noticeArea = [[MagicUIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(_textView.frame), CGRectGetMaxY(_scrV_showImg.frame)+10, img.size.width/2, img.size.height/2)];
            _bt_noticeArea.backgroundColor=[UIColor clearColor];
            _bt_noticeArea.tag=-4;
            [_bt_noticeArea addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside];
            [_bt_noticeArea setImage:img forState:UIControlStateNormal];
//            [_bt_face setImage:img forState:UIControlStateHighlighted];
            [self.view addSubview:_bt_noticeArea];
//            _bt_noticeArea.showsTouchWhenHighlighted=YES;
//            [_bt_noticeArea changePosInSuperViewWithAlignment:1];
            RELEASE(_bt_noticeArea);
        }
        
        _muA_SelPic = [[NSMutableArray alloc] initWithCapacity:6];
        
    }else if ([signal is:MagicViewController.WILL_APPEAR]){
        [self.headview setTitle:@"发布通知"];
        self.view.backgroundColor=self.headview.backgroundColor;
        [self backImgType:0];
        
        if (!_bt_send) {//发
            UIImage *img= [UIImage imageNamed:@"ftz1"];
            _bt_send = [[MagicUIButton alloc] initWithFrame:CGRectMake(self.headview.frame.size.width-img.size.width/2, 0, img.size.width/2, img.size.height/2)];
            _bt_send.backgroundColor=[UIColor clearColor];
            _bt_send.tag=-1;
            [_bt_send addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside];
            [_bt_send setImage:img forState:UIControlStateNormal];
            [_bt_send setImage:[UIImage imageNamed:@"ftz2"] forState:UIControlStateHighlighted];//btn_send_dis.png
            [_bt_send setImage:[UIImage imageNamed:@"btn_send_dis.png"] forState:UIControlStateDisabled];//

            [self.headview addSubview:_bt_send];
//            _bt_send.showsTouchWhenHighlighted=YES;
            [_bt_send changePosInSuperViewWithAlignment:1];
            RELEASE(_bt_send);
        }
        
        _bt_send.enabled=(_muA_noticeArea.count>0&&[self convertSystemEmoji:_textView.text].length>0);

       
    }else if ([signal is:MagicViewController.DID_APPEAR]){
        
        
    }else if ([signal is:MagicViewController.DID_DISAPPEAR]){
        
        
    }else if ([signal is:[MagicViewController LAYOUT_VIEWS]])
    {
       
    }else if ([signal is:[MagicViewController FREE_DATAS]])//dealloc时回调,先释放数据
    {
        RELEASEDICTARRAYOBJ(_muA_noticeArea);
        RELEASEDICTARRAYOBJ(_muA_SelPic);
        
    }else if ([signal is:[MagicViewController DELETE_VIEWS]]){//dealloc时回调,再释放视图
        
        
    }
    
}

// 触摸背景，关闭键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    UIView *view = (UIView *)[touch view];
    if (view == self.view) {
        [_textView resignFirstResponder];
    }
}


#pragma mark- 只接受UITextView信号
- (void)handleViewSignal_MagicUITextView:(MagicViewSignal *)signal
{
    if ([signal is:[MagicUITextView TEXTVIEWSHOULDBEGINEDITING]])//textViewShouldBeginEditing
    {

    }else  if ([signal is:[MagicUITextView TEXTVIEWDIDBEGINEDITING]])//textViewDidBeginEditing
    {
        NSMutableDictionary *muD = (NSMutableDictionary *)[signal object];
        MagicUITextView *textView=[muD objectForKey:@"textView"];
        //        [self.view bringSubviewToFront:_v_bottomView];
        
        {//收表情view
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:0.25f];
            [_viewFace setFrame:CGRectMake(0, self.view.frame.size.height, 320, 200)];
            [UIView commitAnimations];
            
            _bt_face.selected=!_bt_face.selected;
        }
        
    }else  if ([signal is:[MagicUITextView TEXT_OVERFLOW]])//文字超长
    {
        [signal returnNO];

    }else  if ([signal is:[MagicUITextView TEXTVIEW]])//shouldChangeTextInRange
    {
        NSMutableDictionary *muD = (NSMutableDictionary *)[signal object];
        NSString *emString=[muD objectForKey:@"text"];
        if ([emString isEqualToString:@"\n"]) {
            [signal returnNO];
            [_textView setActive:NO];
        }
    }
    else  if ([signal is:[MagicUITextView TEXTVIEWDIDCHANGE]])//textViewDidChange
    {
        NSMutableDictionary *muD = (NSMutableDictionary *)[signal object];
        MagicUITextView *textView=[muD objectForKey:@"textView"];
        
        NSString *_strContent = [self convertSystemEmoji:textView.text];

        [textView freshLbTextLengthText:[NSString stringWithFormat:@"%d / %d",_strContent.length,textView.maxLength]];
        
        _bt_send.enabled=(_muA_noticeArea.count>0&&[self convertSystemEmoji:_textView.text].length>0);
        
    }else  if ([signal is:[MagicUITextView TEXTVIEWDIDCHANGESELECTION]])//textViewDidChangeSelection
    {
    }else  if ([signal is:[MagicUITextView TEXTVIEWSHOULDENDEDITING]])//textViewShouldEndEditing
    {
    }else  if ([signal is:[MagicUITextView TEXTVIEWDIDENDEDITING]])//textViewDidEndEditing
    {
    }
}

#pragma mark- 接受按钮信号
- (void)handleViewSignal_MagicUIButton:(MagicViewSignal *)signal{
    if ([signal is:[MagicUIButton TOUCH_UP_INSIDE]]) {
        MagicUIButton *bt=(MagicUIButton *)signal.source;
        if (bt)
        {
            switch (bt.tag) {
                case -1://发通知
                {
                    NSString *mus=@"";
                    for (NSString *str in _muA_noticeArea) {
                        mus = [mus stringByAppendingString:[NSString stringWithFormat:@"%@,",str]];
                    }
                    
                    NSMutableArray *_arrIMGData = [[NSMutableArray alloc] init];
                    for (UIImage *imgSendPic in _muA_SelPic) {
                        NSData *dataPic = UIImagePNGRepresentation(imgSendPic);
                        [_arrIMGData addObject:dataPic];
                    }
                    
                    NSString *content=[self convertSystemEmoji:_textView.text];
                    
                    if (content.length==0) {
                        return;
                    }
                    
                    NSMutableDictionary *dict = [DYBHttpInterface status_add_content:[self convertSystemEmoji:_textView.text] add_notice:@"1" sync_tag:[SHARED.curUser.sync_tag intValue] refuse:@"" at_eclass:mus address:@""];
                    DYBRequest *request = AUTORELEASE([[DYBRequest alloc] init]);
                    MagicRequest *dre = [request DYBPOSTIMG:dict isAlert:YES receive:self imageData:_arrIMGData];
                    dre.tag =  -1;
                    RELEASEDICTARRAYOBJ(_arrIMGData);

                }
                    break;
                    
                case -2://表情
                {
//                    [_textView becomeFirstResponder];

                    if (!_viewFace) {
                        _viewFace = [[DYBFaceView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame), screenShows.size.width, 200)];
                        _viewFace.delegate = self;
                        [self.view addSubview:_viewFace];
                        RELEASE(_viewFace);
                        
                        UIImage *imgShadowLine = [UIImage imageNamed:@"line_padshadow"];
                        MagicUIImageView *viewShadowLine = [[MagicUIImageView alloc] initWithFrame:CGRectMake(0, -3, imgShadowLine.size.width/2, imgShadowLine.size.height/2)];
                        [viewShadowLine setImage:imgShadowLine];
                        [viewShadowLine setBackgroundColor:[UIColor clearColor]];
                        [_viewFace addSubview:viewShadowLine];
                        RELEASE(viewShadowLine);
                    }
                    
                    if (bt.selected == NO) {
                        [_textView resignFirstResponder];
                        
                        [UIView beginAnimations:nil context:nil];
                        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                        [UIView setAnimationDuration:0.25f];
                        [_viewFace setFrame:CGRectMake(0, self.view.frame.size.height-215, 320, 200)];
                        [UIView commitAnimations];
                    }else{
                        [UIView beginAnimations:nil context:nil];
                        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                        [UIView setAnimationDuration:0.25f];
                        [_viewFace setFrame:CGRectMake(0, self.view.frame.size.height, 320, 200)];
                        [UIView commitAnimations];
                    }
                    bt.selected = !bt.selected;
                    
                }
                    break;
                case -3://加图片
                {
                    [_textView resignFirstResponder];

                    UIActionSheet *actionView = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"立刻拍照" otherButtonTitles:@"相册选择", nil];
                    [actionView showInView:self.view];
                    RELEASE(actionView);
                }
                    break;
                case -4://通知范围
                {
                    DYBClassListViewController *con=[[DYBClassListViewController alloc]init];
                    con.type=1;
                    if (!_muA_noticeArea) {
                        _muA_noticeArea=[[NSMutableArray alloc]init];
                    }
                    con.muA_noticeArea=_muA_noticeArea;
                    [self.drNavigationController pushViewController:con animated:YES];
                    RELEASE(con);
                }
                    break;
                case -5://查看大图
                {
                    DYBCheckImageViewController *vc = [[DYBCheckImageViewController alloc] initWithImage:bt.imageView.image];
                    [self.drNavigationController pushViewController:vc animated:YES];
                    RELEASE(vc);
                }
                    break;
                default:
                    break;
            }
        }
        
    }
    
}

#pragma mark - 表情功能
-(void)selectFace:(id)sender{
    UIButton *tempbtn = (UIButton *)sender;
    NSMutableDictionary *tempdic = [_viewFace.faces objectAtIndex:tempbtn.tag];
    NSArray *temparray = [tempdic allKeys];
    NSString *faceStr= [NSString stringWithFormat:@"%@",[temparray objectAtIndex:0]];
    NSArray *arrayTemp = [faceStr componentsSeparatedByString:@"/"];
    NSString *tempStr = [[[arrayTemp objectAtIndex:1] componentsSeparatedByString:@"]"] objectAtIndex:0];
    NSString *last = [[self getFaceCode] objectForKey:tempStr];
    
    NSString *beforeString = [self beforeString:_textView subString:last];
    if ([self convertSystemEmoji:_textView.text].length+last.length>_textView.maxLength) {
        return;
    }
    _textView.text = [self subStringOperat:_textView subString:last beforeString:beforeString] ;
    
    //光标位置
    NSRange range = [_textView.text rangeOfString:beforeString];
    NSRange ragne1 = NSMakeRange(range.location+beforeString.length, 0);
    _textView.selectedRange = ragne1;
    
    {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:_textView, @"textView", nil];
        [self sendViewSignal:[MagicUITextView TEXTVIEWDIDCHANGE] withObject:dict];
        RELEASEDICTARRAYOBJ(dict);

    }
}

//操作字符串
-(NSString* )subStringOperat:(UITextView *)textView subString:(NSString*)string beforeString:(NSString *)beforeString{
    int location;
    if (textView.text.length < 1) {
        
        location = 0;
        
    }else {
        
        location = textView.selectedRange.location;
    }
    NSString *afterSacn = [textView.text substringFromIndex:location];
    if (afterSacn.length > 0) {
        afterSacn = [beforeString stringByAppendingString:afterSacn];
    }else{
        afterSacn = beforeString;
    }
    
    return afterSacn;
}

-(void)face_end{
    //    bONface = NO;
    [_viewFace setFrame:CGRectMake(0, 600, 320, 200)];
}

-(NSDictionary*)getFaceCode{
    NSDictionary * dic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"emoji" ofType:@"plist"]];
    return dic ;
}

-(NSString* )beforeString:(UITextView* )textView subString :(NSString *)string{
//    int location = textView.selectedRange.location;
    
    int location;
    if (textView.text.length < 1) {
        
        location = 0;
        
    }else {
        
        location = textView.selectedRange.location;
    }
    
    NSString*  beforeString = [textView.text substringToIndex:location];
    if (beforeString.length > 0) {
        beforeString = [beforeString stringByAppendingString:string];
    }else{
        beforeString = string;
    }
    
    return beforeString;
}

-(BOOL)checkIncludeString_string:(NSString*)str include_str:(NSString*)include_str{
    NSRange range = [str rangeOfString:include_str];
    if (range.length > 0) {
        return YES;
    }else{
        return NO;
    }
}

-(NSString *)convertSystemEmoji:(NSString *)orgString{
    NSString *strConvert = [NSString stringWithFormat:@"%@", orgString];
    
    if ([self checkIncludeString_string:strConvert include_str:@"\xe2\x98\xba"])
    {
        strConvert = [strConvert stringByReplacingOccurrencesOfString:@"\xe2\x98\xba" withString:@"[小嘴微笑]"];
    }
    
    if ([self checkIncludeString_string:strConvert include_str:@"\xe2\x9c\x8c"]) {
        strConvert = [strConvert stringByReplacingOccurrencesOfString:@"\xe2\x9c\x8c" withString:@"[胜利]"];
    }
    if ([self checkIncludeString_string:strConvert include_str:@"\xe2\x9c\x8a"]) {
        strConvert = [strConvert stringByReplacingOccurrencesOfString:@"\xe2\x9c\x8a" withString:@"[掌心拳]"];
    }
    
    if (strConvert.length > 0) {
        
        XiTongFaceCode * faceCode = [[XiTongFaceCode alloc]init];
        NSMutableDictionary* dictFace = [faceCode ServerToXiTong];
        for (int i = 0; i < [strConvert length] - 1; i++) {
            NSRange range = NSMakeRange(i, 2);
            NSString *tempStr = [strConvert substringWithRange:range];
            NSString *temp = [dictFace objectForKey:tempStr];
            if (temp) {
                strConvert = [strConvert stringByReplacingOccurrencesOfString:tempStr withString:temp];
            }
        }
        
        [faceCode release];
    }
    
    return strConvert;
}

#pragma mark- UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    [_textView resignFirstResponder];
    
    switch (buttonIndex) {
        case 0:
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self.drNavigationController presentModalViewController:imagePicker animated:YES];
                RELEASE(imagePicker);
            }
            break;
        case 1:{
            
            DYBImagePickerController *_imgPicker = [[DYBImagePickerController alloc] init];
            [_imgPicker setFather:self];
            _imgPicker.delegate = self;
            _imgPicker.allowsMultipleSelection = YES;//是否是多图上传
            _imgPicker.limitsMaximumNumberOfSelection = YES;// 最大图片数量
            _imgPicker.maximumNumberOfSelection = 6 - [_muA_SelPic count];
            [self.drNavigationController pushViewController:_imgPicker animated:YES];
            RELEASE(_imgPicker);
        }
            break;
    }
}

#pragma mark- 图片选择回调
- (void)imagePickerController:(DYBImagePickerController *)imagePickerController didFinishPickingMediaWithInfo:(id)info
{
    if([imagePickerController isKindOfClass:[DYBImagePickerController class]]){
        if(imagePickerController.allowsMultipleSelection) {
            NSArray *mediaInfoArray = (NSArray *)info;
            
            for (int i = 0; i < [mediaInfoArray count]; i++) {
                NSDictionary *dic = [mediaInfoArray objectAtIndex:i];
                UIImage *img = (UIImage *)[dic objectForKey:@"UIImagePickerControllerOriginalImage"];
                
                if (![_muA_SelPic containsObject:img]) {
                    [_muA_SelPic addObject:img];
                }
                
                if ([_muA_SelPic count] < 7) {
                    int nIndex = [_muA_SelPic count] -1;
                    MagicUIButton *btnPic = [[MagicUIButton alloc] initWithFrame:CGRectMake(7+nIndex*57, 7, CGRectGetWidth(_bt_addImg.frame), CGRectGetHeight(_bt_addImg.frame))];
                    [btnPic setBackgroundColor:[UIColor clearColor]];
                    [btnPic setImage:img forState:UIControlStateNormal];
                    btnPic.tag=-5;
                    [btnPic setContentMode:UIViewContentModeScaleToFill];
                    [btnPic addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside];
                    [_scrV_showImg addSubview:btnPic];
                    RELEASE(btnPic);
                }
                
                [_bt_addImg setFrame:CGRectMake(6+57*[_muA_SelPic count], 7, CGRectGetWidth(_bt_addImg.frame), CGRectGetHeight(_bt_addImg.frame))];
            }
            
            int nCount = [_muA_SelPic count];
            
            if (nCount >= 6) {
                [_bt_addImg setHidden:YES];
                [_scrV_showImg setScrollEnabled:YES];
                [_scrV_showImg setContentOffset:CGPointMake(64, 0) animated:YES];
            }else if (nCount == 5){
                [_scrV_showImg setScrollEnabled:YES];
                [_scrV_showImg setContentOffset:CGPointMake(64, 0) animated:YES];
            }
        } else {
            NSDictionary *mediaInfo = (NSDictionary *)info;
            NSLog(@"Selected: %@", mediaInfo);
        }
    }else if ([imagePickerController isKindOfClass:[UIImagePickerController class]]){
        
        _photoEditor = [[DYBPhotoEditorView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, self.view.bounds.size.height)];
        _photoEditor.ntype = 3;

        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];//获取图片
        if (((UIImagePickerController *)imagePickerController).sourceType == UIImagePickerControllerSourceTypeCamera)
        {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);//将拍到的图片保存到相册
        }
        
        if ((((UIImagePickerController *)imagePickerController).sourceType == UIImagePickerControllerSourceTypeCamera)) {
            [self manageImage:image];
            
        }
        
        [_photoEditor.imgRootView setCenter:CGPointMake(160.0f,self.view.bounds.size.height/2-25)];
        
        _photoEditor.imgRootView.image = _photoEditor.curImage;
        [self.view addSubview:_photoEditor];
        [self dismissModalViewControllerAnimated:YES];
        
        RELEASE(_photoEditor);

    }


    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)manageImage:(UIImage*)image{
    
    float ratX = image.size.width/320;
    float ratY = image.size.height/self.view.bounds.size.height;
    float lastRat =  1;
    
    if (ratX>ratY) {
        lastRat = ratX;
        [_photoEditor.imgRootView setFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, image.size.height*320/image.size.width)];
        UIImage *smallImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(self.view.bounds.size.width*2, image.size.height*320/image.size.width*2) interpolationQuality:kCGInterpolationDefault];
        _photoEditor.curImage = smallImage;
        
    }else{
        lastRat = ratY;
        [_photoEditor.imgRootView setFrame:CGRectMake(0.0f, 0.0f, image.size.width*self.view.bounds.size.height/image.size.height, self.view.bounds.size.height)];
        UIImage *smallImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(image.size.width*self.view.bounds.size.height/image.size.height*2, self.view.bounds.size.height*2) interpolationQuality:kCGInterpolationDefault];
        _photoEditor.curImage = smallImage;
        
    }
    
    _photoEditor.imgRootView.contentMode = UIViewContentModeScaleAspectFit;
    
}

#pragma mark- 接收 通知中心
- (void)handleNotification:(NSNotification *)notification
{
    if ([notification is:[DYBPhotoEditorView DOSAVEIMAGE]]){
        
        NSDictionary *dic = (NSDictionary *)[notification userInfo];
        NSInteger nType = [[dic objectForKey:@"type"] intValue];
        
        if (nType != 3) {
            return;
        }
        
        UIImage *img = (UIImage*)[notification object];
        
        if (![_muA_SelPic containsObject:img]) {
            [_muA_SelPic addObject:img];
        }
        
        if ([_muA_SelPic count] < 7) {
            int nIndex = [_muA_SelPic count] -1;
            MagicUIButton *btnPic = [[MagicUIButton alloc] initWithFrame:CGRectMake(7+nIndex*57, 7, 50, 50)];
            [btnPic setBackgroundColor:[UIColor clearColor]];
            [btnPic setImage:img forState:UIControlStateNormal];
            [btnPic setContentMode:UIViewContentModeScaleToFill];
            [btnPic addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside];
            btnPic.tag=-5;
            [_scrV_showImg addSubview:btnPic];
            RELEASE(btnPic);
        }
        
        [_bt_addImg setFrame:CGRectMake(6+57*[_muA_SelPic count], 7, 50, 50)];
        
        int nCount = [_muA_SelPic count];
        
        if (nCount >= 6) {
            [_bt_addImg setHidden:YES];
            [_scrV_showImg setScrollEnabled:YES];
            [_scrV_showImg setContentOffset:CGPointMake(64, 0) animated:YES];
        }else if (nCount == 5){
            [_scrV_showImg setScrollEnabled:YES];
            [_scrV_showImg setContentOffset:CGPointMake(64, 0) animated:YES];
        }
        
    }else if ([notification is:[DYBCheckImageViewController DELETEMAGE]])//删除
    {
        UIImage *img = (UIImage *)[notification object];
        [_muA_SelPic removeObject:img];
        
        for (MagicUIButton *btn in [_scrV_showImg subviews]) {
            if ([btn isKindOfClass:[MagicUIButton class]] && btn != _bt_addImg) {
                [btn removeFromSuperview];
            }
        }
        
        for (int i = 0; i < [_muA_SelPic count]; i++) {
            UIImage *imgSel = (UIImage *)[_muA_SelPic objectAtIndex:i];
            MagicUIButton *btnPic = [[MagicUIButton alloc] initWithFrame:CGRectMake(7+i*57, 7, 50, 50)];
            [btnPic setBackgroundColor:[UIColor clearColor]];
            [btnPic setImage:imgSel forState:UIControlStateNormal];
            [btnPic setContentMode:UIViewContentModeScaleToFill];
            [btnPic addSignal:[MagicUIButton TOUCH_UP_INSIDE] forControlEvents:UIControlEventTouchUpInside];
            btnPic.tag=-5;
            [_scrV_showImg addSubview:btnPic];
            RELEASE(btnPic);
        }
        
        [_bt_addImg setHidden:NO];
        [_bt_addImg setFrame:CGRectMake(6+57*[_muA_SelPic count], 7, 50, 50)];
        
        if ([_muA_SelPic count] == 5) {
            [_scrV_showImg setScrollEnabled:YES];
            [_scrV_showImg setContentOffset:CGPointMake(64, 0) animated:YES];
        }else if ([_muA_SelPic count] < 5){
            [_scrV_showImg setScrollEnabled:NO];
            [_scrV_showImg setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    }
}

#pragma mark- 网络
- (void)handleRequest:(MagicRequest *)request receiveObj:(id)receiveObj
{
    if ([request succeed]){
        if (request.tag == -1){/*发通知*/
            JsonResponse *respose =(JsonResponse *)receiveObj;
            
            if (respose.response == khttpsucceedCode){
                [self.drNavigationController popVCAnimated:YES];                
            }
        }
    }else if ([request failed]){
        
    }
}
@end
