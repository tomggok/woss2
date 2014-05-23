
#import <UIKit/UIKit.h>

@interface Cell1 : UITableViewCell


@property (nonatomic,retain) UILabel *titleLabel;
@property (nonatomic,retain) UIImageView *arrowImageView;

- (void)changeArrowWithUp:(BOOL)up;
-(void)setIconImage:(int)num;
@end
