//
//  EleveZoomTVC.h
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

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "ASIHTTPRequest.h"


@interface EleveZoomTVC : UITableViewController <NSXMLParserDelegate, ASIHTTPRequestDelegate, MFMailComposeViewControllerDelegate> {

	NSMutableArray *eleve;
	NSString *eleveLogin;
	NSString *eleveNom;
	NSString *elevePrenom;
	
	NSXMLParser * rssParser;
	NSString *currentElement;
	
	int compteur;
	
}
@property (nonatomic, retain) NSMutableArray *eleve;

-(id)initWithLogin:(NSString *)login nom:(NSString *)nom prenom:(NSString *)prenom;
-(void)displayComposerSheet:(NSString *)recipient;
- (NSString *)getCurrentAnneeScolaire;
@end