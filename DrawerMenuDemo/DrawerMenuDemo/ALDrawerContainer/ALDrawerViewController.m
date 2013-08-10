//
//  ALDrawerViewController.m
//
//  Created by Andrew Lister on 2/4/13.
//  Copyright (c) 2013 plasticcube. All rights reserved.
//

#import "ALDrawerViewController.h"

typedef enum {
    ContainerPositionLeft,    // left position
    ContainerPositionCenter,  // center position
    ContainerPositionRight    // right position
} ContainerPosition;


@interface ALDrawerViewController ()

@property (nonatomic, readwrite) UIViewController       *centerViewController;
@property (nonatomic, readwrite) UITapGestureRecognizer *tapCloseDrawerGesture;
@property (nonatomic, readwrite) UIPanGestureRecognizer *panGesture;
@property (nonatomic, readwrite) ContainerPosition      currentPosition;

@end

@implementation ALDrawerViewController


- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.view.backgroundColor = [UIColor blackColor];
        
        self.openPadding = 60.f; // default paddding width when drawer is open
        
        
        // Default buttons. You can change the buttons using the
        // setRightNavigationDrawerButton/setLeftNavigationDrawerButton methods.
        UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Left"
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(toggleLeftDrawer)];
        self.navigationItem.leftBarButtonItem = leftBarButton;
        
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Right"
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(toggleRightDrawer)];
        self.navigationItem.rightBarButtonItem = rightBarButton;
        self.currentPosition = ContainerPositionCenter;
    }
    
    return self;
}


- (id)initWithLeftViewController:(UIViewController *)leftViewController rightViewController:(UIViewController *)rightViewController
{
    self = [self init];
    if (self) {
        self.leftViewController = leftViewController;
        self.rightViewController = rightViewController;
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Tap main content widow to close the drawer and show the content when the drawer is open.
    self.tapCloseDrawerGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                         action:@selector(slideCenter)];
  
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                              action:@selector(didPanGesture:)];
    self.panGesture.delegate = self;
    [self.view addGestureRecognizer:self.panGesture];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setupLeftDrawer];
}


- (void)displayCenterViewController:(UIViewController *)centerViewControllerController
{
    [self displayCenterViewController:centerViewControllerController close:YES];
}


- (void)displayCenterViewController:(UIViewController *)centerViewControllerController close:(BOOL)close
{
    if (centerViewControllerController != self.centerViewController) {
        [self.centerViewController willMoveToParentViewController:nil];
        [self.centerViewController.view removeFromSuperview];
        [self.centerViewController removeFromParentViewController];
        
        [self addChildViewController:centerViewControllerController];
        [self.view addSubview:centerViewControllerController.view];
        [centerViewControllerController didMoveToParentViewController:self];
        
        self.centerViewController = centerViewControllerController;
    }

    [self closeDrawer];
}


- (void)setLeftViewController:(UIViewController *)leftViewController
{
    _leftViewController = leftViewController;
    if (leftViewController == nil) {
        self.navigationItem.leftBarButtonItem = nil;
    }
}


- (void)setRightViewController:(UIViewController *)rightViewController
{
    _rightViewController = rightViewController;
    if (rightViewController == nil) {
        self.navigationItem.rightBarButtonItem = nil;
    }
}


- (void)close
{
    [self closeDrawer];
}


#pragma mark - Actions


/**
 *  Toggle sliding open the right drawer.
 */
- (void)toggleRightDrawer
{
    if (ContainerPositionCenter == self.currentPosition) {
        [self setupRightDrawer];
        [self slideLeft];
    }
    else {
        [self closeDrawer];
    }
}


/**
 *  Toggle sliding open the left drawer.
 */
- (void)toggleLeftDrawer
{
    if (ContainerPositionCenter == self.currentPosition) {
        [self setupLeftDrawer];
        [self openLeftDrawer];
    }
    else {
        [self closeDrawer];
    }
}


- (void)didPanGesture:(UIPanGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan || sender.state == UIGestureRecognizerStateChanged) {
        // Move the navigation.view for panning left to right, if there is a view controller on that side
        [self handlePanningForGesture:sender];
    }
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        // Slide to a finishing postion
        [self slideToComplete];
    }
}


- (void)slideToComplete
{
    float threshold = 70.f;  // define where the threshhold limit for when a slide will auto complete. 
    
    if (((ContainerPositionLeft == self.currentPosition) && self.navFrame.origin.x > ([self xCoordForPosition:ContainerPositionLeft] + threshold)) ||
        ((ContainerPositionRight == self.currentPosition) && self.navFrame.origin.x < ([self xCoordForPosition:ContainerPositionRight] - threshold)) ) {
        
        [self closeDrawer];
    }
    else if (((ContainerPositionCenter == self.currentPosition) && self.navFrame.origin.x > (threshold)) ||
             (ContainerPositionRight == self.currentPosition)) {
        
        [self openLeftDrawer];
    }
    else if (((ContainerPositionCenter == self.currentPosition) && self.navFrame.origin.x < (-threshold)) ||
             (ContainerPositionLeft == self.currentPosition)) {
        
        [self slideLeft];
    }
    else if (ContainerPositionCenter == self.currentPosition) {
        
        [self closeDrawer];
    }
}


- (void)handlePanningForGesture:(UIPanGestureRecognizer *)sender
{
    // Move the navigation.view for panning left to right, if there is a view controller on that side
    CGPoint translation = [sender translationInView:[self.navigationController.view superview]];
    
    if ([self canPanForPoint:translation]) {
        
        self.navigationController.view.frame = CGRectMake(self.navFrame.origin.x + translation.x,
                                                          self.navFrame.origin.y,
                                                          self.navFrame.size.width,
                                                          self.navFrame.size.height);
        // setup draw view controller
        if (self.navFrame.origin.x > 0) {
            [self setupLeftDrawer];
        }
        else if (self.navFrame.origin.x < 0) {
            [self setupRightDrawer];
        }
    }
    
    [sender setTranslation:CGPointZero inView:[self.navigationController.view superview]];
}


#pragma mark - Helpers


- (CGRect)navFrame
{
    return self.navigationController.view.frame;
}


- (void)setupRightDrawer
{
    if (self.rightViewController) {
        if (self.leftViewController && self.leftViewController.view.superview) {
            [self.leftViewController.view removeFromSuperview];
        }
        
        if (self.rightViewController.view.superview == nil) {
            [self.view.window insertSubview:self.rightViewController.view
                               belowSubview:self.view.window.rootViewController.view];
        }
    }
}


- (void)setupLeftDrawer
{
    if (self.leftViewController) {
        if (self.rightViewController && self.rightViewController.view.superview) {
            [self.rightViewController.view removeFromSuperview];
        }
        
        if (self.leftViewController && self.leftViewController.view.superview == nil) {
            [self.view.window insertSubview:self.leftViewController.view
                               belowSubview:self.view.window.rootViewController.view];
        }
    }
}


- (float)xCoordForPosition:(ContainerPosition)postion
{
    float x = 0;  
    
    switch (postion) {
        case ContainerPositionLeft:
            x = -(self.view.frame.size.width - self.openPadding);
            break;

        case ContainerPositionRight:
            x = (self.view.frame.size.width - self.openPadding);
            break;
            
        case ContainerPositionCenter:
        default:
            x = 0.f;   // center default
            break;
    }
    
    return x;
}


/**
 *  Slide from the Center position to the right to open the left drawer.
 */
- (void)openLeftDrawer
{
    if (self.leftViewController) {
        [self.view addGestureRecognizer:self.tapCloseDrawerGesture];
        [self animateSlideToPosition:ContainerPositionRight];  // animate drawer opening or closing
    }
}


/**
 *  Slide from either left or right back to the center position to close the drawer.
 */
- (void)closeDrawer
{
    [self.view removeGestureRecognizer:self.tapCloseDrawerGesture];
    [self animateSlideToPosition:ContainerPositionCenter];  // animate drawer opening or closing
}


/**
 *  Slide from the center position to the left.
 */
- (void)slideLeft
{
    if (self.rightViewController) {
        [self.view addGestureRecognizer:self.tapCloseDrawerGesture];
        [self animateSlideToPosition:ContainerPositionLeft];
    }
}


- (void)animateSlideToPosition:(ContainerPosition)position
{
    UIViewController<ALDrawerViewControllerDelegate> *ovc = [self viewControllerForPosition:self.currentPosition];
    UIViewController<ALDrawerViewControllerDelegate> *nvc = [self viewControllerForPosition:position];
    
    if ([ovc respondsToSelector:@selector(viewWillDisappearDrawer)]) {
        [ovc viewWillDisappearDrawer];
    }
    
    if ([nvc respondsToSelector:@selector(viewWillAppearDrawer)]) {
        [nvc viewWillAppearDrawer];
    }
    
    float x = [self xCoordForPosition:position];
    
    [UIView animateWithDuration:0.3
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         self.navigationController.view.frame =
                            (CGRect) {{x, self.navFrame.origin.y}, self.navFrame.size};
                         
                     } completion:^(BOOL finished) {
                         
                         self.currentPosition = position;
                         
                         //  Call viewDidAppearFromDrawer on view controller.
                         if ([ovc respondsToSelector:@selector(viewDidDisappearDrawer)]) {
                             [ovc viewDidDisappearDrawer];
                         }
                         
                         if ([nvc respondsToSelector:@selector(viewDidAppearDrawer)]) {
                             [nvc viewDidAppearDrawer];
                         }
                     }
     ];
}


- (void)hideRightBarButton
{
    self.navigationItem.rightBarButtonItem = nil;
}

   
- (void)hideLeftBarButton
{
    self.navigationItem.leftBarButtonItem = nil;
}


- (void)setRightNavigationDrawerButton:(UIButton *)button
{
    // If target and actions have not been set on the button, set them to the drawer slide default
    NSArray *actions = [button actionsForTarget:self forControlEvent:UIControlEventTouchUpInside];
    if ([actions count] == 0) {
        [button addTarget:self action:@selector(toggleLeftSlide) forControlEvents:UIControlEventTouchUpInside];
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}


- (void)setLeftNavigationDrawerButton:(UIButton *)button
{
    // If target and actions have not been set on the button, set them to the drawer slide default
    NSArray *actions = [button actionsForTarget:self forControlEvent:UIControlEventTouchUpInside];
    if ([actions count] == 0) {
        [button addTarget:self action:@selector(toggleRightSlide) forControlEvents:UIControlEventTouchUpInside];
    }

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}


- (BOOL)isPanningLeft:(float)newX
{
    return (self.navFrame.origin.x + newX < self.navFrame.origin.x);
}


- (BOOL)isPanningRight:(float)newX
{
    return (self.navFrame.origin.x + newX > self.navFrame.origin.x);
}


- (BOOL)canPanForPoint:(CGPoint)point
{
    BOOL canPan = NO;
    
    if (self.leftViewController && self.rightViewController) {
        canPan = YES;
    }
    else if ([self isPanningLeft:point.x]) {
        float center = [self xCoordForPosition:ContainerPositionCenter];
        canPan = (self.rightViewController && (ContainerPositionCenter == self.currentPosition ||
                  (ContainerPositionRight == self.currentPosition && [self navFrame].origin.x < center))) ||
                    (!self.rightViewController && (ContainerPositionRight == self.currentPosition ||
                                                         (ContainerPositionCenter == self.currentPosition &&
                                                          [self navFrame].origin.x > center)));
    }
    else if ([self isPanningRight:point.x]) {
        float center = [self xCoordForPosition:ContainerPositionCenter];
        canPan = (self.leftViewController && (ContainerPositionCenter == self.currentPosition ||
                                                    (ContainerPositionRight == self.currentPosition && [self navFrame].origin.x > center))) ||
                (!self.leftViewController && (ContainerPositionLeft == self.currentPosition ||
                                                    (ContainerPositionCenter == self.currentPosition &&
                                                     [self navFrame].origin.x < center)));
    }

    return canPan;
}


- (UIViewController<ALDrawerViewControllerDelegate> *)viewControllerForPosition:(ContainerPosition)position
{
    if (ContainerPositionCenter == position) {
        return (UIViewController<ALDrawerViewControllerDelegate> *)self.centerViewController;
    }
    else if (ContainerPositionRight == position) {
        return (UIViewController<ALDrawerViewControllerDelegate> *)self.leftViewController;
    }
    else if (ContainerPositionLeft == position) {
        return (UIViewController<ALDrawerViewControllerDelegate> *)self.rightViewController;
    }
    
    return nil;
}

@end
