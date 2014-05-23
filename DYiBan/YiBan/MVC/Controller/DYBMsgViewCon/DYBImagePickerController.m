//
//  DYBImagePickerController.m
//  DYiBan
//
//  Created by Song on 13-9-6.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DYBImagePickerController.h"
#import "DYBImagePickerGroupCell.h"
#import "DYBAssetCollectionViewController.h"
#import "DYBAssetCollectionViewControllerDelegate.h"
@interface DYBImagePickerController ()

@property (nonatomic, retain) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, retain) NSMutableArray *assetsGroups;

@property (nonatomic, retain) MagicUITableView *tableView;

- (void)cancel;
- (NSDictionary *)mediaInfoFromAsset:(ALAsset *)asset;

@end

@implementation DYBImagePickerController

@synthesize father = _father;

- (void)handleViewSignal_MagicViewController:(MagicViewSignal *)signal
{
    if ([signal is:[MagicViewController WILL_APPEAR]])
    {
        [self.rightButton setHidden:YES];
        [self.headview setTitle:@"本地照片"];
        [self setButtonImage:self.leftButton setImage:@"btn_back_def"];
        [self willAppearView];
    }else if ([signal is:[MagicViewController CREATE_VIEWS]])
    {
        [self initView];
        [self addSubView];
        
        
    }
    
}

#pragma mark- 
- (void)handleViewSignal_DYBBaseViewController:(MagicViewSignal *)signal
{
    if ([signal is:[DYBBaseViewController BACKBUTTON]])
    {
        [self.drNavigationController popViewControllerAnimated:YES];
        
    }
    
    
}


- (void)initView {
    
    [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
    [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    
    /* Initialization */
    self.filterType = DYBImagePickerFilterTypeAllPhotos;
    
//    self.allowsMultipleSelection = NO;

    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    self.assetsLibrary = assetsLibrary;
    [assetsLibrary release];
    
    self.assetsGroups = [NSMutableArray array];
    
    // Table View
    _tableView = [[MagicUITableView alloc] initWithFrame:CGRectMake(0, self.headHeight, SCREEN_WIDTH, SCREEN_HEIGHT-self.headHeight) isNeedUpdate:NO];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self setExtraCellLineHidden:self.tableView];
    [self.view addSubview:_tableView];
    RELEASE(_tableView);
}


- (void)addSubView {
    void (^assetsGroupsEnumerationBlock)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *assetsGroup, BOOL *stop) {
        if(assetsGroup) {
            switch(self.filterType) {
                case DYBImagePickerFilterTypeAllAssets:
                    [assetsGroup setAssetsFilter:[ALAssetsFilter allAssets]];
                    break;
                case DYBImagePickerFilterTypeAllPhotos:
                    [assetsGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
                    break;
                case DYBImagePickerFilterTypeAllVideos:
                    [assetsGroup setAssetsFilter:[ALAssetsFilter allVideos]];
                    break;
            }
            
            if(assetsGroup.numberOfAssets > 0) {
                [self.assetsGroups addObject:assetsGroup];
                [self.tableView reloadData];
            }
        }
    };
    
    void (^assetsGroupsFailureBlock)(NSError *) = ^(NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
    };
    
    // Enumerate Camera Roll
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:assetsGroupsEnumerationBlock failureBlock:assetsGroupsFailureBlock];
    
    // Photo Stream
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupPhotoStream usingBlock:assetsGroupsEnumerationBlock failureBlock:assetsGroupsFailureBlock];
    
    // Album
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:assetsGroupsEnumerationBlock failureBlock:assetsGroupsFailureBlock];
    
    // Event
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupEvent usingBlock:assetsGroupsEnumerationBlock failureBlock:assetsGroupsFailureBlock];
    
    // Faces
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupFaces usingBlock:assetsGroupsEnumerationBlock failureBlock:assetsGroupsFailureBlock];

    
}

- (void)willAppearView {
    
     [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

#pragma mark - Instance Methods

- (void)cancel
{
    if([self.delegate respondsToSelector:@selector(imagePickerControllerDidCancel:)]) {
        [self.delegate imagePickerControllerDidCancel:self];
    }
}

- (NSDictionary *)mediaInfoFromAsset:(ALAsset *)asset
{
    NSMutableDictionary *mediaInfo = [NSMutableDictionary dictionary];
    [mediaInfo setObject:[asset valueForProperty:ALAssetPropertyType] forKey:@"UIImagePickerControllerMediaType"];
    [mediaInfo setObject:[UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]] forKey:@"UIImagePickerControllerOriginalImage"];
    [mediaInfo setObject:[[asset valueForProperty:ALAssetPropertyURLs] valueForKey:[[[asset valueForProperty:ALAssetPropertyURLs] allKeys] objectAtIndex:0]] forKey:@"UIImagePickerControllerReferenceURL"];
    
    return mediaInfo;
}


#pragma mark - UITableViewDataSource


- (void)handleViewSignal_MagicUITableView:(MagicViewSignal *)signal
{
    if ([signal is:[MagicUITableView TABLENUMROWINSEC]])/*numberOfRowsInSection*/{
        NSNumber *s = [NSNumber numberWithInteger:self.assetsGroups.count];
        [signal setReturnValue:s];
        
    }else if([signal is:[MagicUITableView TABLENUMOFSEC]])/*numberOfSectionsInTableView*/{
        NSNumber *s = [NSNumber numberWithInteger:1];
        [signal setReturnValue:s];
        
    }else if([signal is:[MagicUITableView TABLEHEIGHTFORROW]])/*heightForRowAtIndexPath*/{
       
        NSNumber *s = [NSNumber numberWithInteger:56];
        [signal setReturnValue:s];
        
    }else if([signal is:[MagicUITableView TABLETHEIGHTFORHEADERINSECTION]])/*heightForHeaderInSection*/{
        [signal setReturnValue:[NSNumber numberWithFloat:0.0]];
        
    }else if([signal is:[MagicUITableView TABLECELLFORROW]])/*cell*/{
        
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        static NSString *cellIdentifier = @"Cell";
        DYBImagePickerGroupCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if(cell == nil) {
            cell = [[[DYBImagePickerGroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        ALAssetsGroup *assetsGroup = [self.assetsGroups objectAtIndex:indexPath.row];
        
        cell.imageView.image = [UIImage imageWithCGImage:assetsGroup.posterImage];
        cell.titleLabel.text = [NSString stringWithFormat:@"%@", [assetsGroup valueForProperty:ALAssetsGroupPropertyName]];
        cell.countLabel.text = [NSString stringWithFormat:@"(%d)", assetsGroup.numberOfAssets];
        
        UIColor* color = ColorDivLine;//通过RGB来定义颜色
        cell.selectedBackgroundView=[[[UIView alloc]initWithFrame:cell.frame]autorelease];
        cell.selectedBackgroundView.backgroundColor=color;
        
        
        [signal setReturnValue:cell];
        
        
    }else if([signal is:[MagicUITableView TABLEDIDSELECT]])/*选中cell*/{
        
        NSDictionary *dict = (NSDictionary *)[signal object];
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        
        ALAssetsGroup *assetsGroup = [self.assetsGroups objectAtIndex:indexPath.row];
        
        
        BOOL showsFooterDescription = NO;
        
        switch(self.filterType) {
            case DYBImagePickerFilterTypeAllAssets:
                showsFooterDescription = ([self.delegate respondsToSelector:@selector(imagePickerController:descriptionForNumberOfPhotos:numberOfVideos:)]);
                break;
            case DYBImagePickerFilterTypeAllPhotos:
                showsFooterDescription = ([self.delegate respondsToSelector:@selector(imagePickerController:descriptionForNumberOfPhotos:)]);
                break;
            case DYBImagePickerFilterTypeAllVideos:
                showsFooterDescription = ([self.delegate respondsToSelector:@selector(imagePickerController:descriptionForNumberOfVideos:)]);
                break;
        }
        
        [self.drNavigationController pushViewController:[self creatAssetCollection:assetsGroup] animated:YES];
        RELEASE([self creatAssetCollection:assetsGroup]);
    }
    
}

- (DYBAssetCollectionViewController *)creatAssetCollection:(ALAssetsGroup*)assetsGroup{
    
    DYBAssetCollectionViewController *assetCollectionViewController = [[DYBAssetCollectionViewController alloc] init];
    assetCollectionViewController.title = [assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    assetCollectionViewController.delegate = self;
    assetCollectionViewController.assetsGroup = assetsGroup;
    [assetCollectionViewController setTitle:[assetsGroup valueForProperty:ALAssetsGroupPropertyName]];
    assetCollectionViewController.filterType = self.filterType;
    assetCollectionViewController.allowsMultipleSelection = self.allowsMultipleSelection;
    assetCollectionViewController.limitsMinimumNumberOfSelection = self.limitsMinimumNumberOfSelection;
    assetCollectionViewController.limitsMaximumNumberOfSelection = self.limitsMaximumNumberOfSelection;
    assetCollectionViewController.minimumNumberOfSelection = self.minimumNumberOfSelection;
    assetCollectionViewController.maximumNumberOfSelection = self.maximumNumberOfSelection;
    [assetCollectionViewController setFather:_father];
    
    return assetCollectionViewController;
}

- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [view release];
}

#pragma mark - QBAssetCollectionViewControllerDelegate

- (void)assetCollectionViewController:(DYBAssetCollectionViewController *)assetCollectionViewController didFinishPickingAsset:(ALAsset *)asset
{
    if([self.delegate respondsToSelector:@selector(imagePickerControllerWillFinishPickingMedia:)]) {
        [self.delegate imagePickerControllerWillFinishPickingMedia:self];
    }
    
    if([self.delegate respondsToSelector:@selector(imagePickerController:didFinishPickingMediaWithInfo:)]) {
        [self.delegate imagePickerController:self didFinishPickingMediaWithInfo:[self mediaInfoFromAsset:asset]];
    }
}

- (void)assetCollectionViewController:(DYBAssetCollectionViewController *)assetCollectionViewController didFinishPickingAssets:(NSArray *)assets
{
    if([self.delegate respondsToSelector:@selector(imagePickerControllerWillFinishPickingMedia:)]) {
        [self.delegate imagePickerControllerWillFinishPickingMedia:self];
    }
    
    if([self.delegate respondsToSelector:@selector(imagePickerController:didFinishPickingMediaWithInfo:)]) {
        NSMutableArray *info = [NSMutableArray array];
        
        for(ALAsset *asset in assets) {
            [info addObject:[self mediaInfoFromAsset:asset]];
        }
        
        [self.delegate imagePickerController:self didFinishPickingMediaWithInfo:info];
    }
}

- (void)assetCollectionViewControllerDidCancel:(DYBAssetCollectionViewController *)assetCollectionViewController
{
    if([self.delegate respondsToSelector:@selector(imagePickerControllerDidCancel:)]) {
        [self.delegate imagePickerControllerDidCancel:self];
    }
}

- (NSString *)descriptionForSelectingAllAssets:(DYBAssetCollectionViewController *)assetCollectionViewController
{
    NSString *description = nil;
    
    if([self.delegate respondsToSelector:@selector(descriptionForSelectingAllAssets:)]) {
        description = [self.delegate descriptionForSelectingAllAssets:self];
    }
    
    return description;
}



- (NSString *)assetCollectionViewController:(DYBAssetCollectionViewController *)assetCollectionViewController descriptionForNumberOfPhotos:(NSUInteger)numberOfPhotos
{
    NSString *description = nil;
    
    if([self.delegate respondsToSelector:@selector(imagePickerController:descriptionForNumberOfPhotos:)]) {
        description = [self.delegate imagePickerController:self descriptionForNumberOfPhotos:numberOfPhotos];
    }
    
    return description;
}

- (NSString *)assetCollectionViewController:(DYBAssetCollectionViewController *)assetCollectionViewController descriptionForNumberOfVideos:(NSUInteger)numberOfVideos
{
    NSString *description = nil;
    
    if([self.delegate respondsToSelector:@selector(imagePickerController:descriptionForNumberOfVideos:)]) {
        description = [self.delegate imagePickerController:self descriptionForNumberOfVideos:numberOfVideos];
    }
    
    return description;
}

- (NSString *)assetCollectionViewController:(DYBAssetCollectionViewController *)assetCollectionViewController descriptionForNumberOfPhotos:(NSUInteger)numberOfPhotos numberOfVideos:(NSUInteger)numberOfVideos
{
    NSString *description = nil;
    
    if([self.delegate respondsToSelector:@selector(imagePickerController:descriptionForNumberOfPhotos:numberOfVideos:)]) {
        description = [self.delegate imagePickerController:self descriptionForNumberOfPhotos:numberOfPhotos numberOfVideos:numberOfVideos];
    }
    
    return description;
}

@end
