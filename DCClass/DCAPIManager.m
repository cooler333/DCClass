//
//  DCAPIManager.m
//  DCClass
//
//  Created by Дмитрий Утьманов on 06/03/15.
//  Copyright (c) 2015 cooler. All rights reserved.
//


#import "DCAPIManager.h"

#import "DCLog.h"


@interface DCAPIManager ()

@property(nonatomic,strong) NSDateFormatter *dateFormatter;

@end


@implementation DCAPIManager

static DCAPIManager *_sharedManager = nil;

+ (void)setSharedManagerWithBaseURL:(NSURL *)baseURL {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedManager = [[super alloc] initWithBaseURL:baseURL];
  });
}

+ (instancetype)sharedManager {
  return _sharedManager;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
  self = [super initWithBaseURL:url];
  if (self) {
    AFHTTPRequestSerializer *JSONRequestSerializer = [AFHTTPRequestSerializer serializer];
    JSONRequestSerializer.stringEncoding = NSUTF8StringEncoding;
    self.requestSerializer = JSONRequestSerializer;
    
    NSJSONReadingOptions JSONReadingOptions = (NSJSONReadingOptions)(NSJSONReadingAllowFragments|NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves);
    AFJSONResponseSerializer *JSONResponseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:JSONReadingOptions];
    JSONResponseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    self.responseSerializer = JSONResponseSerializer;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier: @"en_US_POSIX"];
    self.dateFormatter.dateFormat = @"EEE, dd MMM yyyy HH:mm:ss Z";  //RFC2822-Format
  }
  return self;
}

- (id)isResponseObjectConforms:(id)responseObject {
  if (responseObject != nil && [responseObject isKindOfClass:[NSArray class]]) {
    return responseObject;
  }
  if (responseObject != nil && [responseObject isKindOfClass:[NSDictionary class]]) {
    return [NSArray arrayWithObject:responseObject];
  }
  return nil;
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(NSDictionary *)parameters success:(void (^)(NSURLSessionDataTask *, NSArray *))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
  if (isObjectEmpty(URLString)) {
    URLString = @"";
  }
  NSMutableDictionary *newParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
  NSURLSessionDataTask *URLSessionDataTask = [super GET:URLString parameters:newParameters success:^(NSURLSessionDataTask *task, id responseObject) {
    NSInteger statusCode = [(NSHTTPURLResponse *)task.response statusCode];
    responseObject = [self isResponseObjectConforms:responseObject];
    if (isObjectNotEmpty(responseObject)) {
      if (success) {
        [self printLogWithURLString:@"" parameters:newParameters responseObject:responseObject statusCode:statusCode error:nil];
        success(task, responseObject);
      }
    } else {
      if (failure) {
        NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
        [errorDetail setValue:@"Data object nil or isn't an array" forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:@"API Error: POST" code:200 userInfo:errorDetail];
        [self printLogWithURLString:@"" parameters:newParameters responseObject:nil statusCode:statusCode error:error];
        failure(task, error);
      }
    }
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    if (failure) {
      NSInteger statusCode = [(NSHTTPURLResponse *)task.response statusCode];
      [self printLogWithURLString:@"" parameters:newParameters responseObject:nil statusCode:statusCode error:error];
      failure(task, error);
    }
  }];
  return URLSessionDataTask;
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(NSDictionary *)parameters constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block success:(void (^)(NSURLSessionDataTask *, NSArray *responseArray))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
  if (isObjectEmpty(URLString)) {
    URLString = @"";
  }
  NSMutableDictionary *newParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
  
  NSURLSessionDataTask *URLSessionDataTask = [super POST:URLString parameters:newParameters constructingBodyWithBlock:block success:^(NSURLSessionDataTask *task, id responseObject) {
    NSInteger statusCode = [(NSHTTPURLResponse *)task.response statusCode];
    responseObject = [self isResponseObjectConforms:responseObject];
    if (isObjectNotEmpty(responseObject)) {
      if (success) {
        [self printLogWithURLString:@"" parameters:newParameters responseObject:responseObject statusCode:statusCode error:nil];
        success(task, responseObject);
      }
    } else {
      if (failure) {
        NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
        [errorDetail setValue:@"Data object nil or isn't an array" forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:@"API Error: POST" code:200 userInfo:errorDetail];
        [self printLogWithURLString:@"" parameters:newParameters responseObject:nil statusCode:statusCode error:error];
        failure(task, error);
      }
    }
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    NSInteger statusCode = [(NSHTTPURLResponse *)task.response statusCode];
    if (failure) {
      [self printLogWithURLString:@"" parameters:newParameters responseObject:nil statusCode:statusCode error:error];
      failure(task, error);
    }
  }];
  return URLSessionDataTask;
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(NSDictionary *)parameters success:(void (^)(NSURLSessionDataTask *task, NSArray *responseArray))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
  if (isObjectEmpty(URLString)) {
    URLString = @"";
  }
  
  NSMutableDictionary *newParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
  
//  NSString *tokenString = [KeychainWrapper keychainTokenString];
//  NSString *IDString = [KeychainWrapper keychainIDString];
//  if (isObjectNotEmpty(tokenString) && isObjectNotEmpty(IDString)) {
//    [newParameters setValue:tokenString forKey:@"access_token"];
//    [newParameters setValue:IDString forKey:@"access_id"];
//  }
  
  //  [newParameters setValue:@"fe7c088fa5b950ecc44fa469e67b03dd7eb9226a" forKey:@"access_token"];
  //  [newParameters setValue:@"1" forKey:@"access_id"];
  
  
  NSURLSessionDataTask *URLSessionDataTask = [super POST:URLString parameters:newParameters success:^(NSURLSessionDataTask *task, id responseObject) {
    NSInteger statusCode = [(NSHTTPURLResponse *)task.response statusCode];
    responseObject = [self isResponseObjectConforms:responseObject];
    if (isObjectNotEmpty(responseObject)) {
      if (success) {
        [self printLogWithURLString:@"" parameters:newParameters responseObject:responseObject statusCode:statusCode error:nil];
        success(task, responseObject);
      }
    } else {
      if (failure) {
        NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
        [errorDetail setValue:@"Data object nil or isn't an array" forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:@"API Error: POST" code:200 userInfo:errorDetail];
        [self printLogWithURLString:@"" parameters:newParameters responseObject:nil statusCode:statusCode error:error];
        failure(task, error);
      }
    }
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    NSInteger statusCode = [(NSHTTPURLResponse *)task.response statusCode];
    if (failure) {
      [self printLogWithURLString:@"" parameters:newParameters responseObject:nil statusCode:statusCode error:error];
      failure(task, error);
    }
  }];
  return URLSessionDataTask;
}

- (void)printLogWithURLString:(NSString *)URLString parameters:(NSDictionary *)parameters responseObject:(id)responseObject statusCode:(NSInteger)statusCode error:(NSError *)error {
#ifdef DEBUG
  NSMutableString *logString = [NSMutableString string];
  
  [logString appendFormat:@"Path: %@\n", [self.baseURL.absoluteString stringByAppendingString:URLString]];
  [logString appendFormat:@"Status Code: %li\n", (long)statusCode];
  if (isObjectNotEmpty(parameters)) {
    [logString appendFormat:@"Params: %@\n", parameters];
  }
  if (isObjectNotEmpty(error)) {
    if ([error.domain isEqualToString:AFURLRequestSerializationErrorDomain]) {
      if ([[error userInfo] valueForKey:AFNetworkingOperationFailingURLRequestErrorKey]) {
        [logString appendFormat:@"AFNetworkingOperationFailingURLRequestErrorKey: {\n    %@\n}\n", [[error userInfo] valueForKey:AFNetworkingOperationFailingURLRequestErrorKey]];
      }
    }
    if ([error.domain isEqualToString:AFURLResponseSerializationErrorDomain]) {
      if ([[error userInfo] valueForKey:AFNetworkingOperationFailingURLResponseErrorKey]) {
        [logString appendFormat:@"AFNetworkingOperationFailingURLResponseErrorKey: {\n    %@\n}\n", [[error userInfo] valueForKey:AFNetworkingOperationFailingURLResponseErrorKey]];
      }
      if ([[error userInfo] valueForKey:AFNetworkingOperationFailingURLResponseDataErrorKey]) {
        [logString appendFormat:@"AFNetworkingOperationFailingURLResponseDataErrorKey: {\n    %@\n}\n", [[error userInfo] valueForKey:AFNetworkingOperationFailingURLResponseDataErrorKey]];
        NSString *str = [[NSString alloc] initWithData:[[error userInfo] valueForKey:AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        [logString appendFormat:@"AFNetworkingOperationFailingURLResponseStringErrorKey: {\n    %@\n}\n", str];
      }
    }
    if (isObjectNotEmpty(error.domain)) {
      [logString appendFormat:@"Domain: {\n    %@\n}\n", error.domain];
    }
    if (isObjectNotEmpty(error.description)) { // error.description
      [logString appendFormat:@"Description: {\n    %@\n}\n", error.description];
    }
    if ([[error userInfo] valueForKey:NSUnderlyingErrorKey]) { // NSUnderlyingErrorKey
      [logString appendFormat:@"Underlying Error Key: {\n    %@\n}\n", [[error userInfo] valueForKey:NSUnderlyingErrorKey]];
    }
    if ([[error userInfo] valueForKey:NSLocalizedDescriptionKey]) { // NSLocalizedDescriptionKey
      [logString appendFormat:@"Localized Description: {\n    %@\n}\n", [[error userInfo] valueForKey:NSLocalizedDescriptionKey]];
      [[[UIAlertView alloc] initWithTitle:@"API Error:" message:[[error userInfo] valueForKey:NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    if ([[error userInfo] valueForKey:NSLocalizedFailureReasonErrorKey]) { // NSLocalizedFailureReasonErrorKey
      [logString appendFormat:@"Localized Failure ReasonError Key: {\n    %@\n}\n", [[error userInfo] valueForKey:NSLocalizedFailureReasonErrorKey]];
    }
    
    switch (error.code) {
      case NSURLErrorUnknown: {
        [logString appendFormat:@"NSURLErrorUnknown: {\n    Error code: %li\n}\n", (long)error.code];
        break;
      }
      case NSURLErrorCancelled: {
        [logString appendFormat:@"NSURLErrorCancelled: {\n    Error code: %li\n}\n", (long)error.code];
        break;
      }
      case NSURLErrorBadURL: {
        [logString appendFormat:@"NSURLErrorBadURL: {\n    Error code: %li\n}\n", (long)error.code];
        break;
      }
      case NSURLErrorTimedOut: {
        [logString appendFormat:@"NSURLErrorTimedOut: {\n    Error code: %li\n}\n", (long)error.code];
        break;
      }
      case NSURLErrorUnsupportedURL: {
        [logString appendFormat:@"NSURLErrorUnsupportedURL: {\n    Error code: %li\n}\n", (long)error.code];
        break;
      }
      case NSURLErrorCannotFindHost: {
        [logString appendFormat:@"NSURLErrorCannotFindHost: {\n    Error code: %li\n}\n", (long)error.code];
        break;
      }
      case NSURLErrorCannotConnectToHost: {
        [logString appendFormat:@"NSURLErrorCannotConnectToHost: {\n    Error code: %li\n}\n", (long)error.code];
        break;
      }
      case NSURLErrorDataLengthExceedsMaximum: {
        [logString appendFormat:@"NSURLErrorDataLengthExceedsMaximum: {\n    Error code: %li\n}\n", (long)error.code];
        break;
      }
      case NSURLErrorNetworkConnectionLost: {
        [logString appendFormat:@"NSURLErrorNetworkConnectionLost: {\n    Error code: %li\n}\n", (long)error.code];
        break;
      }
      case NSURLErrorDNSLookupFailed: {
        [logString appendFormat:@"NSURLErrorDNSLookupFailed: {\n    Error code: %li\n}\n", (long)error.code];
        break;
      }
      case NSURLErrorHTTPTooManyRedirects: {
        [logString appendFormat:@"NSURLErrorHTTPTooManyRedirects: {\n    Error code: %li\n}\n", (long)error.code];
        break;
      }
      case NSURLErrorResourceUnavailable: {
        [logString appendFormat:@"NSURLErrorResourceUnavailable: {\n    Error code: %li\n}\n", (long)error.code];
        break;
      }
      case NSURLErrorNotConnectedToInternet: {
        [logString appendFormat:@"NSURLErrorNotConnectedToInternet: {\n    Error code: %li\n}\n", (long)error.code];
        break;
      }
      case NSURLErrorRedirectToNonExistentLocation: {
        [logString appendFormat:@"NSURLErrorRedirectToNonExistentLocation: {\n    Error code: %li\n}\n", (long)error.code];
        break;
      }
      case NSURLErrorBadServerResponse: {
        [logString appendFormat:@"NSURLErrorBadServerResponse: {\n    Error code: %li\n}\n", (long)error.code];
        break;
      }
      case NSURLErrorUserCancelledAuthentication: {
        [logString appendFormat:@"NSURLErrorUserCancelledAuthentication: {\n    Error code: %li\n}\n", (long)error.code];
        break;
      }
      case NSURLErrorUserAuthenticationRequired: {
        [logString appendFormat:@"NSURLErrorUserAuthenticationRequired: {\n    Error code: %li\n}\n", (long)error.code];
        break;
      }
      case NSURLErrorZeroByteResource: {
        [logString appendFormat:@"NSURLErrorZeroByteResource: {\n    Error code: %li\n}\n", (long)error.code];
        break;
      }
      case NSURLErrorCannotDecodeRawData: {
        [logString appendFormat:@"NSURLErrorCannotDecodeRawData: {\n    Error code: %li\n}\n", (long)error.code];
        break;
      }
      case NSURLErrorCannotDecodeContentData: {
        [logString appendFormat:@"NSURLErrorCannotDecodeContentData: {\n    Error code: %li\n}\n", (long)error.code];
        break;
      }
      case NSURLErrorCannotParseResponse: {
        [logString appendFormat:@"NSURLErrorCannotParseResponse: {\n    Error code: %li\n}\n", (long)error.code];
        break;
      }
      case NSURLErrorInternationalRoamingOff: {
        [logString appendFormat:@"NSURLErrorInternationalRoamingOff: {\n    Error code: %li\n}\n", (long)error.code];
        break;
      }
      case NSURLErrorCallIsActive: {
        [logString appendFormat:@"NSURLErrorCallIsActive: {\n    Error code: %li\n}\n", (long)error.code];
        break;
      }
      case NSURLErrorDataNotAllowed: {
        [logString appendFormat:@"NSURLErrorDataNotAllowed: {\n    Error code: %li\n}\n", (long)error.code];
        break;
      }
      case NSURLErrorRequestBodyStreamExhausted: {
        [logString appendFormat:@"NSURLErrorRequestBodyStreamExhausted: {\n    Error code: %li\n}\n", (long)error.code];
        break;
      }
      default: {
        [logString appendFormat:@"Default: {\n    Error code: %li\n}\n", (long)error.code];
        break;
      }
    }
    //    if ([[error userInfo] valueForKey:kResponseDataStringKey]) {
    //      [logString appendFormat:@"Response Data String:\n{\n    %@\n}\n", [[error userInfo] valueForKey:kResponseDataStringKey]];
    //    }
  }
  if (isObjectNotEmpty(responseObject)) {
    [logString appendFormat:@"Response: %@\n", responseObject];
  } else {
    [logString appendFormat:@"Response: {\n    NULL\n}\n"];
  }
  DCLog(@"\n####################################################################################################################\n"
        "%@"
        "####################################################################################################################\n",
        logString);
#endif
}

@end
