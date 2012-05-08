//
//  EmploiDuTempsTVC.m
//  iMines-1
//
//  Created by François de la Taste on 31/08/10.
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

#import "EmploiDuTempsTVC.h"
#import "StandardWebView.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
#import "DocumentViewController.h"

@implementation EmploiDuTempsTVC
@synthesize emploisDuTemps, myTableView;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
	self.tableView.backgroundColor = [UIColor colorWithRed:163.0/255.0 green:196.0/255.0 blue:229.0/255.0 alpha:1];
	// Remplissage du contenu du tableau des emplois du temps (titre + adresse URL)
	
	emploisDuTemps = [[NSMutableArray alloc] init];
	NSMutableArray *enCours = [[NSMutableArray alloc] init];
	[enCours addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
						@"1A", @"title",
						@"http://www.ensmp.fr/Intra/IngCivil/EmploiTemps/Semaine/Encours1A.pdf", @"url",
						nil
						]];
	[enCours addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
						@"2A", @"title",
						@"http://www.ensmp.fr/Intra/IngCivil/EmploiTemps/Semaine/Encours2A.pdf", @"url",
						nil
						]];
	[enCours addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
						@"3A", @"title",
						@"http://www.ensmp.fr/Intra/IngCivil/EmploiTemps/Semaine/Encours3A.pdf", @"url",
						nil
						]];
	[emploisDuTemps addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
							   @"En Cours", @"title",
							   enCours, @"contenu",
							   nil
							   ]];
	[enCours release];
	
	NSMutableArray *semaineProchaine = [[NSMutableArray alloc] init];
	
	[semaineProchaine addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
								 @"1A", @"title",
								 @"http://www.ensmp.fr/Intra/IngCivil/EmploiTemps/Semaine/Prochain1A.pdf", @"url",
								 nil
								 ]];
	[semaineProchaine addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
								 @"2A", @"title",
								 @"http://www.ensmp.fr/Intra/IngCivil/EmploiTemps/Semaine/Prochain2A.pdf", @"url",
								 nil
								 ]];
	[semaineProchaine addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
								 @"3A", @"title",
								 @"http://www.ensmp.fr/Intra/IngCivil/EmploiTemps/Semaine/Prochain3A.pdf", @"url",
								 nil
								 ]];
	[emploisDuTemps addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
							   @"Semaine Prochaine", @"title",
							   semaineProchaine, @"contenu",
							   nil
							   ]];
	[semaineProchaine release];
	
	NSMutableArray *semestriels = [[NSMutableArray alloc] init];
	[semestriels addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
								 @"S1", @"title",
								[NSString stringWithFormat:@"http://intranet.mines-paristech.fr/Intra/IngCivil/EmploiTemps/%@/Semestre1.pdf",[self getCurrentAnnee]], @"url",
								 nil
								 ]];
	[semestriels addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
							@"S2", @"title",
							[NSString stringWithFormat:@"http://intranet.mines-paristech.fr/Intra/IngCivil/EmploiTemps/%@/Semestre2.pdf",[self getCurrentAnnee]], @"url",
							nil
							]];
	[semestriels addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
							@"S3", @"title",
							[NSString stringWithFormat:@"http://intranet.mines-paristech.fr/Intra/IngCivil/EmploiTemps/%@/Semestre3.pdf",[self getCurrentAnnee]], @"url",
							nil
							]];
	[semestriels addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
							@"S4", @"title",
							[NSString stringWithFormat:@"http://intranet.mines-paristech.fr/Intra/IngCivil/EmploiTemps/%@/Semestre4.pdf",[self getCurrentAnnee]], @"url",
							nil
							]];
	[semestriels addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
							@"VS", @"title",
							[NSString stringWithFormat:@"http://intranet.mines-paristech.fr/Intra/IngCivil/EmploiTemps/%@/VS.pdf",[self getCurrentAnnee]], @"url",
							nil
							]];
	[semestriels addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
							@"S5", @"title",
							[NSString stringWithFormat:@"http://intranet.mines-paristech.fr/Intra/IngCivil/EmploiTemps/%@/Semestre5.pdf",[self getCurrentAnnee]], @"url",
							nil
							]];
	[semestriels addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
							@"S6", @"title",
							[NSString stringWithFormat:@"http://intranet.mines-paristech.fr/Intra/IngCivil/EmploiTemps/%@/Semestre6.pdf",[self getCurrentAnnee]], @"url",
							nil
							]];
	[emploisDuTemps addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
							   @"Semestriels", @"title",
							   semestriels, @"contenu",
							   nil
							   ]];	
	[semestriels release];
    [super viewDidLoad];
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


/*
 - (void)viewWillAppear:(BOOL)animated {
 [super viewWillAppear:animated];
 }
 */
/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */
/*
 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 }
 */
/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */

 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft );
 }
 


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [emploisDuTemps count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[[emploisDuTemps objectAtIndex:section] objectForKey:@"contenu"] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	NSString *cellText = [[[[emploisDuTemps objectAtIndex:indexPath.section] objectForKey:@"contenu"] objectAtIndex:indexPath.row] objectForKey:@"title"];
	cell.textLabel.text =  cellText;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; // ajout du chevron en fin de ligne
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	// permet d'attribuer un nom à la section
	return [[emploisDuTemps objectAtIndex:section] objectForKey:@"title"];
	
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark -
#pragma mark Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	
	// StandardWebView *detailViewController = [[StandardWebView alloc] initWithURLString:[[[[emploisDuTemps objectAtIndex:indexPath.section] objectForKey:@"contenu"] objectAtIndex:indexPath.row] objectForKey:@"url"]];
	
	
	// Configure a proxy server (pour récupérer l'emploi du temps...)
	
	NSURL *url = [NSURL URLWithString:[[[[emploisDuTemps objectAtIndex:indexPath.section] objectForKey:@"contenu"] objectAtIndex:indexPath.row] objectForKey:@"url"]];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request setDownloadCache:[ASIDownloadCache sharedCache]];
	// Set a username and password for HTPP authentication
	NSUserDefaults *defaultSettings = [NSUserDefaults standardUserDefaults];
	NSString *userLogin = [defaultSettings stringForKey:@"login_edt"];
	NSString *userPassword = [defaultSettings stringForKey:@"password_edt"];
	if([userLogin length]==0 || [userPassword length]==0){
		// identifiants mal renseignés -> introduction aux emplois du temps
		UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Emplois du temps" message:@"Tu ne sais plus où a lieu le cours de Thermo-sociologie et Morphotronique ?\nLes emplois du temps indiquent les heures et les salles pour tous les cours de la semaine \n Pas mal, non ?\n\nSi tu es élève de l'école, va renseigner tes identifiants dans les Paramètres de l'iPhone" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[errorAlert show];
		[errorAlert release];
	}
	else {
		CGRect frame = CGRectMake(50.0, 20.0, 200.0, 24.0);
		UIProgressView *myProgressIndicator = [[UIProgressView alloc] initWithFrame:frame];
		myProgressIndicator.progressViewStyle = UIProgressViewStyleDefault;
		[request setDownloadProgressDelegate:myProgressIndicator];
		[[tableView cellForRowAtIndexPath:indexPath].contentView addSubview:myProgressIndicator];
        [myProgressIndicator release];
		[request setUsername:userLogin];
		[request setPassword:userPassword];
		[request setDelegate:self];
		[request start];
		//currentIndexPath = indexPath;
		actIndCell = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		[actIndCell startAnimating];
		//[[tableView cellForRowAtIndexPath:indexPath] setAccessoryView:actIndCell];
		[[tableView cellForRowAtIndexPath:indexPath].accessoryView addSubview:actIndCell];
		
	}
	
	// ...
	// Pass the selected object to the new view controller.
	//[self.navigationController pushViewController:detailViewController animated:YES];
	// [detailViewController release];
	
}
/*
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
	[super tableView:tableView didDeselectRowAtIndexPath:indexPath];
	[[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
}
*/


-(void)requestFailed:(ASIHTTPRequest *)request{
	
	[actIndCell stopAnimating];
	NSError *error = [request error];
	NSLog(@"Erreur : %@", error);
	
	
}

-(void)requestFinished:(ASIHTTPRequest *)request{
	
	NSData *reponse = [request responseData];
	[actIndCell stopAnimating];
	[actIndCell removeFromSuperview];
	int width = fmin(self.view.frame.size.width,self.view.frame.size.height+64);
	int height = fmax(self.view.frame.size.width,self.view.frame.size.height+64);
	UIWebView *edt= [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
	//UIWebView *edt = [[UIWebView alloc] init];
	[edt setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
	 UIViewController *edtvc = [[DocumentViewController alloc] init];
	[edtvc.view addSubview:edt];
	[edt release];
	[self.navigationController pushViewController:edtvc animated:YES];
	[edtvc release];
	[edt loadData:reponse MIMEType:@"application/pdf" textEncodingName:@"utf-8" baseURL:nil];
	edt.scalesPageToFit = YES;
}

-(void)authenticationNeededForRequest:(ASIHTTPRequest *)request {

	UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Erreur de connexion" message:@"Les identifiants sont incorrects" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[errorAlert show];
	[errorAlert release];
	
}

/*
-(void)proxyAuthenticationNeededForRequest:(ASIHTTPRequest *)request{
	NSLog(@"Proxy authentication needed. Provinding credentials...");
	NSUserDefaults *defaultSettings = [NSUserDefaults standardUserDefaults];
	NSString *userLogin = [defaultSettings stringForKey:@"login_annuaire"];
	NSString *userPassword = [defaultSettings stringForKey:@"password_annuaire"];
	[request setProxyUsername:userLogin];
	[request setProxyPassword:userPassword];
	[request retryUsingSuppliedCredentials];
	 	
}
*/
#pragma mark -
#pragma mark Gestion données 
- (NSString *)getCurrentAnnee { // renvoie l'année du type 2010 (selon l'année scolaire, et non pas civile)
	NSDate *today = [NSDate date]; // On récupère la date d'aujourd'hui
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"Y"];
	NSString *year = [dateFormat stringFromDate:today]; // le numéro de l'année YYYY
	[dateFormat setDateFormat:@"M"];
	NSString *numberOfTheMonth = [dateFormat stringFromDate:today]; // le numéro du mois MM
	[dateFormat release];
	if([numberOfTheMonth intValue]>=1 && [numberOfTheMonth intValue]<=8) {
		return [NSString stringWithFormat:@"%d",[year intValue] - 1];
	}
	else {
		return [NSString stringWithFormat:@"%d",[year intValue]];
	}
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	[emploisDuTemps release];
}


@end

