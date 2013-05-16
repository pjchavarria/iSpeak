//
//  CoursesCell.h
//  X Project
//
//  Created by Lion User on 30/04/2013.
//  Copyright (c) 2013 NextLvL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoursesCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *percentage;
@property (strong, nonatomic) IBOutlet UIImageView *courseImage;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundScroll;
@property (strong, nonatomic) IBOutlet UIImageView *masteredScroll;
@property (strong, nonatomic) IBOutlet UIImageView *startedScroll;

-(void)initialize:(CGFloat)started mastered:(CGFloat)mastered;
@end
