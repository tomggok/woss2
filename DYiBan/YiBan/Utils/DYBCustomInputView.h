//
//  inputView.h
//  Yiban
//
//  Created by 周 哲 on 12-11-22.
//
//

#import <UIKit/UIKit.h>
#import "Magic_UIButton.h"
#import "Magic_UITableView.h"


#ifndef k_offsite
#define k_offsite 3  //避免 多行时底部文字没和底部框对齐的偏移量
#endif

#ifndef k_tag_send
#define k_tag_send -1000
#endif

#ifndef k_tag_bt_Shade
#define k_tag_bt_Shade -1001 //取消按钮的tag
#endif

#ifndef k_H_ChineseItems 
#define k_H_ChineseItems 36 //中文输入时 中文选项的高
#endif

//自定义输入框
@interface DYBCustomInputView : UIView{
    
    MagicUITextView * _textV;
    MagicUIButton * _bt_send,*_bt_Shade/*用于点开后遮罩键盘外的区域*/;
    UIImageView *_imgV_input_bg;//UITextView的背景框

}

@property (nonatomic,retain)    MagicUITextView * textV;
@property (nonatomic,assign)    int i_contentType;//1.文字 2.位置 3.图片 4.语音


- (id)initWithFrame:(CGRect)frame input_bg:(UIImage *)input_bg placeHolder:(NSString *)placeHolder btSignal:(NSString *)btSignal/*发送按钮信号名*/;
- (id)initWithFrame:(CGRect)frame placeHolder:(NSString *)placeHolder;
-(void)initShadeBt;
-(BOOL)cancelInput;
-(BOOL)couldSend;
-(void)addkeyboardNotice;
-(void)sendSuccess;

@end
