//
//  StoreView.h
//  Remindly
//
//  Created by Nathan Stitt on 12/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

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
