//
//  VenueAnnotation.h
//  HearClear
//
//  Created by Dan Nolan on 11/09/12.
//  Copyright (c) 2012 Dan Nolan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface VenueAnnotation : NSObject<MKAnnotation>

-(id)initWithCoordinate:(CLLocationCoordinate2D)co andTitle:(NSString*)ti andSubtitle:(NSString*)st;

@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *subtitle;
@property(nonatomic, assign) CLLocationCoordinate2D coordinate;

@end
