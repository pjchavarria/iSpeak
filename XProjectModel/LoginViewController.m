//
//  LoginViewController.m
//  X Project
//
//  Created by Lion User on 30/04/2013.
//  Copyright (c) 2013 NextLvL. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
@property (strong, nonatomic) IBOutlet UITextField *txtUsername;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UIView *controles;

- (IBAction)loginButtonPressed:(id)sender;
@end

@implementation LoginViewController
{
    BOOL subio;
    BOOL keepUp;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToDashboard) name:@"kUserDidEnter" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shakeView) name:@"kUserDidNotEnter" object:nil];
	self.txtUsername.text = @"";
	self.txtPassword.text = @"";
    [self.txtPassword setSecureTextEntry:YES];
    subio = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(!subio)
    {
        subio = YES;
        [self animateViewUp:YES];
    }
    if(subio)
        keepUp = YES;
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(subio)
    {
        subio = NO;
        [self animateViewUp:NO];
        [textField resignFirstResponder];
    }
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if(subio)
    {
        if(!keepUp)
        {
            subio = NO;
            [self animateViewUp:NO];
        }
    }
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint location = [[touches anyObject] locationInView:self.view];
    CGRect touch = CGRectMake(location.x, location.y, 1, 1);
    
    if(!CGRectIntersectsRect(touch, self.txtUsername.frame))
        if(!CGRectIntersectsRect(touch, self.txtPassword.frame))
        {
            keepUp = NO;
            [self.view endEditing:YES];
        }
}
-(void)animateViewUp:(BOOL)up
{
    if(up)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];
        [UIView setAnimationRepeatAutoreverses:NO];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        
        [self.view setCenter:CGPointMake(self.view.center.x, self.view.center.y-118)];
        
        [UIView commitAnimations];
    }
    else
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];
        [UIView setAnimationRepeatAutoreverses:NO];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        
        [self.view setCenter:CGPointMake(self.view.center.x, self.view.center.y+118)];
        
        [UIView commitAnimations];
    }
}
- (void)shakeView
{
    UIView *viewToShake = self.controles;
    CGFloat t = 8.0;
    CGAffineTransform translateRight  = CGAffineTransformTranslate(CGAffineTransformIdentity, t, 0.0);
    CGAffineTransform translateLeft = CGAffineTransformTranslate(CGAffineTransformIdentity, -t, 0.0);
    
    viewToShake.transform = translateLeft;
    
    [UIView animateWithDuration:0.07 delay:0.0 options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat animations:^{
        [UIView setAnimationRepeatCount:2.0];
        viewToShake.transform = translateRight;
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                viewToShake.transform = CGAffineTransformIdentity;
            } completion:NULL];
        }
    }];
}
- (void)goToDashboard{
    [self.view endEditing:YES];
    subio = NO;
    [self performSegueWithIdentifier:@"login" sender:nil];
}
- (IBAction)loginButtonPressed:(id)sender {
	[self goToDashboard];
    //[UsuarioParse validateUsuario:self.txtUsername.text Password:self.txtPassword.text];
}
@end
