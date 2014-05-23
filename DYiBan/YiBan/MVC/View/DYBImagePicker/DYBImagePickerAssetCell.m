//
//  DYBImagePickerAssetCell.m
//  DYiBan
//
//  Created by Song on 13-9-6.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBImagePickerAssetCell.h"
#import "DYBImagePickerAssetView.h"
@interface DYBImagePickerAssetCell ()

- (void)addAssetViews;

@end

@implementation DYBImagePickerAssetCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier imageSize:(CGSize)imageSize numberOfAssets:(NSUInteger)numberOfAssets margin:(CGFloat)margin
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self) {
        self.imageSize = imageSize;
        self.numberOfAssets = numberOfAssets;
        self.margin = margin;
        
        [self addAssetViews];
    }
    
    return self;
}

- (void)setAssets:(NSArray *)assets
{
    [_assets release];
    _assets = [assets retain];
    
    // Set assets
    for(NSUInteger i = 0; i < self.numberOfAssets; i++) {
        DYBImagePickerAssetView *assetView = (DYBImagePickerAssetView *)[self.contentView viewWithTag:(1 + i)];
        
        if(i < self.assets.count) {
            assetView.hidden = NO;
            
            assetView.asset = [self.assets objectAtIndex:i];
        } else {
            assetView.hidden = YES;
        }
    }
}

- (void)setAllowsMultipleSelection:(BOOL)allowsMultipleSelection
{
    _allowsMultipleSelection = allowsMultipleSelection;
    
    // Set property
    for(UIView *subview in self.contentView.subviews) {
        if([subview isMemberOfClass:[DYBImagePickerAssetView class]]) {
            [(DYBImagePickerAssetView *)subview setAllowsMultipleSelection:self.allowsMultipleSelection];
        }
    }
}

- (void)dealloc
{
    [_assets release];
    
    [super dealloc];
}


#pragma mark - Instance Methods

- (void)addAssetViews
{
    // Remove all asset views
    for(UIView *subview in self.contentView.subviews) {
        if([subview isMemberOfClass:[DYBImagePickerAssetView class]]) {
            [subview removeFromSuperview];
        }
    }
    
    // Add asset views
    for(NSUInteger i = 0; i < self.numberOfAssets; i++) {
        // Calculate frame
        CGFloat offset = (self.margin + self.imageSize.width) * i;
        CGRect assetViewFrame = CGRectMake(offset + self.margin, self.margin, self.imageSize.width, self.imageSize.height);
        
        // Add asset view
        DYBImagePickerAssetView *assetView = [[DYBImagePickerAssetView alloc] initWithFrame:assetViewFrame];
        assetView.delegate = self;
        assetView.tag = 1 + i;
        assetView.autoresizingMask = UIViewAutoresizingNone;
        
        [self.contentView addSubview:assetView];
        [assetView release];
    }
}

- (void)selectAssetAtIndex:(NSUInteger)index
{
    DYBImagePickerAssetView *assetView = (DYBImagePickerAssetView *)[self.contentView viewWithTag:(index + 1)];
    assetView.selected = YES;
}

- (void)deselectAssetAtIndex:(NSUInteger)index
{
    DYBImagePickerAssetView *assetView = (DYBImagePickerAssetView *)[self.contentView viewWithTag:(index + 1)];
    assetView.selected = NO;
}

- (void)selectAllAssets
{
    for(UIView *subview in self.contentView.subviews) {
        if([subview isMemberOfClass:[DYBImagePickerAssetView class]]) {
            if(![(DYBImagePickerAssetView *)subview isHidden]) {
                [(DYBImagePickerAssetView *)subview setSelected:YES];
            }
        }
    }
}

- (void)deselectAllAssets
{
    for(UIView *subview in self.contentView.subviews) {
        if([subview isMemberOfClass:[DYBImagePickerAssetView class]]) {
            if(![(DYBImagePickerAssetView *)subview isHidden]) {
                [(DYBImagePickerAssetView *)subview setSelected:NO];
            }
        }
    }
}


#pragma mark - QBImagePickerAssetViewDelegate

- (BOOL)assetViewCanBeSelected:(DYBImagePickerAssetView *)assetView
{
    return [self.delegate assetCell:self canSelectAssetAtIndex:(assetView.tag - 1)];
}

- (void)assetView:(DYBImagePickerAssetView *)assetView didChangeSelectionState:(BOOL)selected
{
    [self.delegate assetCell:self didChangeAssetSelectionState:selected atIndex:(assetView.tag - 1)];
}
@end
