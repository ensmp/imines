//
//  TweeterCell.h
//  iMines-1
//
//  Created by François de la Taste on 30/07/10.
//  Copyright 2010 Mines ParisTech. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TweeterCell : UITableViewCell {
	
	IBOutlet UILabel *titreLabel;
	IBOutlet UILabel *contenuLabel;

}

@property (nonatomic, retain) IBOutlet UILabel *titreLabel;
@property (nonatomic, retain) IBOutlet UILabel *contenuLabel;

@end
