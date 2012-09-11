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
{
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;
}

-(id)initWithCoordinate:(CLLocationCoordinate2D)co andTitle:(NSString*)ti andSubtitle:(NSString*)st;

@property(nonatomic,readonly) CLLocationCoordinate2D coordinate;
@property(nonatomic,readonly) NSString *title;
@property(nonatomic,readonly) NSString *subTitle;

@end
