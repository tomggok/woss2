//
//  DYBNoteDetailViewController.h
//  DYiBan
//
//  Created by zhangchao on 13-10-28.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <CommonCrypto/CommonDigest.h>
#import <AudioToolbox/AudioSession.h>

#import "DYBBaseViewController.h"
#import "noteModel.h"
#import "DYBVariableTbvView.h"
#import "DYBPhotoEditorView.h"
#import "DYBImagePickerController.h"
//#import "SoundOperateRecoder.h"
#import "DYBAudioProgressView.h"

#define k_recodeTimeKey @"recodeTimeKey" //记录录音时间
#define k_recodeTimeValue 0 //记录录音时间


//笔记详情|笔记编辑|新建笔记
@interface DYBNoteDetailViewController : DYBBaseViewController <UIImagePickerControllerDelegate,DYBImagePickerControllerDelegate,AVAudioPlayerDelegate,AVAudioRecorderDelegate>
{
    MagicUIButton *_bt_Right;
    DYBBaseView *_v_dropDown/*下拉view*/,*_v_dropUp/*非编辑模式下底部上拉view*/;
//    MagicUIButton *_bt_more[5]/*下拉列表里的bt*/;
    MagicUIButton *_bt_edit,*_bt_share,*_bt_moveToDataBase,*_bt_star,*_bt_del/*,*_bt_cancelDropDown取消下拉view*//*,*_bt_AddTag添加标签*/,*_bt_audio,*_bt_photo/*相册*/,*_bt_camera/*拍照*/,*_bt_StartRecording/*开始录音*/,*_bt_stopRecording/*停止录音*/;
    noteModel *_model;
    DYBVariableTbvView *_tbvView;//封装的公用tbv
    MagicUIImageView *_v_dropUpInEditing/*编辑模式下底部上拉view*/;
    MagicUIScrollView *_scrV_back/*整体背景*/,*_scrV_Tip/*标签背景滚动*//*,*_scrV_Content文本非编辑状态时的滚动背景*/;
    MagicUITextView *_textView;
//    MagicUILabel *_lb_content/*文本展示时的lb*/;
    NSMutableArray *_muA_audioData/*音频数据*/,*_muA_ImgViewData/*图片数据*/,*_muA_audioView/*放音频视图*/,*_muA_showImgView/*放展示图视图*//*,*_muA_fid编辑笔记进来时音频和图片文件的ID,在点 右上角保存编辑修改时和最新的 文件IDS对比,如果给有新的文件,就调 notes_uploadfile 接口上传新文件*/;
    DYBPhotoEditorView *_photoEditor;
    
//    SoundOperateRecoder *recoder;//录音
    AVAudioRecorder*  recorder;
    NSString *_str_curRecordFilePath/*当前录音的文件路径*//*,*_str_curRecordFileName当前录音的文件名*/;
    int _recodeTime;
    NSTimer *_t_recodeTime;
    AVAudioPlayer *_audioPlayer;//音频播放器
    DYBAudioProgressView *_v_Progress;//进度条
    MagicUILabel *_lb_ProgressTime;//进度条时间
    
    int typeTop;
    NSString *userId;
    NSString *shareId;
    
    BOOL _isSaveRecordData;//是否保存录音数据
}

AS_SIGNAL(SELTAG)       //选择标签成功回调
AS_SIGNAL(DELNOTE)     //删除笔记回调

@property (nonatomic,retain) NSString *str_nid;//当前笔记ID*/
@property (nonatomic,assign) int typeTop;//当前类型 1是共享给我 2 我共享的*/
@property (nonatomic,retain) NSString *userId;//id
@property (nonatomic,retain) NSString *shareId;//取消共享的id
@property (nonatomic,assign) BOOL isEditing;//是否正在编辑状态
@property (nonatomic,retain) NSString *str_favorite;//刚进来时读接口得到的model的收藏值,退出时如果被改了,返回上一页后要刷新列表里对应model.favorite

-(void)initWithTags:(NSArray *)tag_list_info;

@end
