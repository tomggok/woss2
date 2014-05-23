//
//  DYBImagePickerAssetCell.h
//  DYiBan
//
//  Created by Song on 13-9-6.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

// Delegate
#import "DYBImagePickerAssetCellDelegate.h"
#import "DYBImagePickerAssetViewDelegate.h"


@interface DYBImagePickerAssetCell : UITableViewCell<DYBImagePickerAssetViewDelegate>

@property (nonatomic, assign) id<DYBImagePickerAssetCellDelegate> delegate;
@property (nonatomic, copy) NSArray *assets;
@property (nonatomic, assign) CGSize imageSize;
@property (nonatomic, assign) NSUInteger numberOfAssets;
@property (nonatomic, assign) CGFloat margin;
@property (nonatomic, assign) BOOL allowsMultipleSelection;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier imageSize:(CGSize)imageSize numberOfAssets:(NSUInteger)numberOfAssets margin:(CGFloat)margin;

- (void)selectAssetAtIndex:(NSUInteger)index;
- (void)deselectAssetAtIndex:(NSUInteger)index;
- (void)selectAllAssets;
- (void)deselectAllAssets;

@end
