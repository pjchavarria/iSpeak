//
//  CoursesHeader.h
//  X Project
//
//  Created by Lion User on 30/04/2013.
//  Copyright (c) 2013 NextLvL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoursesHeader : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *initialImage;
@property (strong, nonatomic) IBOutlet UILabel *startedNumber;
@property (strong, nonatomic) IBOutlet UILabel *masteredNumber;
@property (strong, nonatomic) IBOutlet UILabel *completedNumber;
@property (strong, nonatomic) IBOutlet UILabel *studyTimeNumber;

@end
