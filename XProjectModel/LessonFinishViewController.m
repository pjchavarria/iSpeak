//
//  LessonReviewViewController.m
//  X Project
//
//  Created by Lion User on 14/05/2013.
//  Copyright (c) 2013 NextLvL. All rights reserved.
//

#import "LessonFinishViewController.h"
#import "SyncEngine.h"
#import "CoreDataController.h"
#import "Reachability.h"

@interface LessonFinishViewController ()
@property (strong, nonatomic) IBOutlet UILabel *reviewedItemsLabel;
@property (strong, nonatomic) IBOutlet UILabel *studiedTimeLabel;
- (IBAction)finishLessonPressed:(id)sender;
- (IBAction)goToCourseViewPressed:(id)sender;

@end

@implementation LessonFinishViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.reviewedItemsLabel.text = [NSString stringWithFormat:@"%d",self.palabrasRepasadas];
    double timeStudied = self.tiempoEstudiadoTotal;
    int as = (timeStudied/60);
	int as2 = (as*60);
	int as3 = timeStudied-as2;
    self.studiedTimeLabel.text = [NSString stringWithFormat:@"%dh %dm",as,as3];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)finishLessonPressed:(id)sender {
    NetworkStatus netStatus = [self currentNetworkStatus];
    if(netStatus != NotReachable)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[SyncEngine sharedEngine] finalizarLeccion:self.curso completion:^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }
    else
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"Y" forKey:@"progress"];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)goToCourseViewPressed:(id)sender {
    NetworkStatus netStatus = [self currentNetworkStatus];
    if(netStatus != NotReachable)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[SyncEngine sharedEngine] finalizarLeccion:self.curso completion:^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
    }
    else
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"Y" forKey:@"progress"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (NetworkStatus)currentNetworkStatus
{
	Reachability* wifiReach = [Reachability reachabilityWithHostName: @"www.apple.com"];
	NetworkStatus netStatus = [wifiReach currentReachabilityStatus];
	
	switch (netStatus)
	{
		case NotReachable:
		{
			NSLog(@"Access Not Available");
			break;
		}
			
		case ReachableViaWWAN:
		{
			NSLog(@"Reachable WWAN");
			break;
		}
		case ReachableViaWiFi:
		{
			NSLog(@"Reachable WiFi");
			break;
		}
	}
	return netStatus;
}
@end
