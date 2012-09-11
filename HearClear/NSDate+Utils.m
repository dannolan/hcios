//
//  NSDate+Utils.m
//  HearClear
//
//  Created by Dan Nolan on 11/09/12.
//  Copyright (c) 2012 Dan Nolan. All rights reserved.
//

#import "NSDate+Utils.h"

@implementation NSDate(Utils)


-(NSString*)serverTimeString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss z"];
    //[dateFormatter setTimeZone:[NSTimeZone ]]
    return [dateFormatter stringFromDate:self];
}

@end
