//
//  EleveZoomTVC.m
//  iMines-1
//
//  Created by François de la Taste on 20/12/10.
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

#import "EleveZoomTVC.h"
#import "asyncimageview.h"
#import <QuartzCore/QuartzCore.h>

#define TAG_SURNOM			0
#define TAG_DICTON			1
#define TAG_PROMO			2
#define TAG_DATENAISSANCE	3
#define TAG_MAIL			4
#define TAG_TEL				5
#define TAG_MEUH			6
#define TAG_ADRESSE			7
#define TAG_ASSOS			8
#define TAG_CO				9
#define TAG_PARRAIN			10
#define TAG_FILLOT			11

#define FLUX_FICHE @"http://www.mines-paris.eu/trombi/getInfosEleve.php?login="
#define FLUX_PHOTO @"http://www.mines-paris.eu/trombi/photos/"

@implementation EleveZoomTVC
@synthesize eleve;

#pragma mark -
#pragma mark View lifecycle


- (id)initWithLogin:(NSString *)login nom:(NSString *)nom prenom:(NSString *)prenom {
	eleveLogin = login;
	eleveNom = nom;
	elevePrenom = prenom;
	compteur = 0;
	return [super initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
	
	[super viewDidLoad];
	self.tableView.backgroundColor = [UIColor colorWithRed:163.0/255.0 green:196.0/255.0 blue:229.0/255.0 alpha:1];
	
	// ON SUPPOSE QU'ON EST DEJA IDENTIFIE SUR LE TROMBI !
	NSString *root = FLUX_FICHE;
	NSString *path = [root stringByAppendingString:eleveLogin];
	//NSLog(@"Asked for URL : %@",path);
	/* Operation Queue init (autorelease) : on crée une nouvelle opération pour laisser la main à l'utilisateur*/
	NSOperationQueue *queue = [NSOperationQueue new];
	
	/* Create our NSInvocationOperation to call loadDataWithOperation, passing in nil */
	NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self
																			selector:@selector(parseXMLFileAtURL:)
																			  object:path];
	
	/* Add the operation to the queue */
	[queue addOperation:operation];
    [operation release];
	//
    // Create a header view. Wrap it in a container to allow us to position
    // it better.
    //
    
	UIView *containerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 110)] autorelease];
	
	AsyncImageView *photoView = [[[AsyncImageView alloc] initWithFrame:CGRectMake(10, 10, 72, 100)] autorelease];
	photoView.layer.cornerRadius = 5.0;
    photoView.layer.masksToBounds = YES;
    photoView.layer.borderColor = [UIColor grayColor].CGColor;
    photoView.layer.borderWidth = 1.0;
	photoView.tag = 666;
	
	//NSString *pathToPhoto = [@"http://mines-paris.eu/trombi/get_100px_image.php?login=" stringByAppendingString:eleveLogin];
	//NSLog(@"path to photo : %@",pathToPhoto);
	//NSURL *url = [NSURL URLWithString:pathToPhoto]
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://sgs.ensmp.fr/prod/file/sgs/ensmp/%@/photo/%@.jpg", [self getCurrentAnneeScolaire], [eleveLogin lowercaseString]]];
	
	SEL actionSelector = @selector(flipToPhotoTrombi);
	[photoView addTarget:nil action:actionSelector forControlEvents:UIControlEventTouchUpInside];
	[photoView loadImageFromURL:url];
	
	
	[containerView addSubview:photoView];
	
	UILabel *nomLabel = [[[UILabel alloc] initWithFrame:CGRectMake(92, 10, 218, 45)] autorelease];
	nomLabel.text = [@" Nom : " stringByAppendingString:[eleveNom uppercaseString]];
	nomLabel.layer.cornerRadius = 5.0;
    nomLabel.layer.masksToBounds = YES;
    nomLabel.layer.borderColor = [UIColor grayColor].CGColor;
    nomLabel.layer.borderWidth = 1.0;
	nomLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
	[containerView addSubview:nomLabel];
	
	UILabel *prenomLabel = [[[UILabel alloc] initWithFrame:CGRectMake(92, 65, 218, 45)] autorelease];
	prenomLabel.text = [@" Prénom : " stringByAppendingString:[elevePrenom capitalizedString]];
	prenomLabel.layer.cornerRadius = 5.0;
    prenomLabel.layer.masksToBounds = YES;
    prenomLabel.layer.borderColor = [UIColor grayColor].CGColor;
    prenomLabel.layer.borderWidth = 1.0;
	prenomLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
	[containerView addSubview:prenomLabel];
	
	
	
	
	
	
    self.tableView.tableHeaderView = containerView;
	self.tableView.tableHeaderView.userInteractionEnabled = YES;
	
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (NSString *)getCurrentAnneeScolaire { // renvoie l'année du type 20102011
	NSDate *today = [NSDate date]; // On récupère la date d'aujourd'hui
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"Y"];
	NSString *year = [dateFormat stringFromDate:today]; // le numéro de l'année YYYY
	[dateFormat setDateFormat:@"M"];
	NSString *numberOfTheMonth = [dateFormat stringFromDate:today]; // le numéro du mois MM
	[dateFormat release];
	if([numberOfTheMonth intValue]>=1 && [numberOfTheMonth intValue]<=8) {
		return [NSString stringWithFormat:@"%d%d",[year intValue] - 1,[year intValue]];
	}
	else {
		return [NSString stringWithFormat:@"%d%d",[year intValue],[year intValue]+1];
	}
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	if([touch view] == self.tableView.tableHeaderView){
		NSLog(@"touch imageView");
	}
}

- (void)flipToPhotoTrombi {
	compteur++;
	AsyncImageView *myImageView = (AsyncImageView *)[self.tableView.tableHeaderView viewWithTag:666];

	if (compteur == 1){
		NSString *pathToPhoto = [@"http://mines-paris.eu/trombi/get_100px_image.php?login=" stringByAppendingString:eleveLogin];
		//NSLog(@"path to photo : %@",pathToPhoto);
		NSURL *urlPhotoBis = [NSURL URLWithString:pathToPhoto];
		NSData *data = [NSData dataWithContentsOfURL:urlPhotoBis];
		
		UIImageView *trombiImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 72, 100)];
		trombiImageView.image = [UIImage imageWithData:data];
		trombiImageView.contentMode = UIViewContentModeScaleAspectFill;
		[myImageView insertSubview:trombiImageView atIndex:0];
        [trombiImageView release];
	}
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:myImageView cache:YES];
	[myImageView exchangeSubviewAtIndex:1 withSubviewAtIndex:0];
	[UIView commitAnimations];
	
	
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
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 12;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
    }
    NSString *definitionContenu = @"";
	NSString *contenu = @"";
	switch (indexPath.row){
		case TAG_SURNOM:
			definitionContenu = @"Surnom";
			contenu = [eleve objectAtIndex:TAG_SURNOM];
			break;
		case TAG_DICTON:
			definitionContenu = @"Dicton";
			contenu = [eleve objectAtIndex:TAG_DICTON];
			break;
		case TAG_PROMO:
			definitionContenu = @"Promo";
			contenu = [eleve objectAtIndex:TAG_PROMO];
			break;
		case TAG_DATENAISSANCE:
			definitionContenu = @"Anniversaire";
			contenu = [eleve objectAtIndex:TAG_DATENAISSANCE];
			break;
		case TAG_MAIL:
			definitionContenu = @"Mail";
			contenu = [eleve objectAtIndex:TAG_MAIL];
			break;
		case TAG_FILLOT:
			definitionContenu = @"Fillot";
			contenu = [eleve objectAtIndex:TAG_FILLOT];
			break;
		case TAG_TEL:
			definitionContenu = @"Tel";
			contenu = [eleve objectAtIndex:TAG_TEL];
			contenu = [contenu stringByReplacingOccurrencesOfString:@" " withString:@""]; // on enlève les espaces dans le numéro de téléphone (sinon le numéro n'est pas reconnu par l'iPhone pour appeler) 
			break;
		case TAG_MEUH:
			definitionContenu = @"Meuh";
			contenu = [eleve objectAtIndex:TAG_MEUH];
			break;
		case TAG_ADRESSE:
			definitionContenu = @"Adresse";
			contenu = [eleve objectAtIndex:TAG_ADRESSE];
			break;
		case TAG_ASSOS:
			definitionContenu = @"Assos";
			contenu = [eleve objectAtIndex:TAG_ASSOS];
			break;
		case TAG_CO:
			definitionContenu = @"Co";
			contenu = [eleve objectAtIndex:TAG_CO];
			break;
		case TAG_PARRAIN:
			definitionContenu = @"Parrain";
			contenu = [eleve objectAtIndex:TAG_PARRAIN];
			break;
    }
	cell.textLabel.text = definitionContenu;
	cell.detailTextLabel.text = contenu;
    return cell;
}

#pragma mark -
#pragma mark RSS Parsing
- (void)parseXMLFileAtURL:(NSString *)URL {
	
	//On lance le activity indicator
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
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
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[errorAlert show];
	[errorAlert release];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
	//NSLog(@"found this element: %@", elementName);
	currentElement = [elementName copy];
	
	if ([elementName isEqualToString:@"eleve"]) { // Si on tombe sur une nouvelle entrée
		// clear out our story item caches...
		eleve = [[NSMutableArray alloc] init];
		for (int i=0; i<=14; i++) {
			[eleve addObject:[[NSMutableString alloc] initWithString:@""]];
		}
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	
	//NSLog(@"ended element: %@", elementName);
	
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
	//NSLog(@"found characters: %@", string);
	// save the characters for the current item...
	if ([currentElement isEqualToString:@"surnom"]) {
		[[eleve objectAtIndex:TAG_SURNOM] appendString:string];
	}	else if ([currentElement isEqualToString:@"dicton"]) {
		[[eleve objectAtIndex:TAG_DICTON] appendString:string];
	}else if ([currentElement isEqualToString:@"promo"]) {
		[[eleve objectAtIndex:TAG_PROMO] appendString:string];
	}else if ([currentElement isEqualToString:@"dateDeNaissance"]) {
		[[eleve objectAtIndex:TAG_DATENAISSANCE] appendString:string];
	}else if ([currentElement isEqualToString:@"mail"]) {
		[[eleve objectAtIndex:TAG_MAIL] appendString:string];
	}else if ([currentElement isEqualToString:@"tel"]) {
		[[eleve objectAtIndex:TAG_TEL] appendString:string];
	}else if ([currentElement isEqualToString:@"meuh"]) {
		[[eleve objectAtIndex:TAG_MEUH] appendString:string];
	}else if ([currentElement isEqualToString:@"adresse"]) {
		[[eleve objectAtIndex:TAG_ADRESSE] appendString:string];
	}else if ([currentElement isEqualToString:@"assos"]) {
		[[eleve objectAtIndex:TAG_ASSOS] appendString:string];
	}else if ([currentElement isEqualToString:@"co"]) {
		[[eleve objectAtIndex:TAG_CO] appendString:string];
	}else if ([currentElement isEqualToString:@"parrain"]) {
		[[eleve objectAtIndex:TAG_PARRAIN] appendString:string];
	}else if ([currentElement isEqualToString:@"fillot"]) {
		[[eleve objectAtIndex:TAG_FILLOT] appendString:string];
	}
	
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	NSLog(@"all done!");
	[self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
	
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
 // Delete the row from the data source.
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
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
    /*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
	 // ...
	 // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
	switch(indexPath.row){
		case TAG_TEL:
			NSLog(@"trying to dial phone number");
			NSString *phoneNumber = [@"tel:" stringByAppendingString:[eleve objectAtIndex:TAG_TEL]];
			NSLog(@"dialing : %@",phoneNumber);
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
			break;
		case TAG_MAIL:
			[self displayComposerSheet:[eleve objectAtIndex:TAG_MAIL]];
			break;
		default:
			[tableView deselectRowAtIndexPath:indexPath animated:YES];
	}
	
}

#pragma mark -
#pragma mark MAIL
-(void)displayComposerSheet:(NSString *)recipient
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	[picker setSubject:@""];
	
	// Set up the recipients.
	NSArray *toRecipients = [NSArray arrayWithObjects:recipient,
							 nil];
	
	[picker setToRecipients:toRecipients];
	
	// Fill out the email body text.
	NSString *emailBody = [[@"Salut " stringByAppendingString:elevePrenom] stringByAppendingString:@" !"];
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


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];
	
	// Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
	// Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
	// For example: self.myOutlet = nil;
}


- (void)dealloc {
	[super dealloc];
}


@end

