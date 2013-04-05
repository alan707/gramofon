//
//  HTTPRequest.h
//  gramofon
//
//  Created by Dan Trenz on 4/4/13.
//  Copyright (c) 2013 gramofon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTTPRequest : NSObject

- (void)getRequest:(NSString *)URL doAsynchronousRequest:(BOOL)async complete:(void (^)(void))completionBlock;
- (void)postRequest:(NSString *)URL doAsynchronousRequest:(BOOL)async;
- (void)putRequest:(NSString *)URL doAsynchronousRequest:(BOOL)async;
- (void)deleteRequest:(NSString *)URL doAsynchronousRequest:(BOOL)async;
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;

@end
