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
    
    //return and test
    [NSURLConnection sendAsynchronousRequest:request queue:nil completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         [self requestCompleted];
         
         if ( error ) {
             NSLog(@"Error: %@", [error localizedDescription]);
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
