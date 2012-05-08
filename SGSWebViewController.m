//
//  SGSWebViewController.m
//  iMines-1
//
//  Created by François de la Taste on 18/12/10.
/*
This file is part of iMines ParisTech.

iMines ParisTech is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

iMines ParisTech is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#import "SGSWebViewController.h"
#import "ASIFormDataRequest.h"

@implementation SGSWebViewController
@synthesize webView;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization.
 }
 return self;
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	// Construction de la requête
	NSUserDefaults *defaultSettings = [NSUserDefaults standardUserDefaults];
	NSURL *urlSGS = [[NSURL alloc] initWithString:@"https://sgs.mines-paristech.fr/prod/sgs/ensmp/php_login.php"];
	
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:urlSGS];
	[urlSGS release];
	[request setDelegate:self];
	NSString *userName = [defaultSettings stringForKey:@"login_ccsi"] ;
	NSString *userPassword = [defaultSettings stringForKey:@"password_ccsi"] ;
	if ([userName length]==0 || [userPassword length]==0) {
		// identifiants mal renseignés -> on affiche un texte de description de SGS
		UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Système de Gestion\nde la Scolarité" message:@"Tu veux savoir ta note de projet TMF ou te rajouter une 12ème langue vivante ?\nSGS est LA plateforme de centralisation des infos sur les cours!\n\nSi tu es élève de l'école, va renseigner tes identifiants dans les Paramètres de l'iPhone" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[errorAlert show];
		[errorAlert release];
	}
	else {
		// on envoie la requête avec les identifiants...
		
		[request setPostValue:userName forKey:@"login"];
		[request setPostValue:userPassword forKey:@"password"];
		[request start];
		
		//[webView loadRequest:request];
		NSError *error = [request error];
		if (!error) {
			NSLog(@"Pas d'erreur !");
		}
		else {
			UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Erreur :" message:@"Impossible d'envoyer la requête" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[errorAlert show];
			[errorAlert release];
		}
	}
}


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */


- (void)requestFinished:(ASIHTTPRequest *)request
{
	// Use when fetching text data
	NSString *responseString = [request responseString];
	//NSLog(@"Reponse : %@", responseString);
	if([responseString rangeOfString:@"Vos identifiants sont incorrects"].location == NSNotFound){
		responseString = [responseString stringByReplacingOccurrencesOfString:@"/prod/sgs" withString:@"https://sgs.mines-paristech.fr/prod/sgs"];
		[webView loadHTMLString:responseString baseURL:nil];
	}
	else{
		UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Erreur :" message:@"Identifiants incorrects !\nVoir Préférences iMines" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[errorAlert show];
		[errorAlert release];
		//[self.navigationController popViewControllerAnimated:YES];
	}
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	NSError *error = [request error];
	NSLog(@"Erreur : %@", error);
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
