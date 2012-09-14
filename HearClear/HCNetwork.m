//
//  HCNetwork.m
//  HearClear
//
//  Created by Dan Nolan on 4/09/12.
//  Copyright (c) 2012 Dan Nolan. All rights reserved.
//

#import "HCNetwork.h"
#import "NSDictionary+Utils.h"
#import "HCUtils.h"


#define kBackendCheckinURL  @"http://hearclear.mobi/api/v1/checkin/new"
#define kVenueCreateURL  @"http://hearclear.mobi/api/v1/venue/new"
#define kVenueInfoURL  @"http://hearclear.mobi/api/v1/venue/"
#define kUserExistsURL @"http://hearclear.mobi/api/v1/user/"
#define kUserCreateURL @"http://hearclear.mobi/api/v1/user/create"


@implementation HCNetwork





# pragma mark venue information

+(void)postCheckinInformation:(VenueCheckin*)checkin withDetails:(NSDictionary *)details{
    //TODO: Details should have the USER ID but actually not really needed at this stage
    NSData *postData = (NSData*)[checkin JSONRepresentation];
    
    NSURL *url = [NSURL URLWithString:kBackendCheckinURL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *resp, NSData *data, NSError *error) {
        if(error)
        {
            NSLog(@"Error okay ERROR: %@", [error localizedDescription]);
        }else{
            NSLog(@"Reseponse from backend:%@", [resp description]);
            
        }
    }];
}

+(void)venueExists:(NSDictionary*)venueDict
{
    NSString *venueQueryString = [NSString stringWithFormat:@"%@%@", kVenueInfoURL, [venueDict objectForKey:@"id"]];
    NSURL *venueQueryURL = [NSURL URLWithString:venueQueryString];
    NSURLRequest *request = [NSURLRequest requestWithURL:venueQueryURL];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if(error)
        {
            
        }else{
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if([httpResponse statusCode] == 200)
            {
                //we cool
            }else if([httpResponse statusCode] == 404)
            {
                [HCNetwork createVenue:venueDict];
            }else{
                //do nothing
            }
            
            
        }
    }];
    
    
}

+(void)createVenue:(NSDictionary *)venueDict
{
    NSString *venueQueryString = [NSString stringWithFormat:@"%@", kVenueCreateURL];
    NSDictionary *postDict = @{ @"venue" : venueDict };
    NSData *postData = (NSData*)[postDict JSONRepresentation];
    
    NSURL *venueQueryURL = [NSURL URLWithString:venueQueryString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:venueQueryURL];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *resp, NSData *data, NSError *error) {
        if(error)
        {
            NSLog(@"Error okay ERROR: %@", [error localizedDescription]);
        }else{
            NSLog(@"Reseponse from backend:%@", [resp description]);
            
        }
    }];

}



+(void)userExists{
    NSString *userIdentifier = [HCUtils HCID];
    NSString *requestString = [NSString stringWithFormat:@"%@%@", kUserExistsURL,userIdentifier];
    NSURL *userExistsURL = [NSURL URLWithString:requestString];
    NSURLRequest *request = [NSURLRequest requestWithURL:userExistsURL];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if(error)
        {
            
        }else{
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;

            if([httpResponse statusCode] == 200)
            {
                //we're cool
            }else if([httpResponse statusCode] == 404)
            {
                [HCNetwork createUser];
            }else{
                //we're boned something is totally fucked
            }
        }
        
    }];
    
    
}



+(void)createUser{
    NSDictionary *userCreateDict = @{@"user" : [HCUtils userInfoDictionary]};
    NSData *postData = (NSData *) [userCreateDict JSONRepresentation];
    NSString *userCreateString = [NSString stringWithFormat:@"%@", kUserCreateURL];
    NSURL *createUserURL = [NSURL URLWithString:userCreateString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:createUserURL];
    [request setHTTPBody:postData];
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if(error)
        {
            
        }else{
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            if([httpResponse statusCode] == 200){
                NSLog(@"Yay we did it");
            }else if([httpResponse statusCode] == 401){
                NSLog(@"Forbidden to create");
            }
            
        }
    }];
    
    
    
}




@end
