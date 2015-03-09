//
//  APIManagerExampleViewController.m
//  DCClass iOS Example
//
//  Created by Dmitriy Utmanov on 09/03/15.
//  Copyright (c) 2015 Dmitriy Utmanov. All rights reserved.
//


#import "APIManagerExampleViewController.h"

#import "DCAPIManager.h"
#import "DCColor.h"
#import "UIImageView+AFNetworking.h"
#import "DCLog.h"


@interface APIManagerExampleViewController ()

@property(nonatomic) UIButton *getImageButton;
@property(nonatomic) UIImageView *imageView;

@property(nonatomic) UIButton *getJSONButton;
@property(nonatomic) UIButton *postJSONButton;
@property(nonatomic) UITextView *textView;

@property(nonatomic) UIActivityIndicatorView *activityIndicatorView;

@end


@implementation APIManagerExampleViewController

- (void)viewDidLoad {
  [DCAPIManager setSharedManagerWithBaseURL:[NSURL URLWithString:@"http://httpbin.org/"]];

  [super viewDidLoad];
  // Do any additional setup after loading the view.

  self.getImageButton = [[UIButton alloc] initWithFrame:CGRectZero];
  [self.getImageButton setTitle:@"GET IMAGE" forState:UIControlStateNormal];
  [self.getImageButton addTarget:self action:@selector(getImageRequest:) forControlEvents:UIControlEventTouchUpInside];
  self.getImageButton.backgroundColor = [DCColor grayColor];
  [self.view addSubview:self.getImageButton];
  
  self.getJSONButton = [[UIButton alloc] initWithFrame:CGRectZero];
  [self.getJSONButton setTitle:@"GET JSON" forState:UIControlStateNormal];
  [self.getJSONButton addTarget:self action:@selector(getRequest:) forControlEvents:UIControlEventTouchUpInside];
  self.getJSONButton.backgroundColor = [DCColor grayColor];
  [self.view addSubview:self.getJSONButton];
  
  self.postJSONButton = [[UIButton alloc] initWithFrame:CGRectZero];
  [self.postJSONButton setTitle:@"POST JSON" forState:UIControlStateNormal];
  [self.postJSONButton addTarget:self action:@selector(postRequest:) forControlEvents:UIControlEventTouchUpInside];
  self.postJSONButton.backgroundColor = [DCColor grayColor];
  [self.view addSubview:self.postJSONButton];
  
  self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
  self.imageView.backgroundColor = [DCColor testColor];
  [self.view addSubview:self.imageView];
  
  self.textView = [[UITextView alloc] initWithFrame:CGRectZero];
  self.textView.editable = NO;
  [self.view addSubview:self.textView];
  
  self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
}

#pragma mark - Private Methods

- (NSString *)stringFromJSONDataDictionary:(NSDictionary *)dataDictionary {
  NSError *error;
  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataDictionary
                                                     options:(NSJSONWritingOptions)NSJSONWritingPrettyPrinted
                                                       error:&error];
  NSString *JSONString;
  if (!jsonData) {
    DCLog(@"bv_jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
    JSONString = @"{}";
  } else {
    JSONString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
  }
  return JSONString;
}

- (void)getImageRequest:(UIButton *)sender {
  self.activityIndicatorView.center = self.imageView.center;
  [self.view addSubview:self.activityIndicatorView];
  [self.activityIndicatorView startAnimating];
  
  self.imageView.hidden = NO;
  self.textView.hidden = YES;
  
  NSURL *imageURL = [NSURL URLWithString:@"http://httpbin.org/image/png"];
  NSURLRequest *imageURLRequest = [NSURLRequest requestWithURL:imageURL];
  
  __weak typeof(self) weakSelf = self;
  [self.imageView setImageWithURLRequest:imageURLRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
    weakSelf.imageView.image = image;
    [weakSelf.activityIndicatorView removeFromSuperview];
  } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
    [weakSelf.activityIndicatorView removeFromSuperview];
  }];

}

- (void)getRequest:(UIButton *)sender {
  self.activityIndicatorView.center = self.imageView.center;
  [self.view addSubview:self.activityIndicatorView];
  [self.activityIndicatorView startAnimating];
  
  self.imageView.hidden = YES;
  self.textView.hidden = NO;
  
  // Full URL: http://httpbin.org/get or http://domain.com/somePage
  NSDictionary *params = @{@"Key": @"Value", @"Key 2": @"Value 2"};
  [[DCAPIManager sharedManager] GET:@"get" parameters:params success:^(NSURLSessionDataTask *task, NSArray *responseArray) {
    NSDictionary *dataDictionary = responseArray[0];
    self.textView.text = [self stringFromJSONDataDictionary:dataDictionary];
    
    [self.activityIndicatorView removeFromSuperview];
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    [self.activityIndicatorView removeFromSuperview];
  }];
}

- (void)postRequest:(UIButton *)sender {
  self.activityIndicatorView.center = self.imageView.center;
  [self.view addSubview:self.activityIndicatorView];
  [self.activityIndicatorView startAnimating];
  
  self.imageView.hidden = YES;
  self.textView.hidden = NO;
  
  // Full URL: http://httpbin.org/post or http://domain.com/somePage
  NSDictionary *params = @{@"Key": @"Value", @"Key 2": @"Value 2"};
  [[DCAPIManager sharedManager] POST:@"post" parameters:params success:^(NSURLSessionDataTask *task, NSArray *responseArray) {
    NSDictionary *dataDictionary = responseArray[0];
    self.textView.text = [self stringFromJSONDataDictionary:dataDictionary];
    
    [self.activityIndicatorView removeFromSuperview];
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    [self.activityIndicatorView removeFromSuperview];
  }];
}

#pragma mark - DCViewControllerProtocol

- (void)configureView {
  self.textView.hidden = YES;
  self.imageView.hidden = YES;
  
  self.imageView.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.rect), CGRectGetHeight(self.rect) / 2.0f);
  self.textView.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.rect), CGRectGetHeight(self.rect) / 2.0f);

  self.getImageButton.frame = CGRectMake(0.0f, CGRectGetHeight(self.rect) / 2.0f, CGRectGetWidth(self.rect), 44.0f);
  self.getJSONButton.frame = CGRectMake(0.0f, CGRectGetMaxY(self.getImageButton.frame) + 5.0f, CGRectGetWidth(self.rect), 44.0f);
  self.postJSONButton.frame = CGRectMake(0.0f, CGRectGetMaxY(self.getJSONButton.frame) + 5.0f, CGRectGetWidth(self.rect), 44.0f);
}

- (void)cleanView {
  
}

@end
