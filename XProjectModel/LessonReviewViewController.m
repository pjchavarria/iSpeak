//
//  LessonViewController.m
//  X Project
//
//  Created by Lion User on 14/05/2013.
//  Copyright (c) 2013 NextLvL. All rights reserved.
//

#import "LessonReviewViewController.h"
#import "PalabraAvance.h"
#import "Palabra.h"

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
- (IBAction)nextButton:(id)sender;
- (IBAction)backButton:(id)sender;
@end

@implementation LessonReviewViewController
{
    int contador;
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
	// Do any additional setup after loading the view.
    contador = 0;
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
            [self.palabraRespuesta1Button setTitle:palabra.palabra.traduccion forState:UIControlStateNormal];
            [self.palabraRespuesta2Button setTitle:pa.palabra.traduccion forState:UIControlStateNormal];
            pa = [array objectAtIndex:1];
            [self.palabraRespuesta3Button setTitle:pa.palabra.traduccion forState:UIControlStateNormal];
            pa = [array objectAtIndex:2];
            [self.palabraRespuesta4Button setTitle:pa.palabra.traduccion forState:UIControlStateNormal];
            break;
        }
        case 2:
        {
            NSMutableArray *array = [self getPalabrasRandom];
            PalabraAvance *pa = [array objectAtIndex:0];
            [self.palabraRespuesta2Button setTitle:palabra.palabra.traduccion forState:UIControlStateNormal];
            [self.palabraRespuesta1Button setTitle:pa.palabra.traduccion forState:UIControlStateNormal];
            pa = [array objectAtIndex:1];
            [self.palabraRespuesta3Button setTitle:pa.palabra.traduccion forState:UIControlStateNormal];
            pa = [array objectAtIndex:2];
            [self.palabraRespuesta4Button setTitle:pa.palabra.traduccion forState:UIControlStateNormal];
            break;
        }
        case 3:
        {
            NSMutableArray *array = [self getPalabrasRandom];
            PalabraAvance *pa = [array objectAtIndex:0];
            [self.palabraRespuesta3Button setTitle:palabra.palabra.traduccion forState:UIControlStateNormal];
            [self.palabraRespuesta2Button setTitle:pa.palabra.traduccion forState:UIControlStateNormal];
            pa = [array objectAtIndex:1];
            [self.palabraRespuesta1Button setTitle:pa.palabra.traduccion forState:UIControlStateNormal];
            pa = [array objectAtIndex:2];
            [self.palabraRespuesta4Button setTitle:pa.palabra.traduccion forState:UIControlStateNormal];
            break;
        }
        case 4:
        {
            NSMutableArray *array = [self getPalabrasRandom];
            PalabraAvance *pa = [array objectAtIndex:0];
            [self.palabraRespuesta4Button setTitle:palabra.palabra.traduccion forState:UIControlStateNormal];
            [self.palabraRespuesta2Button setTitle:pa.palabra.traduccion forState:UIControlStateNormal];
            pa = [array objectAtIndex:1];
            [self.palabraRespuesta3Button setTitle:pa.palabra.traduccion forState:UIControlStateNormal];
            pa = [array objectAtIndex:2];
            [self.palabraRespuesta1Button setTitle:pa.palabra.traduccion forState:UIControlStateNormal];
            break;
        }
            
        default:
            break;
    }
}

-(void)setLesson3WithWord:(PalabraAvance *)palabra
{
}

-(NSMutableArray *)getPalabrasRandom
{
    int index = arc4random()%self.palabras.count;
    PalabraAvance *pa  = [self.palabras objectAtIndex:index];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for(int i = 0; i < 3; i++)
    {
        while ([array containsObject:pa] || index == contador-10) {
            index = arc4random()%self.palabras.count;
            pa  = [self.palabras objectAtIndex:index];
        }
        [array addObject:pa];
    }
    return array;
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
    if(contador < 10)
    {
        [self hideLessons];
        PalabraAvance *pa = [self.palabras objectAtIndex:contador];
        [self setLesson1WithWord:pa];
        contador++;
    }
    else if(contador >= 10 && contador < 20)
    {
        [self hideLessons];
        [self setLesson2WithWord:[self.palabras objectAtIndex:contador-10]];
        contador++;
    }
    else if(contador >= 20 && contador < 30)
    {
        [self hideLessons];
        [self setLesson3WithWord:[self.palabras objectAtIndex:contador-20]];
        contador++;
    }
    else
    {
        [self performSegueWithIdentifier:@"finishLesson" sender:self];
    }
}

- (IBAction)backButton:(id)sender {
}

- (IBAction)palabraRespuesta1:(id)sender {
    NSString *asd = [((UIButton *)sender) titleForState:UIControlStateNormal];;
    [self checkRespuesta:asd];
    [self nextLesson];
}

- (IBAction)palabraRespuesta2:(id)sender {
    NSString *asd = [((UIButton *)sender) titleForState:UIControlStateNormal];;
    [self checkRespuesta:asd];
    [self nextLesson];
}

- (IBAction)palabraRespuesta3:(id)sender {
    NSString *asd = [((UIButton *)sender) titleForState:UIControlStateNormal];;
    [self checkRespuesta:asd];
    [self nextLesson];
}

- (IBAction)palabraRespuesta4:(id)sender {
    NSString *asd = [((UIButton *)sender) titleForState:UIControlStateNormal];;
    [self checkRespuesta:asd];
    [self nextLesson];
}
-(void)checkRespuesta:(NSString *)rpta
{
    PalabraAvance *pa = [self.palabras objectAtIndex:contador-11];
    if(rpta == pa.palabra.traduccion)
    {
        NSLog(@"bien");
    }
    else
    {
        NSLog(@"mal");        
    }
}
@end
