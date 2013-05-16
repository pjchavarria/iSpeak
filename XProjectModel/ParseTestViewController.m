//
//  ParseTestViewController.m
//  XProjectModel
//
//  Created by Daniel Soto on 5/13/13.
//  Copyright (c) 2013 Next Level. All rights reserved.
//

#import "ParseTestViewController.h"
#import "ParseUtilities.h"
#import "AppDelegate.h"   
#import "DTO.h"

@interface ParseTestViewController ()

@end

@implementation ParseTestViewController


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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoaded:) name:@"kUserDidLoaded" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(oracionLoaded:) name:@"kOracionDidLoaded" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(palabraLoaded:) name:@"kPalabraDidLoaded" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cursoLoaded:) name:@"kCursoDidLoaded" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nivelLoaded:) name:@"kNivelDidLoaded" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listUserLoaded:) name:@"kListUserDidLoaded" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listPalabraLoaded:) name:@"kListPalabraDidLoaded" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listCursoLoaded:) name:@"kListCursoDidLoaded" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listNivelLoaded:) name:@"kListNivelDidLoaded" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listOracionLoaded:) name:@"kListOracionDidLoaded" object:nil];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listCursoByNivelLoaded:) name:@"kListCursoByNivelDidLoaded" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listPalabraByCursoLoaded:) name:@"kListPalabraByCursoIDDidLoaded" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listOracionByPalabraLoaded:) name:@"kListOracionByIDPalabraDidLoaded" object:nil];

    
}
-(void) listUserLoaded :(id)resultados {
    
    NSMutableArray *obj = (NSMutableArray *)[resultados object];
    NSLog(@"%lu",(unsigned long)obj.count);
    
}

-(void) listPalabraLoaded :(id)resultados {
    
    NSMutableArray *obj = (NSMutableArray *)[resultados object];
    NSLog(@"%lu",(unsigned long)obj.count);
    
}

-(void) listCursoLoaded :(id)resultados {
    
    NSMutableArray *obj = (NSMutableArray *)[resultados object];
    NSLog(@"%lu",(unsigned long)obj.count);
    
}


-(void) listNivelLoaded :(id)resultados {
    
    NSMutableArray *obj = (NSMutableArray *)[resultados object];
    NSLog(@"%lu",(unsigned long)obj.count);
    
}

-(void) listOracionLoaded :(id)resultados {
    
    NSMutableArray *obj = (NSMutableArray *)[resultados object];
    NSLog(@"%lu",(unsigned long)obj.count);
    
}

-(void) listCursoByNivelLoaded :(id)resultados {
    
    NSMutableArray *obj = (NSMutableArray *)[resultados object];
    NSLog(@"%lu",(unsigned long)obj.count);
    
}

-(void) listPalabraByCursoLoaded :(id)resultados {
    
    NSMutableArray *obj = (NSMutableArray *)[resultados object];
    NSLog(@"%lu",(unsigned long)obj.count);
    
}

-(void) listOracionByPalabraLoaded :(id)resultados {
    
    NSMutableArray *obj = (NSMutableArray *)[resultados object];
    NSLog(@"%lu",(unsigned long)obj.count);
    
}
-(void) userLoaded :(id)usuario {
    
    UsuarioDTO *user = (UsuarioDTO *)[usuario object];
    NSLog(@"%@",user.password);
    
}

-(void) oracionLoaded :(id)oracion {
    
    
    OracionDTO *obj = (OracionDTO *)[oracion object];
    NSLog(@"%@",obj.oracion);
}

-(void) palabraLoaded :(id)palabra {
    
    
    PalabraDTO *obj = (PalabraDTO *)[palabra object];
    NSLog(@"%@",obj.palabra);
    
    
    
}

-(void) cursoLoaded :(id)curso {
    
    
    CursoDTO *cur = (CursoDTO *)[curso object];
    NSLog(@"%@",cur.nombre);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)insertUser:(id)sender {
    
    UsuarioDTO *userToInsert = [[UsuarioDTO alloc]init];
    [userToInsert setUsername:@"Username"];
    [userToInsert setPassword:@"Pass Insertado"];
 
    
    // Recordar que todas las llamadas a parse son asincronas xsiak
    [UsuarioParse insertUsuario:userToInsert];
    
}
- (IBAction)deleteUser:(id)sender {
    NSString *userIDToDelete = @"EpIVJDlmnH";
    
    [UsuarioParse deleteUsuario:userIDToDelete];
    
}
- (IBAction)updateUser:(id)sender {
    
    UsuarioDTO *userToUpdate = [[UsuarioDTO alloc]init];
    
    [userToUpdate setUsername:@"User Modificado"];
    [userToUpdate setPassword:@"Pass Modificado"];
    [userToUpdate setObjectId:@"8Gj8dJPgKr"];
    [UsuarioParse updateUsuario:userToUpdate];
    
}
- (IBAction)selectUser:(id)sender {
    
    [UsuarioParse selectUsuario:@"8Gj8dJPgKr"];
   
   
}

- (IBAction)selectAllUsers:(id)sender {
    
    [UsuarioParse selectUsuarioAll];
   
}
- (IBAction)insertCurso:(id)sender {
    
    CursoDTO *cursoToInsert = [[CursoDTO alloc]init];
   
    
  
    [cursoToInsert setNombre:@"Curso Nuevouih"];
    [cursoToInsert setPalabrasCompletas:[NSNumber numberWithInt:1]];
    [cursoToInsert setTiempoEstudiando:[NSNumber numberWithInt:2]];
    [cursoToInsert setCurso:[NSNumber numberWithInt:3]];
    [cursoToInsert setCantidadPalabras:[NSNumber numberWithInt:4]];
    [cursoToInsert setAvance:[NSNumber numberWithInt:5]];
    
    [cursoToInsert setNivel:@"Af7cHOjsa7"];

   
    
    // Recordar que todas las llamadas a parse son asincronas xsiak
    [CursoParse insertCurso:cursoToInsert];

}
- (IBAction)deleteCurso:(id)sender {
    
    NSString *cursoIDToDelete = @"3HnbPx4FWx";
    
    [CursoParse deleteCurso:cursoIDToDelete];
}
- (IBAction)updateCurso:(id)sender {
    
    CursoDTO *cursoToUpdate = [[CursoDTO alloc]init];
    
  
    
    [cursoToUpdate setObjectId:@"uodpWgYv7w"];
    
    [cursoToUpdate setNombre:@"Curso a modidasddsfficar"];
    [cursoToUpdate setNivel:@"aR2gkAVupS"];
    
   
    [cursoToUpdate setPalabrasCompletas:[NSNumber numberWithInt:1]];
    [cursoToUpdate setTiempoEstudiando:[NSNumber numberWithInt:2]];
    [cursoToUpdate setCurso:[NSNumber numberWithInt:3]];
    [cursoToUpdate setCantidadPalabras:[NSNumber numberWithInt:4]];
    [cursoToUpdate setAvance:[NSNumber numberWithInt:5]];
    

    
    [CursoParse updateCurso:cursoToUpdate];
}
- (IBAction)selectCurso:(id)sender {
    
   [CursoParse selectCurso:@"uodpWgYv7w"];
    
}
- (IBAction)selectAllCursos:(id)sender {
    
   [CursoParse selectCursoAll];

}

- (IBAction)insertPalabra:(id)sender {
    
    PalabraDTO *palabraToInsert = [[PalabraDTO alloc]init];
    
      
    
    
    [palabraToInsert setTraduccion:@"Yugioh"];
    [palabraToInsert setEstado:[NSNumber numberWithInt:1]];
    [palabraToInsert setPrioridad:[NSNumber numberWithInt:2]];
    [palabraToInsert setCurso:@"8GSviRI5LO"];
    [palabraToInsert setTipoPalabra:[NSNumber numberWithInt:4]];
    [palabraToInsert setAvance:[NSNumber numberWithInt:5]];
    [palabraToInsert setPalabra:@"Juegos de cartas"];
    
    

    
    NSDate *now = [[NSDate alloc] init];
    [palabraToInsert setUltimaFechaRepaso:now];
     
    // Recordar que todas las llamadas a parse son asincronas xsiak
    [PalabraParse insertPalabra:palabraToInsert];

}

- (IBAction)deletePalabra:(id)sender {
    
    NSString *palabraIDToDelete = @"pRdMF0AU6M";
    
    [PalabraParse deletePalabra:palabraIDToDelete];
}

- (IBAction)updatePalabra:(id)sender {
    
    PalabraDTO *palabraToUpdate = [[PalabraDTO alloc]init];
    

    
    [palabraToUpdate setObjectId:@"6Eauose4ys"];
    [palabraToUpdate setCurso:@"uodpWgYv7w"];
    [palabraToUpdate setPalabra:@"BEST Card gamee"];
    [palabraToUpdate setTraduccion:@"BEST Card gamee"];
    [palabraToUpdate setUltimaFechaRepaso:[[NSDate alloc]init]];
    
    
    
    [palabraToUpdate setEstado:[NSNumber numberWithInt:1]];
    [palabraToUpdate setPrioridad:[NSNumber numberWithInt:2]];
    [palabraToUpdate setTipoPalabra:[NSNumber numberWithInt:4]];
    [palabraToUpdate setAvance:[NSNumber numberWithInt:5]];
    

    
    [PalabraParse updatePalabra:palabraToUpdate];
}

- (IBAction)selectPalabra:(id)sender {
    
    [PalabraParse selectPalabra:@"6Eauose4ys"];
    
    
}

- (IBAction)selectAllPalabras:(id)sender {
    
    [PalabraParse selectPalabraAll];
}

- (IBAction)insertOracion:(id)sender {
    
    OracionDTO *oracionToInsert = [[OracionDTO alloc]init];
    
    
     // [oracionToInsert setAudio:[NSNull null]];
    [oracionToInsert setTraduccion:@"Lolololo"];
    [oracionToInsert setPalabra:@"KnDCnROhOr"];
    [oracionToInsert setOracion:@"Lalalala"];
  
    
    // Recordar que todas las llamadas a parse son asincronas xsiak
    [OracionParse insertOracion:oracionToInsert];
}

- (IBAction)deleteOracion:(id)sender {
    
    
    NSString *oracionDToDelete = @"Ai6A0dCN1K";
    
    [OracionParse deleteOracion:oracionDToDelete];
}

- (IBAction)updateOracion:(id)sender {
    
    OracionDTO *oracionToUpdate = [[OracionDTO alloc]init];
    

    
    // [oracionToUpdate setAudio:[NSNull null]];
    [oracionToUpdate setObjectId:@"aS1lLxcsyG"];
    [oracionToUpdate setPalabra:@"KnDCnROhOr"];
    [oracionToUpdate setOracion:@"Oracion MOdificado"];
    [oracionToUpdate setTraduccion:@"BESsdsdfsd"];
 
     
    [OracionParse updateOracion:oracionToUpdate];

}

- (IBAction)selectOracion:(id)sender {
    
    
    [OracionParse selectOracion:@"aS1lLxcsyG"];
    
   
}

- (IBAction)selectAllOraciones:(id)sender {
    
   [OracionParse  selectOracionAll];
}

- (IBAction)selectCursoByNivelID:(id)sender {
    
    [CursoParse selectCursoAllByNivelID:@"Af7cHOjsa7"];
}

- (IBAction)selectPalabrasByCursoID:(id)sender {
    
    [PalabraParse selectPalabraAllByCursoID:@"8GSviRI5LO"];
}

- (IBAction)selectOracionByPalabraID:(id)sender {
    
     [OracionParse selectOracionAllByPalabraID:@"8PWJnYaj3F"];
}
@end
