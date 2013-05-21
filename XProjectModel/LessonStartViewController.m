//
//  CourseViewController.m
//  X Project
//
//  Created by Lion User on 04/05/2013.
//  Copyright (c) 2013 NextLvL. All rights reserved.
//

#import "LessonStartViewController.h"
#import "LessonFinishViewController.h"
#import "CoreDataController.h"

@interface LessonStartViewController ()

@property (strong, nonatomic) IBOutlet UILabel *courseTitle;
@property (strong, nonatomic) IBOutlet UILabel *progressPercentage;
@property (strong, nonatomic) IBOutlet UILabel *masteredItems;
@property (strong, nonatomic) IBOutlet UILabel *startedItems;
@property (strong, nonatomic) IBOutlet UILabel *nonStartedItems;
@property (strong, nonatomic) IBOutlet UILabel *itemsToReview;
@property (strong, nonatomic) IBOutlet UILabel *currentStudyTime;

@property (strong, nonatomic) Curso *curso;
@property (strong, nonatomic) CursoAvance *cursoAvance;

- (IBAction)startCoursePressed:(id)sender;
- (IBAction)backToDashboardPressed:(id)sender;

@end

@implementation LessonStartViewController
- (id)initWithCurso:(Curso *)curso
{
    CoreDataController *coreDataController = [CoreDataController sharedInstance];
    
    Usuario *usuarioActivo = [coreDataController usuarioActivo];
    self.curso = curso;
    self.cursoAvance = [[CoreDataController sharedInstance] getObjectForClass:kCursoAvanceClass predicate:[NSPredicate predicateWithFormat:@"curso.objectId == %@ AND usuario.objectId == %@",curso.objectId,usuarioActivo.objectId]];
    return [self initWithNibName:nil bundle:nil];
}
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
    
    self.courseTitle.text = self.curso.nombre;
    self.masteredItems.text = self.cursoAvance.palabrasCompletas.stringValue;
    self.startedItems.text = self.cursoAvance.palabrasComenzadas.stringValue;
    self.nonStartedItems.text = [NSString stringWithFormat:@"%d",50-self.cursoAvance.palabrasComenzadas.intValue-self.cursoAvance.palabrasCompletas.intValue];
    
    self.progressPercentage.text = [NSString stringWithFormat:@"%@",self.cursoAvance.avance];
    self.itemsToReview.text = @"..";
    self.currentStudyTime.text = @"..h:..m";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)startCoursePressed:(id)sender {
    [self performSegueWithIdentifier:@"pushLesson" sender:nil];
}

- (IBAction)backToDashboardPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
