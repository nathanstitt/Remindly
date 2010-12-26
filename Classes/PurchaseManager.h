//
//  InAppPurchaseManager.h
//  Remindly
//
//  Created by Nathan Stitt on 12/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>


#define LIMITED_PRODUCT_ID @"com.iogee.remindly.limited"
#define UNLIMITED_PRODUCT_ID @"com.iogee.remindly.unlimited"
#define UNLIMITED_UPGRADE_PRODUCT_ID @"com.iogee.remindly.unlimited-upgrade"

#define IN_APP_PURCHASE_MADE @"InAppPurchaseMade"
#define IN_APP_PURCHASE_CANCELED @"InAppPurchaseCanceled"
@interface PurchaseManager : NSObject <SKPaymentTransactionObserver> {

}


@end
