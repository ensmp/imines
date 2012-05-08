//
//  EleveWrapper.h
//  iMines-1
//
//  Created by François de la Taste on 19/12/10.
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

#import <Foundation/Foundation.h>


@interface EleveWrapper : NSObject <NSCopying>{

	NSString *eleveID;
	NSString *nom;
	NSString *prenom;
}

@property (nonatomic, copy) NSString *eleveID;
@property (nonatomic, copy) NSString *nom;
@property (nonatomic, copy) NSString *prenom;

- (id)initWithID:(NSString *)currentID nom:(NSString *)currentNom prenom:(NSString *)currentPrenom;
@end
