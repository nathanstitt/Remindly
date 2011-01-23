//
//  StoreView.h
//  Created by Nathan Stitt on 12/24/10.
//  Copyright 2011.
//  Distributed under the terms of the GNU General Public License version 3.

// StoreView initiates an InApp purchase

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

@class GradientButton;

@interface StoreView : UIView <UITableViewDelegate,
								UIAlertViewDelegate,
								UITableViewDataSource,
								SKProductsRequestDelegate> 
{
	UITableView *tableView;
	UILabel *message;

	UITableViewCell *firstOption;
	UILabel *firstDesc;

	UITableViewCell *secondOption;
	UILabel *secondDesc;
	
	GradientButton *closeButton;

	NSNumberFormatter *priceFormatter;
}

-(id)initAndShowInto:(UIView*)view;

@end
