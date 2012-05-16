//
//  BDEViewController.m
//  iMines-1
//
//  Created by François de la Taste on 31/08/10.
//  Copyright 2010 Mines ParisTech. All rights reserved.
//

#import "BDEViewController.h"
#import "EcrireAuBDEViewController.h"
#import "EntreprisesTVC.h"
#import "TeamTVC.h"
#import "HTMLViewController.h"

@implementation BDEViewController


-(IBAction)showNextView:(id)sender {
	
	UIButton *bouton = (UIButton *)sender;
	NSLog(@"Bouton tag : %d", bouton.tag);
	
	// on regarde quel bouton a envoyé l'action (voir header pour les constantes)
	
	switch (bouton.tag) { 
		case TAG_EQUIPEBDE:
			NSLog(@"L'equipe BDE");
			TeamTVC	*ttvc = [[TeamTVC alloc] initWithStyle:UITableViewStyleGrouped];
			ttvc.title = @"L'équipe BDE";
			[self.navigationController pushViewController:ttvc animated:YES];
			[ttvc release];
			break;
		case TAG_ENTREPRISESBDE:
			NSLog(@"BDE Entreprises");
			EntreprisesTVC *etvc = [[EntreprisesTVC alloc] initWithStyle:UITableViewStyleGrouped];
			etvc.title = @"Les Entreprises";
			[self.navigationController pushViewController:etvc animated:YES];
			[etvc release];
			break;
		case TAG_ECRIREBDE:
			NSLog(@"Ecrire au BDE");
			[self displayComposerSheet];
			break;
		case TAG_PRESENTATION:
			NSLog(@"Presentation BDE");
			HTMLViewController *htmlvc = [[HTMLViewController alloc] initWithHTMLfilename:@"presentation_BDE"];
			[self.navigationController pushViewController:htmlvc animated:YES];
			break;
			
		default:
			break;
	}	
}

-(void)displayComposerSheet
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
	
    [picker setSubject:@"[iMines] "];
	
    // Set up the recipients.
    NSArray *toRecipients = [NSArray arrayWithObjects:@"bde@mines-paristech.fr",
							 nil];
	
    [picker setToRecipients:toRecipients];
	
    // Fill out the email body text.
    NSString *emailBody = @"Ton message...";
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
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

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
