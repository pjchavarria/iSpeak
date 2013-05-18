//
//  CourseViewController.m
//  X Project
//
//  Created by Lion User on 04/05/2013.
//  Copyright (c) 2013 NextLvL. All rights reserved.
//

#import "LessonStartViewController.h"

@interface LessonStartViewController ()

@property (strong, nonatomic) IBOutlet UILabel *courseTitle;
@property (strong, nonatomic) IBOutlet UILabel *progressPercentage;
@property (strong, nonatomic) IBOutlet UILabel *masteredItems;
@property (strong, nonatomic) IBOutlet UILabel *startedItems;
@property (strong, nonatomic) IBOutlet UILabel *nonStartedItems;
@property (strong, nonatomic) IBOutlet UILabel *itemsToReview;
@property (strong, nonatomic) IBOutlet UILabel *currentStudyTime;

- (IBAction)startCoursePressed:(id)sender;
- (IBAction)backToDashboardPressed:(id)sender;

@end

@implementation LessonStartViewController

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
    self.courseTitle.text = self.courseTitleS;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)startCoursePressed:(id)sender {
    [self performSegueWithIdentifier:@"pushLesson" sender:nil];
}

- (IBAction)backToDashboardPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
