//
//  LZWebServiceClient.h
//  LazadaAssignement
//
//  Created by abhijeet upadhyay on 26/11/16.
//  Copyright © 2016 lazada. All rights reserved.
//

@import Foundation;

#import "AFHTTPSessionManager.h"

typedef void (^CompletionHandlerBlock)(BOOL error, _Nullable id data);

@interface LZWebServiceClient : NSObject

+ (id _Nonnull)sharedManager;

@property (nonnull, readonly, nonatomic, strong) AFHTTPSessionManager *sessionManager;

- (void)getImages:(nonnull NSString * )category page:(int)page pageSize:(int)count completionHandler:(nonnull CompletionHandlerBlock)completionHandler;

- (void)getPhotoDetailWithId:(nonnull NSString *)photoId completionHandler:(nonnull CompletionHandlerBlock)completionHandler;

@end
