//
//  ParseTestViewController.h
//  XProjectModel
//
//  Created by Daniel Soto on 5/13/13.
//  Copyright (c) 2013 Next Level. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParseTestViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *insertUserButton;
- (IBAction)insertUser:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *deleteUserButton;
- (IBAction)deleteUser:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *updateUserButton;
- (IBAction)updateUser:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *selectUserButton;
- (IBAction)selectUser:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *selectAllUsersButton;
- (IBAction)selectAllUsers:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *insertCursoButton;
- (IBAction)insertCurso:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *deleteCursoButton;
- (IBAction)deleteCurso:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *updateCursoButton;
- (IBAction)updateCurso:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *selectCursoButton;
- (IBAction)selectCurso:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *selectAllCursosButton;
- (IBAction)selectAllCursos:(id)sender;


- (IBAction)insertPalabra:(id)sender;
- (IBAction)deletePalabra:(id)sender;
- (IBAction)updatePalabra:(id)sender;
- (IBAction)selectPalabra:(id)sender;
- (IBAction)selectAllPalabras:(id)sender;


- (IBAction)insertOracion:(id)sender;
- (IBAction)deleteOracion:(id)sender;
- (IBAction)updateOracion:(id)sender;
- (IBAction)selectOracion:(id)sender;
- (IBAction)selectAllOraciones:(id)sender;



- (IBAction)selectCursoByNivelID:(id)sender;
- (IBAction)selectPalabrasByCursoID:(id)sender;
- (IBAction)selectOracionByPalabraID:(id)sender;







@end
