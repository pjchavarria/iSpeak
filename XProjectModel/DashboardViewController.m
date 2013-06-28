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
    
	

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CoreDataController *coreDataController = [CoreDataController sharedInstance];
	
	courses = [coreDataController managedObjectsForClass:@"Curso" sortKey:@"curso" ascending:YES];
    
    int mastered = 0,started = 0, completed = 0;
    float timeStudied = 0.0;
	Usuario *usuario = [[CoreDataController sharedInstance] usuarioActivo];
    
    for (Curso *curso in courses) {
        
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"usuario.objectId like %@",usuario.objectId];
        NSSet *cursoAvances = [curso.cursoAvance filteredSetUsingPredicate:pred];
        CursoAvance *cursoAvance = cursoAvances.anyObject;
        completed += (cursoAvance.avance.intValue==100)?1:0;
        timeStudied += [cursoAvance.tiempoEstudiado floatValue];
		started += cursoAvance.palabrasComenzadas.intValue;
		mastered += cursoAvance.palabrasCompletas.intValue;
    }
    int as = (timeStudied/60);
	int as2 = (as*60);
	int as3 = timeStudied-as2;
    [self.masteredItemsLabel setText:[NSString stringWithFormat:@"%d",mastered]];
    [self.completedCoursesLabel setText:[NSString stringWithFormat:@"%d",completed]];
    [self.startedItemsLabel setText:[NSString stringWithFormat:@"%d",started]];
    [self.timeStudiedLabel setText:[NSString stringWithFormat:@"%dh %dm",as,as3]];
    
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
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"usuario.objectId like %@",[[CoreDataController sharedInstance] usuarioActivo].objectId];
	CursoAvance *cursoAvance = ((NSSet*)[curso.cursoAvance filteredSetUsingPredicate:predicate]).anyObject;
	if (!cursoAvance) {
		
		[cell initializeCell];
		[cell initialize:0 mastered:0 ];
		cell.percentage.text = [NSString stringWithFormat:@"0%%"];
		cell.masteredItemsLabel.text = [NSString stringWithFormat:@"Mastered 0"];
		cell.startedItemsLabel.text = [NSString stringWithFormat:@"Started 0"];
	}else{
		double comenzadas = cursoAvance.palabrasComenzadas.doubleValue;
		double completadas = cursoAvance.palabrasCompletas.doubleValue;
		double total = cursoAvance.palabrasTotales.doubleValue;
		double initialize = 0;
		double mastered = 0;
		if (total) {
			initialize = cursoAvance.avance.floatValue;
			mastered = completadas/total;
		}
		[cell initializeCell];
		[cell initialize:initialize
				mastered:mastered];
		cell.percentage.text = [NSString stringWithFormat:@"%.0f%%",cursoAvance.avance.floatValue*100];
		cell.masteredItemsLabel.text = [NSString stringWithFormat:@"Mastered %@",cursoAvance.palabrasCompletas];
		cell.startedItemsLabel.text = [NSString stringWithFormat:@"Started %@",cursoAvance.palabrasComenzadas];
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
