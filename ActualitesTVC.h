//
//  ActualitesTVC.h
//  iMines-1
//
//  Created by François de la Taste on 30/07/10.
//  Copyright 2010 Mines ParisTech. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ActualitesTVC : UITableViewController <NSXMLParserDelegate> {
	
	IBOutlet UITableViewCell *tvCell;
	IBOutlet UITableView * newsTable;
	UIActivityIndicatorView * activityIndicator;
	CGSize cellSize;
	NSXMLParser * rssParser;
	NSMutableArray * stories;
	
	// a temporary item; added to the "stories" array one at a time, and cleared for the next one
	NSMutableDictionary * item;
	
	// it parses through the document, from top to bottom...
	// we collect and cache each sub-element value, and then save each item to our array.
	// we use these to track each current item, until it's ready to be added to the "stories" array
	NSString * currentElement;
	NSMutableString * currentTitle, * currentDate, * currentSummary, * currentLink;

}

@property (nonatomic, assign) IBOutlet UITableViewCell *tvCell;

- (void)parseXMLFileAtURL:(NSString *)URL;

@end
