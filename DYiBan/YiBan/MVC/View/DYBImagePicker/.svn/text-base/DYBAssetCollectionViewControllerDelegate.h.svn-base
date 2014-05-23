//
//  DYBAssetCollectionViewControllerDelegate.h
//  DYiBan
//
//  Created by Song on 13-9-6.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

@class DYBAssetCollectionViewController;

@protocol DYBAssetCollectionViewControllerDelegate <NSObject>

@required
- (void)assetCollectionViewController:(DYBAssetCollectionViewController *)assetCollectionViewController didFinishPickingAsset:(ALAsset *)asset;
- (void)assetCollectionViewController:(DYBAssetCollectionViewController *)assetCollectionViewController didFinishPickingAssets:(NSArray *)assets;
- (void)assetCollectionViewControllerDidCancel:(DYBAssetCollectionViewController *)assetCollectionViewController;
- (NSString *)descriptionForSelectingAllAssets:(DYBAssetCollectionViewController *)assetCollectionViewController;
- (NSString *)assetCollectionViewController:(DYBAssetCollectionViewController *)assetCollectionViewController descriptionForNumberOfPhotos:(NSUInteger)numberOfPhotos;
- (NSString *)assetCollectionViewController:(DYBAssetCollectionViewController *)assetCollectionViewController descriptionForNumberOfVideos:(NSUInteger)numberOfVideos;
- (NSString *)assetCollectionViewController:(DYBAssetCollectionViewController *)assetCollectionViewController descriptionForNumberOfPhotos:(NSUInteger)numberOfPhotos numberOfVideos:(NSUInteger)numberOfVideos;

@end
