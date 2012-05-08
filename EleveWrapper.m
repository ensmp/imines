//
//  EleveWrapper.m
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

#import "EleveWrapper.h"


@implementation EleveWrapper
@synthesize eleveID, nom, prenom;

-(id)initWithID:(NSString *)currentID nom:(NSString *)currentNom prenom:(NSString *)currentPrenom {
		
	eleveID = currentID;
	nom = currentNom;
	prenom = currentPrenom;
	return [super init];
}

-(id)copyWithZone:(NSZone *)zone {
	
	id result = [[[self class] allocWithZone:zone] init];
	
    [result setNom:nom];
    [result setPrenom:prenom];
	[result setEleveID:eleveID];
	
    return result;
	
}

- (void)dealloc {
	[super dealloc];
	[eleveID release];
	[prenom release];
	[nom release];
	
}
@end
