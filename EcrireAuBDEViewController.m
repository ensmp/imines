//
//  EcrireAuBDEViewController.m
//  iMines-1
//
//  Created by François de la Taste on 31/08/10.
//  Copyright 2010 Mines ParisTech. All rights reserved.
//

#import "EcrireAuBDEViewController.h"


@implementation EcrireAuBDEViewController
@synthesize objetTextField, contenuTextView;




- (void)textViewDidBeginEditing:(UITextView *)textView {
	NSLog(@"begin editing in text view");
	UIBarButtonItem* doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donePressed)];
	self.navigationItem.rightBarButtonItem = doneItem;
}

- (void)donePressed {
	[contenuTextView resignFirstResponder];
	self.navigationItem.rightBarButtonItem = nil;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
	NSLog(@"end editing text view");
	[contenuTextView resignFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	NSLog(@"end editing text view");
	[objetTextField resignFirstResponder];
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

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

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
