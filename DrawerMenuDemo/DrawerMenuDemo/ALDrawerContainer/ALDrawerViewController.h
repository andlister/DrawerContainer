//
//  ALDrawerViewController.h
//
//  Created by Andrew Lister on 2/4/13.
//  Copyright (c) 2013 plasticcube. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALDrawerViewControllerDelegate.h"

/**
 *  This is the main display in the draw menu  - this class handles displaying
 *  your left and right drawer view controllers and settings the center one.
 *  
 *  This class is a parent container view controller that displays its child view 
 *  controllers using the Container View Controller mechanism.
 */

@interface ALDrawerViewController : UIViewController <UIGestureRecognizerDelegate>

/**
    Get/Set the view controller for the right drawer.
 */
@property (nonatomic) UIViewController *rightViewController;

/**
    Get/Set the view controller for the left drawer.
 */
@property (nonatomic) UIViewController *leftViewController;

/**
    Get/Set the current center view controller.
    Setting this will replace the existing view controller with a new one.
    The drawer will close automatically.
 */
@property (nonatomic) UIViewController *centerViewController;


/**
    Get/Set the position to which the the drawer will open to.
    Default 60.f
 */
@property (nonatomic) float            openPadding;


- (id)initWithLeftViewController:(UIViewController *)leftViewController rightViewController:(UIViewController *)rightViewController;

/**
    Resets the main view to the center closing the drawer.
 */
- (void)close;

- (void)hideRightBarButton;
- (void)hideLeftBarButton;
- (void)setRightNavigationDrawerButton:(UIButton *)button;
- (void)setLeftNavigationDrawerButton:(UIButton *)button;

@end
