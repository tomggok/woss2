//
//  DYBImagePickerAssetView.h
//  DYiBan
//
//  Created by Song on 13-9-6.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class DYBImagePickerAssetView;

@protocol DYBImagePickerAssetViewDelegate <NSObject>

@required
- (BOOL)assetViewCanBeSelected:(DYBImagePickerAssetView *)assetView;
- (void)assetView:(DYBImagePickerAssetView *)assetView didChangeSelectionState:(BOOL)selected;

@end

@interface DYBImagePickerAssetView : UIView

@property (nonatomic, assign) id<DYBImagePickerAssetViewDelegate> delegate;
@property (nonatomic, retain) ALAsset *asset;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) BOOL allowsMultipleSelection;

@end
