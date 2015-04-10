//
//  DCSideMenuViewController.m
//  DCClass
//
//  Created by Дмитрий Утьманов on 26/02/15.
//  Copyright (c) 2015 cooler. All rights reserved.
//


#import "DCSideMenuViewController.h"

#import "DCBundleHelper.h"
#import "DCStatusBarSize.h"


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
    _menuViewController = menuVC;
    _menuWidthInPercent = 0.5f;
    _menuTopOffsetInPercent = 0.05f;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.clipsToBounds = YES;
  
  self.menuView = [[UIView alloc] initWithFrame:CGRectMake(-CGRectGetWidth(self.view.frame) * self.menuWidthInPercent / 2.0f, 0.0f, CGRectGetWidth(self.view.frame) * self.menuWidthInPercent, CGRectGetHeight(self.view.frame))];
  self.menuView.backgroundColor = [UIColor redColor];
  self.menuView.clipsToBounds = YES;
  [self.view addSubview:self.menuView];
  
  self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
  [self.view addSubview:self.contentView];
  
  CALayer *frontViewLayer = self.contentView.layer;
  frontViewLayer.shadowColor = [[UIColor blackColor] CGColor];
  frontViewLayer.shadowOpacity = 0.6f;
  frontViewLayer.shadowOffset = CGSizeMake(0.0f, 2.5f);
  frontViewLayer.shadowRadius = 2.5f;
  
  self.statusBarSize = [DCStatusBarSize getSize];
  self.contentControllerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, self.statusBarSize.height, CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame) - self.statusBarSize.height)];
  self.contentControllerView.backgroundColor = [UIColor yellowColor];
  self.contentControllerView.clipsToBounds = YES;
  [self.contentView addSubview:self.contentControllerView];
  
  self.tapView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame))];
  
  [self addChildViewController:_menuViewController];
  _menuViewController.view.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.menuView.frame), CGRectGetHeight(self.menuView.frame));
  [self.menuView addSubview:self.menuViewController.view];
  [_menuViewController didMoveToParentViewController:self];
  
  self.menuPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
  self.menuPanGestureRecognizer.delegate = self;
  [self.view addGestureRecognizer:self.menuPanGestureRecognizer];
  
  self.menuTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
  [self.tapView addGestureRecognizer:self.menuTapGestureRecognizer];
  
  [self setStatusBarBackgroundColor:[UIColor grayColor]];
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

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  CGRect fixedFrame;
  if (IS_OS_7) {
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
      fixedFrame = CGRectMake(self.view.frame.origin.y, self.view.frame.origin.x, self.view.frame.size.height, self.view.frame.size.width);
    } else {
      fixedFrame = self.view.frame;
    }
  } else if (IS_OS_8_OR_LATER) {
    fixedFrame = self.view.frame;
  }
  
  self.contentView.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(fixedFrame), CGRectGetHeight(fixedFrame));
  self.menuView.frame = CGRectMake(-CGRectGetWidth(fixedFrame) * self.menuWidthInPercent / 2.0f, 0.0f, CGRectGetWidth(fixedFrame) * self.menuWidthInPercent, CGRectGetHeight(fixedFrame));
  
  CGPoint contentControllerViewCenter = self.contentControllerView.center;
  contentControllerViewCenter.y = self.contentControllerView.frame.size.height / 2.0f + 20.0f;
  self.contentControllerView.center = contentControllerViewCenter;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
  [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
  
  //  if (self.menuState == DCMenuStateOpened) {
  //    self.contentView.frame = CGRectMake(CGRectGetWidth(self.view.frame) * self.menuWidthInPercent, CGRectGetHeight(self.view.frame) * self.menuTopOffsetInPercent, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
  //    self.menuView.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.frame) * self.menuWidthInPercent, CGRectGetHeight(self.view.frame));
  //    self.contentControllerView.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame));
  //
  //    self.contentViewController.view.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.contentControllerView.frame), CGRectGetHeight(self.contentControllerView.frame));
  //    self.menuViewController.view.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.menuView.frame), CGRectGetHeight(self.menuView.frame));
  //  } else {
  
  self.menuPanGestureRecognizer.enabled = NO;
  self.menuState = DCMenuStateUnknown;
  
  CGRect fixedFrame;
  if (IS_OS_7) {
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
      fixedFrame = CGRectMake(self.view.frame.origin.y, self.view.frame.origin.x, self.view.frame.size.height, self.view.frame.size.width);
    } else {
      fixedFrame = self.view.frame;
    }
  } else if (IS_OS_8_OR_LATER) {
    fixedFrame = self.view.frame;
  }
  
  self.contentView.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(fixedFrame), CGRectGetHeight(fixedFrame));
  self.menuView.frame = CGRectMake(-CGRectGetWidth(fixedFrame) * self.menuWidthInPercent / 2.0f, 0.0f, CGRectGetWidth(fixedFrame) * self.menuWidthInPercent, CGRectGetHeight(fixedFrame));
  
  CGPoint contentControllerViewCenter = self.contentControllerView.center;
  contentControllerViewCenter.y = self.contentControllerView.frame.size.height / 2.0f + 20.0f;
  self.contentControllerView.center = contentControllerViewCenter;
  
  [UIView setAnimationsEnabled:NO];
  
  self.customStatusBarState = NO;
  self.statusBarHidden = NO;
  [self setNeedsStatusBarAppearanceUpdate];
  
  self.snapshotView.alpha = 0.0;
  [self.snapshotView removeFromSuperview];
  self.snapshotView = nil;
  
  [UIView setAnimationsEnabled:YES];
  
  [self.tapView removeFromSuperview];
  
  self.menuState = DCMenuStateClosed;
  self.menuPanGestureRecognizer.enabled = YES;
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
      [self addChildViewController:_contentViewController];
      vc.view.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.contentControllerView.frame), CGRectGetHeight(self.contentControllerView.frame));
      [self.contentControllerView addSubview:vc.view];
      [_contentViewController didMoveToParentViewController:self];
      
      [self _didSelectMenuItemAtIndexPath:indexPath];
    }
  }
  [self closeMenu:0.25f];
}

- (void)setStatusBarBackgroundColor:(UIColor *)color {
  if (color != nil) {
    self.contentView.backgroundColor = color;
  }
}

#pragma mark - Private Methods

- (void)openMenuViewController:(UIBarButtonItem *)barButtonItem {
  CGRect fixedFrame;
  if (IS_OS_7) {
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
      fixedFrame = CGRectMake(self.view.frame.origin.y, self.view.frame.origin.x, self.view.frame.size.height, self.view.frame.size.width);
    } else {
      fixedFrame = self.view.frame;
    }
  } else if (IS_OS_8_OR_LATER) {
    fixedFrame = self.view.frame;
  }
  
  if (self.menuState == DCMenuStateClosed) {
    self.menuState = DCMenuStateUnknown;
    
    if ([UIApplication sharedApplication].statusBarHidden == NO) {
      [UIView setAnimationsEnabled:NO];
      
      self.statusBarSize = [DCStatusBarSize getSize];
      
      UIView *snapshotView = [self getSnapshotView];
      self.snapshotView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.statusBarSize.width, self.statusBarSize.height)];
      self.snapshotView.clipsToBounds = YES;
      [self.snapshotView addSubview:snapshotView];
      [self.contentView addSubview:self.snapshotView];
      
      self.customStatusBarState = YES;
      self.statusBarHidden = YES;
      [self setNeedsStatusBarAppearanceUpdate];
      
      if (IS_OS_7) {
        if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
          // Do nothing
        } else {
          CGPoint contentControllerViewCenter = self.contentControllerView.center;
//          contentControllerViewCenter.y += self.statusBarSize.height;
          self.contentControllerView.center = contentControllerViewCenter;
        }
      } else if (IS_OS_8_OR_LATER) {
        CGPoint contentControllerViewCenter = self.contentControllerView.center;
//        contentControllerViewCenter.y += self.statusBarSize.height;
        self.contentControllerView.center = contentControllerViewCenter;
      }
      
      [UIView setAnimationsEnabled:YES];
    }
    
    [self openMenu:0.25f];
  } else if (self.menuState == DCMenuStateOpened) {
    self.menuState = DCMenuStateUnknown;
    
    [self closeMenu:0.25f];
  }
}

- (void)handleTapGesture:(UITapGestureRecognizer *)recognizer {
  if (self.menuState == DCMenuStateOpened) {
    [self closeMenu:0.25f];
  }
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer {
  CGRect fixedFrame;
  if (IS_OS_7) {
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
      fixedFrame = CGRectMake(self.view.frame.origin.y, self.view.frame.origin.x, self.view.frame.size.height, self.view.frame.size.width);
    } else {
      fixedFrame = self.view.frame;
    }
  } else if (IS_OS_8_OR_LATER) {
    fixedFrame = self.view.frame;
  }
  
  switch(recognizer.state) {
    case UIGestureRecognizerStateBegan: {
      self.startPoint = self.contentView.center;
      
      if (self.menuState == DCMenuStateClosed) {
        if ([UIApplication sharedApplication].statusBarHidden == NO) {
          [UIView setAnimationsEnabled:NO];
          
          self.statusBarSize = [DCStatusBarSize getSize];
          
          UIView *snapshotView = [self getSnapshotView];
          self.snapshotView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.statusBarSize.width, self.statusBarSize.height)];
          self.snapshotView.clipsToBounds = YES;
          [self.snapshotView addSubview:snapshotView];
          [self.contentView addSubview:self.snapshotView];
          
          self.customStatusBarState = YES;
          self.statusBarHidden = YES;
          [self setNeedsStatusBarAppearanceUpdate];
          
          if (IS_OS_7) {
            if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
              // Do nothing
            } else {
              CGPoint contentControllerViewCenter = self.contentControllerView.center;
//              contentControllerViewCenter.y += self.statusBarSize.height;
              self.contentControllerView.center = contentControllerViewCenter;
            }
          } else if (IS_OS_8_OR_LATER) {
            CGPoint contentControllerViewCenter = self.contentControllerView.center;
//            contentControllerViewCenter.y += self.statusBarSize.height;
            self.contentControllerView.center = contentControllerViewCenter;
          }
          
          //          CGRect contentViewControllerFrame = self.contentViewController.view.frame;
          //          contentViewControllerFrame.size.height -= self.statusBarSize.height;
          //          self.contentViewController.view.frame = contentViewControllerFrame;
          
          [UIView setAnimationsEnabled:YES];
        }
      }
      self.menuState = DCMenuStateUnknown;
      break;
    }
    case UIGestureRecognizerStateChanged: {
      CGPoint translationPoint = [recognizer translationInView:self.view];
      CGPoint endPoint = CGPointMake(self.startPoint.x + translationPoint.x, self.startPoint.y);
      
      if (endPoint.x < (CGRectGetWidth(fixedFrame) / 2.0f)) {
        endPoint.x = (CGRectGetWidth(fixedFrame) / 2.0f);
      }
      if (endPoint.x > (CGRectGetWidth(fixedFrame) /  2.0f) + (CGRectGetWidth(fixedFrame) * self.menuWidthInPercent)) {
        endPoint.x = (CGRectGetWidth(fixedFrame) /  2.0f) + (CGRectGetWidth(fixedFrame) * self.menuWidthInPercent);
      }
      
      CGFloat menuViewRatio = (endPoint.x - (CGRectGetWidth(fixedFrame) / 2.0f)) / (CGRectGetWidth(fixedFrame) * self.menuWidthInPercent);
      self.contentView.center = CGPointMake(endPoint.x, CGRectGetHeight(fixedFrame) / 2.0f + CGRectGetHeight(fixedFrame) * self.menuTopOffsetInPercent * menuViewRatio);
      menuViewRatio = (1.0f - menuViewRatio) / 2.0f;
      
      CGPoint menuViewCenter = self.menuView.center;
      menuViewCenter = CGPointMake(-CGRectGetWidth(fixedFrame) * self.menuWidthInPercent * menuViewRatio + CGRectGetWidth(fixedFrame) * self.menuWidthInPercent / 2.0f, CGRectGetHeight(fixedFrame) / 2.0f);
      self.menuView.center = menuViewCenter;
      break;
    }
    case UIGestureRecognizerStateEnded: {
      CGPoint translationPoint = [recognizer translationInView:self.view];
      CGPoint velocityPoint = [recognizer velocityInView:self.view];
      CGPoint endPoint = CGPointMake(self.startPoint.x + translationPoint.x + velocityPoint.x, self.startPoint.y);
      endPoint.x -= CGRectGetWidth(fixedFrame) * self.menuWidthInPercent;
      
      if (endPoint.x < 0) {
        CGFloat animationDuration;
        CGFloat value = -endPoint.x;
        CGFloat menuWidth = CGRectGetWidth(fixedFrame) * self.menuWidthInPercent + CGRectGetWidth(fixedFrame);
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
        CGFloat menuWidth = CGRectGetWidth(fixedFrame) * self.menuWidthInPercent + CGRectGetWidth(fixedFrame);
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
  
  CGRect fixedFrame;
  if (IS_OS_7) {
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
      fixedFrame = CGRectMake(self.view.frame.origin.y, self.view.frame.origin.x, self.view.frame.size.height, self.view.frame.size.width);
    } else {
      fixedFrame = self.view.frame;
    }
  } else if (IS_OS_8_OR_LATER) {
    fixedFrame = self.view.frame;
  }
  
  self.tapView.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(fixedFrame), CGRectGetHeight(fixedFrame));
  [self.contentView addSubview:self.tapView];
  //    CGFloat velocity = animationDuration * CGRectGetWidth(self.view.frame) * self.menuWidthInPercent;
  [UIView animateWithDuration:animationDuration delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
    //  [UIView animateWithDuration:animationDuration delay:0.0f usingSpringWithDamping:0.4f initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
    self.contentView.center = CGPointMake(CGRectGetWidth(fixedFrame) / 2.0f + CGRectGetWidth(fixedFrame) * self.menuWidthInPercent, CGRectGetHeight(fixedFrame) / 2.0f + CGRectGetHeight(fixedFrame) * self.menuTopOffsetInPercent);
    self.menuView.center = CGPointMake(CGRectGetWidth(fixedFrame) * self.menuWidthInPercent / 2.0f, CGRectGetHeight(fixedFrame) / 2.0f);
  } completion:^(BOOL finished) {
    self.menuState = DCMenuStateOpened;
    self.menuPanGestureRecognizer.enabled = YES;
  }];
}

- (void)closeMenu:(NSTimeInterval)animationDuration {
  self.menuPanGestureRecognizer.enabled = NO;
  self.menuState = DCMenuStateUnknown;
  
  CGRect fixedFrame;
  if (IS_OS_7) {
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
      fixedFrame = CGRectMake(self.view.frame.origin.y, self.view.frame.origin.x, self.view.frame.size.height, self.view.frame.size.width);
    } else {
      fixedFrame = self.view.frame;
    }
  } else if (IS_OS_8_OR_LATER) {
    fixedFrame = self.view.frame;
  }
  
  [UIView animateWithDuration:animationDuration delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
    self.contentView.center = CGPointMake(CGRectGetWidth(fixedFrame) / 2.0f, CGRectGetHeight(fixedFrame) / 2.0f);
    self.menuView.center = CGPointMake(0.0f, CGRectGetHeight(fixedFrame) / 2.0f);
  } completion:^(BOOL finished) {
    [UIView setAnimationsEnabled:NO];
    
    CGPoint contentControllerViewCenter = self.contentControllerView.center;
    contentControllerViewCenter.y = self.contentControllerView.frame.size.height / 2.0f + 20.0f;
    self.contentControllerView.center = contentControllerViewCenter;
    
    //    CGRect contentViewControllerFrame = self.contentViewController.view.frame;
    //    contentViewControllerFrame.size.height += self.statusBarSize.height;
    //    self.contentViewController.view.frame = contentViewControllerFrame;
    
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
  //  if ([gestureRecognizer isEqual:self.menuPanGestureRecognizer]) {
  //    return YES;
  //  }
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
