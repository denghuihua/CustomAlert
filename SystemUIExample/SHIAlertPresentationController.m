//
//  SHIAlertPresentationController.m
//  SystemUIExample
//
//  Created by huihuadeng on 2018/4/20.
//  Copyright © 2018年 huihuadeng. All rights reserved.
//

#import "SHIAlertPresentationController.h"
#import "UIColor+Hex.h"

@interface SHIAlertPresentationController(){
    
}
@property(nonatomic,strong)UIView *blackView;
@end

@implementation SHIAlertPresentationController

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController
{
    self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
    
    if (self) {
        // 必须设置 presentedViewController 的 modalPresentationStyle
        // 在自定义动画效果的情况下，苹果强烈建议设置为 UIModalPresentationCustom
        presentedViewController.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

- (CGSize)sizeForChildContentContainer:(id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize
{
    if (container == self.presentedViewController)
        return ((UIViewController*)container).preferredContentSize;
    else
        return [super sizeForChildContentContainer:container withParentContainerSize:parentSize];
}

//在我们的自定义呈现中，被呈现的 view 并没有完全完全填充整个屏幕，
//被呈现的 view 的过渡动画之后的最终位置，是由 UIPresentationViewController 来负责定义的。
//我们重载 frameOfPresentedViewInContainerView 方法来定义这个最终位置
- (CGRect)frameOfPresentedViewInContainerView
{
    CGRect containerViewBounds = self.containerView.bounds;
    CGSize presentedViewContentSize = [self sizeForChildContentContainer:self.presentedViewController withParentContainerSize:containerViewBounds.size];
    
    // The presented view extends presentedViewContentSize.height points from
    // the bottom edge of the screen.
    CGRect presentedViewControllerFrame = containerViewBounds;
    presentedViewControllerFrame.size.height = presentedViewContentSize.height;
    presentedViewControllerFrame.origin.y = CGRectGetMaxY(containerViewBounds) - presentedViewContentSize.height -  100;
    return presentedViewControllerFrame;
}


//  This method is similar to the -viewWillLayoutSubviews method in
//  UIViewController.  It allows the presentation controller to alter the
//  layout of any custom views it manages.
//
- (void)containerViewWillLayoutSubviews
{
    [super containerViewWillLayoutSubviews];
    self.blackView.frame = self.containerView.bounds;
}

#pragma mark 点击了背景遮罩view

- (void)presentationTransitionWillBegin{
    UIView *blackView = [self blackView];
    blackView.alpha = 0;
    [self.containerView addSubview:blackView];
    [UIView animateWithDuration:0.3 animations:^{
        blackView.alpha = 1;
    }];
}

- (void)presentationTransitionDidEnd:(BOOL)completed{
    [UIView animateWithDuration:0.3 animations:^{
        self.blackView.alpha = 1;
    }];
}

- (void)dismissalTransitionWillBegin{
    [UIView animateWithDuration:0.3 animations:^{
        self.blackView.alpha = 0;
    }];
}

- (void)dismissalTransitionDidEnd:(BOOL)completed{
    if (completed) {
        [self.blackView removeFromSuperview];
    }
}

- (UIView *)blackView{
    if (_blackView == nil) {
        UIView *view = [[UIView alloc] initWithFrame:self.containerView.bounds];
        view.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.4];
        _blackView = view;
    }
    return _blackView;
}

@end
