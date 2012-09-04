//
//  NSDictionary+Utils.m
//  HearClear
//
//  Created by Dan Nolan on 4/09/12.
//  Copyright (c) 2012 Dan Nolan. All rights reserved.
//

#import "NSDictionary+Utils.h"

@implementation NSDictionary (Utils)

-(BOOL)hasValueForKey:(NSString *)key
{
    if([self objectForKey:key] == nil){
        return false;
    }
    
    if([[self objectForKey:key] isKindOfClass:[NSNull class]]){
        return false;
    }
    
    return true;
    
}

@end
