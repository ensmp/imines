//
//  VDMTVC.h
//  iMines-1
//
//  Created by François de la Taste on 02/08/11.
/*
 This file is part of iMines ParisTech.
 
 iMines ParisTech is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 iMines ParisTech is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#import <UIKit/UIKit.h>
#import "PullRefreshTableViewController.h"
#import "ComposeVDMVC.h"
#include "SBJson.h"
#import <QuartzCore/QuartzCore.h>


@interface VDMTVC : PullRefreshTableViewController <ComposeVDMVCDelegate>
{
    
    
    IBOutlet UITableViewCell *tvCell;
    IBOutlet UITableView * VDMTable;
    
    UIActivityIndicatorView *activityIndicator;

    NSMutableArray * listeVDM; // Contient la liste des VDM (chaque item est une VDM)
    
    NSMutableData *responseData; // utilisé pour stocker au fur et à mesure les données téléchargées.
    
    BOOL isRefreshing; // pour éviter qu'on rafraichisse alors qu'on a pas fini de rafraichir (t'as compris ?)
    int currentPage;
    BOOL isAddingNextPage;
    
}

@property (nonatomic, assign) IBOutlet UITableViewCell *tvCell;
@property (nonatomic, retain) IBOutlet UITableView *VDMTable;
@property (nonatomic, retain) NSMutableArray *listeVDM;

- (void)writeVDM; // appelé lorsque l'utilisateur clique sur "Composer". Affiche un Modal View Controller pour rédiger une VDM (seulement si l'utilisateur a rempli ses identifiants CCSI)
- (void)fetchVDMlist; // rafraîchit la liste des VDM
@end

