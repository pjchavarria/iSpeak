//
//  CoursesCell.m
//  X Project
//
//  Created by Lion User on 30/04/2013.
//  Copyright (c) 2013 NextLvL. All rights reserved.
//

#import "CoursesCell.h"
@interface CoursesCell()



@end
@implementation CoursesCell
{
    BOOL inited;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}
- (void)initializeCell
{
	if(!inited)
    {
		UIImage *scrollBackground = [[UIImage imageNamed:@"dashboad-progress-bar-background.png"]
                                     resizableImageWithCapInsets:UIEdgeInsetsMake(0,5,0,5)];
        UIImage *scrollMastered = [[UIImage imageNamed:@"dashboad-progress-bar-mastered.png"]
                                   resizableImageWithCapInsets:UIEdgeInsetsMake(0,3,0,3)];
        UIImage *scrollStarted = [[UIImage imageNamed:@"dashboad-progress-bar-started.png"]
                                  resizableImageWithCapInsets:UIEdgeInsetsMake(0,3,0,3)];
		self.backgroundScroll.image = scrollBackground;
		self.masteredScroll.image = scrollMastered;
		self.startedScroll.image = scrollStarted;
		
        inited = YES;
	}
}
-(void)initialize:(CGFloat)started mastered:(CGFloat)mastered
{
	self.startedScroll.frame = CGRectMake(self.startedScroll.frame.origin.x, self.startedScroll.frame.origin.y, 278.0*started, self.startedScroll.frame.size.height);

	self.masteredScroll.frame = CGRectMake(self.masteredScroll.frame.origin.x, self.masteredScroll.frame.origin.y, 278*mastered, self.masteredScroll.frame.size.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
