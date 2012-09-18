//
//  VenueCheckin.h
//  HearClear
//
//  Created by Dan Nolan on 10/09/12.
//  Copyright (c) 2012 Dan Nolan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VenueCheckin : NSObject
{
    NSString *venueName;
    NSString *venueID;
    NSString *venueLat;
    NSString *venueLon;
    //NSMutableArray *venueSamples;
}


-(id)initWithName:(NSString *)name andVenueID:(NSString*)vID andLatitude:(NSString*)lat andLongitude:(NSString *)lon;

-(void)addSampleWithAvg:(double)avg andMax:(double)max;

-(NSDictionary *)asDictionary;

-(id)JSONRepresentation;

@property(nonatomic,retain) NSMutableArray *venueSamples;

@end
