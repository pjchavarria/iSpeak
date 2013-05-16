//
//  CourseViewController.h
//  X Project
//
//  Created by Lion User on 04/05/2013.
//  Copyright (c) 2013 NextLvL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LessonStartViewController : UIViewController
- (IBAction)goBack:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *courseTitle;
@property (nonatomic) NSString *courseTitleS;

@end
