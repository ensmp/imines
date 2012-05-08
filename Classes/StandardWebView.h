//
//  StandardWebView.h
//  iMines-1
//
//  Created by François de la Taste on 31/07/10.
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


@interface StandardWebView : UIViewController {
	
	NSString *urlString;
	IBOutlet UIWebView *webView;

}

@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, retain) IBOutlet UIWebView *webView;

-(id)initWithURLString:(NSString *)anyURL;

@end
