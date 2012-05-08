//
//  VDMCategorySelectionTVC.h
//  iMines-1
//
//  Created by François de la Taste on 04/08/11.
//  Copyright 2011 Mines ParisTech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VDMCategorySelectionTVC;
@protocol VDMCategorySelectionDelegate <NSObject>

@required
- (IBAction)VDMCategorySelection:(VDMCategorySelectionTVC *)vdmcstvc selectedCategory:(int)categoryNumber;

@end
@interface VDMCategorySelectionTVC : UITableViewController
{
    id <VDMCategorySelectionDelegate> delegate;
    NSArray *categories;
}
- (id)initWithStyle:(UITableViewStyle)style andArray:(NSArray*)array;

@property (nonatomic, assign) id <VDMCategorySelectionDelegate> delegate;
@end

