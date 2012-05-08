//
//  VDMShowCommentsTVC.m
//  iMines-1
//
//  Created by François de la Taste on 08/08/11.
//  Copyright 2011 Mines ParisTech. All rights reserved.
//

#import "VDMShowCommentsTVC.h"
#import "SBJson.h"
#import "ComposeCommentVC.h"

#define MAX_HEIGHT 20000.0f
#define CONTENT_FONT_SIZE 14.0f
#define DETAIL_CONTENT_FONT_SIZE 13.0f
#define CELL_CONTENT_MARGIN 5.0f
#define CELL_CONTENT_TOP_MARGIN 16.0f

@implementation VDMShowCommentsTVC

- (id)initWithStyle:(UITableViewStyle)style andID:(int)theID
{
    self = [super initWithStyle:style];
    if (self) {
        idVDM = theID;
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
    isLiking = FALSE;
    self.tableView.backgroundColor = [UIColor colorWithRed:163.0/255.0 green:196.0/255.0 blue:229.0/255.0 alpha:1];
    self.tableView.separatorColor = [UIColor grayColor];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    UIButton *addCommentButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    addCommentButton.frame = CGRectMake(10, 10, 300, 50);
    [addCommentButton setTitle:@"Ajouter un commentaire" forState:UIControlStateNormal];
    [addCommentButton addTarget:self action:@selector(showCommentModalViewController:event:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:addCommentButton];
    self.tableView.tableFooterView = view;
    
    
    
    
    
    NSString *settingsPath = [[NSBundle mainBundle] pathForResource:@"SETTINGS" ofType:@"plist"];
    NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:settingsPath];
    
    
    NSString *url = [[settings objectForKey:@"serveur-vdm"] stringByAppendingFormat:[settings objectForKey:@"vdm-readcomm"],idVDM]; 
    
    responseData = [[NSMutableData data] retain];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    NSArray *itemsValidation = [NSArray arrayWithObjects:@"Johny-validé",@"Tu l'as mérité", nil];
    
    UISegmentedControl *validationSegmentedControl = [[UISegmentedControl alloc] initWithItems:itemsValidation];
    validationSegmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    validationSegmentedControl.frame = CGRectMake(0, 0, 320, 29);
    
    [validationSegmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    
    
    self.navigationItem.titleView = validationSegmentedControl;
    [validationSegmentedControl release];
    
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)segmentAction:(id)sender
{
	// The segmented control was clicked, handle it here 
    isLiking = TRUE;
	UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
	NSLog(@"Segment clicked: %d", segmentedControl.selectedSegmentIndex);
    segmentedControl.enabled = FALSE;
    
    NSString *settingsPath = [[NSBundle mainBundle] pathForResource:@"SETTINGS" ofType:@"plist"];
    NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:settingsPath];
    
    NSString *secretKey = [settings objectForKey:@"vdm-secretkey"];
    NSURLRequest *urlRequest;
    NSURL *url;
    NSURLConnection *connection;
    
    
    
    switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            NSLog(@"valide");
            // on like
            url = [NSURL URLWithString:[[settings objectForKey:@"serveur-vdm"] stringByAppendingFormat:[settings objectForKey:@"vdm-like"],secretKey,idVDM]];
            //NSLog(@"connection description : %@", connection.description);
            break;
        case 1:
            NSLog(@"bien fait");
            // on dislike
           url = [NSURL URLWithString:[[settings objectForKey:@"serveur-vdm"] stringByAppendingFormat:[settings objectForKey:@"vdm-dislike"],secretKey,idVDM]];
            
            break;
        default:
            break;
        
    }
    urlRequest = [[NSURLRequest alloc] initWithURL:url];
    //NSLog(@"REQUEST : %@", [urlRequest description]);
    connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
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
    // On regarde si la connection concerne la validation (like ou dislike) OU la récupération des comms.
    if(!isLiking) {
        listeComms = [[NSMutableDictionary alloc] initWithDictionary:[responseString JSONValue]];
        //NSLog(@"listeComms - comms: %@",[listeComms objectForKey:@"comm"]);
        
        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        isLiking = FALSE;
    }
    else {
        NSLog(@"reponse validation : %@",responseString);
    }
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    switch(section) {
        case 0:
            // section 0 = contenu de la VDM sélectionnée donc 1 rangée
            return 1;
            break;
        case 1:
            // section 1 = tous les commentaires donc n rangées
            if ([[listeComms objectForKey:@"comm"] isKindOfClass:[NSArray class]]) // On vérifie que la liste des comms est bien un Array (sinon il n'y a aucun commentaire, et ce n'est pas un array)
            {
                return [[listeComms objectForKey:@"comm"] count];
            }
            else {
                return 0;
            }
            break;
        default:
            // ne devrait jamais arriver, mais nécessaire pour compiler (?)
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    switch(indexPath.section) {
        case 0:
            // section 0 = contenu de la VDM sélectionnée
            if([listeComms isKindOfClass:[NSDictionary class]]) {
                cell.textLabel.text = [[listeComms objectForKey:@"story"] objectForKey:@"body"];
                NSString *poster = [[listeComms objectForKey:@"story"] objectForKey:@"poster"];
                cell.detailTextLabel.text = [@"par " stringByAppendingString:poster];
            }
            
            break;
        case 1:
            // section 1 = commentaires
            cell.textLabel.text = [[[listeComms objectForKey:@"comm"] objectAtIndex:indexPath.row] objectForKey:@"body"];
            cell.backgroundColor = [UIColor colorWithRed:204.0f/256.0 green:204.0/256.0 blue:204.0/256.0 alpha:1];
            
            NSString *detailText = @"par ";
            detailText = [detailText stringByAppendingFormat:@"%@ le %@",[[[listeComms objectForKey:@"comm"] objectAtIndex:indexPath.row] objectForKey:@"poster"],[[[listeComms objectForKey:@"comm"] objectAtIndex:indexPath.row] objectForKey:@"date"]];
            cell.detailTextLabel.text = detailText;
            break;
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:CONTENT_FONT_SIZE];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:DETAIL_CONTENT_FONT_SIZE];
    cell.textLabel.numberOfLines = 50;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *contentText;
    int offset = 0;
    switch(indexPath.section) {
        case 0:
            // section 0 = contenu de la VDM sélectionnée
            contentText = [[listeComms objectForKey:@"story"] objectForKey:@"body"];
            offset = 55;
            break;
        case 1:
            // section 1 = commentaires
            contentText = [[[listeComms objectForKey:@"comm"] objectAtIndex:indexPath.row] objectForKey:@"body"];
            offset = 30;
            break;
    }
    CGSize size = [contentText sizeWithFont:[UIFont systemFontOfSize:CONTENT_FONT_SIZE]
                          constrainedToSize:CGSizeMake(self.view.frame.size.width - 2*CELL_CONTENT_MARGIN, MAX_HEIGHT)
                              lineBreakMode:UILineBreakModeWordWrap];
    CGFloat height = MAX(size.height, 44.0f);
    return  height+offset;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 29.0f;
}


-(void)showCommentModalViewController:(id)sender event:(id)event{
    ComposeCommentVC *ccmvc = [[ComposeCommentVC alloc] init];
    [ccmvc setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    ccmvc.delegate = self;
    ccmvc.idVDM = idVDM;
    [self presentModalViewController:ccmvc animated:YES];
}

-(IBAction)ComposeCommentVC:(ComposeCommentVC *)ccvc shouldDismiss:(BOOL)shouldDismiss{
    [self dismissModalViewControllerAnimated:YES];
    
    NSString *settingsPath = [[NSBundle mainBundle] pathForResource:@"SETTINGS" ofType:@"plist"];
    NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:settingsPath];
    
    NSString *url = [[settings objectForKey:@"serveur-vdm"] stringByAppendingFormat:[settings objectForKey:@"vdm-readcomm"],idVDM]; 
    
    responseData = [[NSMutableData data] retain];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}
@end
