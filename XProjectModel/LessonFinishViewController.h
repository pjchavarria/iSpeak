//
//  LessonReviewViewController.h
//  X Project
//
//  Created by Lion User on 14/05/2013.
//  Copyright (c) 2013 NextLvL. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Curso, CursoAvance;
@interface LessonFinishViewController : UIViewController

@property (strong, nonatomic) Curso *curso;
@property (strong, nonatomic) CursoAvance *cursoAvance;
@property (nonatomic) int palabrasRepasadas;
@property (nonatomic) int tiempoEstudiadoTotal;

@end
