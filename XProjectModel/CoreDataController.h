//
//  SDCoreDataController.h
//  SignificantDates
//
//  Created by Chris Wagner on 5/14/12.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "DTO.h"
#import "CursoAvance.h"
#import "PalabraAvance.h"
#import "Oracion.h"
#import "Palabra.h"
#import "Usuario.h"
#import "Curso.h"
@class Usuario;

extern NSString * const kPalabraAvanceClass;
extern NSString * const kCursoAvanceClass;
extern NSString * const kOracionClass;
extern NSString * const kCursoClass;
extern NSString * const kPalabraClass;
extern NSString * const kUsuarioClass;

@interface CoreDataController : NSObject

@property (strong, nonatomic) Usuario *usuarioActivo;


+ (id)sharedInstance;

- (NSURL *)applicationDocumentsDirectory;

- (NSManagedObjectContext *)masterManagedObjectContext;
- (NSManagedObjectContext *)backgroundManagedObjectContext;
- (NSManagedObjectContext *)newManagedObjectContext;
- (void)saveMasterContext;
- (void)saveBackgroundContext;
- (NSManagedObjectModel *)managedObjectModel;
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;

- (void)insertUsuario:(UsuarioDTO *)data;
- (void)updateUsuario:(UsuarioDTO *)data;

- (void)insertCurso:(CursoDTO*)data;
- (void)insertOracion:(OracionDTO*)data palabra:(Palabra *)palabra;
- (void)insertPalabra:(PalabraDTO*)data curso:(Curso *)curso;
- (void)insertPalabraAvance:(PalabraAvanceDTO*)data palabra:(Palabra *)palabra;
- (void)insertCursoAvance:(CursoAvanceDTO*)data curso:(Curso *)curso;

- (void)updateCurso:(Curso*)curso withData:(CursoDTO*)data ;
- (void)updateOracion:(Oracion*)oracion withData:(OracionDTO*)data;
- (void)updatePalabra:(Palabra*)palabra withData:(PalabraDTO*)data;
- (void)updatePalabraAvance:(PalabraAvance*)palabraAvance withData:(PalabraAvanceDTO*)data;
- (void)updateCursoAvance:(CursoAvance*)cursoAvance withData:(CursoAvanceDTO*)data;


- (id)getObjectForClass:(NSString *)className predicate:(NSPredicate *)predicate;
- (NSArray *)managedObjectsForClass:(NSString *)className;
- (NSArray *)managedObjectsForClass:(NSString *)className predicate:(NSPredicate *)predicate;
- (NSArray *)managedObjectsForClass:(NSString *)className sortKey:(NSString *)sortKey ascending:(BOOL)ascending;
@end
