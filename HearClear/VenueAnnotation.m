//
//  VenueAnnotation.m
//  HearClear
//
//  Created by Dan Nolan on 11/09/12.
//  Copyright (c) 2012 Dan Nolan. All rights reserved.
//

#import "VenueAnnotation.h"

@implementation VenueAnnotation

-(id)initWithCoordinate:(CLLocationCoordinate2D)co andTitle:(NSString*)ti andSubtitle:(NSString*)st
{
    if(self = [super init])
    {
        self.coordinate = co;
        self.title = ti;
        self.subtitle = st;
    }

    return self;
}

@end
