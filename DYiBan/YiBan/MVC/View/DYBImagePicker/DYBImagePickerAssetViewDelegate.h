//
//  DYBImagePickerAssetViewDelegate.h
//  DYiBan
//
//  Created by Song on 13-9-6.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

@class DYBImagePickerAssetView;

@protocol DYBImagePickerAssetViewDelegate <NSObject>

@required
- (BOOL)assetViewCanBeSelected:(DYBImagePickerAssetView *)assetView;
- (void)assetView:(DYBImagePickerAssetView *)assetView didChangeSelectionState:(BOOL)selected;

@end