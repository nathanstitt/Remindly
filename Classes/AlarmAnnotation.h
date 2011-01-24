//
//  AlarmAnnotation.h
//  Remindly
//
//  Created by Nathan Stitt on 1/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface AlarmAnnotation : NSObject <MKAnnotation> {
	CLLocationCoordinate2D coordinate;
	BOOL entering;
}

@property (nonatomic) CLLocationCoordinate2D coordinate;

@property (nonatomic) BOOL entering;

@end
