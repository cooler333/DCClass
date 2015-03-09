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


@interface APIManagerExampleViewController ()

@property(nonatomic) UIButton *getImageButton;
@property(nonatomic) UIImageView *imageView;

@property(nonatomic) UIActivityIndicatorView *activityIndicatorView;

@end


@implementation APIManagerExampleViewController

- (void)viewDidLoad {
  [DCAPIManager setSharedManagerWithBaseURL:[NSURL URLWithString:@"https://api.github.com/"]];

  [super viewDidLoad];
  // Do any additional setup after loading the view.

  self.getImageButton = [[UIButton alloc] initWithFrame:CGRectZero];
  [self.getImageButton setTitle:@"GET" forState:UIControlStateNormal];
  [self.getImageButton addTarget:self action:@selector(getImage:) forControlEvents:UIControlEventTouchUpInside];
  self.getImageButton.backgroundColor = [DCColor grayColor];
  [self.view addSubview:self.getImageButton];
  
  self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
  self.imageView.backgroundColor = [DCColor testColor];
  [self.view addSubview:self.imageView];
  
  self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
}

#pragma mark - Private Methods

- (void)getImage:(UIButton *)sender {
  self.activityIndicatorView.center = self.imageView.center;
  [self.view addSubview:self.activityIndicatorView];
  [self.activityIndicatorView startAnimating];
  
  [[DCAPIManager sharedManager] GET:@"users/cooler333" parameters:nil success:^(NSURLSessionDataTask *task, NSArray *responseArray) {
    
    NSDictionary *dataDictionary = responseArray[0];
    NSString *avatarURLString = [dataDictionary valueForKey:@"avatar_url"];
    [self.imageView setImageWithURL:[NSURL URLWithString:avatarURLString]];
    
    [self.activityIndicatorView removeFromSuperview];
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    [self.activityIndicatorView removeFromSuperview];
  }];
}

#pragma mark - DCViewControllerProtocol

- (void)configureView {
  self.imageView.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.rect), CGRectGetHeight(self.rect) / 2.0f);
  
  self.getImageButton.frame = CGRectMake(0.0f, CGRectGetHeight(self.rect) / 2.0f, CGRectGetWidth(self.rect), CGRectGetHeight(self.rect) / 2.0f);
}

- (void)cleanView {
  
}

@end
