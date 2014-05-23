
#import "Cell1.h"

@implementation Cell1{

    UIImageView *imageIcon;

}
@synthesize titleLabel,arrowImageView;

- (void)dealloc
{
    self.titleLabel = nil;
    self.arrowImageView = nil;
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
        [self creatCell];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)changeArrowWithUp:(BOOL)up
{
    if (up) {
        self.arrowImageView.image = [UIImage imageNamed:@"UpAccessory.png"];
    }else
    {
        self.arrowImageView.image = [UIImage imageNamed:@"DownAccessory.png"];
    }
}

-(void)creatCell{

    
    UIImage *image = [UIImage imageNamed:@"icon5"];
    imageIcon = [[UIImageView alloc]initWithFrame:CGRectMake(5.0f, 15.0f+ 2, image.size.width/2, image.size.height/2)];
    [self addSubview:imageIcon];
    RELEASE(imageIcon);
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5 + image.size.width/2 + 5, 3.0f, 150.0f, 50.0f)];
    [self addSubview:titleLabel];
     [titleLabel setTextColor:ColorGryWhite];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    RELEASE(titleLabel);
    
    arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(200.0f, 5.0f, 50.0f, 50.0f)];
    [arrowImageView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:arrowImageView];
    RELEASE(arrowImageView);
    
    UIImageView *imageViewFen = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 59.0f, 320.0f, 1)];
    [imageViewFen setImage:[UIImage imageNamed:@"个人中心_line"]];
    [self addSubview:imageViewFen];
    RELEASE(imageViewFen);

}

-(void)setIconImage:(int)num{

    switch (num) {
        case 0:
            [imageIcon setImage:[UIImage imageNamed:@"icon5"]];
            break;
        case 1:
            [imageIcon setImage:[UIImage imageNamed:@"icon1"]];
            break;
        case 2:
            [imageIcon setImage:[UIImage imageNamed:@"icon2"]];
            break;
        case 3:
            [imageIcon setImage:[UIImage imageNamed:@"icon3"]];
            break;
        case 4:
            [imageIcon setImage:[UIImage imageNamed:@"icon4"]];
            break;
        case 5:{
            
            UIImage *image = [UIImage imageNamed:@"箭头_right"];
        
            [imageIcon setFrame:CGRectMake(25.0f, 15.0f+ 10, image.size.width/2, image.size.height/2)];
            [imageIcon setImage:[UIImage imageNamed:@"箭头_right"]];
            [titleLabel sizeToFit];
            [titleLabel setFrame:CGRectMake(30 + 5, 20.0f, 150.0f, 20.0f)];
            [titleLabel setBackgroundColor:[UIColor clearColor]];
            break;
        }
        default:
            break;
    }

}

@end
