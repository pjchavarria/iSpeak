//
//  CourseViewController.m
//  X Project
//
//  Created by Lion User on 04/05/2013.
//  Copyright (c) 2013 NextLvL. All rights reserved.
//

#import "LessonStartViewController.h"
#import "LessonReviewViewController.h"
#import "CoreDataController.h"

@interface LessonStartViewController ()

@property (strong, nonatomic) IBOutlet UILabel *courseTitle;
@property (strong, nonatomic) IBOutlet UILabel *progressPercentage;
@property (strong, nonatomic) IBOutlet UILabel *masteredItems;
@property (strong, nonatomic) IBOutlet UILabel *startedItems;
@property (strong, nonatomic) IBOutlet UILabel *nonStartedItems;
@property (strong, nonatomic) IBOutlet UILabel *itemsToReview;
@property (strong, nonatomic) IBOutlet UILabel *currentStudyTime;

// Barras
@property (strong, nonatomic) IBOutlet UIImageView *barraMastered;
@property (strong, nonatomic) IBOutlet UIImageView *barraStarted;
@property (strong, nonatomic) IBOutlet UIImageView *barraNew;

@property (strong, nonatomic) CursoAvance *cursoAvance;
@property (strong, nonatomic) NSArray *palabrasCompletadas;
@property (strong, nonatomic) NSArray *palabrasEnProgreso;
@property (strong, nonatomic) NSArray *palabrasNuevas;

- (IBAction)startCoursePressed:(id)sender;
- (IBAction)backToDashboardPressed:(id)sender;

@end

@implementation LessonStartViewController
- (void)setCurso:(Curso *)curso
{
    CoreDataController *coreDataController = [CoreDataController sharedInstance];
    
    Usuario *usuarioActivo = [coreDataController usuarioActivo];
    _curso = curso;
    self.cursoAvance = [[CoreDataController sharedInstance] getObjectForClass:kCursoAvanceClass predicate:[NSPredicate predicateWithFormat:@"curso.objectId == %@ AND usuario.objectId == %@",curso.objectId,usuarioActivo.objectId]];
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
    CoreDataController *coreDataController = [CoreDataController sharedInstance];
    
    self.courseTitle.text = self.curso.nombre;
    self.masteredItems.text = self.cursoAvance.palabrasCompletas.stringValue;
    self.startedItems.text = self.cursoAvance.palabrasComenzadas.stringValue;
    self.nonStartedItems.text = [NSString stringWithFormat:@"%d",50-self.cursoAvance.palabrasComenzadas.intValue-self.cursoAvance.palabrasCompletas.intValue];
    
    self.progressPercentage.text = [NSString stringWithFormat:@"%.0f%%",self.cursoAvance.avance.floatValue*100];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"palabra.curso.objectId like %@",self.curso.objectId];
    NSArray *palabrasDelCurso = [coreDataController managedObjectsForClass:kPalabraAvanceClass predicate:predicate];
    
    self.palabrasCompletadas = [palabrasDelCurso filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"avance >= 1"]];
    self.palabrasEnProgreso = [palabrasDelCurso filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"avance < 1 AND avance > 0"]];
    self.palabrasNuevas = [palabrasDelCurso filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"avance <= 0"]];
    
    self.itemsToReview.text = [NSString stringWithFormat:@"%d",self.palabrasNuevas.count+self.palabrasEnProgreso.count];
    double timeStudied = self.cursoAvance.tiempoEstudiado.doubleValue;
    int as = (timeStudied/60);
	int as2 = (as*60);
	int as3 = timeStudied-as2;
    [self.currentStudyTime setText:[NSString stringWithFormat:@"%dh %dm",as,as3]];
    
    // Barras
    UIImage *scrollBackground = [[UIImage imageNamed:@"dashboad-progress-bar-background.png"]
                                 resizableImageWithCapInsets:UIEdgeInsetsMake(0,5,0,5)];
    UIImage *scrollMastered = [[UIImage imageNamed:@"dashboad-progress-bar-mastered.png"]
                               resizableImageWithCapInsets:UIEdgeInsetsMake(0,3,0,3)];
    UIImage *scrollStarted = [[UIImage imageNamed:@"dashboad-progress-bar-started.png"]
                              resizableImageWithCapInsets:UIEdgeInsetsMake(0,3,0,3)];
    self.barraNew.image = scrollBackground;
    self.barraMastered.image = scrollMastered;
    self.barraStarted.image = scrollStarted;
    
    CGRect size = self.barraMastered.frame;
    size.size.width = 274*(self.cursoAvance.palabrasCompletas.doubleValue/self.cursoAvance.palabrasTotales.doubleValue);
    self.barraMastered.frame = size;
    
    size = self.barraStarted.frame;
    size.size.width = 274*(self.cursoAvance.avance.floatValue);
    self.barraStarted.frame = size;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pushLesson"]) {
        LessonReviewViewController *lrvc = segue.destinationViewController;
        lrvc.curso = self.curso;
        lrvc.cursoAvance = self.cursoAvance;
        // Filtrar las palabras a repasar considerando cuantas palabras nuevas/a-repasar
        NSMutableArray *palabrasEnLaLeccion = [NSMutableArray array];
        int index;
        // 1ro si hay palabras nuevas comenzarlas
        if (self.palabrasNuevas.count) {
            NSRange theRange;
            theRange.location = 0;
            theRange.length = (self.palabrasNuevas.count>2)?3:self.palabrasNuevas.count;
            index = theRange.length;
            [palabrasEnLaLeccion addObjectsFromArray:[self.palabrasNuevas subarrayWithRange:theRange]];
        }
        // 2do completar con todas las demas palabras q faltan ordenadas en orden de prioridad
        int palabrasEnLaLeccionCount = palabrasEnLaLeccion.count;
        
        if (self.palabrasEnProgreso.count) {
            NSArray *prioritySorted = [self.palabrasEnProgreso sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"prioridad" ascending:NO]]];
            int palabrasEnLaLeccionLeft = 10 - palabrasEnLaLeccionCount;
            
            NSRange theRange;
            theRange.location = 0;
            theRange.length = (prioritySorted.count>=palabrasEnLaLeccionLeft)?palabrasEnLaLeccionLeft:prioritySorted.count;
            
            [palabrasEnLaLeccion addObjectsFromArray:[self.palabrasEnProgreso subarrayWithRange:theRange]];
        }
        
        palabrasEnLaLeccionCount = palabrasEnLaLeccion.count;
        if(palabrasEnLaLeccionCount < 10)
        {
        // 3ro se rellena con palabras nuevas
        if (self.palabrasNuevas.count) {
            int palabrasEnLaLeccionLeft = 10 - palabrasEnLaLeccionCount;
            NSRange theRange;
            theRange.location = index;
            theRange.length = (self.palabrasNuevas.count>=palabrasEnLaLeccionLeft + index)?palabrasEnLaLeccionLeft:self.palabrasNuevas.count-index;
            [palabrasEnLaLeccion addObjectsFromArray:[self.palabrasNuevas subarrayWithRange:theRange]];
        }
        }
        
        lrvc.palabras = palabrasEnLaLeccion;
    }
}
- (IBAction)startCoursePressed:(id)sender {
    [self performSegueWithIdentifier:@"pushLesson" sender:nil];
}

- (IBAction)backToDashboardPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
