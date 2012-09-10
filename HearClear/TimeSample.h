//
//  TimeSample.h
//  HearClear
//
//  Created by Dan Nolan on 10/09/12.
//  Copyright (c) 2012 Dan Nolan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeSample : NSObject


-(id)initWithDate:(NSDate*)date andAveragePower:(double)avg andMaximumPower:(double)max;
-(NSDictionary *)dictionaryForm;

@end
