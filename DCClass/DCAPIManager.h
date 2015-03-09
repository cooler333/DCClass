//
//  DCAPIManager.h
//  DCClass
//
//  Created by Дмитрий Утьманов on 06/03/15.
//  Copyright (c) 2015 cooler. All rights reserved.
//


#import "AFHTTPSessionManager.h"


@interface DCAPIManager : AFHTTPSessionManager

@property(nonatomic,strong,readonly) NSDateFormatter *dateFormatter;

+ (void)setSharedManagerWithBaseURL:(NSURL *)baseURL;
+ (instancetype)sharedManager;


- (NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(NSDictionary *)parameters success:(void (^)(NSURLSessionDataTask *task, NSArray *responseArray))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;


- (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(NSDictionary *)parameters success:(void (^)(NSURLSessionDataTask *task, NSArray *responseArray))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(NSDictionary *)parameters constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block success:(void (^)(NSURLSessionDataTask *task, NSArray *responseArray))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

@end
