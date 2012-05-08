//
//  ComposeVDMVC.h
//  iMines-1
//
//  Created by François de la Taste on 03/08/11.
//  Copyright 2011 Mines ParisTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VDMCategorySelectionTVC.h"

@class ComposeVDMVC;
@protocol ComposeVDMVCDelegate <NSObject>

@required
- (IBAction)ComposeVDMVC:(ComposeVDMVC *)cvdmvc shouldDismiss:(BOOL)shouldDismiss;

@end
@interface ComposeVDMVC : UIViewController <VDMCategorySelectionDelegate, UIActionSheetDelegate>
{
    id <ComposeVDMVCDelegate> delegate;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UITextView *textField;
    IBOutlet UIBarButtonItem *rightBarButtonItem;
    BOOL keyboardIsShown;
    NSArray *categories;
    IBOutlet UIButton *categoryButton;
    int selectedCategoryNumber;
}
- (IBAction)dismiss;
- (IBAction)addVDM;
- (IBAction)selectCategory;
@property (nonatomic, assign) id <ComposeVDMVCDelegate> delegate;

@end
