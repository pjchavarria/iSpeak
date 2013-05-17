//
//  SDCoreDataController.h
//  SignificantDates
//
//  Created by Chris Wagner on 5/14/12.
//

#import <Foundation/Foundation.h>
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
- (void)insertOracion:(OracionDTO*)data;
- (void)insertPalabra:(PalabraDTO*)data;
- (void)insertPalabraAvance:(PalabraAvanceDTO*)data;
- (void)insertCursoAvance:(CursoAvanceDTO*)data;

- (void)updateCurso:(CursoDTO*)data;
- (void)updateOracion:(OracionDTO*)data;
- (void)updatePalabra:(PalabraDTO*)data;
- (void)updatePalabraAvance:(PalabraAvanceDTO*)data;
- (void)updateCursoAvance:(CursoAvanceDTO*)data;


- (id)getObjectForClass:(NSString *)className predicate:(NSPredicate *)predicate;
- (NSArray *)managedObjectsForClass:(NSString *)className;
- (NSArray *)managedObjectsForClass:(NSString *)className predicate:(NSPredicate *)predicate;
- (NSArray *)managedObjectsForClass:(NSString *)className sortKey:(NSString *)sortKey ascending:(BOOL)ascending;
@end
