//
//  DCSideMenuViewController.m
//  DCClass
//
//  Created by Дмитрий Утьманов on 26/02/15.
//  Copyright (c) 2015 cooler. All rights reserved.
//


#import "DCSideMenuViewController.h"

#import "DCColor.h"

typedef NS_ENUM(NSUInteger, DCMenuState) {
  DCMenuStateOpened,
  DCMenuStateClosed,
  DCMenuStateUnknown
};


@interface DCSideMenuViewController () <UIGestureRecognizerDelegate>

@property(nonatomic) UIViewController *menuViewController;
@property(nonatomic) UIView *menuViewControllerView;

@property(nonatomic) UIViewController *contentViewController;
@property(nonatomic) UIView *contentViewControllerView;

@property(nonatomic) UIView *snapshotView;
@property(nonatomic) BOOL isStatusBarHidden;

@property(nonatomic) UIPanGestureRecognizer *menuPanGestureRecognizer;
@property(nonatomic) CGPoint startPoint;

@property(nonatomic) DCMenuState menuState;

@end


@implementation DCSideMenuViewController

- (instancetype)initWithMenuVC:(UIViewController *)menuVC contentVC:(UIViewController *)contentVC {
  self = [super init];
  if (self != nil) {
    self.menuViewController = menuVC;
    [self addChildViewController:self.menuViewController];
    self.menuViewControllerView = self.menuViewController.view;
    
    self.contentViewController = contentVC;
    [self addChildViewController:self.contentViewController ];
    self.contentViewControllerView = self.contentViewController.view;
    
    self.menuWidthInPercent = 0.5f;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
//  self.menuView = [[UIView alloc] initWithFrame:CGRectZero];
//  self.menuView.backgroundColor = [DCColor whiteColor];
//  [self.view addSubview:self.menuView];
  [self.view addSubview:self.menuViewControllerView];
  
//  self.contentView = [[UIView alloc] initWithFrame:CGRectZero];
//  self.contentView.backgroundColor = [DCColor whiteColor];
//  [self.view addSubview:self.contentView];
  [self.view addSubview:self.contentViewControllerView];
  
  self.menuPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
  self.menuPanGestureRecognizer.delegate = self;
  [self.view addGestureRecognizer:self.menuPanGestureRecognizer];
  
  [self resetView];
}

- (void)resetView {
  [self setNeedsStatusBarAppearanceUpdate];
  self.menuState = DCMenuStateClosed;
}

- (void)configureView {
//  self.menuView.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.rect), CGRectGetHeight(self.rect));
  self.menuViewControllerView.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.rect), CGRectGetHeight(self.rect));
  
  if (self.menuState == DCMenuStateOpened) {
    self.contentViewControllerView.frame = CGRectMake(CGRectGetWidth(self.rect) * self.menuWidthInPercent, 0.0f, CGRectGetWidth(self.rect), CGRectGetHeight(self.rect));
  } else {
    self.contentViewControllerView.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.rect), CGRectGetHeight(self.rect));
  }
}

- (void)cleanView {
  // Empty
}

- (BOOL)prefersStatusBarHidden {
  return self.isStatusBarHidden;
}

#pragma mark - Public Methods

//

#pragma mark - Private Methods

- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer {
  switch(recognizer.state) {
    case UIGestureRecognizerStateBegan: {
      self.startPoint = self.contentViewControllerView.frame.origin;
      if (self.menuState == DCMenuStateClosed) {
        self.snapshotView = [self getSnapshotView];
        if (self.snapshotView != nil) {
          [self.contentViewControllerView addSubview:self.snapshotView];
          self.isStatusBarHidden = YES;
          [self setNeedsStatusBarAppearanceUpdate];
        }
      }
      break;
    }
    case UIGestureRecognizerStateChanged: {
      self.menuState = DCMenuStateUnknown;
      
      CGPoint translationPoint = [recognizer translationInView:self.view];
      CGPoint endPoint = CGPointMake(self.startPoint.x + translationPoint.x, self.startPoint.y);
      if (endPoint.x < 0.0) {
        endPoint.x = 0.0;
      }
      if (endPoint.x > CGRectGetWidth(self.rect) * self.menuWidthInPercent) {
        endPoint.x = CGRectGetWidth(self.rect) * self.menuWidthInPercent;
      }
      CGRect contentViewControllerViewFrame = self.contentViewControllerView.frame;
      contentViewControllerViewFrame.origin = endPoint;
      self.contentViewControllerView.frame = contentViewControllerViewFrame;
      break;
    }
    case UIGestureRecognizerStateEnded: {
      CGPoint translationPoint = [recognizer translationInView:self.view];
      CGPoint velocityPoint = [recognizer velocityInView:self.view];
      CGPoint endPoint = CGPointMake(self.startPoint.x + translationPoint.x + velocityPoint.x, self.startPoint.y);
      
      if (endPoint.x < CGRectGetWidth(self.rect) * self.menuWidthInPercent) {
        CGFloat ratio = CGRectGetWidth(self.rect) * self.menuWidthInPercent / (self.contentViewControllerView.frame.origin.x - velocityPoint.x);
        if (ratio > 1.0) {
          ratio = 1.0;
        }
        CGFloat animationDuration = self.menuWidthInPercent * ratio;
        [self closeMenu:animationDuration];
      }
      if (endPoint.x >= CGRectGetWidth(self.rect) * self.menuWidthInPercent) {
        CGFloat ratio = CGRectGetWidth(self.rect) * self.menuWidthInPercent / (self.contentViewControllerView.frame.origin.x + velocityPoint.x);
        if (ratio > 1.0) {
          ratio = 1.0;
        }
        CGFloat animationDuration = self.menuWidthInPercent * ratio;
        [self openMenu:animationDuration];
      }
      break;
    }
    default:
      break;
  }
}

- (void)openMenu:(NSTimeInterval)animationDuration {
  if (self.menuState == DCMenuStateClosed || self.menuState == DCMenuStateUnknown) {
    self.menuPanGestureRecognizer.enabled = NO;
    [UIView animateWithDuration:animationDuration animations:^{
      CGRect contentViewControllerViewFrame = self.contentViewControllerView.frame;
      contentViewControllerViewFrame.origin = CGPointMake(CGRectGetWidth(self.rect) * self.menuWidthInPercent, self.startPoint.y);
      self.contentViewControllerView.frame = contentViewControllerViewFrame;
    } completion:^(BOOL finished) {
      self.menuPanGestureRecognizer.enabled = YES;
      self.menuState = DCMenuStateOpened;
    }];
  }
}

- (void)closeMenu:(NSTimeInterval)animationDuration {
  if (self.menuState == DCMenuStateOpened || self.menuState == DCMenuStateUnknown) {
    self.menuPanGestureRecognizer.enabled = NO;
    [UIView animateWithDuration:animationDuration animations:^{
      CGRect contentViewControllerViewFrame = self.contentViewControllerView.frame;
      contentViewControllerViewFrame.origin = CGPointMake(0.0, self.startPoint.y);
      self.contentViewControllerView.frame = contentViewControllerViewFrame;
    } completion:^(BOOL finished) {
      self.isStatusBarHidden = NO;
      [self setNeedsStatusBarAppearanceUpdate];
      [UIView animateWithDuration:0.2 animations:^{
        self.snapshotView.alpha = 0.0;
      } completion:^(BOOL finished) {
        [self.snapshotView removeFromSuperview];
        self.menuPanGestureRecognizer.enabled = YES;
        self.menuState = DCMenuStateClosed;
      }];
    }];
  }
}

- (UIView *)getSnapshotView {
  UIScreen *screen = UIScreen.mainScreen;
  UIView *snapView = [screen snapshotViewAfterScreenUpdates:NO];
  return snapView;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)panGestureRecognizer {
  CGPoint velocityPoint = [panGestureRecognizer velocityInView:self.view];
  return abs(velocityPoint.y / 2.0f) < abs(velocityPoint.x );
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
  if ([gestureRecognizer isEqual:self.menuPanGestureRecognizer]) {
    return NO;
  }
//  if ([otherGestureRecognizer isEqual:self.menuPanGestureRecognizer]) {
//    return NO;
//  }
  return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
  if ([gestureRecognizer isEqual:self.menuPanGestureRecognizer]) {
    return YES;
  }
//  if ([otherGestureRecognizer isEqual:self.menuPanGestureRecognizer]) {
//    return YES;
//  }
  return NO;
}

@end
