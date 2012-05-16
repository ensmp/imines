//
//  ActualitesTVC.m
//  iMines-1
//
//  Created by François de la Taste on 30/07/10.
//  Copyright 2010 Mines ParisTech. All rights reserved.
//

#import "ActualitesTVC.h"
#import "TweeterCell.h"
#import "StandardWebView.h"

#define TWEETER_FEED @"http://twitter.com/statuses/user_timeline/68965556.rss"

@implementation ActualitesTVC
@synthesize tvCell;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
	[super viewDidLoad];
	
	if ([stories count] == 0) {
		
		NSString * path = TWEETER_FEED;
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
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [stories count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *MyIdentifier = @"TweeterCell";
	TweeterCell *cell = (TweeterCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	
	if (cell == nil) {
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"TweeterCell" owner:nil options:nil];
		
		for(id currentObject in topLevelObjects)
		{
			if([currentObject isKindOfClass:[TweeterCell class]])
			{
				cell = (TweeterCell *)currentObject;
				break;
			}
		}
	}
	int storyIndex = [indexPath indexAtPosition: [indexPath length] - 1];
	//cell.titreLabel.text = @"Titre";
	//cell.contenuLabel.text = @"Contenu";
	
	
	//NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	//[dateFormatter setDateFormat:@"%d %b %y, %H:%M"];
	cell.titreLabel.text = [[stories objectAtIndex: storyIndex] objectForKey: @"date"];
	cell.contenuLabel.text = [[stories objectAtIndex: storyIndex] objectForKey: @"title"];
	
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
	int storyIndex = [indexPath indexAtPosition: [indexPath length] - 1];
	NSString *longString = [[stories objectAtIndex: storyIndex] objectForKey: @"title"];
	
	UIFont *font = [UIFont boldSystemFontOfSize:13.0f]; //La taille de sa font
	
	CGFloat width = 300; //La largeur de son label
	
	CGSize suggestedSize = [longString
							sizeWithFont:font
							constrainedToSize:CGSizeMake(width,2000)
							lineBreakMode:UILineBreakModeWordWrap];
	
	return suggestedSize.height + 34;
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
	 NSString *urlString = @"http://twitter.com/MINES_ParisTech/";
	
	StandardWebView *detailViewController = [[StandardWebView alloc] initWithURLString:urlString];
	detailViewController.title = @"Tweet";
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
   	[currentElement release];
	[rssParser release];
	[stories release];
	[item release];
	[currentTitle release];
	[currentDate release];
	[currentSummary release];
	[currentLink release];
	
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
	NSLog(@"found file and started parsing");
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
	NSLog(@"found this element: %@", elementName);
	currentElement = [elementName copy];
	
	if ([elementName isEqualToString:@"item"]) { // Si on tombe sur une nouvelle entrée
		// clear out our story item caches...
		item = [[NSMutableDictionary alloc] init];
		currentTitle = [[NSMutableString alloc] init];
		currentDate = [[NSMutableString alloc] init];
		currentSummary = [[NSMutableString alloc] init];
		currentLink = [[NSMutableString alloc] init];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	
	NSLog(@"ended element: %@", elementName);
	if ([elementName isEqualToString:@"item"]) {
		
		// save values to an item, then store that item into the array...
		
		// on enlève la chaîne MINES_ParisTech, qui ne sert à rien
		[currentTitle replaceOccurrencesOfString:@"MINES_ParisTech:" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [currentTitle length])];
		
		[item setObject:currentTitle forKey:@"title"];
		[item setObject:currentLink forKey:@"link"];
		[item setObject:currentSummary forKey:@"summary"];
		//Thu, 29 Jul 2010 08:04:30 +0000
		//NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		//[dateFormatter setDateFormat:@"EEE, d MMM yyyy h:mm:s zzz"];
		NSLog(@"Date string : %@", currentDate);
		//NSDate *date = [dateFormatter dateFromString:currentDate];
		//NSLog(@"Date NSDate : %@", date);
		[item setObject:currentDate forKey:@"date"];
		[stories addObject:[item copy]];
		NSLog(@"adding story: %@", currentTitle);
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
	//NSLog(@"found characters: %@", string);
	// save the characters for the current item...
	if ([currentElement isEqualToString:@"title"]) {
		[currentTitle appendString:string];
	} else if ([currentElement isEqualToString:@"link"]) {
		[currentLink appendString:string];
	} else if ([currentElement isEqualToString:@"description"]) {
		[currentSummary appendString:string];
	} else if ([currentElement isEqualToString:@"pubDate"]) {
		[currentDate appendString:string];
	}
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	
	[activityIndicator stopAnimating];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[activityIndicator removeFromSuperview];
	
	NSLog(@"all done!");
	NSLog(@"stories array has %d items", [stories count]);
	[newsTable reloadData];
	[self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];

}



@end

