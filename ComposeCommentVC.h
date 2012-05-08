//
//  ComposeCommentVC.h
//  iMines-1
//
//  Created by François de la Taste on 28/08/11.
//  Copyright 2011 Mines ParisTech. All rights reserved.
//
#import <UIKit/UIKit.h>

@class ComposeCommentVC;
@protocol ComposeCommentDelegate <NSObject>

@required
- (IBAction)ComposeCommentVC:(ComposeCommentVC *)ccvc shouldDismiss:(BOOL)shouldDismiss;

@end
@interface ComposeCommentVC : UIViewController
{
    id <ComposeCommentDelegate> delegate;
    IBOutlet UITextView *textField;
    IBOutlet UIBarButtonItem *rightBarButtonItem;
    IBOutlet UIScrollView *scrollView;
    BOOL keyboardIsShown;
    int idVDM;
}
- (IBAction)dismiss;
- (IBAction)addComment;
@property (nonatomic, assign) id <ComposeCommentDelegate> delegate;
@property (nonatomic) int idVDM;
@end