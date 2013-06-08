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
	self.managedObjectContext = [coreDataController backgroundManagedObjectContext];
	
	courses = [coreDataController managedObjectsForClass:@"Curso" sortKey:@"curso" ascending:YES];
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
	
    [cell initialize:0.5 mastered:0.75];
    Curso *curso = [courses objectAtIndex:indexPath.row];
    cell.title.text = curso.nombre;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	Curso *curso = [courses objectAtIndex:[self.myTableView indexPathForSelectedRow].row];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"curso.objectId like %@ AND usuario.objectId like %@",curso.objectId,[[CoreDataController sharedInstance] usuarioActivo].objectId];
    NSLog(@"%@",predicate.description);
	NSArray *cursoAvances = [[CoreDataController sharedInstance] managedObjectsForClass:kCursoAvanceClass predicate:predicate];
	CursoAvance *cursoA;
	if(cursoAvances.count > 0)
		cursoA = [cursoAvances lastObject];
	
	if(!cursoA)
		[[SyncEngine sharedEngine] iniciarCurso:curso completion:^{
			[self performSegueWithIdentifier:@"modalLessonNavigationController" sender:nil];
		}];
	else
		[[SyncEngine sharedEngine] iniciarRepaso:curso completion:^{
			[self performSegueWithIdentifier:@"modalLessonNavigationController" sender:nil];
		}];
	
    
}

- (IBAction)logoutPressed:(id)sender {
	[[CoreDataController sharedInstance] setUsuarioActivo:nil];
	[self dismissViewControllerAnimated:YES completion:nil];
}
@end
