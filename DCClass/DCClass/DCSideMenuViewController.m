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
@property(nonatomic) UIView *menuView;

@property(nonatomic) UIViewController *contentViewController;
@property(nonatomic) UIView *contentView;

@property(nonatomic) NSIndexPath *selectedMenuItemIndexPath;

@property(nonatomic) UIView *snapshotView;
@property(nonatomic) BOOL statusBarHidden;
@property(nonatomic) CGSize statusBarSize;

@property(nonatomic) UIPanGestureRecognizer *menuPanGestureRecognizer;
@property(nonatomic) CGPoint startPoint;

@property(nonatomic) DCMenuState menuState;

@end


@implementation DCSideMenuViewController

- (instancetype)initWithMenuVC:(UIViewController *)menuVC {
  self = [super init];
  if (self != nil) {
    [self addChildViewController:menuVC];
    [menuVC didMoveToParentViewController:self];
    _menuViewController = menuVC;

    _menuView = [[UIView alloc] initWithFrame:CGRectZero];
    _contentView = [[UIView alloc] initWithFrame:CGRectZero];
    
    _menuWidthInPercent = 0.5f;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.clipsToBounds = YES;
  
  [self.view addSubview:self.menuView];
  [self.menuView addSubview:self.menuViewController.view];
  
  [self.view addSubview:self.contentView];
  
  self.menuPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
  self.menuPanGestureRecognizer.delegate = self;
  [self.view addGestureRecognizer:self.menuPanGestureRecognizer];
  
  [self configureView];
}

- (void)configureView {
  NSLog(@"configureView");
  
  self.menuState = DCMenuStateUnknown;
  self.menuPanGestureRecognizer.enabled = NO;
  
  self.statusBarHidden = NO;
  [self setNeedsStatusBarAppearanceUpdate];
  
  [self.snapshotView removeFromSuperview];
  self.snapshotView = nil;
  
  // ...
  self.menuView.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.rect), CGRectGetHeight(self.rect));
  self.menuViewController.view.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.rect), CGRectGetHeight(self.rect));
  
  self.contentView.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.rect), CGRectGetHeight(self.rect));
  self.contentViewController.view.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.rect), CGRectGetHeight(self.rect));
  // ...
  
  self.menuState = DCMenuStateClosed;
  self.menuPanGestureRecognizer.enabled = YES;
}

- (void)cleanView {
  // Empty
}

- (BOOL)prefersStatusBarHidden {
  return self.statusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
  return UIStatusBarAnimationNone;
}

#pragma mark - Public Methods

- (void)selectMenuItemAtIndexPath:(NSIndexPath *)indexPath {
  if (self.selectedMenuItemIndexPath == nil || indexPath.row != self.selectedMenuItemIndexPath.row || indexPath.section != self.selectedMenuItemIndexPath.section) {
    self.selectedMenuItemIndexPath = indexPath;
    
    UIViewController *vc = [self.dataSource viewControllerForMenuItemAtIndexPath:self.selectedMenuItemIndexPath];
    if (vc != nil) {
      [_contentViewController willMoveToParentViewController:nil];
      [_contentViewController removeFromParentViewController];
      [_contentViewController.view removeFromSuperview];
      
      [self addChildViewController:vc];
      [vc didMoveToParentViewController:self];
      
      CGRect contentViewFrame = self.contentView.bounds;
      NSLog(@"vc.view: %@", NSStringFromCGRect(contentViewFrame));
      contentViewFrame.origin.y += self.statusBarSize.height;
      contentViewFrame.size.height -= self.statusBarSize.height;
      vc.view.frame = contentViewFrame;
      NSLog(@"vc.view: %@", NSStringFromCGRect(contentViewFrame));

      [self.contentView addSubview:vc.view];
      
      _contentViewController = vc;
    }
  }
  [self closeMenu:0.25f];
}

#pragma mark - Private Methods

- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer {
  switch(recognizer.state) {
    case UIGestureRecognizerStateBegan: {
      self.startPoint = self.contentView.frame.origin;
      
      if (self.menuState == DCMenuStateClosed) {
        self.statusBarSize = CGSizeMake(CGRectGetWidth(self.rect), [self statusBarHeight]);

        UIView *snapshotView = [self getSnapshotView];
        self.snapshotView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.statusBarSize.width, self.statusBarSize.height)];
        self.snapshotView.clipsToBounds = YES;
        [self.snapshotView addSubview:snapshotView];
        [self.contentView addSubview:self.snapshotView];
        
        CGRect contentViewControllerViewFrame = self.contentView.bounds;
        contentViewControllerViewFrame.origin.y += self.statusBarSize.height;
        contentViewControllerViewFrame.size.height -= self.statusBarSize.height;
        self.contentViewController.view.frame = contentViewControllerViewFrame;
        
        self.statusBarHidden = YES;
        [self setNeedsStatusBarAppearanceUpdate];
        
//        self.snapshotView.frame = CGRectMake(0.0f, 0.0f, self.statusBarSize.width, self.statusBarSize.height);
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
      CGRect contentViewFrame = self.contentView.frame;
      contentViewFrame.origin = endPoint;
      self.contentView.frame = contentViewFrame;
      
      CGFloat menuViewRatio = endPoint.x / (CGRectGetWidth(self.rect) * self.menuWidthInPercent);
      menuViewRatio = (1.0f - menuViewRatio) / 2.0f;
      
      CGRect menuViewFrame = self.menuView.frame;
      menuViewFrame.origin = CGPointMake(-CGRectGetWidth(self.rect) * self.menuWidthInPercent * menuViewRatio, self.startPoint.y);
      self.menuView.frame = menuViewFrame;
      break;
    }
    case UIGestureRecognizerStateEnded: {
      CGPoint translationPoint = [recognizer translationInView:self.view];
      CGPoint velocityPoint = [recognizer velocityInView:self.view];
      CGPoint endPoint = CGPointMake(self.startPoint.x + translationPoint.x + velocityPoint.x, self.startPoint.y);
      
      if (endPoint.x < CGRectGetWidth(self.rect) * self.menuWidthInPercent) {
        CGFloat ratio = CGRectGetWidth(self.rect) * self.menuWidthInPercent / (self.contentView.frame.origin.x - velocityPoint.x);
        if (ratio > 1.0) {
          ratio = 1.0;
        }
        CGFloat animationDuration = self.menuWidthInPercent * ratio;
        [self closeMenu:animationDuration];
      }
      if (endPoint.x >= CGRectGetWidth(self.rect) * self.menuWidthInPercent) {
        CGFloat ratio = CGRectGetWidth(self.rect) * self.menuWidthInPercent / (self.contentView.frame.origin.x + velocityPoint.x);
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
      CGRect contentViewFrame = self.contentView.frame;
      contentViewFrame.origin = CGPointMake(CGRectGetWidth(self.rect) * self.menuWidthInPercent, self.startPoint.y);
      self.contentView.frame = contentViewFrame;
      
      CGRect menuViewFrame = self.menuView.frame;
      menuViewFrame.origin = CGPointMake(0.0f, self.startPoint.y);
      self.menuView.frame = menuViewFrame;
    } completion:^(BOOL finished) {
      self.menuState = DCMenuStateOpened;
      self.menuPanGestureRecognizer.enabled = YES;
    }];
  }
}

- (void)closeMenu:(NSTimeInterval)animationDuration {
  if (self.menuState == DCMenuStateOpened || self.menuState == DCMenuStateUnknown) {
    self.menuPanGestureRecognizer.enabled = NO;
    [UIView animateWithDuration:animationDuration animations:^{
      CGRect contentViewFrame = self.contentView.frame;
      contentViewFrame.origin = CGPointMake(0.0f, self.startPoint.y);
      self.contentView.frame = contentViewFrame;
      
      CGRect menuViewFrame = self.menuView.frame;
      menuViewFrame.origin = CGPointMake(-CGRectGetWidth(self.rect) * self.menuWidthInPercent * 0.5f, self.startPoint.y);
      self.menuView.frame = menuViewFrame;
    } completion:^(BOOL finished) {
      self.contentViewController.view.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.rect), CGRectGetHeight(self.rect));
      
      self.statusBarHidden = NO;
      [self setNeedsStatusBarAppearanceUpdate];
      
      [UIView animateWithDuration:0.2 animations:^{
        self.snapshotView.alpha = 0.0;
      } completion:^(BOOL finished) {
        [self.snapshotView removeFromSuperview];
        self.snapshotView = nil;
        
        self.menuState = DCMenuStateClosed;
        self.menuPanGestureRecognizer.enabled = YES;
      }];
    }];
  }
}

- (UIView *)getSnapshotView {
  UIView *snapView = [UIScreen.mainScreen snapshotViewAfterScreenUpdates:NO];
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

#pragma mark - DCSideMenuViewControllerDataSource

// ...

#pragma mark - DCSideMenuViewControllerDelegate

- (void)willSelectMenuItemAtIndexPath:(NSIndexPath *)indexPath {
  if ([self.delegate respondsToSelector:@selector(willSelectMenuItemAtIndexPath:)]) {
    [self.delegate willSelectMenuItemAtIndexPath:indexPath];
  }
}

- (void)didSelectMenuItemAtIndexPath:(NSIndexPath *)indexPath {
  if ([self.delegate respondsToSelector:@selector(didSelectMenuItemAtIndexPath:)]) {
    [self.delegate didSelectMenuItemAtIndexPath:indexPath];
  }
}

@end
