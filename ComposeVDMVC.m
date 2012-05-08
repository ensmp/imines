//
//  ComposeVDMVC.m
//  iMines-1
//
//  Created by François de la Taste on 03/08/11.
//  Copyright 2011 Mines ParisTech. All rights reserved.
//

#import "ComposeVDMVC.h"
#import <QuartzCore/QuartzCore.h>
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"

@implementation ComposeVDMVC
@synthesize delegate;
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
    
    selectedCategoryNumber = -1;
    
    categories = [[NSArray alloc] initWithObjects:
                  @"Absurde",
                  @"Amour",
                  @"Assoces",
                  @"Emploi/Stage",
                  @"Soirées",
                  @"Vacances/VP",
                  @"Inclassable",
                  nil];
    
    keyboardIsShown = FALSE;
    
    [textField.layer setBorderWidth:1.0f];
    [textField.layer setBorderColor:[UIColor blackColor].CGColor];
    [textField.layer setCornerRadius:5.0f];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    NSUserDefaults *defaultSettings = [NSUserDefaults standardUserDefaults];
	NSString *userLogin = [defaultSettings stringForKey:@"login_ccsi"];
    NSString *userPassword = [defaultSettings stringForKey:@"password_ccsi"];
    if([userLogin isEqualToString:@""] || [userPassword isEqualToString:@""]){
        // Les identifiants ne sont pas renseignés, on alerte et on revient en arrière (géré par alertView:clickedButtonAtIndex:)
        NSString *errorString = @"Tu dois renseigner ton login pour poster des VDM";
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"VieDeMineur" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alert.tag = 999;
        
        [alert show];
		[alert release];
        
        
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // On a cliqué sur un des boutons de l'alerte affichée si les identifiants ne sont pas renseignés :
	if(buttonIndex==0 && alertView.tag == 999){ // buttonIndex devrait toujours valoir 0 ici,et le tag sert à reconnaître la bonne alerte (pour ne pas confondre  avec l'oubli de sélection de catégorie)
        [self.delegate ComposeVDMVC:self shouldDismiss:YES];
	}
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
- (IBAction)dismiss{
    
    [self.delegate ComposeVDMVC:self shouldDismiss:YES];
    
}
- (IBAction)addVDM {
    if(keyboardIsShown) {
        [textField resignFirstResponder];
    }
    else {
        if (selectedCategoryNumber == -1) {
            // l'utilisateur n'a pas sélectionné de catégorie...
            NSString *errorString = @"Sélectionne une catégorie !";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"VieDeMineur" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alert show];
            [alert release];
        }
        else if ([textField.text isEqualToString:@""] || [textField.text isEqualToString:@"Aujourd'hui..."]) {
            // le champ "contenu" est vide...
            NSString *errorString = @"Remplis ta VDM!";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"VieDeMineur" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alert show];
            [alert release];
        }
        else {
            UIActionSheet *actionSheet = [UIActionSheet alloc];
            [actionSheet initWithTitle:@"Confirmer l'envoi" delegate:self cancelButtonTitle:@"Annuler" destructiveButtonTitle:@"Poster ma VDM" otherButtonTitles:nil];
            //[actionSheet showFromTabBar:self.tabBarController.tabBar];
            [actionSheet showInView:self.view];
            
        }
        
        
    }
}

- (void)actionSheet:(UIActionSheet  *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"button index : %d",buttonIndex);
    if(buttonIndex==0){
        
        // On envoie la requête pour créer une VDM
     
        NSString *contenuVDM = textField.text;
        contenuVDM = [contenuVDM stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSUserDefaults *defaultSettings = [NSUserDefaults standardUserDefaults];
        NSString *poster = [defaultSettings stringForKey:@"login_ccsi"];
        NSString *promo = [poster stringByPaddingToLength:2 withString:@"" startingAtIndex:0];
        promo = [@"P" stringByAppendingString:promo];
        
 
        NSString *catNumber = [NSString stringWithFormat:@"%d",selectedCategoryNumber+1];
        
        NSString *settingsPath = [[NSBundle mainBundle] pathForResource:@"SETTINGS" ofType:@"plist"];
        NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:settingsPath];
        NSString *secretKey = [settings objectForKey:@"vdm-secretkey"];
        // Construction de la requête
        
        NSString *baseURLVDM = [[settings objectForKey:@"serveur-vdm"] stringByAppendingString:[settings objectForKey:@"vdm-writenew"]];
        
        //NSString *userLogin = [defaultSettings stringForKey:@"login_vdm"];
        //NSString *userPassword = [defaultSettings stringForKey:@"password_vdm"];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:baseURLVDM]];     
        
        [request setShouldAttemptPersistentConnection:YES];
        [request setPersistentConnectionTimeoutSeconds:120];
        [request setPostValue:contenuVDM forKey:@"body"];
        [request setPostValue:poster forKey:@"poster"];
        [request setPostValue:promo forKey:@"promo"];
        [request setPostValue:catNumber forKey:@"category"];
        [request setPostValue:secretKey forKey:@"key"];
        NSLog(@"body : %@",contenuVDM);
        NSLog(@"poster : %@", poster);
        NSLog(@"promo : %@", promo);
        NSLog(@"category : %@", catNumber);
        NSLog(@"Key : %@", secretKey);
        
        
        
        //[request setUsername:userLogin];
        //[request setPassword:userPassword];
        //[request setShouldPresentCredentialsBeforeChallenge:NO];
        [request startSynchronous];
        NSError *error = [request error];
        if (!error) {
           // NSLog(@"Pas d'erreur !");
            NSString *response = [request responseString];
            NSLog(@"Reponse : %@", response);
            
            if ([response rangeOfString:@"OK"].location != NSNotFound) {
                
                UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"VDM postée !" message:@"Ta VDM doit maintenant être validée pour apparaître sur le site" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [errorAlert show];
                [errorAlert release];
                [self.delegate ComposeVDMVC:self shouldDismiss:YES];
            }
            else {
                UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Erreur :" message:@"La VDM n'a pas été postée" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
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





- (IBAction)selectCategory {
    VDMCategorySelectionTVC *vdmcstvc = [[VDMCategorySelectionTVC alloc] initWithStyle:UITableViewStyleGrouped andArray:categories];
    [vdmcstvc setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [vdmcstvc setDelegate:self];
    [self presentModalViewController:vdmcstvc animated:YES];
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


#pragma mark - VDM Category Selection delegate
- (IBAction)VDMCategorySelection:(VDMCategorySelectionTVC *)vdmcstvc selectedCategory:(int)categoryNumber {
    selectedCategoryNumber = categoryNumber;
    [self dismissModalViewControllerAnimated:YES];
    [categoryButton setTitle:[categories objectAtIndex:categoryNumber] forState:UIControlStateNormal];
}
@end
