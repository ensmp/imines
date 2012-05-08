//
//  PublicAccueilViewController.m
//  iMines-1
//
//  Created by François de la Taste on 14/07/10.
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

#import "PublicAccueilViewController.h"
#import "StandardWebView.h"
#import "HTMLViewController.h"
#import "VDMTVC.h"
#import "VendomeViewController.h"
#import "TrombiTVC.h"
#import "EmploiDuTempsTVC.h"
#import "SGSWebViewController.h"
#import "PetitsCoursTVC.h"
#import "NewsTVC.h"

@implementation PublicAccueilViewController


-(IBAction)showNextView:(id)sender {
	
	UIButton *bouton = (UIButton *)sender;
	NSLog(@"Bouton tag : %d", bouton.tag);
	UIViewController *vc = [[UIViewController alloc] init];
	
	// on regarde quel bouton a envoyé l'action (voir header pour les constantes)

	switch (bouton.tag) { 
		
        case TAG_VDM:
			NSLog(@"VDM");
			VDMTVC *vdmtvc = [[VDMTVC alloc] initWithStyle:UITableViewStylePlain];
			vdmtvc.title = @"VieDeMineur";
			[self.navigationController pushViewController:vdmtvc animated:YES];
			[vdmtvc release];
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
			SGSWebViewController *sgsVC = [[SGSWebViewController alloc] init];
			sgsVC.title = @"SGS";
			[self.navigationController pushViewController:sgsVC animated:YES];
			[sgsVC release];
			break;
		case TAG_PETITSCOURS:
			NSLog(@"PETITS COURS");
			PetitsCoursTVC *pctvc = [[PetitsCoursTVC alloc] initWithStyle:UITableViewStyleGrouped];
			pctvc.title = @"Les Petits Cours";
			[self.navigationController pushViewController:pctvc animated:YES];
			[pctvc release];
			break;
        case TAG_NEWS:
            NSLog(@"NEWS");
            NewsTVC *ntvc = [[NewsTVC alloc] initWithStyle:UITableViewStylePlain];
            ntvc.title = @"News";
            [self.navigationController pushViewController:ntvc animated:YES];
            [ntvc release];
            break;
        case TAG_ETUDESJUMP:
            
            break;
        case TAG_OBJETSTROUVES:
            
            break;
		default:
			break;
	}	
	
	[vc release];
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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	// on redéfinit le back button
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Accueil" style:UIBarButtonItemStyleBordered target:self action:nil];
	self.navigationItem.backBarButtonItem = backButton;
	[backButton release];
	
	
	[super viewDidLoad];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (UIInterfaceOrientationPortrait==interfaceOrientation);
}


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
