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

- (void)doAsynchRequest:(NSString *)method
       requestURL:(NSString *)url
    requestParams:(NSDictionary *)params
         completeHandler:(void (^)(NSURLResponse *response, NSData *data, NSError *error))complete;

- (void)uploadFile:(NSString *)url fileName:(NSString *)name fileData:(NSData *)data postParams:(NSDictionary *)params;

- (void)updateNetworkActivityIndicator;

- (void)requestStarted;

- (void)requestCompleted;

@end
