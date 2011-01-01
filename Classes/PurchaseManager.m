//
//  InAppPurchaseManager.m
//  Remindly
//
//  Created by Nathan Stitt on 12/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PurchaseManager.h"
#import "NotesManager.h"

@implementation PurchaseManager

#pragma mark SKPaymentTransactionObserver delegate methods

-(id)init {
	self = [ super init ];
	[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
	return self;
}

-(void)unlockReminders:(NSString*)productIdentifier{
	if ( [ productIdentifier isEqualToString: LIMITED_PRODUCT_ID ] ) {
		[ NotesManager instance ].maxNumberOfNotes += 3;
	} else if ( [ productIdentifier isEqualToString: UNLIMITED_PRODUCT_ID ] ) {
		[ NotesManager instance ].maxNumberOfNotes = 9999999;
	} else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unknown Appstore Response"
									message:@"Received an unknown response from Apple, please report to IoGee Support"  
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
									message:@"Received an unknown error from Apple, please report to IoGee Support"  
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
