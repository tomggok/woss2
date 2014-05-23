//
//  DYBImagePickerController.h
//  DYiBan
//
//  Created by Song on 13-9-6.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

// Delegate
#import "DYBAssetCollectionViewControllerDelegate.h"
typedef enum {
    DYBImagePickerFilterTypeAllAssets,//
    DYBImagePickerFilterTypeAllPhotos,//图片
    DYBImagePickerFilterTypeAllVideos//视频
} DYBImagePickerFilterType;

@class DYBImagePickerController;
@protocol DYBImagePickerControllerDelegate <NSObject>

@optional
- (void)imagePickerControllerWillFinishPickingMedia:(DYBBaseViewController *)imagePickerController;
- (void)imagePickerController:(DYBBaseViewController *)imagePickerController didFinishPickingMediaWithInfo:(id)info;
- (void)imagePickerControllerDidCancel:(DYBBaseViewController *)imagePickerController;
- (NSString *)descriptionForSelectingAllAssets:(DYBBaseViewController *)imagePickerController;
- (NSString *)imagePickerController:(DYBBaseViewController *)imagePickerController descriptionForNumberOfPhotos:(NSUInteger)numberOfPhotos;
- (NSString *)imagePickerController:(DYBBaseViewController *)imagePickerController descriptionForNumberOfVideos:(NSUInteger)numberOfVideos;
- (NSString *)imagePickerController:(DYBBaseViewController *)imagePickerController descriptionForNumberOfPhotos:(NSUInteger)numberOfPhotos numberOfVideos:(NSUInteger)numberOfVideos;

@end

@interface DYBImagePickerController : DYBBaseViewController <DYBAssetCollectionViewControllerDelegate>

@property (nonatomic, assign) id<DYBImagePickerControllerDelegate> delegate;
@property (nonatomic, assign) id father;
@property (nonatomic, assign) DYBImagePickerFilterType filterType;
@property (nonatomic, assign) BOOL showsCancelButton;

@property (nonatomic, assign) BOOL allowsMultipleSelection;
@property (nonatomic, assign) BOOL limitsMinimumNumberOfSelection;
@property (nonatomic, assign) BOOL limitsMaximumNumberOfSelection;
@property (nonatomic, assign) NSUInteger minimumNumberOfSelection;
@property (nonatomic, assign) NSUInteger maximumNumberOfSelection;

@end
