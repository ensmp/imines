//
//  ComposeCommentVC.m
//  iMines-1
//
//  Created by François de la Taste on 28/08/11.
//  Copyright 2011 Mines ParisTech. All rights reserved.
//

#import "ComposeCommentVC.h"
#import "ASIFormDataRequest.h"
#import <QuartzCore/QuartzCore.h>

@implementation ComposeCommentVC
@synthesize delegate, idVDM;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    textField.layer.cornerRadius = 5.0f;
    textField.layer.borderColor = [UIColor blackColor].CGColor;
    textField.layer.borderWidth = 1.0f;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    keyboardIsShown = FALSE;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)dismiss{
    [self.delegate ComposeCommentVC:self shouldDismiss:YES];
}
#pragma mark - Keyboard management

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    keyboardIsShown = TRUE;
    rightBarButtonItem.title = @"OK";
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, textField.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, textField.frame.origin.y-kbSize.height);
        [scrollView setContentOffset:scrollPoint animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    keyboardIsShown = FALSE;
    rightBarButtonItem.title = @"Envoyer";
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)addComment{
    if(keyboardIsShown) {
        [textField resignFirstResponder];
    }
    else
    {
        
        NSString *contenuComment = textField.text;
        contenuComment = [contenuComment stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *settingsPath = [[NSBundle mainBundle] pathForResource:@"SETTINGS" ofType:@"plist"];
        NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:settingsPath];
        
        NSUserDefaults *userSettings = [NSUserDefaults standardUserDefaults];
        NSString *poster = [userSettings stringForKey:@"login_ccsi"];
        NSString *secretKey = [settings objectForKey:@"vdm-secretkey"];
        // Construction de la requête
        
        
        
        NSString *baseURLVDM = [[settings objectForKey:@"serveur-vdm"] stringByAppendingString:[settings objectForKey:@"vdm-writecomm"]];
        //NSString *userLogin = [defaultSettings stringForKey:@"login_vdm"];
        //NSString *userPassword = [defaultSettings stringForKey:@"password_vdm"];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:baseURLVDM]];     
        
        [request setShouldAttemptPersistentConnection:YES];
        [request setPersistentConnectionTimeoutSeconds:120];
        [request setPostValue:contenuComment forKey:@"body"];
        [request setPostValue:poster forKey:@"poster"];
        [request setPostValue:secretKey forKey:@"key"];
        [request setPostValue:[NSString stringWithFormat:@"%d",idVDM] forKey:@"id"];
        //[request setUsername:userLogin];
        //[request setPassword:userPassword];
        NSLog(@"contenu : %@",contenuComment);
        NSLog(@"poster : %@",poster);
        NSLog(@"ID : %@",[NSString stringWithFormat:@"%d",idVDM]);
        NSLog(@"requete : %@",[request url]);
        [request startSynchronous];
       
        
        NSError *error = [request error];
        if (!error) {
            //NSLog(@"Pas d'erreur !");
            NSString *response = [request responseString];
            
            NSLog(@"Reponse : %@", response);
            
            if ([response rangeOfString:@"OK"].location != NSNotFound) {
                
                UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Commentaire posté !" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [errorAlert show];
                [errorAlert release];
                [self.delegate ComposeCommentVC:self shouldDismiss:YES];
            }
            else {
                UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Erreur :" message:@"Le commentaire n'a pas été posté" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [errorAlert show];
                [errorAlert release];
            }
        }
        else {
            UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Erreur :" message:@"Impossible d'envoyer la requête" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [errorAlert show];
            [errorAlert release];
        }
    }
}
@end
