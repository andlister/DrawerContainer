//
//  LeftDrawerViewController.m
//
//  Created by Andrew Lister on 2/3/13.
//  Copyright (c) 2013 plasticcube. All rights reserved.
//

#import "LeftDrawerViewController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "AppDelegate.h"

static NSString *kCellId = @"MenuCell";

@interface LeftDrawerViewController ()

@property (nonatomic) UITableView            *tableView;
@property (nonatomic) NSArray                *menu;

@property (nonatomic) FirstViewController    *firstViewController;
@property (nonatomic) SecondViewController   *secondViewController;

@end


@implementation LeftDrawerViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.menu = @[@"First", @"Second"];
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height)
                                                  style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
	self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellId];
    [self.view addSubview:self.tableView];

    
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.firstViewController = [[FirstViewController alloc] initWithNibName:@"FirstViewController_iPhone" bundle:nil];
        self.secondViewController = [[SecondViewController alloc] initWithNibName:@"SecondViewController_iPhone" bundle:nil];
    } else {
        self.firstViewController = [[FirstViewController alloc] initWithNibName:@"FirstViewController_iPad" bundle:nil];
        self.secondViewController = [[SecondViewController alloc] initWithNibName:@"SecondViewController_iPad" bundle:nil];
    }

    [DemoAppDelegate.containerViewController displayCenterViewController:self.firstViewController];
    
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - DrawerContainerViewControllerDelegate


- (void)viewWillAppearDrawer
{
    if ([DemoAppDelegate.containerViewController.centerViewController isKindOfClass:[FirstViewController class]]) {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    else if ([DemoAppDelegate.containerViewController.centerViewController isKindOfClass:[SecondViewController class]]) {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    
    // Optionally do stuff
}


- (void)viewWillDisappearDrawer
{
    // Optionally do stuff
}

- (void)viewDidAppearDrawer
{
    // Optionally do stuff
}


- (void)viewDidDisappearDrawer
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    
    // Optionally do stuff
}

#pragma mark - UITableViewDataSource


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId forIndexPath:indexPath];
    cell.textLabel.text = self.menu[indexPath.row];
    
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.menu count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.menu[indexPath.row] isEqualToString:@"First"]) {
        [DemoAppDelegate.containerViewController displayCenterViewController:self.firstViewController];
    }
    else if ([self.menu[indexPath.row] isEqualToString:@"Second"]) {
        [DemoAppDelegate.containerViewController displayCenterViewController:self.secondViewController];
    }
}


@end
