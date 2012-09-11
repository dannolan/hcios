//
//  TimeSample.m
//  HearClear
//
//  Created by Dan Nolan on 10/09/12.
//  Copyright (c) 2012 Dan Nolan. All rights reserved.
//

#import "TimeSample.h"
#import "NSDate+Utils.h"
@interface TimeSample ()
    @property(nonatomic,assign)double maxPower;
    @property(nonatomic, assign) double avgPower;
    @property(nonatomic,strong)NSDate *date;
@end


@implementation TimeSample



-(id)initWithDate:(NSDate*)date andAveragePower:(double)avg andMaximumPower:(double)max{
    if(self == [super init]){
        self.maxPower = max;
        self.avgPower = avg;
        self.date = date;
    }
    return self;
}



//TODO: Return as Dictionary to use NSJSONSerialization
-(NSDictionary *)dictionaryForm
{
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc] init];
    
    
    NSNumber *average = [NSNumber numberWithDouble:self.avgPower];
    NSNumber *max = [NSNumber numberWithDouble:self.maxPower];
    //TODO: Fix this so I'm submitting correct information
    //NSNumber *seconds = [NSNumber numberWithInt:[self.date ]]
    [mutableDict setObject:[self.date serverTimeString] forKey:@"sampleDate"];
    [mutableDict setObject:average forKey:@"avgSample"];
    [mutableDict setObject:max forKey:@"maxSample"];
    NSDictionary *returnDict = [[NSDictionary alloc]initWithDictionary:mutableDict];
    return returnDict;
}

@end
