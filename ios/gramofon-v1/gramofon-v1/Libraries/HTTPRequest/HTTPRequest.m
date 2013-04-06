//
//  HTTPRequest.m
//  gramofon
//
//  Created by Dan Trenz on 4/4/13.
//  Copyright (c) 2013 gramofon. All rights reserved.
//

#import "HTTPRequest.h"

@implementation HTTPRequest

- (void)getRequest:(NSString *)url complete:(void (^)(NSURLResponse *response, NSData *data, NSError *error))completionBlock
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];

    [self requestStarted];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
    {
        [self requestCompleted];
        
        if ( completionBlock != nil) {
            completionBlock( response, data, error );
        }
    }];
}

- (void)requestStarted
{
    requestCounter++;
    [self updateNetworkActivityIndicator];
}

- (void)requestCompleted
{
    requestCounter--;
    [self updateNetworkActivityIndicator];
}

- (void)updateNetworkActivityIndicator
{
    BOOL activityStatus = ( requestCounter > 0 );
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = activityStatus;
}

/*
- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"didReceiveResponse");
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"didReceiveData: %@", data);
}
     
- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError");
}
     
- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"connectionDidFinishLoading");
}
*/

@end
