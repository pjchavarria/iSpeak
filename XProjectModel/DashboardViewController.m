//
//  DashboardViewController.m
//  X Project
//
//  Created by Lion User on 30/04/2013.
//  Copyright (c) 2013 NextLvL. All rights reserved.
//

#import "DashboardViewController.h"
#import "CoursesCell.h"
#import "CoursesHeader.h"
#import "LessonStartViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SyncEngine.h"
#import "CoreDataController.h"


@interface DashboardViewController () <UITableViewDataSource,UITableViewDelegate>
{
    NSArray *courses;
}
@property (strong, nonatomic) IBOutlet UITableView *tableViewCursos;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) IBOutlet UILabel *masteredItemsLabel;
@property (strong, nonatomic) IBOutlet UILabel *startedItemsLabel;
@property (strong, nonatomic) IBOutlet UILabel *completedCoursesLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeStudiedLabel;

- (IBAction)logoutPressed:(id)sender;

@end

@implementation DashboardViewController

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
	
	courses = [coreDataController managedObjectsForClass:@"Curso" sortKey:@"curso" ascending:YES];
    
    int mastered = 0,started = 0, completed = 0;
    float timeStudied = 0.0;
    for (Curso *curso in courses) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"palabra.curso.objectId like %@",curso.objectId];
        NSArray *palabrasDelCurso = [coreDataController managedObjectsForClass:kPalabraAvanceClass predicate:predicate];
        
        NSArray *palabrasCompletadas = [palabrasDelCurso filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"avance == 100"]];
        mastered += palabrasCompletadas.count;
        NSArray *palabrasEnProgreso = [palabrasDelCurso filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"avance != 100 AND avance !=0"]];
        started += palabrasEnProgreso.count;
        NSArray *palabrasNuevas = [palabrasDelCurso filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"avance == 0"]];
        completed += palabrasNuevas.count;
        predicate = [NSPredicate predicateWithFormat:@"curso.objectId like %@",curso.objectId];
        NSArray *cursoAvances = [coreDataController managedObjectsForClass:kCursoAvanceClass predicate:predicate];
        CursoAvance *cursoAvance = [cursoAvances lastObject];
        timeStudied += [cursoAvance.tiempoEstudiado floatValue];
    }
    
    [self.masteredItemsLabel setText:[NSString stringWithFormat:@"%d",mastered]];
    [self.completedCoursesLabel setText:[NSString stringWithFormat:@"%d",completed]];
    [self.startedItemsLabel setText:[NSString stringWithFormat:@"%d",started]];
    [self.timeStudiedLabel setText:[NSString stringWithFormat:@"%f",timeStudied]];
    
	[self.tableViewCursos reloadData];

}

-(void)fillCourses:(id)array
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(int)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [courses count];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"modalLessonNavigationController"]) {
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        LessonStartViewController *lvc = (LessonStartViewController *)[navController.viewControllers objectAtIndex:0];
        Curso *curso = [courses objectAtIndex:[self.myTableView indexPathForSelectedRow].row];
        lvc.curso = curso;
        
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"Cell";
    CoursesCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
    
    Curso *curso = [courses objectAtIndex:indexPath.row];
	CoreDataController *coreDataController = [CoreDataController sharedInstance];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"palabra.curso.objectId like %@",curso.objectId];
    NSArray *palabrasDelCurso = [coreDataController managedObjectsForClass:kPalabraAvanceClass predicate:predicate];
    
    NSArray *palabrasCompletadas = [palabrasDelCurso filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"avance == 100"]];
    NSArray *palabrasEnProgreso = [palabrasDelCurso filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"avance != 100 AND avance !=0"]];
    if(palabrasDelCurso.count == 0)
    {
        [cell initialize:0.0 mastered:0.0];
    }
    else
    {
        [cell initialize:(palabrasEnProgreso.count*1.0/palabrasDelCurso.count*1.0) mastered:(palabrasCompletadas.count*1.0/palabrasDelCurso.count*1.0)];
    }
    cell.title.text = curso.nombre;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	Curso *curso = [courses objectAtIndex:[self.myTableView indexPathForSelectedRow].row];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"curso.objectId like %@ AND usuario.objectId like %@",curso.objectId,[[CoreDataController sharedInstance] usuarioActivo].objectId];	
	NSArray *cursoAvances = [[CoreDataController sharedInstance] managedObjectsForClass:kCursoAvanceClass predicate:predicate];
	CursoAvance *cursoA;
	if(cursoAvances.count > 0)
		cursoA = [cursoAvances lastObject];
	if (!cursoA) {
        NSLog(@"CREANDO CURSOPALABRA AVANCE");
        [[SyncEngine sharedEngine] iniciarCurso:curso createCursoPalabraAvance:YES completion:^{
			[self performSegueWithIdentifier:@"modalLessonNavigationController" sender:nil];
		}];
    }else if(cursoA.tiempoEstudiado.doubleValue<=0)
    {
        
        NSLog(@"NO CREANDO CURSOPALABRA AVANCE");
		[[SyncEngine sharedEngine] iniciarCurso:curso createCursoPalabraAvance:NO completion:^{
			[self performSegueWithIdentifier:@"modalLessonNavigationController" sender:nil];
		}];
	}else{
        
        NSLog(@"SOLO REPASO");
		[[SyncEngine sharedEngine] iniciarRepaso:curso completion:^{
			[self performSegueWithIdentifier:@"modalLessonNavigationController" sender:nil];
		}];
    }
	
    
}

- (IBAction)logoutPressed:(id)sender {
	[[CoreDataController sharedInstance] setUsuarioActivo:nil];
	[self dismissViewControllerAnimated:YES completion:nil];
}
@end
