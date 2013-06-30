//
//  DashboardViewController.h
//  X Project
//
//  Created by Lion User on 30/04/2013.
//  Copyright (c) 2013 NextLvL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashboardViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *myTableView;

- (IBAction)refreshButtonTapped:(id)sender;

@end
