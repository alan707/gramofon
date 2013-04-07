//
//  HTTPRequest.h
//  gramofon
//
//  Created by Dan Trenz on 4/4/13.
//  Copyright (c) 2013 gramofon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTTPRequest : NSObject
{
    int requestCounter;
}

+ (HTTPRequest *)sharedInstance;

- (void)getRequest:(NSString *)url complete:(void (^)(NSURLResponse *response, NSData *data, NSError *error))completionBlock;

- (void)uploadFile:(NSString *)url fileName:(NSString *)name fileData:(NSData *)data postParams:(NSDictionary *)params;

- (void)updateNetworkActivityIndicator;

- (void)requestStarted;

- (void)requestCompleted;

/*
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;

- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
*/

@end
