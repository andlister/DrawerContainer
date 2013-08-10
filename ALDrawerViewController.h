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
@property (nonatomic, readwrite) UIViewController   *rightViewController;

/**
    Get/Set the view controller for the left drawer.
 */
@property (nonatomic, readwrite) UIViewController   *leftViewController;

/**
    Get the current center view controller.
 */
@property (nonatomic, readonly) UIViewController    *centerViewController;


/**
    Get/Set the left/right margin that the drawer will open to.
    Default 60.f.
 */
@property (nonatomic) float                         openPadding;


/** 
    Initializes the the ALDrawerViewController.
    @param leftViewController The left view controller. Set to nil for no left hand drawer. 
    @param rightViewController The right view controller. Set to nil for no right hand drawer.
 */
- (id)initWithLeftViewController:(UIViewController *)leftViewController rightViewController:(UIViewController *)rightViewController;


/**
    Sets the center content area view controller to the child view controller passed in.
    If the drawer is open it is closed automatically.
    @param centerViewControllerController The ViewController to be displayed.
 */
- (void)displayCenterViewController:(UIViewController *)centerViewControllerController;


/**
    Sets the center content area view controller to the child view controller passed in.
    @param centerViewControllerController The ViewController to be displayed.
    @param close Close the drawer after settting the centerViewControllerController.
 */
- (void)displayCenterViewController:(UIViewController *)centerViewControllerController close:(BOOL)close;

/**
    Resets the main view to the center closing the drawer.
 */
- (void)close;

/**
    Set the right bar button. Set to nil to hide.
    @param button New right button to show.
 */
- (void)setRightNavigationDrawerButton:(UIButton *)button;

/**
    Set the left bar button. Set to nil to hide.
    @param button New left button to show.
 */
- (void)setLeftNavigationDrawerButton:(UIButton *)button;

@end
