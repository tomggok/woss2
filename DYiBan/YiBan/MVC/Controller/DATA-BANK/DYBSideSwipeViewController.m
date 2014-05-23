//
//  SideSwipeViewController.m
//  Yiban
//
//  Created by Hyde.Xu on 13-2-27.
//
//

#import "DYBSideSwipeViewController.h"
#import "Dragon_UIButton.h"
#import "DYBDataBankShotView.h"


// By setting this to YES, you'll use gesture recognizers under 4.x and use the table's swipe to delete under 3.x
// By setting it to NO, you'll be using the table's swipe to delete under both 3.x and 4.x. This is what version 3 of the Twitter app does
// Swipe to delete on a table doesn't expose the direction of the swipe, so the animation will always be left to right
#define USE_GESTURE_RECOGNIZERS YES
// Bounce pixels define how many pixels the view is moved during the bounce animation
#define BOUNCE_PIXELS 0.0
// The first implemenation of this animated both the cell and the sideSwipeView.
// But this isn't exactly how the Twitter app does it. Instead it keeps the sideSwipeView behind the cell at x-offset of 0
// then animates in and out the cell content. The code has been updated to do it this way. If you preferred the old way
// set PUSH_STYLE_ANIMATION to YES and you'll get the older push style animation
#define PUSH_STYLE_ANIMATION NO

#define DEL_BKG_WIDTH 275

@interface DYBSideSwipeViewController (){
    
    UITableViewCell* _cell;
    UITapGestureRecognizer *tap;
    
    DragonUIButton *allBtn[5];
    DragonUIButton *goodBtn[4];
    
}

@end

@implementation DYBSideSwipeViewController
DEF_SIGNAL(TOUCHBTN)
DEF_SIGNAL(OPEARTION)
@synthesize sideSwipeView, sideSwipeDirection, animatingSideSwipe,_tableview, sideSwipeCell,sender,type;
//@synthesize delegate;

- (void)dealloc
{
    //    [sideSwipeView release];
    //    [_tableview release];
    //    [sideSwipeCell release];
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)resetBKG{
    
    //    DEL_BKG_WIDTH = 286;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)initSwipeView:(UITableView *)tableview{
    animatingSideSwipe = NO;
    
    _tableview = tableview;
    
    self.sideSwipeView = [[UIView alloc] initWithFrame:CGRectMake(_tableview.frame.origin.x, _tableview.frame.origin.y, _tableview.frame.size.width, _tableview.rowHeight)];
    //    animatingSideSwipe = NO;
    
    [self setupGestureRecognizers];
    [self setupSideSwipeView];
    [self.sideSwipeView release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupSideSwipeView
{
   
    self.sideSwipeView.backgroundColor = [UIColor colorWithRed: 248/255.0f green:248/255.0f blue:248/255.0f alpha:1.0f];
    
    UIColor *colorBKG = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"del_bgWide.png"]];
    UIView *viewBKG = [[UIView alloc] init];
    [viewBKG setTag:778];
    [viewBKG setBackgroundColor:colorBKG];
    [self.sideSwipeView addSubview:viewBKG];
    [viewBKG release];
    [colorBKG release];
    
    
    
    switch (self.type) {
            
        case allOperationsType:
        {
            [self creatAllBtn];
        
        }
            break;
        case onlyDELOperationType:
        {
            [self creatDELBtn];
//            [self creatAllBtn];
            
        }
            break;
        case onlyShareOperationType:
        {
            [self creratShareBtn];
            
        }
            break;
        case goodANDbelittleOperationType:
        {
            [self creatGoodBtn];
            
        }
            break;
        case shareANDDELOpeartionType:
        {
            
            [self creatShareANDDELBtn];
        }
            break;
            
        default:
            break;
    }
  
//    [self creatAllBtn];
    
    if (1) {
        [self forbidTouch];
    }
    
}
-(void)creatAllBtn{

    for (int i = 0; i < 5; i++) {
        allBtn[i] = [DragonUIButton buttonWithType:UIButtonTypeCustom];
        [allBtn[i] addTarget:self action:@selector(touchBtn:event:) forControlEvents:UIControlEventTouchUpInside];
        [allBtn[i] setFrame:CGRectMake(45 + i*CELL_BTN_WIDTH, 0.0f, CELL_BTN_WIDTH, CELL_BTN_HIGHT)];
        [allBtn[i] setTag:BTNTAG_SHARE + i];
        switch (i) {
            case 0:{
                [allBtn[i] setBackgroundImage:[UIImage imageNamed:@"file_share_def"] forState:UIControlStateNormal];
                
                [allBtn[i] setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateDisabled];
                [allBtn[i] setBackgroundImage:[UIImage imageNamed:@"file_share_high"] forState:UIControlStateHighlighted];
            }
                break;
            case 1:
            {

                [allBtn[i] setBackgroundImage:[UIImage imageNamed:@"file_move_def"] forState:UIControlStateNormal];
                [allBtn[i] setBackgroundImage:[UIImage imageNamed:@"file_move_dis"] forState:UIControlStateDisabled];
                [allBtn[i] setBackgroundImage:[UIImage imageNamed:@"file_move_high"] forState:UIControlStateHighlighted];
                
            }

                break;
            case 2:
            {
               
                [allBtn[i] setBackgroundImage:[UIImage imageNamed:@"file_rename_def"] forState:UIControlStateNormal];
                [allBtn[i] setBackgroundImage:[UIImage imageNamed:@"file_rename_dis"] forState:UIControlStateDisabled];
                [allBtn[i] setBackgroundImage:[UIImage imageNamed:@"file_rename_high"] forState:UIControlStateHighlighted];
                
            }

                break;
            case 3:
            {
                [allBtn[i] setBackgroundImage:[UIImage imageNamed:@"file_offline_def"] forState:UIControlStateNormal];
                [allBtn[i] setBackgroundImage:[UIImage imageNamed:@"file_offline_dis"] forState:UIControlStateDisabled];
                [allBtn[i] setBackgroundImage:[UIImage imageNamed:@"file_offline_high"] forState:UIControlStateHighlighted];
                
            }

                break;
            case 4:
            {
               
                [allBtn[i] setBackgroundImage:[UIImage imageNamed:@"file_del_def"] forState:UIControlStateNormal];
                [allBtn[i] setBackgroundImage:[UIImage imageNamed:@"file_del_dis"] forState:UIControlStateDisabled];
                [allBtn[i] setBackgroundImage:[UIImage imageNamed:@"file_del_high"] forState:UIControlStateHighlighted];
            }
                break;
                
            default:
                break;
        }
        
        [self.sideSwipeView addSubview: allBtn[i]];
    }


}

-(void)forbidTouch{

    for (int i = 1; i <= 4 ; i++) {
        [allBtn[i] setSelected:NO];
//        [allBtn[i] sett];
    }



}

-(void)creratShareBtn{
    DragonUIButton *shareBtn = [DragonUIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setTag:BTNTAG_SHARE];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"file_share_def"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(touchBtn:event:) forControlEvents:UIControlEventTouchUpInside];
    [shareBtn setFrame:CGRectMake((320 - 45 - CELL_BTN_WIDTH)/2 + 45, 0.0f  , CELL_BTN_WIDTH, CELL_BTN_HIGHT)];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateDisabled];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"file_share_high"] forState:UIControlStateHighlighted];
    [self.sideSwipeView addSubview:shareBtn];
}

-(void)creatDELBtn{

    DragonUIButton *shareBtn = [DragonUIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setTag:BTNTAG_DEL];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"file_del_def"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(touchBtn:event:) forControlEvents:UIControlEventTouchUpInside];
    [shareBtn setBackgroundColor:[UIColor clearColor]];
    [shareBtn setFrame:CGRectMake((320 - 45 - CELL_BTN_WIDTH)/2 + 45, 0.0f  , CELL_BTN_WIDTH, CELL_BTN_HIGHT)];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateDisabled];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"file_del_high"] forState:UIControlStateHighlighted];
    [self.sideSwipeView addSubview:shareBtn];

}


-(void)creatShareANDDELBtn{

    DragonUIButton *shareBtn = [DragonUIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setTag:BTNTAG_SHARE];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"file_offline_def"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(touchBtn:event:) forControlEvents:UIControlEventTouchUpInside];
    [shareBtn setFrame:CGRectMake(50, 0.0f, CELL_BTN_WIDTH, CELL_BTN_HIGHT)];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateDisabled];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"file_share_high"] forState:UIControlStateHighlighted];
    [self.sideSwipeView addSubview:shareBtn];
    
    
    DragonUIButton *delBtn = [DragonUIButton buttonWithType:UIButtonTypeCustom];
    [delBtn setTag:BTNTAG_DEL];
    [delBtn setBackgroundImage:[UIImage imageNamed:@"file_del_def"] forState:UIControlStateNormal];
    [delBtn addTarget:self action:@selector(touchBtn:event:) forControlEvents:UIControlEventTouchUpInside];
    [delBtn setFrame:CGRectMake((300 - CELL_BTN_WIDTH)/2, 0.0f, CELL_BTN_WIDTH, CELL_BTN_HIGHT)];
    [delBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateDisabled];
    [delBtn setBackgroundImage:[UIImage imageNamed:@"file_del_high"] forState:UIControlStateHighlighted];
    [self.sideSwipeView addSubview:delBtn];



}

-(void)creatGoodBtn{

    for (int i = 0; i < 4; i++) {
        allBtn[i] = [DragonUIButton buttonWithType:UIButtonTypeCustom];
        [allBtn[i] addTarget:self action:@selector(touchBtn:event:) forControlEvents:UIControlEventTouchUpInside];
        [allBtn[i] setFrame:CGRectMake(45 + i*CELL_BTN_WIDTH, 0.0f, CELL_BTN_WIDTH, CELL_BTN_HIGHT)];
        [allBtn[i] setTag:BTNTAG_SHARE + i];
        switch (i) {
            case 0:{
                [allBtn[i] setBackgroundImage:[UIImage imageNamed:@"file_share_def"] forState:UIControlStateNormal];
                
                [allBtn[i] setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateDisabled];
                [allBtn[i] setBackgroundImage:[UIImage imageNamed:@"file_share_high"] forState:UIControlStateHighlighted];
            }
                break;
            case 1:
            {
                
                [allBtn[i] setBackgroundImage:[UIImage imageNamed:@"file_move_def"] forState:UIControlStateNormal];
                [allBtn[i] setBackgroundImage:[UIImage imageNamed:@"file_move_dis"] forState:UIControlStateDisabled];
                [allBtn[i] setBackgroundImage:[UIImage imageNamed:@"file_move_high"] forState:UIControlStateHighlighted];
                
            }
                
                break;
            case 2:
            {
                
                [allBtn[i] setBackgroundImage:[UIImage imageNamed:@"file_rename_def"] forState:UIControlStateNormal];
                [allBtn[i] setBackgroundImage:[UIImage imageNamed:@"file_rename_dis"] forState:UIControlStateDisabled];
                [allBtn[i] setBackgroundImage:[UIImage imageNamed:@"file_rename_high"] forState:UIControlStateHighlighted];
                
            }
                
                break;
            case 3:
            {
                [allBtn[i] setBackgroundImage:[UIImage imageNamed:@"file_offline_def"] forState:UIControlStateNormal];
                [allBtn[i] setBackgroundImage:[UIImage imageNamed:@"file_offline_dis"] forState:UIControlStateDisabled];
                [allBtn[i] setBackgroundImage:[UIImage imageNamed:@"file_offline_high"] forState:UIControlStateHighlighted];
                
            }
                
                break;
            case 4:
            {
                
                [allBtn[i] setBackgroundImage:[UIImage imageNamed:@"file_del_def"] forState:UIControlStateNormal];
                [allBtn[i] setBackgroundImage:[UIImage imageNamed:@"file_del_dis"] forState:UIControlStateDisabled];
                [allBtn[i] setBackgroundImage:[UIImage imageNamed:@"file_del_high"] forState:UIControlStateHighlighted];
            }
                break;
                
            default:
                break;
        }
        
        [self.sideSwipeView addSubview: allBtn[i]];
    }

}



-(void)handleViewSignal_DYBSideSwipeViewController:(DragonViewSignal *)signal{

    if ([signal is:[DYBSideSwipeViewController OPEARTION]]) {
        
    }


}

-(void)touchBtn:(id)_sender event:(id)event{
    
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:_tableview];
    NSIndexPath *indexPath = [_tableview indexPathForRowAtPoint:currentTouchPosition];
    
    DLogInfo(@"index ------ > %d",indexPath.row);
    
    UIButton *btn = (UIButton *)_sender;

    NSNumber *num = [NSNumber numberWithInt:btn.tag];
    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:num,@"num",[NSNumber numberWithInt:indexPath.row],@"row", nil];
    [self sendViewSignal:[DYBSideSwipeViewController TOUCHBTN] withObject:dict from:self target:sender];

}

-(void)addTapView{
    
    UIView *tapView  = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, _cell.frame.size.width, _cell.frame.size.height)] ;
    [_cell addSubview:tapView];
    [tapView setBackgroundColor:[UIColor  clearColor]];
    [tapView setTag:90];
    [tapView release];
    
    tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(recoverFrame:)];
    [_cell addGestureRecognizer:tap];
    [tap release];
    
    
}
-(void)recoverFrame:(UITapGestureRecognizer *)sender{
    
   
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelegate:self];
    
    _cell.frame = CGRectMake(0, _cell.frame.origin.y, _cell.frame.size.width, _cell.frame.size.height);
    [UIView commitAnimations];
    
    [self removerCoverView];
}

-(void)removerCoverView{
    
    UIView *coverView = [_cell viewWithTag:90];
    if (coverView) {
        [_cell removeGestureRecognizer:tap];
        [coverView removeFromSuperview];
        coverView = nil;
    }
    
}

- (void)Hitbtn:(id)sender event:(id)event{
    //    [delegate DelMessage:sender event:event];
}


- (void) setupGestureRecognizers
{
    // Do nothing under 3.x
    //    if (![self gestureRecognizersSupported]) return;
    
    // Setup a left swipe gesture recognizer
    UISwipeGestureRecognizer* leftSwipeGestureRecognizer = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)] autorelease];
    leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [_tableview addGestureRecognizer:leftSwipeGestureRecognizer];
    
    // Setup a right swipe gesture recognizer
    UISwipeGestureRecognizer* rightSwipeGestureRecognizer = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)] autorelease];
    rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [_tableview addGestureRecognizer:rightSwipeGestureRecognizer];
}

- (void)swipeRight:(UISwipeGestureRecognizer *)recognizer
{
    [self swipe:recognizer direction:UISwipeGestureRecognizerDirectionRight];
}


- (void)swipeLeft:(UISwipeGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:_tableview];
    NSIndexPath* indexPath = [_tableview indexPathForRowAtPoint:location];
    DLogInfo(@"index ------ > %d",indexPath.row);
    UITableViewCell* cell = [_tableview cellForRowAtIndexPath:indexPath];
    
    //增加Tag，有特殊标识的时候，屏蔽左滑消息
    for (UIView *view in cell.subviews) {
        if (view.tag == 991) {
            return;
        }
    }
    
    [self swipe:recognizer direction:UISwipeGestureRecognizerDirectionLeft];
}

// Handle a left or right swipe
- (void)swipe:(UISwipeGestureRecognizer *)recognizer direction:(UISwipeGestureRecognizerDirection)direction
{
    DLogInfo(@"dddd");
    if (recognizer && recognizer.state == UIGestureRecognizerStateEnded)
    {
        // Get the table view cell where the swipe occured
        CGPoint location = [recognizer locationInView:_tableview];
        NSIndexPath* indexPath = [_tableview indexPathForRowAtPoint:location];
        _cell = [_tableview cellForRowAtIndexPath:indexPath];
        
        // If we are already showing the swipe view, remove it
        if (_cell.frame.origin.x != 0)
        {
            [self removeSideSwipeView:YES];
            return;
        }
        
        // Make sure we are starting out with the side swipe view and cell in the proper location
        [self removeSideSwipeView:NO];
        
        // If this isn't the cell that already has thew side swipe view and we aren't in the middle of animating
        // then start animating in the the side swipe view
        if (_cell!= sideSwipeCell && !animatingSideSwipe && direction != UISwipeGestureRecognizerDirectionRight){
            
            float cellheight = [_tableview cellForRowAtIndexPath:indexPath].frame.size.height;
            
            for (UIView *view in self.sideSwipeView.subviews) {
                if (view.tag == 777) {
                    [view setFrame:CGRectMake(300, (cellheight-50)/2, 40, 50)];
                }
                else if (view.tag == 778){
                    [view setFrame:CGRectMake(300, 0, 84, cellheight)];
                }
               
            }
            
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.2];
            
            for (UIView *view in self.sideSwipeView.subviews) {
                if (view.tag == 777) {
                    [view setFrame:CGRectMake(220, (cellheight-50)/2, 40, 50)];
                }
                else if (view.tag == 778){
                    [view setFrame:CGRectMake(200, -2, 84, cellheight)];
                }
                
            }
            
            [UIView commitAnimations];
            
            [self addSwipeViewTo:_cell direction:direction];
        }
    }
}

// Remove the side swipe view.
// If animated is YES, then the removal is animated using a bounce effect
- (void) removeSideSwipeView:(BOOL)animated
{
    // Make sure we have a cell where the side swipe view appears and that we aren't in the middle of animating
    if (!sideSwipeCell || animatingSideSwipe) return;
    
    if (animated)
    {
        // The first step in a bounce animation is to move the side swipe view a bit offscreen
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        if (sideSwipeDirection == UISwipeGestureRecognizerDirectionRight)
        {
            if (PUSH_STYLE_ANIMATION)
                sideSwipeView.frame = CGRectMake(-sideSwipeView.frame.size.width + BOUNCE_PIXELS,sideSwipeView.frame.origin.y,sideSwipeView.frame.size.width, sideSwipeView.frame.size.height);
            sideSwipeCell.frame = CGRectMake(BOUNCE_PIXELS, sideSwipeCell.frame.origin.y, sideSwipeCell.frame.size.width, sideSwipeCell.frame.size.height);
        }
        else
        {
            if (PUSH_STYLE_ANIMATION)
                sideSwipeView.frame = CGRectMake(sideSwipeView.frame.size.width - BOUNCE_PIXELS,sideSwipeView.frame.origin.y,sideSwipeView.frame.size.width, sideSwipeView.frame.size.height);
            sideSwipeCell.frame = CGRectMake(-BOUNCE_PIXELS, sideSwipeCell.frame.origin.y, sideSwipeCell.frame.size.width, sideSwipeCell.frame.size.height);
        }
        animatingSideSwipe = YES;
        
        for (UIView *view in self.sideSwipeView.subviews) {
            if (view.tag == 777) {
                [view setFrame:CGRectMake(300, view.frame.origin.y, 40, 50)];
            }
            else if (view.tag == 778){
                [view setFrame:CGRectMake(300, 0, 84, view.frame.size.height)];
            }
        }
        
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStopOne:finished:context:)];
        [UIView commitAnimations];
    }
    else
    {
        [sideSwipeView removeFromSuperview];
        sideSwipeCell.frame = CGRectMake(0,sideSwipeCell.frame.origin.y,sideSwipeCell.frame.size.width, sideSwipeCell.frame.size.height);
        self.sideSwipeCell = nil;
    }
}

#pragma mark Adding the side swipe view
- (void) addSwipeViewTo:(UITableViewCell*)cell direction:(UISwipeGestureRecognizerDirection)direction
{
    // Change the frame of the side swipe view to match the cell
    sideSwipeView.frame = cell.frame;
    
    // Add the side swipe view to the table below the cell
    [_tableview insertSubview:sideSwipeView belowSubview:cell];
    
    // Remember which cell the side swipe view is displayed on and the swipe direction
    self.sideSwipeCell = cell;
    sideSwipeDirection = direction;
    
    CGRect cellFrame = cell.frame;
    if (PUSH_STYLE_ANIMATION)
    {
        // Move the side swipe view offscreen either to the left or the right depending on the swipe direction
        sideSwipeView.frame = CGRectMake(direction == UISwipeGestureRecognizerDirectionRight ? -cellFrame.size.width : cellFrame.size.width, cellFrame.origin.y, cellFrame.size.width, cellFrame.size.height);
    }
    else
    {
        // Move the side swipe view to offset 0
        sideSwipeView.frame = CGRectMake(0, cellFrame.origin.y, cellFrame.size.width, cellFrame.size.height);
    }
    
    // Animate in the side swipe view
    animatingSideSwipe = YES;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStopAddingSwipeView:finished:context:)];
    if (PUSH_STYLE_ANIMATION)
    {
        // Move the side swipe view to offset 0
        // While simultaneously moving the cell's frame offscreen
        // The net effect is that the side swipe view is pushing the cell offscreen
        sideSwipeView.frame = CGRectMake(0, cellFrame.origin.y, cellFrame.size.width, cellFrame.size.height);
    }
    cell.frame = CGRectMake(direction == UISwipeGestureRecognizerDirectionRight ? DEL_BKG_WIDTH : -DEL_BKG_WIDTH, cellFrame.origin.y, cellFrame.size.width, cellFrame.size.height);
    [UIView commitAnimations];
    [self addTapView];
}

- (void)animationDidStopOne:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    if (sideSwipeDirection == UISwipeGestureRecognizerDirectionRight)
    {
        if (PUSH_STYLE_ANIMATION)
            sideSwipeView.frame = CGRectMake(-sideSwipeView.frame.size.width + BOUNCE_PIXELS*2,sideSwipeView.frame.origin.y,sideSwipeView.frame.size.width, sideSwipeView.frame.size.height);
        sideSwipeCell.frame = CGRectMake(0, sideSwipeCell.frame.origin.y, sideSwipeCell.frame.size.width, sideSwipeCell.frame.size.height);
    }
    else
    {
        
        sideSwipeCell.frame = CGRectMake(0, sideSwipeCell.frame.origin.y, sideSwipeCell.frame.size.width, sideSwipeCell.frame.size.height);
    }
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStopThree:finished:context:)];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView commitAnimations];
}

// When the bounce animation is completed, remove the side swipe view and reset some state
- (void)animationDidStopThree:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    animatingSideSwipe = NO;
    self.sideSwipeCell = nil;
    [sideSwipeView removeFromSuperview];
    [self removerCoverView];
}

// Note that the animation is done
- (void)animationDidStopAddingSwipeView:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    animatingSideSwipe = NO;
}


@end
