//
//  InscriptionPetitCoursVC.h
//  iMines-1
//
//  Created by François de la Taste on 12/09/10.
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


@interface InscriptionPetitCoursVC : UIViewController <UIActionSheetDelegate>{

	NSMutableDictionary *selectedPetitCours;
	IBOutlet UIScrollView *scrollView;
	IBOutlet UILabel *nomPC;
	IBOutlet UILabel *matierePC;
	IBOutlet UILabel *niveauPC;
	IBOutlet UILabel *adressePC;
	IBOutlet UILabel *commentairePC;
	NSData *responseData;
}

@property (nonatomic, retain) NSMutableDictionary *selectedPetitCours;
@property (nonatomic, retain) IBOutlet UILabel *nomPC;
@property (nonatomic, retain) IBOutlet UILabel *matierePC;
@property (nonatomic, retain) IBOutlet UILabel *niveauPC;
@property (nonatomic, retain) IBOutlet UILabel *adressePC;
@property (nonatomic, retain) IBOutlet UILabel *commentairePC;

- (id)initWithPetitCours:(NSMutableDictionary *)pc;
- (IBAction)sIncrirePressed;
@end
