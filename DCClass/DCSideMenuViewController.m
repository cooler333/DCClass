//
//  DCSideMenuViewController.m
//  DCClass
//
//  Created by Дмитрий Утьманов on 26/02/15.
//  Copyright (c) 2015 cooler. All rights reserved.
//


#import "DCSideMenuViewController.h"

#import "DCBundleHelper.h"


@interface DCSideMenuViewController () <UIGestureRecognizerDelegate>

@property(nonatomic) UIViewController *menuViewController;
@property(nonatomic) UIView *menuView;

@property(nonatomic) UIViewController *contentViewController;
@property(nonatomic) UIView *contentView;
@property(nonatomic) UIView *contentControllerView;

@property(nonatomic) UIView *tapView;

@property(nonatomic) NSIndexPath *selectedMenuItemIndexPath;

@property(nonatomic) UIView *snapshotView;
@property(nonatomic) BOOL statusBarHidden;
@property(nonatomic) BOOL customStatusBarState;
@property(nonatomic) CGSize statusBarSize;

@property(nonatomic) UIPanGestureRecognizer *menuPanGestureRecognizer;
@property(nonatomic) UITapGestureRecognizer *menuTapGestureRecognizer;

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
    _contentControllerView = [[UIView alloc] initWithFrame:CGRectZero];
    _tapView = [[UIView alloc] initWithFrame:CGRectZero];
    _menuWidthInPercent = 0.5f;
    _menuTopOffsetInPercent = 0.05f;
    
    _contentView.backgroundColor = [UIColor cyanColor];
    _contentControllerView.backgroundColor = [UIColor redColor];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.clipsToBounds = YES;
  
  [self.view addSubview:self.menuView];
  //  self.menuView.clipsToBounds = YES;
  
  [self.view addSubview:self.contentView];
  //  self.contentView.clipsToBounds = YES;
  [self.contentView addSubview:self.contentControllerView];
  //  self.contentControllerView.clipsToBounds = YES;
  
  self.menuPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
  self.menuPanGestureRecognizer.delegate = self;
  [self.view addGestureRecognizer:self.menuPanGestureRecognizer];
  
  self.menuTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
  [self.tapView addGestureRecognizer:self.menuTapGestureRecognizer];
  
  [self configureView];

  CGFloat menuWidth = CGRectGetWidth(self.rect) * self.menuWidthInPercent;
  self.menuViewController.view.frame = CGRectMake(0.0f, 0.0f, menuWidth, CGRectGetHeight(self.rect));
  [self.menuView addSubview:self.menuViewController.view];
}

- (void)configureView {
  self.menuPanGestureRecognizer.enabled = NO;
  self.menuState = DCMenuStateClosed;
  
  CGFloat menuWidth = CGRectGetWidth(self.rect) * self.menuWidthInPercent;
  self.menuView.frame = CGRectMake(-menuWidth * 0.5f, 0.0f, menuWidth, CGRectGetHeight(self.rect));
  
  self.contentView.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.rect), CGRectGetHeight(self.rect));
  self.contentControllerView.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.rect), CGRectGetHeight(self.rect));
  self.tapView.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.rect), CGRectGetHeight(self.rect));
  
//  self.customStatusBarState = NO;
//  self.statusBarHidden = NO;
//  [self setNeedsStatusBarAppearanceUpdate];
  
//  if (self.snapshotView != nil) {
//    [self.snapshotView removeFromSuperview];
//    self.snapshotView = nil;
//  }
  
//  [self.tapView removeFromSuperview];
  self.menuPanGestureRecognizer.enabled = YES;
}

- (void)cleanView {
  // ...
}

- (void)setStatusBarHidden:(BOOL)statusBarHidden {
  if (_statusBarHidden != statusBarHidden) {
    _statusBarHidden = statusBarHidden;
  }
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
  return UIStatusBarAnimationNone;
}

- (NSUInteger)supportedInterfaceOrientations {
  return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
  return UIInterfaceOrientationPortrait;
}

- (BOOL)prefersStatusBarHidden {
  return self.statusBarHidden;
}

- (UIViewController *)childViewControllerForStatusBarHidden {
  if (self.customStatusBarState == YES) {
    return nil;
  }
  if (self.contentViewController != nil) {
    return self.contentViewController;
  }
  return nil;
}

- (UIViewController *)childViewControllerForStatusBarStyle {
  if (self.customStatusBarState == YES) {
    return nil;
  }
  if (self.contentViewController != nil) {
    return self.contentViewController;
  }
  return nil;
}

#pragma mark - Public Methods

- (void)selectMenuItemAtIndexPath:(NSIndexPath *)indexPath {
  if (self.selectedMenuItemIndexPath == nil || indexPath.row != self.selectedMenuItemIndexPath.row || indexPath.section != self.selectedMenuItemIndexPath.section) {
    NSIndexPath *oldSelectedMenuItemIndexPath = [self.selectedMenuItemIndexPath copy];
    [self _willDeselectMenuItemAtIndexPath:oldSelectedMenuItemIndexPath];
    
    self.selectedMenuItemIndexPath = indexPath;
    [self _willSelectMenuItemAtIndexPath:indexPath];
    
    UIViewController *vc = [self.dataSource viewControllerForMenuItemAtIndexPath:self.selectedMenuItemIndexPath];
    if (vc != nil) {
      [_contentViewController willMoveToParentViewController:nil];
      [_contentViewController.view removeFromSuperview];
      [_contentViewController removeFromParentViewController];
      _contentViewController = nil;
      
      [self _didDeselectMenuItemAtIndexPath:oldSelectedMenuItemIndexPath];
      
      if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nvc = (UINavigationController *)vc;
        UINavigationBar *navigationBar = nvc.navigationBar;

        UIImage *menuIconImage = [DCBundleHelper getImageNamed:@"menu_icon.png"];
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:menuIconImage style:UIBarButtonItemStylePlain target:self action:@selector(openMenuViewController:)];
        leftBarButtonItem.tintColor = navigationBar.tintColor;
        UIViewController *firstVC = nvc.viewControllers[0];
        firstVC.navigationItem.leftBarButtonItem = leftBarButtonItem;
      }
      
      _contentViewController = vc;
      [self addChildViewController:vc];
      [vc didMoveToParentViewController:self];

      vc.view.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.rect), CGRectGetHeight(self.rect));
      [self.contentControllerView addSubview:vc.view];
      
      [self _didSelectMenuItemAtIndexPath:indexPath];
    }
  }
  [self closeMenu:0.25f];
}

#pragma mark - Private Methods

- (void)openMenuViewController:(UIBarButtonItem *)barButtonItem {
  if (self.menuState == DCMenuStateClosed) {
    self.menuState = DCMenuStateUnknown;
      
    if ([UIApplication sharedApplication].statusBarHidden == NO) {
      [UIView setAnimationsEnabled:NO];
      
      self.statusBarSize = CGSizeMake(CGRectGetWidth(self.rect), [self statusBarHeight]);
      
      UIView *snapshotView = [self getSnapshotView];
      self.snapshotView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.statusBarSize.width, self.statusBarSize.height)];
      self.snapshotView.clipsToBounds = YES;
      [self.snapshotView addSubview:snapshotView];
      [self.contentView addSubview:self.snapshotView];
      
      self.customStatusBarState = YES;
      self.statusBarHidden = YES;
      [self setNeedsStatusBarAppearanceUpdate];
      
      CGRect contentControllerViewFrame = self.contentControllerView.frame;
      contentControllerViewFrame.origin.y += self.statusBarSize.height;
      self.contentControllerView.frame = contentControllerViewFrame;
      
      CGRect contentViewControllerFrame = self.contentViewController.view.frame;
      contentViewControllerFrame.size.height -= self.statusBarSize.height;
      self.contentViewController.view.frame = contentViewControllerFrame;
      
      [UIView setAnimationsEnabled:YES];
    }
    
    [self openMenu:0.25f];
  } else if (self.menuState == DCMenuStateOpened) {
    [self closeMenu:0.25f];
  }
}

- (void)handleTapGesture:(UITapGestureRecognizer *)recognizer {
  if (self.menuState == DCMenuStateOpened) {
    [self closeMenu:0.25f];
  }
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer {
  switch(recognizer.state) {
    case UIGestureRecognizerStateBegan: {
      self.startPoint = self.contentView.center;
      
      if (self.menuState == DCMenuStateClosed) {
        self.menuState = DCMenuStateUnknown;
        
        if ([UIApplication sharedApplication].statusBarHidden == NO) {
          [UIView setAnimationsEnabled:NO];

          self.statusBarSize = CGSizeMake(CGRectGetWidth(self.rect), [self statusBarHeight]);
          
          UIView *snapshotView = [self getSnapshotView];
          self.snapshotView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.statusBarSize.width, self.statusBarSize.height)];
          self.snapshotView.clipsToBounds = YES;
          [self.snapshotView addSubview:snapshotView];
          [self.contentView addSubview:self.snapshotView];
          
          self.customStatusBarState = YES;
          self.statusBarHidden = YES;
          [self setNeedsStatusBarAppearanceUpdate];
          
          CGRect contentControllerViewFrame = self.contentControllerView.frame;
          contentControllerViewFrame.origin.y += self.statusBarSize.height;
          self.contentControllerView.frame = contentControllerViewFrame;
          
          CGRect contentViewControllerFrame = self.contentViewController.view.frame;
          contentViewControllerFrame.size.height -= self.statusBarSize.height;
          self.contentViewController.view.frame = contentViewControllerFrame;
          
          [UIView setAnimationsEnabled:YES];
        }
      }
      break;
    }
    case UIGestureRecognizerStateChanged: {
      CGPoint translationPoint = [recognizer translationInView:self.view];
      CGPoint endPoint = CGPointMake(self.startPoint.x + translationPoint.x, self.startPoint.y);

      if (endPoint.x < (CGRectGetWidth(self.rect) / 2.0f)) {
        endPoint.x = (CGRectGetWidth(self.rect) / 2.0f);
      }
      if (endPoint.x > (CGRectGetWidth(self.rect) /  2.0f) + (CGRectGetWidth(self.rect) * self.menuWidthInPercent)) {
        endPoint.x = (CGRectGetWidth(self.rect) /  2.0f) + (CGRectGetWidth(self.rect) * self.menuWidthInPercent);
      }
      
      CGFloat menuViewRatio = (endPoint.x - (CGRectGetWidth(self.rect) / 2.0f)) / (CGRectGetWidth(self.rect) * self.menuWidthInPercent);
      self.contentView.center = CGPointMake(endPoint.x, CGRectGetHeight(self.rect) / 2.0f + CGRectGetHeight(self.rect) * self.menuTopOffsetInPercent * menuViewRatio);
      menuViewRatio = (1.0f - menuViewRatio) / 2.0f;
      
      CGRect menuViewFrame = self.menuView.frame;
      menuViewFrame.origin = CGPointMake(-CGRectGetWidth(self.rect) * self.menuWidthInPercent * menuViewRatio, 0.0f);
      self.menuView.frame = menuViewFrame;
      break;
    }
    case UIGestureRecognizerStateEnded: {
      CGPoint translationPoint = [recognizer translationInView:self.view];
      CGPoint velocityPoint = [recognizer velocityInView:self.view];
      CGPoint endPoint = CGPointMake(self.startPoint.x + translationPoint.x + velocityPoint.x, self.startPoint.y);
      endPoint.x -= CGRectGetWidth(self.rect) * self.menuWidthInPercent;
      
      if (endPoint.x < 0) {
        CGFloat animationDuration;
        CGFloat value = -endPoint.x;
        CGFloat menuWidth = CGRectGetWidth(self.rect) * self.menuWidthInPercent + CGRectGetWidth(self.rect);
        if (value > menuWidth) {
          animationDuration = 0.05f;
        } else {
          animationDuration = 0.5f * (1.0f - value / menuWidth);
        }
        NSLog(@"CLOSE: %f", animationDuration);
        [self closeMenu:animationDuration];
      } else {
        CGFloat animationDuration;
        CGFloat value = endPoint.x;
        CGFloat menuWidth = CGRectGetWidth(self.rect) * self.menuWidthInPercent + CGRectGetWidth(self.rect);
        NSLog(@"value: %f", value);
        if (value > menuWidth) {
          animationDuration = 0.05f;
        } else {
          animationDuration = 0.5f * (1.0f - value / menuWidth);
        }
        NSLog(@"OPEN: %f", animationDuration);
        [self openMenu:animationDuration];
      }
      break;
    }
    default: {
      break;
    }
  }
}

- (void)openMenu:(NSTimeInterval)animationDuration {
  self.menuPanGestureRecognizer.enabled = NO;
  self.menuState = DCMenuStateUnknown;
  
  [self.contentView addSubview:self.tapView];
//    CGFloat velocity = animationDuration * CGRectGetWidth(self.rect) * self.menuWidthInPercent;
  [UIView animateWithDuration:animationDuration delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
//  [UIView animateWithDuration:animationDuration delay:0.0f usingSpringWithDamping:0.4f initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
    self.contentView.center = CGPointMake((CGRectGetWidth(self.rect) / 2.0f) + (CGRectGetWidth(self.rect) * self.menuWidthInPercent), CGRectGetHeight(self.rect) / 2.0f + CGRectGetHeight(self.rect) * self.menuTopOffsetInPercent);
    
    CGRect menuViewFrame = self.menuView.frame;
    menuViewFrame.origin = CGPointMake(0.0f, 0.0f);
    self.menuView.frame = menuViewFrame;
    
  } completion:^(BOOL finished) {
    self.menuState = DCMenuStateOpened;
    self.menuPanGestureRecognizer.enabled = YES;
  }];
}

- (void)closeMenu:(NSTimeInterval)animationDuration {
  self.menuPanGestureRecognizer.enabled = NO;
  self.menuState = DCMenuStateUnknown;
  
  [UIView animateWithDuration:animationDuration delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
    self.contentView.center = CGPointMake(CGRectGetWidth(self.rect) /  2.0f, CGRectGetHeight(self.rect) / 2.0f);
    
    CGRect menuViewFrame = self.menuView.frame;
    CGFloat menuWidth = CGRectGetWidth(self.rect) * self.menuWidthInPercent;
    menuViewFrame.origin = CGPointMake(-menuWidth * 0.5f, 0.0f);
    self.menuView.frame = menuViewFrame;
  } completion:^(BOOL finished) {
    [UIView setAnimationsEnabled:NO];

    self.contentControllerView.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.rect), CGRectGetHeight(self.rect));
    CGRect contentViewControllerFrame = self.contentViewController.view.frame;
    contentViewControllerFrame.size.height += self.statusBarSize.height;
    self.contentViewController.view.frame = contentViewControllerFrame;
    
    self.customStatusBarState = NO;
    self.statusBarHidden = NO;
    [self setNeedsStatusBarAppearanceUpdate];
    
    [UIView setAnimationsEnabled:YES];

    [UIView animateWithDuration:0.05f animations:^{
      self.snapshotView.alpha = 0.0;
    } completion:^(BOOL finished) {
      [self.snapshotView removeFromSuperview];
      self.snapshotView = nil;
      
      [self.tapView removeFromSuperview];
      
      self.menuState = DCMenuStateClosed;
      self.menuPanGestureRecognizer.enabled = YES;
    }];
  }];
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

#pragma mark - DCSideMenuViewControllerDelegate

- (void)_willDeselectMenuItemAtIndexPath:(NSIndexPath *)indexPath {
  if ([self.delegate respondsToSelector:@selector(willDeselectMenuItemAtIndexPath:)]) {
    [self.delegate willDeselectMenuItemAtIndexPath:indexPath];
  }
}

- (void)_didDeselectMenuItemAtIndexPath:(NSIndexPath *)indexPath {
  if ([self.delegate respondsToSelector:@selector(didDeselectMenuItemAtIndexPath:)]) {
    [self.delegate didDeselectMenuItemAtIndexPath:indexPath];
  }
}

- (void)_willSelectMenuItemAtIndexPath:(NSIndexPath *)indexPath {
  if ([self.delegate respondsToSelector:@selector(willSelectMenuItemAtIndexPath:)]) {
    [self.delegate willSelectMenuItemAtIndexPath:indexPath];
  }
}

- (void)_didSelectMenuItemAtIndexPath:(NSIndexPath *)indexPath {
  if ([self.delegate respondsToSelector:@selector(didSelectMenuItemAtIndexPath:)]) {
    [self.delegate didSelectMenuItemAtIndexPath:indexPath];
  }
}

@end
