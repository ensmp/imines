//
//  PriveViewController.m
//  iMines-1
//
//  Created by François de la Taste on 30/08/10.
//  Copyright 2010 Mines ParisTech. All rights reserved.
//

#import "PriveViewController.h"
#import "VDMViewController.h"
#import "BDEViewController.h"
#import "VendomeViewController.h"
#import "TrombiTVC.h"
#import "EmploiDuTempsTVC.h"
#import "CalendrierViewController.h"
#import "AssosTVC.h"
#import "PetitsCoursTVC.h"
#import "SGSWebViewController.h"

@implementation PriveViewController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

-(IBAction)showNextView:(id)sender {
	
	UIButton *bouton = (UIButton *)sender;
	NSLog(@"Bouton tag : %d", bouton.tag);
		
	// on regarde quel bouton a envoyé l'action (voir header pour les constantes)
	
	switch (bouton.tag) { 
		case TAG_VDM:
			NSLog(@"VDM");
			VDMViewController *vdmvc = [[VDMViewController alloc] init];
			vdmvc.title = @"VieDeMineur";
			[self.navigationController pushViewController:vdmvc animated:YES];
			[vdmvc release];
			break;
		case TAG_BDE:
			NSLog(@"BDE");
			BDEViewController *bdevc = [[BDEViewController alloc] init];
			bdevc.title = @"Le BDE";
			[self.navigationController pushViewController:bdevc animated:YES];
			[bdevc release];
			break;
		case TAG_VENDOME:
			NSLog(@"VENDOME");
			VendomeViewController *vvc = [[VendomeViewController alloc] init];
			vvc.title = @"Le Vendôme";
			[self.navigationController pushViewController:vvc animated:YES];	
			[vvc release];
			break;
		case TAG_TROMBI:
			NSLog(@"TROMBI");
			TrombiTVC *ttvc = [[TrombiTVC alloc] init];
			ttvc.title = @"Le Trombi";
			[self.navigationController pushViewController:ttvc animated:YES];
			[ttvc release];
			break;
		case TAG_EMPLOIDUTEMPS:
			NSLog(@"EMPLOI DU TEMPS");
			EmploiDuTempsTVC *edttvc = [[EmploiDuTempsTVC alloc] initWithStyle:UITableViewStyleGrouped];
			edttvc.title = @"Les emplois du temps";
			[self.navigationController pushViewController:edttvc animated:YES];
			[edttvc release];
			break;
		case TAG_SGS:
			NSLog(@"SGS");
			SGSWebViewController *detailViewController = [[SGSWebViewController alloc] init];
			[self.navigationController pushViewController:detailViewController animated:YES];
			[detailViewController release];
			break;
		case TAG_CALENDRIER:
			NSLog(@"CALENDRIER");
			CalendrierViewController *cvc = [[CalendrierViewController alloc] init];
			cvc.title = @"Le Calendrier";
			[self.navigationController pushViewController:cvc animated:YES];
			[cvc release];
			break;
		case TAG_ASSOS:
			NSLog(@"ASSOS");
			AssosTVC *atvc = [[AssosTVC alloc] init];
			atvc.title = @"Les Associations";
			[self.navigationController pushViewController:atvc animated:YES];
			[atvc release];
			break;
		case TAG_PETITSCOURS:
			NSLog(@"PETITS COURS");
			PetitsCoursTVC *pctvc = [[PetitsCoursTVC alloc] initWithStyle:UITableViewStyleGrouped];
			pctvc.title = @"Les Petits Cours";
			[self.navigationController pushViewController:pctvc animated:YES];
			[pctvc release];
			break;
			
		default:
			break;
	}	
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {

	
	// Redéfinition du bouton Retour pour une meilleure lisibilité (plus court)
	
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Privé" style:UIBarButtonItemStyleBordered target:self action:nil];
	self.navigationItem.backBarButtonItem = backButton;
	[backButton release];
    [super viewDidLoad];
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
