//
//  VDMShowCommentsTVC.h
//  iMines-1
//
//  Created by François de la Taste on 08/08/11.
//  Copyright 2011 Mines ParisTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComposeCommentVC.h"

@interface VDMShowCommentsTVC : UITableViewController <ComposeCommentDelegate>
{
    int idVDM;
    NSMutableData *responseData;
    NSMutableDictionary *listeComms;
    BOOL isLiking;
}
- (id)initWithStyle:(UITableViewStyle)style andID:(int)theID;
@end
