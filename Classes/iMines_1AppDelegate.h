//
//  iMines_1AppDelegate.h
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

#import <UIKit/UIKit.h>
#import "GlobalTabBarController.h"

@interface iMines_1AppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	IBOutlet GlobalTabBarController *tabBarController; // La tabBar principale (Public—Prive—Contact—Calendrier)
	
	IBOutlet UINavigationController *publicNavigationController; // NavigationController de la partie publique
	IBOutlet UINavigationController *priveNavigationController; // NavigationController de la partie privee
	IBOutlet UIViewController *contactViewController; // ViewController de la page Contact
	IBOutlet UIViewController *calendrierViewController; // ViewController de la page Calendrier
	
	
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet GlobalTabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet UINavigationController *publicNavigationController;
@property (nonatomic, retain) IBOutlet UINavigationController *priveNavigationController;
@property (nonatomic, retain) IBOutlet UIViewController *contactViewController;
@property (nonatomic, retain) IBOutlet UIViewController *calendrierViewController;

@end

