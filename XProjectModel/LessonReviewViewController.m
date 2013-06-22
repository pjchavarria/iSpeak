//
//  LessonViewController.m
//  X Project
//
//  Created by Lion User on 14/05/2013.
//  Copyright (c) 2013 NextLvL. All rights reserved.
//

#import "LessonReviewViewController.h"
#import "LessonFinishViewController.h"
#import "CoreDataController.h"
#import "PalabraAvance.h"
#import "Palabra.h"

#import <AVFoundation/AVFoundation.h>

enum {
    kSincronizacionEstadoInsertado,
    kSincronizacionEstadoModificado,
    kSincronizacionEstadoEliminado,
    kSincronizacionEstadoSincronizado
}SincronizacionEstado;

@interface LessonReviewViewController ()
// First excercise
@property (strong, nonatomic) IBOutlet UIView *firstView;
@property (strong, nonatomic) IBOutlet UILabel *palabraLabel;
@property (strong, nonatomic) IBOutlet UILabel *significadoLabel;


// Second excercise
@property (strong, nonatomic) IBOutlet UIView *secondView;
@property (strong, nonatomic) IBOutlet UILabel *palabraEnunciadoLabel;

@property (strong, nonatomic) IBOutlet UIButton *palabraRespuesta1Button;
@property (strong, nonatomic) IBOutlet UIButton *palabraRespuesta2Button;
@property (strong, nonatomic) IBOutlet UIButton *palabraRespuesta3Button;
@property (strong, nonatomic) IBOutlet UIButton *palabraRespuesta4Button;


// Third excercise
@property (strong, nonatomic) IBOutlet UIView *thirdView;
@property (strong, nonatomic) IBOutlet UILabel *oracionIncompletaLabel;

// Progress
@property (strong, nonatomic) IBOutlet UIImageView *progressImageView;

// Command Buttons
@property (strong, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) IBOutlet UIButton *backButton;

// Repeat sound actions
- (IBAction)repeatWord:(id)sender;
- (IBAction)repeatOracion:(id)sender;


- (IBAction)nextButton:(id)sender;
- (IBAction)backButton:(id)sender;
@end

@implementation LessonReviewViewController
{
    int contador;
    int numeroDePalabras;
    NSString *respuestaActual;
	NSMutableArray *fallas;
	AVAudioPlayer *_backgroundMusicPlayer;
    NSDate *inicio;
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
    inicio = [NSDate date];
	// Do any additional setup after loading the view.
    fallas = [[NSMutableArray alloc] initWithCapacity:numeroDePalabras];
    for (int i = 0; i < numeroDePalabras; i++) {
        [fallas addObject:[NSNumber numberWithInt:0]];
    }
    numeroDePalabras = self.palabras.count;
    contador = 0;
    self.progressImageView.image = [[UIImage imageNamed:@"dashboad-progress-bar-started.png"]
                              resizableImageWithCapInsets:UIEdgeInsetsMake(0,3,0,3)];
    self.progressImageView.frame = CGRectMake(self.progressImageView.frame.origin.x, self.progressImageView.frame.origin.y, 273*(contador/numeroDePalabras), self.progressImageView.frame.size.height);
    
    [self.txtRespuestaOracion setDelegate:self];
    [self.txtRespuestaOracion setAutocorrectionType:UITextAutocorrectionTypeNo];
    
    [self nextLesson];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)hideLessons
{
    [self.firstView setHidden:YES];
    [self.secondView setHidden:YES];
    [self.thirdView setHidden:YES];
}

-(void)setLesson1WithWord:(PalabraAvance *)palabra
{
    [self.firstView setHidden:NO];
    [self.palabraLabel setText:palabra.palabra.palabra];
    [self.significadoLabel setText:palabra.palabra.traduccion];
	
	NSData *audio = palabra.palabra.audio;
	NSError *error;
	_backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithData:audio error:&error];
	[_backgroundMusicPlayer prepareToPlay];
	[_backgroundMusicPlayer play];
}

-(void)setLesson2WithWord:(PalabraAvance *)palabra
{
    [self.secondView setHidden:NO];
    [self.palabraEnunciadoLabel setText:palabra.palabra.palabra];
    
    int random = arc4random()%4;
    if(random == 0)
        random ++;
    
    switch (random) {
        case 1:
        {
            NSMutableArray *array = [self getPalabrasRandom];
            PalabraAvance *pa = [array objectAtIndex:0];
            [self.palabraRespuesta1Button setTitle:[NSString stringWithFormat:@"  %@",palabra.palabra.traduccion] forState:UIControlStateNormal];
            [self.palabraRespuesta2Button setTitle:[NSString stringWithFormat:@"  %@",pa.palabra.traduccion] forState:UIControlStateNormal];
            pa = [array objectAtIndex:1];
            [self.palabraRespuesta3Button setTitle:[NSString stringWithFormat:@"  %@",pa.palabra.traduccion] forState:UIControlStateNormal];
            pa = [array objectAtIndex:2];
            [self.palabraRespuesta4Button setTitle:[NSString stringWithFormat:@"  %@",pa.palabra.traduccion] forState:UIControlStateNormal];
            break;
        }
        case 2:
        {
            NSMutableArray *array = [self getPalabrasRandom];
            PalabraAvance *pa = [array objectAtIndex:0];
            [self.palabraRespuesta2Button setTitle:[NSString stringWithFormat:@"  %@",palabra.palabra.traduccion] forState:UIControlStateNormal];
            [self.palabraRespuesta1Button setTitle:[NSString stringWithFormat:@"  %@",pa.palabra.traduccion] forState:UIControlStateNormal];
            pa = [array objectAtIndex:1];
            [self.palabraRespuesta3Button setTitle:[NSString stringWithFormat:@"  %@",pa.palabra.traduccion] forState:UIControlStateNormal];
            pa = [array objectAtIndex:2];
            [self.palabraRespuesta4Button setTitle:[NSString stringWithFormat:@"  %@",pa.palabra.traduccion] forState:UIControlStateNormal];
            break;
        }
        case 3:
        {
            NSMutableArray *array = [self getPalabrasRandom];
            PalabraAvance *pa = [array objectAtIndex:0];
            [self.palabraRespuesta3Button setTitle:[NSString stringWithFormat:@"  %@",palabra.palabra.traduccion] forState:UIControlStateNormal];
            [self.palabraRespuesta2Button setTitle:[NSString stringWithFormat:@"  %@",pa.palabra.traduccion] forState:UIControlStateNormal];
            pa = [array objectAtIndex:1];
            [self.palabraRespuesta1Button setTitle:[NSString stringWithFormat:@"  %@",pa.palabra.traduccion] forState:UIControlStateNormal];
            pa = [array objectAtIndex:2];
            [self.palabraRespuesta4Button setTitle:[NSString stringWithFormat:@"  %@",pa.palabra.traduccion] forState:UIControlStateNormal];
            break;
        }
        case 4:
        {
            NSMutableArray *array = [self getPalabrasRandom];
            PalabraAvance *pa = [array objectAtIndex:0];
            [self.palabraRespuesta4Button setTitle:[NSString stringWithFormat:@"  %@",palabra.palabra.traduccion] forState:UIControlStateNormal];
            [self.palabraRespuesta2Button setTitle:[NSString stringWithFormat:@"  %@",pa.palabra.traduccion] forState:UIControlStateNormal];
            pa = [array objectAtIndex:1];
            [self.palabraRespuesta3Button setTitle:[NSString stringWithFormat:@"  %@",pa.palabra.traduccion] forState:UIControlStateNormal];
            pa = [array objectAtIndex:2];
            [self.palabraRespuesta1Button setTitle:[NSString stringWithFormat:@"  %@",pa.palabra.traduccion] forState:UIControlStateNormal];
            break;
        }
            
        default:
            break;
    }
    respuestaActual = palabra.palabra.traduccion;
}

-(void)setLesson3WithWord:(PalabraAvance *)palabra
{
    [self.thirdView setHidden:NO];
    CoreDataController *coreDataController = [CoreDataController sharedInstance];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"palabra.objectId like %@",palabra.palabra.objectId];
    NSArray *oraciones = [coreDataController managedObjectsForClass:kOracionClass predicate:predicate];
    
    int random = arc4random()%oraciones.count;
    
    Oracion *oracion = [oraciones objectAtIndex:random];
	NSData *audio = oracion.audio;
	NSError *error;
	_backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithData:audio error:&error];
	[_backgroundMusicPlayer prepareToPlay];
	[_backgroundMusicPlayer play];
	
    NSString *oracionText = oracion.oracion;
    int start,end;
    for (int i=0;i<[oracionText length];i++) {
        char ch;
        ch = [oracionText  characterAtIndex:i];
        if(ch == '*')
        {
            end = i;
        }
    }
    for (int i=[oracionText length]-1;i>=0;i--) {
        char ch;
        ch = [oracionText  characterAtIndex:i];
        if(ch == '*')
        {
            start = i;
        }
    }
    NSRange theRange;
    theRange.location = start;
    theRange.length = end-start+1;
    
    int numeroDeEspacios = theRange.length-4;
    NSString *espacios = @"";
    for (int i=0; i<numeroDeEspacios; i++) {
        if(i == numeroDeEspacios -1)
        espacios =[espacios stringByAppendingString:@"_"];
        else
            espacios =[espacios stringByAppendingString:@"_ "];
    }
    
    NSString *sub = [oracionText substringWithRange:theRange];
    oracionText = [oracionText stringByReplacingOccurrencesOfString:sub withString:espacios];
    
    [self.oracionIncompletaLabel setText:oracionText];
    theRange.location = 2;
    theRange.length = [sub length]-4;
    respuestaActual = [sub substringWithRange:theRange];
}

-(NSMutableArray *)getPalabrasRandom
{
    int index = arc4random()%self.palabras.count;
    PalabraAvance *pa  = [self.palabras objectAtIndex:index];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for(int i = 0; i < 3; i++)
    {
        while ([array containsObject:pa] || index == contador-numeroDePalabras) {
            index = arc4random()%self.palabras.count;
            pa  = [self.palabras objectAtIndex:index];
        }
        [array addObject:pa];
    }
    return array;
}

- (IBAction)repeatWord:(id)sender {
    
    [_backgroundMusicPlayer stop];
    [_backgroundMusicPlayer prepareToPlay];
	[_backgroundMusicPlayer play];
}

- (IBAction)repeatOracion:(id)sender {
    
    [_backgroundMusicPlayer stop];
    [_backgroundMusicPlayer prepareToPlay];
	[_backgroundMusicPlayer play];
}

- (IBAction)nextButton:(id)sender {
    /*if(![self.firstView isHidden])
    {
        [self.firstView setHidden:YES];
        [self.secondView setHidden:NO];
    }
    else if(![self.secondView isHidden])
    {
        [self.secondView setHidden:YES];
        [self.thirdView setHidden:NO];
    }
    else if(![self.thirdView isHidden])
    {
        [self performSegueWithIdentifier:@"pushLessonReview" sender:nil];
    }
     */
    [self nextLesson];
}

-(void)nextLesson
{
    
    if(contador < numeroDePalabras)
    {
        [self hideLessons];
        PalabraAvance *pa = [self.palabras objectAtIndex:contador];
        [self setLesson1WithWord:pa];
        contador++;
        float ratio = (contador*1.0/(numeroDePalabras*3.0));
        self.progressImageView.frame = CGRectMake(self.progressImageView.frame.origin.x, self.progressImageView.frame.origin.y, 273*ratio, self.progressImageView.frame.size.height);
    }
    else if(contador >= numeroDePalabras && contador < numeroDePalabras*2)
    {
        [self hideLessons];
        [self setLesson2WithWord:[self.palabras objectAtIndex:contador-numeroDePalabras]];
        contador++;
        float ratio = (contador*1.0/(numeroDePalabras*3.0));
        self.progressImageView.frame = CGRectMake(self.progressImageView.frame.origin.x, self.progressImageView.frame.origin.y, 273*ratio, self.progressImageView.frame.size.height);
    }
    else if(contador >= numeroDePalabras*2 && contador < numeroDePalabras*3)
    {
        [self hideLessons];
        [self setLesson3WithWord:[self.palabras objectAtIndex:contador-numeroDePalabras*2]];
        contador++;
        float ratio = (contador*1.0/(numeroDePalabras*3.0));
        self.progressImageView.frame = CGRectMake(self.progressImageView.frame.origin.x, self.progressImageView.frame.origin.y, 273*ratio, self.progressImageView.frame.size.height);
    }
    else
    {
        [self applyChangesPalabras];
        [self applyChangesCurso];
        [self performSegueWithIdentifier:@"finishLesson" sender:self];
    }
}

- (IBAction)backButton:(id)sender {
}

- (IBAction)palabraRespuesta1:(id)sender {
    NSString *asd = [((UIButton *)sender) titleForState:UIControlStateNormal];
    [self checkRespuesta:asd];
    [self nextLesson];
}

- (IBAction)palabraRespuesta2:(id)sender {
    NSString *asd = [((UIButton *)sender) titleForState:UIControlStateNormal];
    [self checkRespuesta:asd];
    [self nextLesson];
}

- (IBAction)palabraRespuesta3:(id)sender {
    NSString *asd = [((UIButton *)sender) titleForState:UIControlStateNormal];
    [self checkRespuesta:asd];
    [self nextLesson];
}

- (IBAction)palabraRespuesta4:(id)sender {
    NSString *asd = [((UIButton *)sender) titleForState:UIControlStateNormal];
    [self checkRespuesta:asd];
    [self nextLesson];
}
-(void)checkRespuesta:(NSString *)rpta
{
    if([rpta isEqualToString:[@"  " stringByAppendingString:respuestaActual]])
    {
        NSLog(@"bien");
    }
    else
    {
        [fallas replaceObjectAtIndex:(contador-numeroDePalabras-1) withObject:[NSNumber numberWithInt:1]];
        NSLog(@"mal");        
    }
}
-(void)checkOracion
{
    if([self.txtRespuestaOracion.text isEqualToString:respuestaActual])
    {
        NSLog(@"bien");
    }
    else
    {
        [fallas replaceObjectAtIndex:(contador-numeroDePalabras*2-1) withObject:[NSNumber numberWithInt:1]];
        NSLog(@"mal");
    }
    [self.txtRespuestaOracion setText:@""];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [[self thirdView] endEditing:YES];
    [self checkOracion];
    [self nextLesson];
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"finishLesson"]) {
        LessonFinishViewController *controller = segue.destinationViewController;
        controller.cursoAvance = self.cursoAvance;
        controller.curso = self.curso;
    }
}
-(void)applyChangesPalabras
{
    int i = 0;
    for (PalabraAvance *pa in self.palabras) {
        NSNumber *fallo = [fallas objectAtIndex:i];
        if([fallo intValue] == 0)
        {
            pa.avance = [NSNumber numberWithFloat:[pa.avance floatValue] +0.2];
        }
        else
        {
            if([pa.avance floatValue] < 0.9)
            {
                pa.avance = [NSNumber numberWithFloat:[pa.avance floatValue] +0.05];
            }
            else
            {
                pa.avance = [NSNumber numberWithFloat:[pa.avance floatValue] +0.02];
            }
        }
        
        NSDate *ultimaFechaRepaso = pa.ultimaFechaRepaso;
        NSDate *actual = [NSDate date];
        
        NSTimeInterval distanceBetweenDates = [actual timeIntervalSinceDate:ultimaFechaRepaso];
        double secondsInAnHour = 3600;
        NSInteger hoursBetweenDates = distanceBetweenDates / secondsInAnHour;
        
        double formula = 0.0;
        if([fallo intValue] == 0)
        {
            formula = hoursBetweenDates*0.5;
        }
        
        formula = ((formula*10)/([pa.avance floatValue]));
        
        pa.prioridad = [NSNumber numberWithDouble:formula];
        pa.sincronizado = [NSNumber numberWithInt:kSincronizacionEstadoModificado];
        pa.ultimaFechaRepaso = [NSDate date];
        
        i++;
    }
    
    [[CoreDataController sharedInstance] saveBackgroundContext];
    [[CoreDataController sharedInstance] saveMasterContext];
}
-(void)applyChangesCurso
{
    CoreDataController *coreDataController = [CoreDataController sharedInstance];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"palabra.curso.objectId like %@ AND usuario.objectId like %@",self.curso.objectId, self.cursoAvance.usuario.objectId];
    NSArray *palabrasAvance = [coreDataController managedObjectsForClass:kPalabraAvanceClass predicate:predicate];
    
    double avanceCurso = 0.0;
    int palabrasComenzadas = 0;
    int palabrasCompletas = 0;
    int palabrasTotales = 0;
    
    for (PalabraAvance *pa in palabrasAvance) {
        avanceCurso += [pa.avance floatValue];
        double avance = [pa.avance floatValue];
        if(avance != 0.0 && avance != 100.0)
        {
            palabrasComenzadas++;
        }
        else if(avance != 0.0)
        {
            palabrasCompletas++;
        }
        palabrasTotales++;
            
    }

    avanceCurso = avanceCurso/palabrasAvance.count;
    
    NSTimeInterval distanceBetweenDates = [inicio timeIntervalSinceDate:[NSDate date]];
    double secondsInAnMinute = 60;
    NSInteger tiempoEstudiado = distanceBetweenDates / secondsInAnMinute;
    
    [self.cursoAvance setPalabrasComenzadas:[NSNumber numberWithInt:palabrasComenzadas]];
    [self.cursoAvance setPalabrasCompletas:[NSNumber numberWithInt:palabrasCompletas]];
    [self.cursoAvance setPalabrasTotales:[NSNumber numberWithInt:palabrasTotales]];
    [self.cursoAvance setAvance:[NSNumber numberWithDouble:avanceCurso]];
    [self.cursoAvance setTiempoEstudiado:[NSNumber numberWithInt:tiempoEstudiado+[self.cursoAvance.tiempoEstudiado intValue]]];
    [self.cursoAvance setSincronizado:[NSNumber numberWithInt:kSincronizacionEstadoModificado]];
    
    [[CoreDataController sharedInstance] saveBackgroundContext];
    [[CoreDataController sharedInstance] saveMasterContext];
}
@end
