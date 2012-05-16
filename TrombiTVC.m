//
//  TrombiTVC.m
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

#import "TrombiTVC.h"
#import "EleveWrapper.h"
#import "asyncimageview.h"
#import "ASIFormDataRequest.h"
#import "EleveZoomTVC.h"
#import "ASIDownloadCache.h"
#include "SBJson.h"

#define NOMLABEL_TAG 10

@implementation TrombiTVC
@synthesize elevesArray, sectionsArray, collation, searchBar, searchResults, listeTrombi, csrfCookie, sessionID;

#pragma mark -
#pragma mark View lifecycle


- (void)lancer_requete:(NSURL *)url {
    //NSLog(@"construction de la requête");
    //On récupère les identifiants
    NSUserDefaults *defaultSettings = [NSUserDefaults standardUserDefaults];
    NSString *userLogin = [defaultSettings stringForKey:@"login_trombi"];
    NSString *userPassword = [defaultSettings stringForKey:@"password_trombi"];
    
    
    // Construction de la requête (tentative de connexion)
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    if(gotToken){
        [request setPostValue:userLogin forKey:@"username"];
        [request setPostValue:userPassword forKey:@"password"];
        //[request setPostValue:@"TRUE" forKey:@"Submit"];
        [request setPostValue:[csrfCookie value] forKey:@"csrfmiddlewaretoken"];
        [request setRequestCookies:[NSMutableArray arrayWithObjects:csrfCookie, sessionID, nil]];
    }
    
    [request setDownloadCache:[ASIDownloadCache sharedCache]];
    [request setCachePolicy:ASIOnlyLoadIfNotCachedCachePolicy];
    [request setDelegate:self];
    [request start];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    searchBar.inputView.frame = CGRectMake(0, 0, 320-44, 30);
    searchBar.delegate = self;
    self.tableView.tableHeaderView = searchBar;
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(44, 0, 0, 0);;
    
    searching = NO;
    letUserSelectRow = YES;
    gotToken = FALSE;
	if ([elevesArray count] == 0) {
		elevesArray = [[NSMutableArray alloc] init];
        //NSLog(@"eleves vides");
		// On récupère les identifiants : 
		NSUserDefaults *defaultSettings = [NSUserDefaults standardUserDefaults];
		NSString *userLogin = [defaultSettings stringForKey:@"login_trombi"];
		NSString *userPassword = [defaultSettings stringForKey:@"password_trombi"];
		
		if([userLogin length]==0 || [userPassword length]==0){
			// Les identifiants sont mal renseignés -> on affiche un texte de description
			UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Le Trombi" message:@"Tu as oublié le n° de chambre de Jessica ? Le Trombi du BDE est là pour toi ! On y trouve les informations importantes de chaque élève (photo, n° de tél, n° de chambre, email, etc.).\nEvidemment, seuls les Mineurs peuvent y accéder...\n\nSi tu es élève de l'école, va renseigner tes identifiants dans les Paramètres de l'iPhone" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[errorAlert show];
			[errorAlert release];
		}
		else {
            NSString *settingsPath = [[NSBundle mainBundle] pathForResource:@"SETTINGS" ofType:@"plist"];
            NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:settingsPath];
            NSURL *urlTrombi = [[NSURL alloc] initWithString:[[settings objectForKey:@"serveur-eleves"] stringByAppendingString:[settings objectForKey:@"serveur-eleves-login"]]];
			[self lancer_requete:urlTrombi];
		}
		
	}
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    //NSLog(@"request finished");
	
	
    if(gotToken){
        listeTrombi = [[NSMutableArray alloc] init];
        NSString *responseString = [request responseString];
        //NSLog(@"Reponse : %@", responseString);
        
        if([responseString rangeOfString:@"Your username and password didn't match"].location == NSNotFound){
            //NSLog(@"IDENTIFICATION TROMBI OK ! : %@", responseString);
            
            [self parseListeTrombi];
            
        }
        else{
            UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Erreur :" message:@"Identifiants trombi incorrects !\nVoir Préférences iMines" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [errorAlert show];
            //[self.navigationController popViewControllerAnimated:YES];
            [errorAlert release];
        }
        
    }
    else {
        // On récupère les cookies (CSRF token et session ID)
        NSArray *cookies = [request responseCookies];
        csrfCookie = [cookies objectAtIndex:0];
        sessionID = [cookies objectAtIndex:1];
        gotToken = TRUE;
        NSString *settingsPath = [[NSBundle mainBundle] pathForResource:@"SETTINGS" ofType:@"plist"];
        NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:settingsPath];
        NSURL *urlTrombi = [[NSURL alloc] initWithString:[[settings objectForKey:@"serveur-eleves"] stringByAppendingString:[settings objectForKey:@"serveur-eleves-login"]]];
        [self lancer_requete:urlTrombi];
        
    }
    
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	NSError *error = [request error];
	NSLog(@"Erreur : %@", error);
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if (searching) 
    {
        return 1;
    }
    else
    {
        //return [[collation sectionTitles] count];   
        return [sectionsArray count];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	if(searching)
    {
        return [searchResults count];
    }
    else
    {
        NSArray *elevesInSection = [sectionsArray objectAtIndex:section];   
        return [elevesInSection count];
    }
	
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"EleveCellWithImage";
	UILabel *nomLabel;
	AsyncImageView *asyncImage;
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        // On charge le label nom
		CGRect frameLabel;
		frameLabel.size.width=320-50;
		frameLabel.size.height=44;
		frameLabel.origin.x=50;
		frameLabel.origin.y=0;
		
		nomLabel = [[[UILabel alloc] initWithFrame:frameLabel] autorelease];
		
		nomLabel.highlightedTextColor = [UIColor whiteColor];
		nomLabel.font = [UIFont boldSystemFontOfSize: 14.0];
		nomLabel.textAlignment = UITextAlignmentLeft;
		nomLabel.textColor = [UIColor darkGrayColor];
		nomLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
		nomLabel.backgroundColor = [UIColor clearColor];
		nomLabel.tag = NOMLABEL_TAG;
		
		[cell.contentView addSubview:nomLabel];
		
		
		
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	else {
		nomLabel = (UILabel *)[cell.contentView viewWithTag:NOMLABEL_TAG];
		AsyncImageView * oldImage = (AsyncImageView*)[cell.contentView viewWithTag:999];
		[oldImage removeFromSuperview];
		
    }
	// On charge le ImageView
	CGRect frame;
	frame.size.width=44; frame.size.height=44;
	frame.origin.x=0; frame.origin.y=0;
	asyncImage = [[AsyncImageView alloc] initWithFrame:frame];
	asyncImage.tag = 999;
	[cell.contentView addSubview:asyncImage];
    EleveWrapper *eleve;
    if(searching)
    {
        // NSLog(@"search results : %@", searchResults);
        eleve = [searchResults objectAtIndex:indexPath.row]; 
    }
    else
    {
        NSArray *elevesInSection = [sectionsArray objectAtIndex:indexPath.section];
        eleve = [elevesInSection objectAtIndex:indexPath.row];
    }    
	nomLabel.text = [[eleve.nom uppercaseString] stringByAppendingFormat:@" %@",[eleve.prenom capitalizedString]];
	
    NSString *settingsPath = [[NSBundle mainBundle] pathForResource:@"SETTINGS" ofType:@"plist"];
    NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:settingsPath];
    NSString *baseURLString = [[settings objectForKey:@"serveur-eleves"] stringByAppendingString:[settings objectForKey:@"photo-mini-eleve"]];
    
    NSString *photoURLString = [NSString stringWithFormat:baseURLString, eleve.eleveID];
    
    
	NSURL* url = [NSURL URLWithString:photoURLString];
	[asyncImage loadImageFromURL:url];
	return cell;
	
}


/*
 Section-related methods: Retrieve the section titles and section index titles from the collation.
 */

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(searching)
    {
        return @"";
    }
    else {
        return [[collation sectionTitles] objectAtIndex:section];
    }
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [collation sectionIndexTitles];
}


- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [collation sectionForSectionIndexTitleAtIndex:index];
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	
	EleveWrapper *eleve;
    if(searching)
    {
        eleve = [searchResults objectAtIndex:indexPath.row];
    }
    else
    {
        eleve = [[sectionsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
    
	EleveZoomTVC *detailViewController = [[EleveZoomTVC alloc] initWithLogin:eleve.eleveID nom:eleve.nom prenom:eleve.prenom];
	// ...
	// Pass the selected object to the new view controller.
	[self.navigationController pushViewController:detailViewController animated:YES];
	[detailViewController release];
	
	//[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark Gestion de la recherche dans la liste

- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
    
    searching = YES;
    letUserSelectRow = NO;
    self.tableView.scrollEnabled = NO;
    
    //Add the done button.
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
                                               initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                               target:self action:@selector(doneSearching_Clicked:)] autorelease];
}

- (NSIndexPath *)tableView :(UITableView *)theTableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(letUserSelectRow)
        return indexPath;
    else
        return nil;
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
    
    //Remove all objects first.
    searchResults = [[NSMutableArray alloc] init];
    //[searchResults removeAllObjects];
    
    if([searchText length] > 0) {
        
        searching = YES;
        letUserSelectRow = YES;
        self.tableView.scrollEnabled = YES;
        [self searchTableView];
    }
    else {
        
        searching = NO;
        letUserSelectRow = NO;
        self.tableView.scrollEnabled = NO;
    }
    
    [self.tableView reloadData];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {
    
    [self searchTableView];
}

- (void) searchTableView {
    
    NSString *searchText = searchBar.text;
    //NSLog(@"Search Text : %@", searchText);
    NSMutableArray *searchArray = [[NSMutableArray alloc] init];
    
    for (NSArray *elevesInSection in sectionsArray)
    {
        [searchArray addObjectsFromArray:elevesInSection];
    }
    
    for (EleveWrapper *eleve in searchArray)
    {
        //NSLog(@"Looking for '%@' in '%@'",searchText, eleve.nom);
        NSRange titleResultsRangeForNom = [eleve.nom rangeOfString:searchText options:NSCaseInsensitiveSearch];
        NSRange titleResultsRangeForPrenom = [eleve.prenom rangeOfString:searchText options:NSCaseInsensitiveSearch];
        
        if (titleResultsRangeForNom.length > 0 || titleResultsRangeForPrenom.length > 0)
        {
            //NSLog(@"added %@",eleve.nom);
            [searchResults addObject:eleve];
            //NSLog(@"search results count :%d",[searchResults count]);
        }
    }
    
    [searchArray release];
    searchArray = nil;
    //NSLog(@"end of searchTableView method");
}

- (void) doneSearching_Clicked:(id)sender {
    
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    
    letUserSelectRow = YES;
    searching = NO;
    self.navigationItem.rightBarButtonItem = nil;
    self.tableView.scrollEnabled = YES;
    
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark Data management

- (void)setElevesArray:(NSMutableArray *)newDataArray {
	//NSLog(@"setElevesArray called !");
	if (newDataArray != elevesArray) {
		[elevesArray release];
		elevesArray = [newDataArray retain];
	}
	if (elevesArray == nil) {
		self.sectionsArray = nil;
	}
	else {
		[self configureSections];
	}
}


- (void)configureSections {
	
	// Get the current collation and keep a reference to it.
	self.collation = [UILocalizedIndexedCollation currentCollation];
	
	NSInteger index, sectionTitlesCount = [[collation sectionTitles] count];
	
	NSMutableArray *newSectionsArray = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
	
	// Set up the sections array: elements are mutable arrays that will contain the time zones for that section.
	for (index = 0; index < sectionTitlesCount; index++) {
		NSMutableArray *array = [[NSMutableArray alloc] init];
		[newSectionsArray addObject:array];
		[array release];
	}
	
	// Segregate the time zones into the appropriate arrays.
	for (EleveWrapper *eleve in elevesArray) {
        
        //NSLog(@"eleve name : %@", eleve.nom);
        
		// Ask the collation which section number the time zone belongs in, based on its locale name.
		NSInteger sectionNumber = [collation sectionForObject:eleve collationStringSelector:@selector(nom)];
		
		// Get the array for the section.
		NSMutableArray *sectionEleves = [newSectionsArray objectAtIndex:sectionNumber];
		
		//  Add the time zone to the section.
		[sectionEleves addObject:eleve];
	}
	
	// Now that all the data's in place, each section array needs to be sorted.
	for (index = 0; index < sectionTitlesCount; index++) {
		
		NSMutableArray *elevesArrayForSection = [newSectionsArray objectAtIndex:index];
		
		// If the table view or its contents were editable, you would make a mutable copy here.
		NSArray *sortedElevesArrayForSection = [collation sortedArrayFromArray:elevesArrayForSection collationStringSelector:@selector(nom)];
		
		// Replace the existing array with the sorted array.
		[newSectionsArray replaceObjectAtIndex:index withObject:sortedElevesArrayForSection];
	}
	
	self.sectionsArray = newSectionsArray;
	[newSectionsArray release];	
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

#pragma mark -
#pragma mark RSS Parsing

- (void)parseListeTrombi {
    
	NSString *settingsPath = [[NSBundle mainBundle] pathForResource:@"SETTINGS" ofType:@"plist"];
    NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:settingsPath];
    NSURL *urlTrombi = [[NSURL alloc] initWithString:[[settings objectForKey:@"serveur-eleves"] stringByAppendingString:[settings objectForKey:@"liste-trombi-json"]]];
    responseData = [[NSMutableData data] retain];
    NSURLRequest *request = [NSURLRequest requestWithURL:urlTrombi];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}


#pragma mark - Connection Management


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"Connection failed: %@", [error description]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[connection release];
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	[responseData release];
    [listeTrombi addObjectsFromArray:[responseString JSONValue]];
    //NSLog(@"liste trombi: %@", listeTrombi);
    for(NSDictionary *eleveJSON in listeTrombi){
        currentEleve = [[EleveWrapper alloc] initWithID:[eleveJSON objectForKey:@"username"] nom:[eleveJSON objectForKey:@"last_name"] prenom:[eleveJSON objectForKey:@"first_name"]];
        [elevesArray addObject:[currentEleve copy]];
    }
    [self configureSections];
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge previousFailureCount] == 0)
    {
        //NSLog(@"received authentication challenge");
        
        NSURLCredential *newCredential;
        
        NSUserDefaults *defaultSettings = [NSUserDefaults standardUserDefaults];
        NSString *userLogin = [defaultSettings stringForKey:@"login_trombi"];
        NSString *userPassword = [defaultSettings stringForKey:@"password_trombi"];
        
        if(userLogin != nil && userPassword !=nil){
            
            newCredential=[NSURLCredential credentialWithUser:userLogin
                                                     password:userPassword
                                                  persistence:NSURLCredentialPersistenceForSession];
            
            
            //NSLog(@"credential created");
            
            [[challenge sender] useCredential:newCredential forAuthenticationChallenge:challenge];
            
            //NSLog(@"responded to authentication challenge");
        }
        else
        {
            //NSLog(@"previous authentication failure");
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Le Trombi" 
                                                            message:@"Tu as oublié le n° de chambre de Jessica ? Le Trombi du BDE est là pour toi ! On y trouve les informations importantes de chaque élève (photo, n° de tél, n° de chambre, email, etc.).\nEvidemment, seuls les Mineurs peuvent y accéder...\n\nSi tu es élève de l'école, va renseigner tes identifiants dans les Paramètres de l'iPhone"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        
    }
    else
    {
        //NSLog(@"previous authentication failure");
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Le Trombi" 
                                                        message:@"Tu as oublié le n° de chambre de Jessica ? Le Trombi du BDE est là pour toi ! On y trouve les informations importantes de chaque élève (photo, n° de tél, n° de chambre, email, etc.).\nEvidemment, seuls les Mineurs peuvent y accéder...\n\nSi tu es élève de l'école, va renseigner tes identifiants dans les Paramètres de l'iPhone"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}


- (void)dealloc {
	[elevesArray release];
	[sectionsArray release];
	[collation release];
	[listeTrombi release];
    [super dealloc];
    [searchBar release];
    [searchResults release];
}


@end

