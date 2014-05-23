//
//  DYBAssetCollectionViewController.h
//  DYiBan
//
//  Created by Song on 13-9-6.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBBaseViewController.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>

// Delegate
#import "DYBAssetCollectionViewControllerDelegate.h"
#import "DYBImagePickerAssetCellDelegate.h"

// Controllers
#import "DYBImagePickerController.h"

@interface DYBAssetCollectionViewController : DYBBaseViewController<DYBImagePickerAssetCellDelegate>

@property (nonatomic, assign) id<DYBAssetCollectionViewControllerDelegate> delegate;
@property (nonatomic, assign) id father;
@property (nonatomic, retain) ALAssetsGroup *assetsGroup;

@property (nonatomic, assign) CGSize imageSize;
@property (nonatomic, assign) DYBImagePickerFilterType filterType;
@property (nonatomic, assign) BOOL showsCancelButton;
@property (nonatomic, assign) BOOL fullScreenLayoutEnabled;
@property (nonatomic, assign) BOOL showsHeaderButton;
@property (nonatomic, assign) BOOL showsFooterDescription;

@property (nonatomic, assign) BOOL allowsMultipleSelection;
@property (nonatomic, assign) BOOL limitsMinimumNumberOfSelection;
@property (nonatomic, assign) BOOL limitsMaximumNumberOfSelection;
@property (nonatomic, assign) NSUInteger minimumNumberOfSelection;
@property (nonatomic, assign) NSUInteger maximumNumberOfSelection;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) UIView *numBack;


@end
