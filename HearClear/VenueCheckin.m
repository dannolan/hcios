//
//  VenueCheckin.m
//  HearClear
//
//  Created by Dan Nolan on 10/09/12.
//  Copyright (c) 2012 Dan Nolan. All rights reserved.
//

#import "VenueCheckin.h"
#import "TimeSample.h"
#import "FSNetwork.h"


@implementation VenueCheckin


-(id)initWithName:(NSString *)name andVenueID:(NSString*)vID andLatitude:(NSString*)lat andLongitude:(NSString *)lon{
    if(self == [super init]){
        venueName = name;
        venueID = vID;
        venueLat = lat;
        venueLon = lon;
        self.venueSamples = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)addSampleWithAvg:(double)avg andMax:(double)max{
    NSDate *now = [NSDate date];
    TimeSample *sample = [[TimeSample alloc] initWithDate:now andAveragePower:avg andMaximumPower:max];
    [self.venueSamples addObject:sample];
}

-(id)JSONRepresentation
{
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:[self asDictionary] options:NSJSONWritingPrettyPrinted error:&error];
    
    //NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //NSLog(@"Json value for Sample: %@", string);
    
    return data;
}


-(NSString *)description
{
    return [NSString stringWithFormat:@"\nVenue: %@\n VID: %@\n Samples: %@\n", venueName, venueID, [self.venueSamples description]];
}


//Return as dictionary to use NSJSONSerialization
-(NSDictionary *)asDictionary
{
    NSMutableDictionary *sampleDict = [[NSMutableDictionary alloc] init];
    
    [sampleDict setObject:venueName forKey:@"name"];
    [sampleDict setObject:venueID forKey:@"ID"];
    [sampleDict setObject:venueLat forKey:@"lat"];
    [sampleDict setObject:venueLon forKey:@"lon"];
    NSMutableArray *sampleArray = [[NSMutableArray alloc]init];
    
    for(TimeSample *ts in self.venueSamples)
    {
        [sampleArray addObject:[ts dictionaryForm]];
    }
    
    NSArray *finishedSampleArray = [NSArray arrayWithArray:sampleArray];
    [sampleDict setObject:finishedSampleArray forKey:@"samples"];
    [sampleDict setObject:[HCUtils HCDeviceString] forKey:@"device"];
    [sampleDict setObject:[HCUtils HCID] forKey:@"deviceID"];
    NSDictionary *repDictionary = [[NSDictionary alloc]initWithDictionary:sampleDict];
    NSDictionary *totalDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:repDictionary, @"checkin", nil];
    NSLog(@"Returned dictionary %@", [totalDictionary description]);
    return totalDictionary;
}


@end
