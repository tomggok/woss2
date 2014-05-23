//
//  DYBAssetCollectionViewController.m
//  DYiBan
//
//  Created by Song on 13-9-6.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBAssetCollectionViewController.h"
#import "DYBImagePickerFooterView.h"
#import "DYBImagePickerAssetCell.h"
#import "DYBCustomLabel.h"
#import "UILabel+ReSize.h"
@interface DYBAssetCollectionViewController ()

@property (nonatomic, retain) NSMutableArray *assets;
@property (nonatomic, retain) NSMutableOrderedSet *selectedAssets;

@property (nonatomic, retain) MagicUITableView *tableView;
@property (nonatomic, retain) DYBCustomLabel *numLabel;
@property (nonatomic, retain) MagicUILabel *numLabel1;
@property (nonatomic, retain) UIBarButtonItem *doneButton;

- (void)reloadData;
- (void)updateRightBarButtonItem;
- (void)updateDoneButton;
- (void)done;
- (void)cancel;

@end

@implementation DYBAssetCollectionViewController

@synthesize  father = _father,title,numBack = _numBack;
- (void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal
{
    if ([signal is:[MagicViewController WILL_APPEAR]])
    {
        [self.headview setTitle:title];
        self.rightButton.hidden = !self.allowsMultipleSelection;
        [self setButtonImage:self.leftButton setImage:@"btn_back_def"];
        [self setButtonImage:self.rightButton setImage:@"btn_ok_dis"];
        
        [self willAppearView];
    }else if ([signal is:[MagicViewController CREATE_VIEWS]])
    {
        [self initView];
        
        
    }
    
}

- (void)initView {
    
    /* Initialization */
    self.assets = [NSMutableArray array];
    self.selectedAssets = [NSMutableOrderedSet orderedSet];
    
    self.imageSize = CGSizeMake(75, 75);
    
    UIImage *backImage = [UIImage imageNamed:@"bg_photo_number"];
    _numBack = [[UIView alloc]initWithFrame:CGRectMake(0, self.headHeight, backImage.size.width/2, backImage.size.height/2)];
    [_numBack setBackgroundColor:[UIColor colorWithPatternImage:backImage]];
    [self.view addSubview:_numBack];
    
    RELEASE(_numBack);
    
    
    _numLabel = [[DYBCustomLabel alloc]initWithFrame:CGRectMake(10, 0, 0, 57)];
    [self creatLabel:_numLabel fontSize:30];
    [_numBack addSubview:_numLabel];
    RELEASE(_numLabel);
    _numLabel.textAlignment = NSTextAlignmentCenter;
    
    
    
    _numLabel1 = [[MagicUILabel alloc]initWithFrame:CGRectMake(_numLabel.frame.size.width, 0, SCREEN_WIDTH-_numLabel.frame.size.width, 57)];
    _numLabel1.text = @"张图片";
    _numLabel1.textAlignment = NSTextAlignmentLeft;
    _numLabel1.textColor = ColorBlack;
    _numLabel1.backgroundColor = [UIColor clearColor];
    [_numBack addSubview:_numLabel1];
    RELEASE(_numLabel1);
    
    
    // Table View
    _tableView = [[MagicUITableView alloc] initWithFrame:CGRectMake(0, self.headHeight, SCREEN_WIDTH, SCREEN_HEIGHT-self.headHeight) isNeedUpdate:NO];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.allowsSelection = YES;
     [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 57)];
    _tableView.tableHeaderView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_tableView];
    [self.view bringSubviewToFront:_numBack];
    
    
    
    
    RELEASE(_tableView);
    
    

}

- (void)creatLabel:(DYBCustomLabel*)label fontSize:(int)size {
    
    label.font = [DYBShareinstaceDelegate DYBFoutStyle:size];  //字体和大小设置
    label.textColor = ColorBlack;
    label.backgroundColor = [UIColor clearColor];
    
    
}


- (void)willAppearView {
    
    // Reload
    [self reloadData];
    _numLabel.text = [@"" stringByAppendingFormat:@"%d",self.assets.count];
    [_numLabel sizeToFitByconstrainedSize:CGSizeMake(100/*最宽*/, 57)];
    _numLabel.frame = CGRectMake(_numLabel.frame.origin.x, (57-_numLabel.frame.size.height)/2+5, _numLabel.frame.size.width, _numLabel.frame.size.height);
    _numLabel1.frame = CGRectMake(_numLabel.frame.origin.x+_numLabel.frame.size.width, (57-_numLabel.frame.size.height)/2+5, SCREEN_WIDTH-_numLabel.frame.size.width, _numLabel.frame.size.height);
}


- (void)setShowsCancelButton:(BOOL)showsCancelButton
{
    _showsCancelButton = showsCancelButton;
    
    [self updateRightBarButtonItem];
}

- (void)setAllowsMultipleSelection:(BOOL)allowsMultipleSelection
{
    _allowsMultipleSelection = allowsMultipleSelection;
    
    [self updateRightBarButtonItem];
}


#pragma mark - Instance Methods

- (void)reloadData
{
    // Reload assets
    [self.assetsGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if(result) {
            [self.assets addObject:result];
        }
    }];
    
    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height) animated:NO];
    
    // Set footer view
    if(self.showsFooterDescription) {
        [self.assetsGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
        NSUInteger numberOfPhotos = self.assetsGroup.numberOfAssets;
        
        [self.assetsGroup setAssetsFilter:[ALAssetsFilter allVideos]];
        NSUInteger numberOfVideos = self.assetsGroup.numberOfAssets;
        
        switch(self.filterType) {
            case DYBImagePickerFilterTypeAllAssets:
                [self.assetsGroup setAssetsFilter:[ALAssetsFilter allAssets]];
                break;
            case DYBImagePickerFilterTypeAllPhotos:
                [self.assetsGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
                break;
            case DYBImagePickerFilterTypeAllVideos:
                [self.assetsGroup setAssetsFilter:[ALAssetsFilter allVideos]];
                break;
        }
        
        DYBImagePickerFooterView *footerView = [[DYBImagePickerFooterView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 48)];
        
        if(self.filterType == DYBImagePickerFilterTypeAllAssets) {
            footerView.titleLabel.text = [self.delegate assetCollectionViewController:self descriptionForNumberOfPhotos:numberOfPhotos numberOfVideos:numberOfVideos];
        } else if(self.filterType == DYBImagePickerFilterTypeAllPhotos) {
            footerView.titleLabel.text = [self.delegate assetCollectionViewController:self descriptionForNumberOfPhotos:numberOfPhotos];
        } else if(self.filterType == DYBImagePickerFilterTypeAllVideos) {
            footerView.titleLabel.text = [self.delegate assetCollectionViewController:self descriptionForNumberOfVideos:numberOfVideos];
        }
        
        self.tableView.tableFooterView = footerView;
        [footerView release];
    } else {
        DYBImagePickerFooterView *footerView = [[DYBImagePickerFooterView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 4)];
        
        self.tableView.tableFooterView = footerView;
        [footerView release];
    }
}

- (void)updateRightBarButtonItem
{
    if(self.allowsMultipleSelection) {
        // Set done button
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
        doneButton.enabled = NO;
        
        [self.navigationItem setRightBarButtonItem:doneButton animated:NO];
        self.doneButton = doneButton;
        [doneButton release];
    } else if(self.showsCancelButton) {
        // Set cancel button
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
        
        [self.navigationItem setRightBarButtonItem:cancelButton animated:NO];
        [cancelButton release];
    } else {
        [self.navigationItem setRightBarButtonItem:nil animated:NO];
    }
}

- (void)updateDoneButton
{
    if(self.limitsMinimumNumberOfSelection) {
        self.doneButton.enabled = (self.selectedAssets.count >= self.minimumNumberOfSelection);
    } else {
        self.doneButton.enabled = (self.selectedAssets.count > 0);
        if (self.doneButton.enabled) {
            [self setButtonImage:self.rightButton setImage:@"btn_ok_def"];
        }else {
            
            [self setButtonImage:self.rightButton setImage:@"btn_ok_dis"];
        }
    
    }
}

#pragma mark- 
- (void)handleViewSignal_DYBBaseViewController:(MagicViewSignal *)signal
{
    MagicUIButton *btn = signal.source;
    if ([signal is:[DYBBaseViewController BACKBUTTON]])
    {
        [self.drNavigationController popViewControllerAnimated:YES];
        
    }
    
    if ([signal is:[DYBBaseViewController NEXTSTEPBUTTON]])
    {
        if (btn.imageView.image == [UIImage imageNamed:@"btn_ok_dis"]) {
            
        }else{
            [self.delegate assetCollectionViewController:self didFinishPickingAssets:self.selectedAssets.array];
            [self.drNavigationController popToViewController:_father animated:YES];
            
        }
        
        
    }
    
    
}


- (void)cancel
{
    [self.delegate assetCollectionViewControllerDidCancel:self];
}


#pragma mark - UITableViewDataSource


- (void)handleViewSignal_MagicUITableView:(MagicViewSignal *)signal
{
    if ([signal is:[MagicUITableView TABLENUMROWINSEC]])/*numberOfRowsInSection*/{
        
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSString *section = [dict objectForKey:@"section"];
        NSInteger numberOfRowsInSection = 0;
        
        switch([section intValue]) {
            case 0: case 1:
            {
                if(self.allowsMultipleSelection && !self.limitsMaximumNumberOfSelection && self.showsHeaderButton) {
                    numberOfRowsInSection = 1;
                }
            }
                break;
            case 2:
            {
                NSInteger numberOfAssetsInRow = self.view.bounds.size.width / self.imageSize.width;
                numberOfRowsInSection = self.assets.count / numberOfAssetsInRow;
                if((self.assets.count - numberOfRowsInSection * numberOfAssetsInRow) > 0) numberOfRowsInSection++;
            }
                break;
        }
        
        NSNumber *s = [NSNumber numberWithInteger:numberOfRowsInSection];
        [signal setReturnValue:s];
        
    }else if([signal is:[MagicUITableView TABLENUMOFSEC]])/*numberOfSectionsInTableView*/{
        NSNumber *s = [NSNumber numberWithInteger:3];
        [signal setReturnValue:s];
        
    }else if([signal is:[MagicUITableView TABLEHEIGHTFORROW]])/*heightForRowAtIndexPath*/{
        
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        CGFloat heightForRow = 0;
        
        switch(indexPath.section) {
            case 0:
            {
                heightForRow = 44;
            }
                break;
            case 1:
            {
                heightForRow = 1;
            }
                break;
            case 2:
            {
                NSInteger numberOfAssetsInRow = self.view.bounds.size.width / self.imageSize.width;
                CGFloat margin = round((self.view.bounds.size.width - self.imageSize.width * numberOfAssetsInRow) / (numberOfAssetsInRow + 1));
                heightForRow = margin + self.imageSize.height;
            }
                break;
        }
        
        NSNumber *s = [NSNumber numberWithInteger:heightForRow];
        [signal setReturnValue:s];
        
    }else if([signal is:[MagicUITableView TABLETHEIGHTFORHEADERINSECTION]])/*heightForHeaderInSection*/{
        [signal setReturnValue:[NSNumber numberWithFloat:0.0]];
        
    }else if([signal is:[MagicUITableView TABLECELLFORROW]])/*cell*/{
        
    
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        NSString *cellIdentifier = @"AssetCell";
        DYBImagePickerAssetCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        
        if(cell == nil) {
            NSInteger numberOfAssetsInRow = self.view.bounds.size.width / self.imageSize.width;
            CGFloat margin = round((self.view.bounds.size.width - self.imageSize.width * numberOfAssetsInRow) / (numberOfAssetsInRow + 1));
            
            cell = [[[DYBImagePickerAssetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier imageSize:self.imageSize numberOfAssets:numberOfAssetsInRow margin:margin] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [(DYBImagePickerAssetCell *)cell setDelegate:self];
            [(DYBImagePickerAssetCell *)cell setAllowsMultipleSelection:self.allowsMultipleSelection];
        }
        
        // Set assets
        NSInteger numberOfAssetsInRow = self.view.bounds.size.width / self.imageSize.width;
        NSInteger offset = numberOfAssetsInRow * indexPath.row;
        NSInteger numberOfAssetsToSet = (offset + numberOfAssetsInRow > self.assets.count) ? (self.assets.count - offset) : numberOfAssetsInRow;
        
        NSMutableArray *assets = [NSMutableArray array];
        for(NSUInteger i = 0; i < numberOfAssetsToSet; i++) {
            ALAsset *asset = [self.assets objectAtIndex:(offset + i)];
            
            [assets addObject:asset];
        }
        
        [(DYBImagePickerAssetCell *)cell setAssets:assets];
        
        // Set selection states
        for(NSUInteger i = 0; i < numberOfAssetsToSet; i++) {
            ALAsset *asset = [self.assets objectAtIndex:(offset + i)];
            
            if([self.selectedAssets containsObject:asset]) {
                [(DYBImagePickerAssetCell *)cell selectAssetAtIndex:i];
            } else {
                [(DYBImagePickerAssetCell *)cell deselectAssetAtIndex:i];
            }
        }

        [signal setReturnValue:cell];
        
        
    }else if([signal is:[MagicUITableView TABLEDIDSELECT]])/*选中cell*/{
        
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        if(indexPath.section == 0 && indexPath.row == 0) {
            if(self.selectedAssets.count == self.assets.count) {
                // Deselect all assets
                [self.selectedAssets removeAllObjects];
            } else {
                // Select all assets
                [self.selectedAssets addObjectsFromArray:self.assets];
            }
            
            // Set done button state
            [self updateDoneButton];
            
            // Update assets
            [_tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
            
            // Update header text
            [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
            
            // Cancel table view selection
            [_tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
        
    }
    
}


#pragma mark - QBImagePickerAssetCellDelegate

- (BOOL)assetCell:(DYBImagePickerAssetCell *)assetCell canSelectAssetAtIndex:(NSUInteger)index
{
    BOOL canSelect = YES;
    
    if(self.allowsMultipleSelection && self.limitsMaximumNumberOfSelection) {
        canSelect = (self.selectedAssets.count < self.maximumNumberOfSelection);
    }
    
    return canSelect;
}

- (void)assetCell:(DYBImagePickerAssetCell *)assetCell didChangeAssetSelectionState:(BOOL)selected atIndex:(NSUInteger)index
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:assetCell];
    
    NSInteger numberOfAssetsInRow = self.view.bounds.size.width / self.imageSize.width;
    NSInteger assetIndex = indexPath.row * numberOfAssetsInRow + index;
    ALAsset *asset = [self.assets objectAtIndex:assetIndex];
    
    if(self.allowsMultipleSelection) {
        if(selected) {
            [self.selectedAssets addObject:asset];
        } else {
            [self.selectedAssets removeObject:asset];
        }
        
        // Set done button state
        [self updateDoneButton];
        
        // Update header text
        if((selected && self.selectedAssets.count == self.assets.count) ||
           (!selected && self.selectedAssets.count == self.assets.count - 1)) {
        }
    } else {
        [self.delegate assetCollectionViewController:self didFinishPickingAsset:asset];
        [self.drNavigationController popToViewController:_father animated:YES];
    }
}


@end
