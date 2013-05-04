//
//  HTTPRequest.m
//  gramofon
//
//  Created by Dan Trenz on 4/4/13.
//  Copyright (c) 2013 gramofon. All rights reserved.
//

#import "HTTPRequest.h"

@implementation HTTPRequest

+ (HTTPRequest *)sharedInstance
{
    // the instance of this class is stored here
    static HTTPRequest *myInstance = nil;
	
    // check to see if an instance already exists
    if ( nil == myInstance ) {
        myInstance  = [[[self class] alloc] init];
        // initialize variables here
    }
    
    // return the instance of this class
    return myInstance;
}

- (void)doAsynchRequest:(NSString *)method
             requestURL:(NSString *)url
          requestParams:(NSDictionary *)params
        completeHandler:(void (^)(NSURLResponse *, NSData *, NSError *))complete
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [request setHTTPMethod:method];
    
    [request setCachePolicy:NSURLRequestReloadRevalidatingCacheData];
    
    if ( params ) {
        NSMutableArray *paramArray = [NSMutableArray array];
        NSString *queryString;
        
        for ( NSString *key in params ) {
            [paramArray addObject:[NSString stringWithFormat:@"%@=%@", key, params[key]]];
        }
        
        queryString = [paramArray componentsJoinedByString:@"&"];
        
        [request setHTTPBody:[queryString dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [self requestStarted];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         [self requestCompleted];
         
         if ( complete != nil) {
             complete( response, data, error );
         }
     }];
}

- (void)uploadFile:(NSString *)url fileName:(NSString *)name fileData:(NSData *)data postParams:(NSDictionary *)params
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSMutableData *body          = [NSMutableData data];
    NSString *boundary           = @"---------------------------14737809831466499882746641449";
    NSString *contentType        = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    
    [request setHTTPMethod:@"POST"];
    
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    // file
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"audio\"; filename=\"%@\"\r\n", name] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:data];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    if ( params ) {
        for ( NSString *key in params ) {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[params[key] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    // close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // set request body
    [request setHTTPBody:body];
    
    [self requestStarted];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         [self requestCompleted];
         
         NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         NSLog(@"%@", responseString);
         
         if ( error ) {
             NSLog(@"Error: %@", [error localizedDescription]);
         }
     }];
}

- (void)requestStarted
{
    requestCounter++;
//    NSLog(@"requestStarted: %i active requests", requestCounter);
    [self updateNetworkActivityIndicator];
}

- (void)requestCompleted
{
    requestCounter--;
//    NSLog(@"requestCompleted: %i active requests", requestCounter);
    [self updateNetworkActivityIndicator];
}

- (void)updateNetworkActivityIndicator
{
    BOOL activityStatus = ( requestCounter > 0 );
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = activityStatus;
}

@end
