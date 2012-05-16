//
//  BDEViewController.h
//  iMines-1
//
//  Created by François de la Taste on 31/08/10.
//  Copyright 2010 Mines ParisTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h> 
#define TAG_EQUIPEBDE 1
#define TAG_ENTREPRISESBDE 2
#define TAG_ECRIREBDE 3
#define TAG_PRESENTATION 4

@interface BDEViewController : UIViewController <MFMailComposeViewControllerDelegate> {

}

-(IBAction)showNextView:(id)sender;
-(void)displayComposerSheet;

@end
