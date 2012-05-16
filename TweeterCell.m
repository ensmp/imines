//
//  TweeterCell.m
//  iMines-1
//
//  Created by François de la Taste on 30/07/10.
//  Copyright 2010 Mines ParisTech. All rights reserved.
//

#import "TweeterCell.h"


@implementation TweeterCell
@synthesize titreLabel, contenuLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
    [super dealloc];
}


@end
