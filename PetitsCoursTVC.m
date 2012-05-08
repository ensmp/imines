//
//  PetitsCoursTVC.m
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

#import "PetitsCoursTVC.h"
#import "InscriptionPetitCoursVC.h"


#define TAG_MATIERE 1
#define TAG_ADRESSE 2
#define TAG_NIVEAU 3
#define TAG_COMMENTAIRE 4

#define LOGIN_PETITSCOURS @"ensmp"
#define PASSWORD_PETITSCOURS @"stebarbe"

@implementation PetitsCoursTVC
@synthesize tvCell;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	self.tableView.backgroundColor = [UIColor colorWithRed:163.0/255.0 green:196.0/255.0 blue:229.0/255.0 alpha:1];
	
	// Avant tout on vérifie les identifiants stockés dans l'iPhone :
	NSUserDefaults *defaultSettings = [NSUserDefaults standardUserDefaults];
	NSString *userLogin = [defaultSettings stringForKey:@"login_petitscours"];
	NSString *userPassword = [defaultSettings stringForKey:@"password_petitscours"];
	
	if ([userLogin isEqualToString:LOGIN_PETITSCOURS] && [userPassword isEqualToString:PASSWORD_PETITSCOURS]){
		// Les identifiants sont corrects, on lance la requête et l'affichage.
		
		if ([stories count] == 0) {
			
			NSString * path = FLUX;
			/* Operation Queue init (autorelease) : on crée une nouvelle opération pour laisser la main à l'utilisateur*/
			NSOperationQueue *queue = [NSOperationQueue new];
			
			/* Create our NSInvocationOperation to call loadDataWithOperation, passing in nil */
			NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self
																					selector:@selector(parseXMLFileAtURL:)
																					  object:path];
			
			/* Add the operation to the queue */
			[queue addOperation:operation];
			[operation release];
			
		}
	}
	else
	{
		// Les identifiants sont incorrects (ou non renseignés), on affiche un texte de présentation des petits cours
		NSString *errorString = @"Les élèves viennent ici consulter les annonces de petits cours recueillies par le BDE.";
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Petits Cours" message:errorString delegate:self cancelButtonTitle:@"Annuler" otherButtonTitles:@"Déposer une demande",@"Plus d'infos", nil];
		[alert show];
		[alert release];
	
	
	}
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
 // On a cliqué sur un des boutons de l'alerte affichée si les mots de passe ne sont pas remplis :
	NSLog(@"button cliqué : %d",buttonIndex);
	switch(buttonIndex){
		case 0:
			// ANNULER -> on ne fait rien
			break;
		case 1:
			// Déposer une demande -> rédaction d'un mail à bde-petitscours@mines-paristech.fr
			[self displayComposerSheet];
			break;
		case 2:
			// Plus d'infos -> on redirige vers http://www.monbde.eu/petitcours.php
			// TODO : ouvrir safari vers http://www.monbde.eu/petitcours.php
			NSLog(@"Plus d'infos sur les petits cours");
			NSString *stringURL = @"http://www.monbde.eu/petitcours.php";
			NSURL *url = [NSURL URLWithString:stringURL];
			[[UIApplication sharedApplication] openURL:url];
			break;
	}
}

#pragma mark -
#pragma mark MAIL
-(void)displayComposerSheet
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	[picker setSubject:@"[Demande de petits cours]"];
	
	// Set up the recipients.
	NSArray *toRecipients = [NSArray arrayWithObjects:@"bde-petitscours@mines-paristech.fr",
							 nil];
	
	[picker setToRecipients:toRecipients];
	
	// Fill out the email body text.
	NSString *emailBody = @"Bonjour.\nJe cherche un élève pour donner des petits cours à\nNom:\nSituation géographique:\nNiveau:\nMatière(s):\nHoraires:\nVous pouvez me contacter au __ ou par mail : __ ";
	[picker setMessageBody:emailBody isHTML:NO];
	
	// Present the mail composition interface.
	[self presentModalViewController:picker animated:YES];
	[picker release]; // Can safely release the controller now.
}


// The mail compose view controller delegate method
- (void)mailComposeController:(MFMailComposeViewController *)controller
		  didFinishWithResult:(MFMailComposeResult)result
						error:(NSError *)error
{
	[self dismissModalViewControllerAnimated:YES];
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
/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */


#pragma mark -
#pragma mark Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 100;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [stories count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"PetitCoursCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"PetitCoursCell" owner:self options:nil];
        cell = tvCell;
        self.tvCell = nil;;
    }
	int storyIndex = indexPath.section;
	UILabel *label;
    label = (UILabel *)[cell viewWithTag:TAG_MATIERE];
    label.text = [[stories objectAtIndex: storyIndex] objectForKey: @"matiere"];
	
    label = (UILabel *)[cell viewWithTag:TAG_ADRESSE];
    label.text = label.text = [[stories objectAtIndex: storyIndex] objectForKey: @"adresse"];
	
	label = (UILabel *)[cell viewWithTag:TAG_NIVEAU];
    label.text = [[stories objectAtIndex: storyIndex] objectForKey: @"niveau"];
	
    label = (UILabel *)[cell viewWithTag:TAG_COMMENTAIRE];
    label.text = label.text = [[stories objectAtIndex: storyIndex] objectForKey: @"commentaire"];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
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
	NSMutableDictionary *pc = [stories objectAtIndex:indexPath.section];
	InscriptionPetitCoursVC *detailViewController = [[InscriptionPetitCoursVC alloc] initWithPetitCours:pc];
    //[pc release]; 
	// ...
	// Pass the selected object to the new view controller.
	[self.navigationController pushViewController:detailViewController animated:YES];
	[detailViewController release];
	
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
}
#pragma mark -
#pragma mark RSS Parsing

- (void)parseXMLFileAtURL:(NSString *)URL {
	
	//On lance le activity indicator
	activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];	
	CGRect frame = activityIndicator.frame;
	frame.origin = CGPointMake(self.view.frame.size.width/2 - 15.0, self.view.frame.size.height/2 - 15.0);
	activityIndicator.frame = frame;
	activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
	[self.tableView addSubview:activityIndicator];
	[activityIndicator startAnimating];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	
	stories = [[NSMutableArray alloc] init];
	
	//you must then convert the path to a proper NSURL or it won't work
	NSURL *xmlURL = [NSURL URLWithString:URL];
	
	// here, for some reason you have to use NSClassFromString when trying to alloc NSXMLParser, otherwise you will get an object not found error
	// this may be necessary only for the toolchain
	rssParser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
	
	// Set self as the delegate of the parser so that it will receive the parser delegate methods callbacks.
	[rssParser setDelegate:self];
	
	// Depending on the XML document you're parsing, you may want to enable these features of NSXMLParser.
	[rssParser setShouldProcessNamespaces:NO];
	[rssParser setShouldReportNamespacePrefixes:NO];
	[rssParser setShouldResolveExternalEntities:NO];
	
	[rssParser parse];
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
	//NSLog(@"found file and started parsing");
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSString * errorString = [NSString stringWithFormat:@"Problème de téléchargement ! (Error code %i )", [parseError code]];
	NSLog(@"error parsing XML: %@", errorString);
	
	UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Erreur :" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[activityIndicator stopAnimating];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[errorAlert show];
	[errorAlert release];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
	//NSLog(@"found this element: %@", elementName);
	currentElement = [elementName copy];
	
	if ([elementName isEqualToString:@"item"]) { // Si on tombe sur une nouvelle entrée
		// clear out our story item caches...
		item = [[NSMutableDictionary alloc] init];
		currentNiveau = [[NSMutableString alloc] init];
		currentAdresse = [[NSMutableString alloc] init];
		currentNom = [[NSMutableString alloc] init];
		currentMatiere = [[NSMutableString alloc] init];
		currentCommentaire = [[NSMutableString alloc] init];
		currentLienInscription = [[NSMutableString alloc] init];
		currentID = [[NSMutableString alloc] init];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	
	//NSLog(@"ended element: %@", elementName);
	if ([elementName isEqualToString:@"item"]) {
		
		// save values to an item, then store that item into the array...
		
		[item setObject:currentNiveau forKey:@"niveau"];
		[item setObject:currentAdresse forKey:@"adresse"];
		[item setObject:currentNom forKey:@"nom"];
		[item setObject:currentMatiere forKey:@"matiere"];
		[item setObject:currentCommentaire forKey:@"commentaire"];
		[item setObject:currentLienInscription forKey:@"inscription"];
		[item setObject:currentID forKey:@"id"];
		[stories addObject:[item copy]];
		//NSLog(@"adding story: %@", currentNom);
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
	//NSLog(@"found characters: %@", string);
	// save the characters for the current item...
	if ([currentElement isEqualToString:@"nom"]) {
		[currentNom appendString:string];
	} else if ([currentElement isEqualToString:@"niveau"]) {
		[currentNiveau appendString:string];
	} else if ([currentElement isEqualToString:@"adresse"]) {
		[currentAdresse appendString:string];
	} else if ([currentElement isEqualToString:@"matiere"]) {
		[currentMatiere appendString:string];
	} else if ([currentElement isEqualToString:@"commentaire"]) {
		[currentCommentaire appendString:string];
	} else if ([currentElement isEqualToString:@"inscription"]) {
		[currentLienInscription appendString:string];
	} else if ([currentElement isEqualToString:@"id"]) {
		[currentID appendString:string];
	}
	
	
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	
	[activityIndicator stopAnimating];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[activityIndicator removeFromSuperview];
	
	//NSLog(@"all done!");
	//NSLog(@"stories array has %d items", [stories count]);
	if ([stories count]==0) {
		
		// aucun petit cours dispo...
		UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Aucun cours disponible :" message:@"Pas de petits cours proposés pour le moment.\nReviens plus tard !" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		
		[errorAlert show];
		[errorAlert release];
		
	}
	[newsTable reloadData];
	[self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
	
}




@end

