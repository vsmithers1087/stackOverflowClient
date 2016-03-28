//
//  BurgerContainerViewController.m
//  StackOverflowClient
//
//  Created by Vincent Smithers on 3/28/16.
//  Copyright © 2016 Vince Smithers. All rights reserved.
//

#import "BurgerContainerViewController.h"
#import "MenuTableViewController.h"
#import "QuestionSearchViewController.h"
#import "UserSearchViewController.h"

CGFloat const kBurgerOpenScreenDivider = 3.0;
CGFloat const kBurgerOpenScreenMultiplier = 2.0;

CGFloat const kBurgerButtonWidth = 50.0;

NSTimeInterval const kTimeToSlideOpen = 0.2;
NSTimeInterval const kTimeToSlideClosed = 0.15;

@interface BurgerContainerViewController ()<UITableViewDelegate>

@property(strong, nonatomic)MenuTableViewController *menuContoller;
@property(strong, nonatomic)QuestionSearchViewController *questionContoller;
@property(strong, nonatomic)UserSearchViewController *userController;

@property(strong, nonatomic)UIViewController *topViewController;

@property(strong, nonatomic)NSArray *viewControllers;

@property(strong, nonatomic)UIButton *burgerButton;
@property(strong, nonatomic)UIPanGestureRecognizer *panGesture;

@end

@implementation BurgerContainerViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self setupMenuViewController];
    [self setUpInitialContentViewController];
    [self setUpAdditionalViewController];
    
    self.viewControllers = @[self.questionContoller, self.userController];
    
    self.topViewController = self.viewControllers[0];
    
    [self setUpPanGesture];
    
    [self burgerButtonWithImageName:@"burger.png"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+(NSString*)identifier{
    return @"BurgerContainerViewContoller";
}

-(void)setUPChildViewController:(UIViewController*)viewController onScreen:(BOOL)onScreen{
    if (onScreen) {
        viewController.view.frame = self.view.frame;
        
        [self addChildViewController:viewController];
        [self.view addSubview:viewController.view];
        
        [viewController didMoveToParentViewController:self];
    }else{
        viewController.view.frame = [self offScreenLocation];
    }
}

-(void)setupMenuViewController{
    MenuTableViewController *menuVC = [self.storyboard instantiateViewControllerWithIdentifier:[MenuTableViewController identifier]];
    
    
    [self setUPChildViewController:menuVC onScreen:true];
    
    self.menuContoller = menuVC;
    
    menuVC.tableView.delegate = self;
}

-(void)setUpInitialContentViewController{
    QuestionSearchViewController *questionSearchVC = [self.storyboard instantiateViewControllerWithIdentifier:[QuestionSearchViewController identifier]];
    
    [self setUPChildViewController:questionSearchVC onScreen:YES];
    
    self.questionContoller = questionSearchVC;
}

-(void)setUpAdditionalViewController{
    
    UserSearchViewController *userSearchVC = [self.storyboard instantiateViewControllerWithIdentifier:[UserSearchViewController identifier]];
    
    [self setUPChildViewController: userSearchVC onScreen:NO];
    
    self.userController = userSearchVC;
}

-(void)removeChildViewController:(UIViewController*)viewController{
    [viewController willMoveToParentViewController:nil];
    [viewController.view removeFromSuperview];
    [viewController removeFromParentViewController];
}

-(CGRect)offScreenLocation{
    CGFloat offScreenLocationX = self.view.frame.size.width;
    CGFloat offScreenLocationY = self.view.frame.origin.y;
    CGFloat offScreenLocationWidth = self.view.frame.size.width;
    CGFloat offScreenLocationHeight = self.view.frame.size.height;
    
    CGRect result = CGRectMake(offScreenLocationX, offScreenLocationY, offScreenLocationWidth, offScreenLocationHeight);
    
    return result;
}


//MARK: Pan

-(void)setUpPanGesture {
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(topViewControllerPanned:)];
    
    [self.topViewController.view addGestureRecognizer:pan];
    self.panGesture = pan;
}

-(void)topViewControllerPanned:(UIPanGestureRecognizer *)sender{
    
    if (sender.state == UIGestureRecognizerStateChanged) {
        [self panGestureStateChangedWithSender: sender];
    
    }else{
        //[self panGestureStateEnded];
    }
}



-(void)panGestureStateChangedWithSender:(UIPanGestureRecognizer*)sender {
    CGPoint velocity = [sender velocityInView:self.topViewController.view];
    CGPoint translation = [sender translationInView:self.topViewController.view];
    
    CGPoint centerBeforeChange = self.topViewController.view.center;
    
    CGPoint newCenter = CGPointMake(centerBeforeChange.x + translation.x, centerBeforeChange.y);
    
    if (velocity.x > 0) {
        
        self.topViewController.view.center = newCenter;
        [sender setTranslation:CGPointZero inView:self.topViewController.view];
    }
}

-(void)panGestureStateEnded{
    CGFloat currentX = self.topViewController.view.frame.origin.x;
    CGFloat widthValue = self.topViewController.view.frame.size.width;
    
    CGPoint menuOpen = CGPointMake(self.view.center.x * kBurgerOpenScreenMultiplier, self.view.center.y);
    
    CGPoint menuCloseLocation = CGPointMake(self.view.center.x, self.view.center.y);
    
    if (currentX > widthValue / kBurgerOpenScreenDivider) {
        
        [UIView animateWithDuration:kTimeToSlideOpen animations:^{
            
            self.topViewController.view.center = menuOpen;
        } completion:^(BOOL finished) {
            [self setUpTapGesture];
            self.burgerButton.userInteractionEnabled = NO;
      
        }];
    }else{
        [UIView animateWithDuration:kTimeToSlideClosed animations:^{
            self.topViewController.view.center =menuCloseLocation;
        } completion:^(BOOL finished) {
            
                  NSLog(@"User Did not open menu far enough to lock");
        }];
    }
}

-(void)setUpTapGesture{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToCloseMenu:)];
    
    [self.topViewController.view addGestureRecognizer:tap];
}

-(void)tapToCloseMenu:(UITapGestureRecognizer *)tap {
    
    [UIView animateWithDuration:kTimeToSlideClosed animations:^{
        
          self.topViewController.view.center = self.view.center;
        
    } completion:^(BOOL finished) {
        self.burgerButton.userInteractionEnabled = YES;
    }];
}

-(void)burgerButtonWithImageName:(NSString*)imageNamed {
    CGRect burgerSize = CGRectMake(0, 0, kBurgerButtonWidth, kBurgerButtonWidth);
    
    UIButton *burgerButton = [[UIButton alloc]initWithFrame:burgerSize];
    
    UIImage *buttonImage = [UIImage imageNamed:@"burger.png"];
    //get image for burger bun
    
    [burgerButton setImage:buttonImage forState:UIControlStateNormal];
    
    [self.topViewController.view addSubview:burgerButton];
    
    [burgerButton addTarget:self action:@selector(burgerButtonPressed:) forControlEvents: UIControlEventTouchUpInside];
    
    self.burgerButton = burgerButton;
}

-(void)burgerButtonPressed:(UIButton*)sender{
    CGPoint newCenter = CGPointMake(self.view.center.x * kBurgerOpenScreenMultiplier, self.view.center.y);
    
    [UIView animateWithDuration:kTimeToSlideOpen animations:^{
        self.topViewController.view.center = newCenter;
    } completion:^(BOOL finished) {
        [self setUpTapGesture];
        sender.userInteractionEnabled = false;
    }];
    
}

@end
