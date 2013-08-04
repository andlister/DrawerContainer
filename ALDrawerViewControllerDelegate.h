//
//  ALDrawerViewControllerDelegate.h
//
//  Created by Andrew Lister on 3/2/13.
//  Copyright (c) 2013 plasticcube. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  A Protocol designed to be (optionally) added to the main center child view controllers.  
 *  Overriding the methods in your child view controller will provide callbacks for
 *  the drawer state. 
 */
@protocol ALDrawerViewControllerDelegate <NSObject>

@optional

/**
    This view controller is about to appear in the center.
 */
- (void)viewWillAppearDrawer;

/**
    This view controller is about to disappear in the center.
 */
- (void)viewWillDisappearDrawer;

/**
    This view controller did appear in the center.
 */
- (void)viewDidAppearDrawer;

/**
    This view controller did disappear in the center.
 */
- (void)viewDidDisappearDrawer;

@end
