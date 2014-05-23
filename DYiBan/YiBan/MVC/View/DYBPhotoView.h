//
//  PhotoViewController.h
//  Magic
//
//  Created by tom zeng on 12-11-12.
//
//

#import <UIKit/UIKit.h>

@interface DYBPhotoView : UIView
@property(nonatomic,retain)UIImageView *imageView;
@property(nonatomic,retain)UIImage *currentImage;
@property(nonatomic,retain)UIImageView *rootImageView;
@property(nonatomic,retain)id father;
-(void)intiView;
@end
