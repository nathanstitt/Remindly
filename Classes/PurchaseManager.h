//
//  PurchaseManager.h
//  Created by Nathan Stitt on 12/19/10.
//  Copyright 2011.
//  Distributed under the terms of the GNU General Public License version 3.

// PurchaseManger listens for notification from Apple to in-app purchase requests.
// once it recieves a notification, it marks the product as being purchased.

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

// these are our sku ID's that we listen for
#define LIMITED_PRODUCT_ID            @"com.iogee.remindly.limited"
#define UNLIMITED_PRODUCT_ID          @"com.iogee.remindly.unlimited"
#define PRIOR_TO_UNLIMITED_PRODUCT_ID @"com.iogee.remindly.prior_to_unlimited"

// we broadcast these notifications once a notificaiton is receieved
// using NSNotificationCenter defaultCenter
#define IN_APP_PURCHASE_MADE @"InAppPurchaseMade"
#define IN_APP_PURCHASE_CANCELED @"InAppPurchaseCanceled"


@interface PurchaseManager : NSObject <SKPaymentTransactionObserver> {

}

// this is called from the App delegate
+(void)startListening;

@end
