//
//  LessonViewController.h
//  X Project
//
//  Created by Lion User on 14/05/2013.
//  Copyright (c) 2013 NextLvL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LessonReviewViewController : UIViewController

@property (strong, nonatomic) NSArray *palabras;
- (IBAction)palabraRespuesta1:(id)sender;
- (IBAction)palabraRespuesta2:(id)sender;
- (IBAction)palabraRespuesta3:(id)sender;
- (IBAction)palabraRespuesta4:(id)sender;

@end
