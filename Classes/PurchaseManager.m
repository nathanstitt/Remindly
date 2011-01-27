//
//  InAppPurchaseManager.m
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

#import "PurchaseManager.h"
#import "NotesManager.h"

@implementation PurchaseManager


PurchaseManager *_instance;


+(void)startup{
	if ( ! _instance ){
		_instance = [[PurchaseManager alloc] init ];
	}
}

-(id)init {
	self = [ super init ];
	[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
	return self;
}

-(void)unlockReminders:(NSString*)productIdentifier{
	if ( [ productIdentifier isEqualToString: LIMITED_PRODUCT_ID ] ) {
		[[ NotesManager instance ] upgradeAllowedNoteCount: NO ];
	} else if ( [ productIdentifier isEqualToString: UNLIMITED_PRODUCT_ID ] ||
			   [ productIdentifier isEqualToString: PRIOR_TO_UNLIMITED_PRODUCT_ID ] ) {
		[[ NotesManager instance ] upgradeAllowedNoteCount: YES ];
	} else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unknown Appstore Response"
				message:[ NSString stringWithFormat: @"Received an unknown response: %@, please report to IoGee Support", productIdentifier ]
				delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];
		[alert release];
	}
}


- (void)finishTransaction:(SKPaymentTransaction *)transaction wasSuccessful:(BOOL)wasSuccessful
{
    // remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:transaction, @"transaction" , nil];
    if (wasSuccessful) {
        // send out a notification that we’ve finished the transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:IN_APP_PURCHASE_MADE object:self userInfo:userInfo];
    } else {
        // send out a notification for the failed transaction
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Purchase Error"
						message:@"Received an unknown error from Apple, please contact IoGee Support at help@iogee.com"  
						delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];
		[alert release];
    }
}


- (void)completeTransaction:(SKPaymentTransaction *)transaction {
	[ self unlockReminders:transaction.payment.productIdentifier];
	[ self finishTransaction:transaction wasSuccessful:YES];
}


- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    [self unlockReminders:transaction.originalTransaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
}




- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    if ( transaction.error.code != SKErrorPaymentCancelled ) {
        // error!
        [self finishTransaction:transaction wasSuccessful:NO];
    } else {
		[[NSNotificationCenter defaultCenter] postNotificationName:IN_APP_PURCHASE_CANCELED object:self userInfo:NULL];
    }
}


#pragma mark SKPaymentTransactionObserver methods


- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
	for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                break;
            default:
                break;
        }
    }
}




@end
