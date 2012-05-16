//
//  iMines_1AppDelegate.h
//  iMines-1
//
//  Created by François de la Taste on 14/07/10.
//  Copyright Mines ParisTech 2010. All rights reserved.
//

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

