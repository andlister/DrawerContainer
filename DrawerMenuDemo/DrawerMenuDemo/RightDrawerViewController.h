//
//  RightDrawerViewController.h
//
//  Created by Andrew Lister on 2/3/13.
//  Copyright (c) 2013 plasticcube. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALDrawerViewControllerDelegate.h"

@class ALDrawerViewController;

@interface RightDrawerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ALDrawerViewControllerDelegate>

@end
