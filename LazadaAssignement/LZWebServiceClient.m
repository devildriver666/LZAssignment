//
//  LZWebServiceClient.m
//  LazadaAssignement
//
//  Created by abhijeet upadhyay on 26/11/16.
//  Copyright © 2016 lazada. All rights reserved.
//

#import "LZWebServiceClient.h"

//key from 500px dashboard
static NSString * const LAZConsumerKey = @"fqX69JbUcSnXVxmaH8NTFgylZ5KdW5ZpaIvrHI5H";

//Base URL for APIs
static NSString * const LAZBaseUrl = @"https://api.500px.com/v1/";

@implementation LZWebServiceClient

//Singleton creation.
+ (id)sharedManager {
    
    static LZWebServiceClient *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    
    if (self = [super init]) {
        _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:LAZBaseUrl] sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
        responseSerializer.readingOptions = NSJSONReadingAllowFragments;
        
        self.sessionManager.responseSerializer = responseSerializer;
    }
    
    return self;
}

//Get Image and related data from API.
- (void)getImages:(NSString *)category page:(int)page pageSize:(int)count completionHandler:(CompletionHandlerBlock)completionHandler {
    
    NSString *urlString = [[self.sessionManager.baseURL URLByAppendingPathComponent:@"photos"] absoluteString];
    
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    NSDictionary *params = @{@"feature": @"popular",
                             @"only": category,
                             @"page": @(page),
                             @"rpp": @(count),
                             @"sort": @"created_at",
                             @"sort_direction": @"desc",
                             @"image_size": @3,
                             @"consumer_key":LAZConsumerKey };
    NSError *error;
    NSURLRequest *request = [requestSerializer requestWithMethod:@"GET" URLString:urlString parameters:params error:&error];
    
    NSURLSessionDataTask *dataTask = [self.sessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            if (completionHandler) {
                completionHandler(NO, responseObject);
            }
        } else {
            if (completionHandler) {
                completionHandler(YES, [error localizedDescription]);
            }
        }
    }];
    
    [dataTask resume];
}

//Get new image to show on detail with bigger size so that zoom and stuff can be made and streaching small image wont be good.
- (void)getPhotoDetailWithId:(NSString *)photoId completionHandler:(CompletionHandlerBlock)completionHandler {

    NSString *urlString = [[self.sessionManager.baseURL URLByAppendingPathComponent:@"photos/"] absoluteString];
    urlString = [urlString stringByAppendingPathComponent:photoId];
    
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    NSDictionary *params = @{@"image_size": @4,
                             @"consumer_key":LAZConsumerKey };
    
    NSError *error;
    NSURLRequest *request = [requestSerializer requestWithMethod:@"GET" URLString:urlString parameters:params error:&error];
    
    NSURLSessionDataTask *dataTask = [self.sessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            if (completionHandler) {
                completionHandler(NO, responseObject);
            }
        } else {
            if (completionHandler) {
                completionHandler(YES, [error localizedDescription]);
            }
        }
    }];
    
    [dataTask resume];
}
@end
