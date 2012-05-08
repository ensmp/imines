//
//  VendomeViewController.m
//  iMines-1
//
//  Created by François de la Taste on 31/08/10.
// Test Vendome Git
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

#import "VendomeViewController.h"
#import "ASIFormDataRequest.h"
#import "ASIDownloadCache.h"

@implementation VendomeViewController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
 // Custom initialization
 }
 return self;
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSUserDefaults *defaultSettings = [NSUserDefaults standardUserDefaults];
	NSString *userLogin = [defaultSettings stringForKey:@"login_serveureleves"];
	NSString *userPassword = [defaultSettings stringForKey:@"password_serveureleves"];
	
	// Première étape : on vérifie que les identifiants ne sont pas vides (surtout le mot de passe car le user a une valeur par défaut...)
	
	if ([userPassword length]==0 || [userLogin length]==0) {
		UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Le Vendôme" message:@"Le Vendôme est le journal des élèves de l'école. Distribué tous les mardis matin, il égaye le quotidien des Mineurs en amphi.\n\nSi tu es élève de l'école, va renseigner tes identifiants dans les Paramètres de l'iPhone." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[errorAlert show];
		[errorAlert release];
	}
	else {
		// Construction de la requête
		NSURL *urlPC = [[NSURL alloc] initWithString:@"http://mines-paris.eu/?q=vendome&amp;destination=vendome"];
		ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:urlPC];
		[urlPC release];
		[request setDownloadCache:[ASIDownloadCache sharedCache]];
		[request setPostValue:userLogin forKey:@"name"];
		[request setPostValue:userPassword forKey:@"pass"];
		[request setPostValue:@"brop" forKey:@"op"];
		[request setPostValue:@"form-184b3cb5935972037088b9a583ad08e5" forKey:@"form_build_id"];
		[request setPostValue:@"user_login_block" forKey:@"form_id"];
		[request setDelegate:self];
		
		UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		CGPoint center = (CGPoint) [self.view center];
		//center.x -= 10;
		center.y -= 30;
		spinner.center = center;
		[spinner startAnimating];
		[self.view addSubview:spinner];
		[spinner release];
		[request start];
	}
	
}

- (void)requestFailed:(ASIHTTPRequest *)request {
	UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Erreur" message:@"request failed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[errorAlert show];
	[errorAlert release];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
	
	NSString *reponse = [request responseString];
	//NSLog(@"reponse : \n%@", reponse);
	//On vérifie que l'authentification a réussi : 
	if ([reponse rangeOfString:@"LOGIN SUCCESSFUL"].location == NSNotFound){
		// identification ratée
		UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Les identifiants sont incorrects." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[errorAlert show];
		[errorAlert release];
	}
	else {
		// identification réussie : on peut afficher la page
		UIWebView *vendomeWebView = [[UIWebView alloc] initWithFrame:self.view.frame];
		
		int from = [reponse rangeOfString:@"<!-- BEGIN VENDOMES -->"].location;
		
		NSString *listeVendomes = [reponse substringFromIndex:from];
		
		int to = [listeVendomes rangeOfString:@"<!-- END VENDOMES -->"].location;
		
		listeVendomes = [listeVendomes substringToIndex:to];
		listeVendomes = [listeVendomes stringByAppendingString:@"<style type=\"text/css\">html { background-color:rgb(163,196,229);font-size:12pt; text-align:justify;font-family:Palatino, serif;}</style>"];
		[vendomeWebView loadHTMLString:listeVendomes baseURL:nil];
		[self.view addSubview:vendomeWebView];
        [vendomeWebView release];
	}
}
/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
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
