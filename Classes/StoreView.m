//
//  StoreView.m
/*  This file is part of Remindly.

    Remindly is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, version 3.

    Remindly is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Remindly.  If not, see <http://www.gnu.org/licenses/>.
*/

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "StoreView.h"
#import "PurchaseManager.h"
#import "GradientButton.h"
#import "NotesManager.h"

@implementation StoreView

-(id)initAndShowInto:(UIView*)view {
    
    self = [super initWithFrame: CGRectMake(0, 480, 320, 480 )];
    if (self) {
        // Initialization code.
    }
	NSSet *productIDs;

	if (  [[NotesManager instance] hasBeenUpgraded] ){
		productIDs = [NSSet setWithObjects: PRIOR_TO_UNLIMITED_PRODUCT_ID, NULL ];
	} else {
		productIDs = [NSSet setWithObjects: LIMITED_PRODUCT_ID, UNLIMITED_PRODUCT_ID, NULL ];
	}
	
	SKProductsRequest *iap_req = [[SKProductsRequest alloc] initWithProductIdentifiers: productIDs ];
	iap_req.delegate = self;
    [ iap_req start ];
	[ iap_req release ];
 
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchaseMade:) name:IN_APP_PURCHASE_MADE object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchaseCanceled:) name:IN_APP_PURCHASE_CANCELED object:nil];

	UILabel *header = [[ UILabel alloc ] initWithFrame:CGRectMake( -2, -2, 324, 32 ) ];
	header.textAlignment = UITextAlignmentCenter;
	header.font = [ UIFont systemFontOfSize:26 ];
	header.text = @"Purchase reminders";
	header.layer.borderColor = [[UIColor grayColor] CGColor];
	header.layer.borderWidth = 2.0;
	header.backgroundColor = [ UIColor colorWithRed: 241.0/255.0
									  green:241.0/255.0 
									  blue:241.0/255.0 
									  alpha:1.0 ];
	[ self addSubview: header ];
	[ header release ];

	[ view addSubview: self ];

	message = [[UILabel alloc ] initWithFrame:CGRectMake( 20, 80, 280, 120 ) ];
	message.textAlignment = UITextAlignmentCenter;
	message.font = [ UIFont systemFontOfSize: 18 ];
	message.numberOfLines = 0;
	message.lineBreakMode = UILineBreakModeWordWrap;
	message.hidden = YES;
	[ self addSubview: message ];

	closeButton = [[ GradientButton alloc ] initWithFrame:CGRectMake(100, 400, 120, 30) ];
	[ closeButton useRedDeleteStyle ];
	[ closeButton addTarget:self action:@selector(closeTouched:) forControlEvents:UIControlEventTouchUpInside ];
	[ closeButton setTitle:@"Cancel" forState:UIControlStateNormal ];
	[ self addSubview: closeButton ];
	
	priceFormatter = [[ NSNumberFormatter alloc ] init ];
	[ priceFormatter setNumberStyle: NSNumberFormatterCurrencyStyle ];

	self.backgroundColor = [ UIColor whiteColor ];

	tableView = [[ UITableView alloc ] initWithFrame:CGRectMake(20, 40, 280, 340 ) style:UITableViewStyleGrouped ];
	tableView.backgroundColor = [ UIColor clearColor ];
	tableView.dataSource = self;
	tableView.delegate = self;
	tableView.sectionHeaderHeight = 10;

	[self addSubview: tableView];

	[ UIView beginAnimations:nil context:NULL ];
	[ UIView setAnimationDuration:0.45f ];
	self.frame = CGRectMake(0, 0, 320, 480 );
	[ UIView commitAnimations ];

	firstOption  = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil ];
	firstOption.textLabel.text = [[NotesManager instance] hasBeenUpgraded] ?
						@"Unlimited Reminders" : @"3 more reminders (5 total)";
	firstDesc = [[UILabel alloc ] initWithFrame:CGRectMake(20, 0, 280, 40 ) ];
	firstDesc.lineBreakMode = UILineBreakModeWordWrap;
	firstDesc.numberOfLines = 0;

	secondOption = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil ];
	secondOption.textLabel.text = @"Unlimited Reminders";
	secondDesc = [[UILabel alloc ] initWithFrame:CGRectMake(20, 0, 280, 40 ) ];
	secondDesc.lineBreakMode = UILineBreakModeWordWrap;
	secondDesc.numberOfLines = 0;
	
	if ( ! [SKPaymentQueue canMakePayments] ){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to purchase"
									message:@"Purchases have been disabled, please check system settings"
									delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];
		alert.tag = 1;
		[alert release];
	}
    return self;
}

- (void)onHidden:(NSString *) aniname finished:(BOOL) finished context:(void *) context{
	[ self removeFromSuperview ];
}

-(void)hide {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.45f ];
	
	[UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(onHidden:finished:context:)];

	self.frame = CGRectMake(0, 480, 320, 215);

	[UIView commitAnimations];
	
}

-(void)closeTouched:(id)btn {
	[ self hide ];
}

-(void)purchaseCanceled:(NSNotification*)note {
	[ self hide ];
}

-(void)purchaseMade:(NSNotification*)note {
	message.text = @"Thank You!\n\nEnjoy your addittional reminders.";
	[ closeButton useWhiteStyle ];
	[ closeButton setTitle:@"Close" forState:UIControlStateNormal ];
}

-(void)setDesc:(UILabel*)l text:(NSString*)str {
    CGSize maximumSize = CGSizeMake( 280, 100 );
    
	UIFont *dateFont = [UIFont fontWithName:@"Helvetica" size:14];

    CGSize dateStringSize = [ str sizeWithFont:dateFont 
								constrainedToSize:maximumSize 
								lineBreakMode: UILineBreakModeWordWrap ];

	l.frame = CGRectMake( 20, 0, 280, dateStringSize.height);
	l.text = str;
}

- (void)dealloc {
	[ firstOption release ];
	[ firstDesc release ];

	[ secondOption release ];
	[ secondDesc release ];

	[ priceFormatter release ];

	[ message release ];

	[ [ NSNotificationCenter defaultCenter] removeObserver:self];

    [ super dealloc ];
}

#pragma mark SKProductsRequestDelegate methods

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
	for ( SKProduct *product in response.products ){
		if ( ( [product.productIdentifier isEqualToString:LIMITED_PRODUCT_ID ] )
			|| ( [ product.productIdentifier isEqualToString:PRIOR_TO_UNLIMITED_PRODUCT_ID ] ) ) {
				firstOption.textLabel.text        = product.localizedTitle;
				firstOption.detailTextLabel.text  = [ priceFormatter stringFromNumber: product.price ];
				[ self setDesc:firstDesc text:product.localizedDescription ];
		} else if ( [product.productIdentifier isEqualToString:UNLIMITED_PRODUCT_ID ] ){
			secondOption.textLabel.text       = product.localizedTitle;
			secondOption.detailTextLabel.text = [ priceFormatter stringFromNumber: product.price ];
			[ self setDesc: secondDesc text:product.localizedDescription ];
		} else if ( [ product.productIdentifier isEqualToString:PRIOR_TO_UNLIMITED_PRODUCT_ID ] ){
			
		}
	}

	[ tableView reloadData ];

    for ( NSString *invalidProductId in response.invalidProductIdentifiers ) {
		NSLog(@"Invalid product id: %@" , invalidProductId);
    }

}


#pragma mark UITableViewDataSource methods

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 100.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ( 0 == section ) {           
        return firstDesc;
    } else if ( 1 == section ){
		return secondDesc;
	}
    return nil; 
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [[ NotesManager instance ] hasBeenUpgraded ] ? 1 : 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tb cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if ( 0 == indexPath.section ){
		return firstOption;
	} else if ( 1 == indexPath.section ){
		return secondOption;
	} else {
		return nil;
	}
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	SKPayment *payment;
	tv.hidden = YES;
	message.hidden = NO;
	if ( 0 == indexPath.section ){
		message.text = [ NSString stringWithFormat:@"Purchasing %@", firstOption.textLabel.text ];
		payment = [SKPayment paymentWithProductIdentifier: LIMITED_PRODUCT_ID ];
	} else if ( 1 == indexPath.section ) {
		message.text = [ NSString stringWithFormat:@"Purchasing %@", secondOption.textLabel.text ];
		payment = [SKPayment paymentWithProductIdentifier: UNLIMITED_PRODUCT_ID ];
	}

	[[SKPaymentQueue defaultQueue] addPayment:payment];
}

#pragma mark UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
	if ( 1 == alertView.tag ){
		[ self hide ];
	}
}

@end
