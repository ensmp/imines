
//
//  VDMTVC.m
//  iMines-1
//
//  Created by François de la Taste on 02/08/11.
// Test GitHub 2
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
#import "VDMTVC.h"
#include "SBJson.h"
#import "VDMShowCommentsTVC.h"

#define MAX_HEIGHT 20000.0f
#define CONTENT_FONT_SIZE 14.0f
#define CELL_CONTENT_MARGIN 5.0f
#define CELL_CONTENT_TOP_MARGIN 16.0f

#define TAG_DATE_LABEL 2
#define TAG_AUTHOR_LABEL 3
#define TAG_CATEGORY_LABEL 6
#define TAG_NB_LIKES_LABEL 4
#define TAG_NB_DISLIKES_LABEL 5
#define TAG_CONTENT_TXTVIEW 1

@implementation VDMTVC

@synthesize tvCell, VDMTable, listeVDM;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    [super viewDidLoad];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"VDM" style:UIBarButtonItemStyleBordered target:self action:nil];
	self.navigationItem.backBarButtonItem = backButton;
	[backButton release];
    isRefreshing = FALSE;
    isAddingNextPage = FALSE;
    currentPage = 1;
    listeVDM = [[NSMutableArray alloc] init];
    self.tableView.backgroundColor = [UIColor colorWithRed:163.0/255.0 green:196.0/255.0 blue:229.0/255.0 alpha:1];
    self.tableView.separatorColor = [UIColor grayColor];
    if ([listeVDM count] == 0) {
        isAddingNextPage = TRUE;
        [self fetchVDMlist];               
    }
    
    // On ajoute le bouton "Rédiger" à droite de la Navigation Bar
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(writeVDM)];
}

- (void)fetchVDMlist
{
    NSString *settingsPath = [[NSBundle mainBundle] pathForResource:@"SETTINGS" ofType:@"plist"];
    NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:settingsPath];
    
    
    NSString *url = [[settings objectForKey:@"serveur-vdm"] stringByAppendingFormat:[settings objectForKey:@"vdm-readpage"],1]; // au cas où...
    if(isAddingNextPage){
        url = [[settings objectForKey:@"serveur-vdm"] stringByAppendingFormat:[settings objectForKey:@"vdm-readpage"],currentPage];
    }
    else if (isRefreshing){
        url = [[settings objectForKey:@"serveur-vdm"] stringByAppendingFormat:[settings objectForKey:@"vdm-readpage"],1];
    }
    responseData = [[NSMutableData data] retain];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    //NSLog(@"REQUEST : %@", [request description]);
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    // Return YES for supported orientations
    
    
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)writeVDM {
    // L'utilisateur a cliqué sur l'icône "Composer"
    // On affiche le Modal View Controller chargé de composer une VDM
    
    ComposeVDMVC *cvdmvc = [[ComposeVDMVC alloc] init];
    [cvdmvc setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    cvdmvc.delegate = self;
    [self presentModalViewController:cvdmvc animated:YES];
    
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
    //NSLog(@"REPONSE : %@", responseString);
	[responseData release];
    if(isAddingNextPage) {
        [listeVDM addObjectsFromArray:[responseString JSONValue]];
        isAddingNextPage = FALSE;
        currentPage++;
    }
    else if(isRefreshing) {
        [listeVDM removeAllObjects];
        [listeVDM addObjectsFromArray:[responseString JSONValue]];
        isRefreshing = FALSE;
    }
    //NSLog(@"liste : %@",listeVDM);
    //NSLog(@"element 1 - body : %@",[[listeVDM objectAtIndex:1] objectForKey:@"body"]);
    
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge previousFailureCount] == 0)
    {
        NSLog(@"received authentication challenge");
        
        NSURLCredential *newCredential;
        
        NSUserDefaults *defaultSettings = [NSUserDefaults standardUserDefaults];
        NSString *userLogin = [defaultSettings stringForKey:@"login_vdm"];
        NSString *userPassword = [defaultSettings stringForKey:@"password_vdm"];
        
        if(userLogin != nil && userPassword !=nil){
        
        newCredential=[NSURLCredential credentialWithUser:userLogin
                                                 password:userPassword
                                              persistence:NSURLCredentialPersistenceForSession];
        
        
        
        
        [[challenge sender] useCredential:newCredential forAuthenticationChallenge:challenge];
        
       
        }
        else
        {
            NSLog(@"previous authentication failure");
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"VieDeMineur" 
                                                            message:@"Ta vie c'est de la Mine et c'est clairement la base ? Poste, commente et valide les meilleures tranches de vie de l'école. \nSi tu as un compte à l'école, va remplir la section VDM dans les paramètres de l'iPhone."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        
    }
    else
    {
        NSLog(@"previous authentication failure");
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"VieDeMineur" 
                                                        message:@"Ta vie c'est de la Mine et c'est clairement la base ? Poste, commente et valide les meilleures tranches de vie de l'école. \nSi tu as un compte à l'école, va remplir la section VDM dans les paramètres de l'iPhone."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}
#pragma mark - Compose VDM Delegate 


- (IBAction)ComposeVDMVC:(ComposeVDMVC *)cvdmvc shouldDismiss:(BOOL)shouldDismiss {
    // Le Modal View Controller demande à être masqué
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Pull refresh

- (void) refresh {
    if (!isRefreshing) {
        isRefreshing = TRUE;
        [self fetchVDMlist];
        [self stopLoading];
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [listeVDM count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"VDMtvCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"VDMtvCell" owner:self options:nil];
        cell = tvCell;
        self.tvCell = nil;
    }
    if ([listeVDM count] >= indexPath.row){
        UILabel *authorLabel, *dateLabel, *catLabel;
        UITextView *contentTextView;
        UILabel *numberOfLikesLabel, *numberOfDislikesLabel;
        
        authorLabel = (UILabel *)[cell viewWithTag:TAG_AUTHOR_LABEL];
        authorLabel.text = [@"par " stringByAppendingString:[[listeVDM objectAtIndex:indexPath.row] objectForKey:@"poster"]];
        
        dateLabel = (UILabel *)[cell viewWithTag:TAG_DATE_LABEL];
        dateLabel.text = [[listeVDM objectAtIndex:indexPath.row] objectForKey:@"date"];
        
        numberOfLikesLabel = (UILabel *)[cell viewWithTag:TAG_NB_LIKES_LABEL];
        numberOfLikesLabel.text = [[listeVDM objectAtIndex:indexPath.row] objectForKey:@"like"];
        
        numberOfDislikesLabel = (UILabel *)[cell viewWithTag:TAG_NB_DISLIKES_LABEL];
        numberOfDislikesLabel.text = [[listeVDM objectAtIndex:indexPath.row] objectForKey:@"dislike"];
        
        catLabel = (UILabel *)[cell viewWithTag:TAG_CATEGORY_LABEL];
        catLabel.text = [[listeVDM objectAtIndex:indexPath.row] objectForKey:@"name"];
        catLabel.layer.borderWidth = 1.0f;
        catLabel.layer.cornerRadius = 5;
        catLabel.layer.borderColor = [UIColor grayColor].CGColor;
        
        contentTextView = (UITextView *)[cell viewWithTag:TAG_CONTENT_TXTVIEW];
        
        // Calcul de la taille du textView en fonction du texte qu'il contient
        NSString *contentText = [[listeVDM objectAtIndex:indexPath.row] objectForKey:@"body"];
        CGSize size = [contentText sizeWithFont:[UIFont systemFontOfSize:CONTENT_FONT_SIZE]
                              constrainedToSize:CGSizeMake(self.view.frame.size.width - 2*CELL_CONTENT_MARGIN, MAX_HEIGHT)
                                  lineBreakMode:UILineBreakModeWordWrap];
        
        [contentTextView setFont:[UIFont systemFontOfSize:CONTENT_FONT_SIZE]];
        CGFloat height = MAX(size.height, 44.0f);
        [contentTextView setFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_TOP_MARGIN, self.view.frame.size.width-2*CELL_CONTENT_MARGIN, height+30)];
        contentTextView.text = contentText;
        contentTextView.layer.cornerRadius = 5;
        contentTextView.layer.borderWidth = 1.0f;
        //[contentTextView release];
        cell.layer.borderColor = [UIColor grayColor].CGColor;
    }
    
    if(indexPath.row == [listeVDM count]-1) {
        // On a atteint la dernière VDM -> on lance la page suivante
        isAddingNextPage = TRUE;
        [self fetchVDMlist];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO : afficher un (Table?)VC avec la liste des commentaires associés à la VDM sélectionnée + bouton pour liker/disliker
    
    // Navigation logic may go here. Create and push another view controller.
    int idVDM = [[[listeVDM objectAtIndex:indexPath.row] objectForKey:@"id"] intValue];
    VDMShowCommentsTVC *vdmsctvc = [[VDMShowCommentsTVC alloc] initWithStyle:UITableViewStyleGrouped andID:idVDM];
    NSString *title = [[listeVDM objectAtIndex:indexPath.row] objectForKey:@"name"];
    vdmsctvc.title = [title stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[title substringToIndex:1] capitalizedString]];
    
    [self.navigationController pushViewController:vdmsctvc animated:YES];
    [vdmsctvc release];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Calcul de la hauteur de la cellule en fonction du texte du textView (idem que dans cellForRowAtIndexPath:)
    
    NSString *contentText = [[listeVDM objectAtIndex:indexPath.row] objectForKey:@"body"];
    CGSize size = [contentText sizeWithFont:[UIFont systemFontOfSize:CONTENT_FONT_SIZE]
                          constrainedToSize:CGSizeMake(self.view.frame.size.width - 2*CELL_CONTENT_MARGIN, MAX_HEIGHT)
                              lineBreakMode:UILineBreakModeWordWrap];
    CGFloat height = MAX(size.height, 44.0f);
    // On ajoute un offset pour les autres éléments
    return height+21+60;
}

@end
