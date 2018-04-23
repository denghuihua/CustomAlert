//
//  SHIPresentBottomVC.m
//  SystemUIExample
//
//  Created by huihuadeng on 2018/4/20.
//  Copyright © 2018年 huihuadeng. All rights reserved.
//

#import "SHIPresentBottomVC.h"
#import "UIColor+Hex.h"
#import "SHIAlertPresentationController.h"
@interface SHIPresentBottomVC ()<UIViewControllerTransitioningDelegate>
{

}
@end

@implementation SHIPresentBottomVC

- (id)init{    
    if (self = [super init]) {
        self.preferredContentSize = CGSizeMake(200 ,300);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    
}

#pragma mark - UIViewControllerTransitioningDelegate
/*
 * 来告诉控制器，谁是动画主管(UIPresentationController)，因为此类继承了UIPresentationController，就返回了self
 */
- (UIPresentationController* )presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source
{
    SHIAlertPresentationController *presentationController = [[SHIAlertPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
    return presentationController;
}


#pragma mark UIViewControllerAnimatedTransitioning具体动画实现


//// 返回的对象控制Presented时的动画 (开始动画的具体细节负责类)
//- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
//{
//    __weak SHIPresentBottomVC *vc = self;
//    return vc;
//}
//// 由返回的控制器控制dismissed时的动画 (结束动画的具体细节负责类)
//- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
//{
//    __weak SHIPresentBottomVC *vc = self;
//    return vc;
//}

// 动画时长
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return [transitionContext isAnimated] ? 0.55 : 0;
}

// 核心，动画效果的实现
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // 1.获取源控制器、目标控制器、动画容器View
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    __unused UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = transitionContext.containerView;
    
    // 2. 获取源控制器、目标控制器 的View，但是注意二者在开始动画，消失动画，身份是不一样的：
    // 也可以直接通过上面获取控制器获取，比如：toViewController.view
    // For a Presentation:
    //      fromView = The presenting view.
    //      toView   = The presented view.
    // For a Dismissal:
    //      fromView = The presented view.
    //      toView   = The presenting view.
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    
    [containerView addSubview:toView];  //必须添加到动画容器View上。
    
    // 判断是present 还是 dismiss
    BOOL isPresenting = (fromViewController == self.presentingViewController);
    
    CGFloat screenW = CGRectGetWidth(containerView.bounds);
    CGFloat screenH = CGRectGetHeight(containerView.bounds);
    
    // 左右留35
    // 上下留80
    
    // 屏幕顶部：
    CGFloat x = 35.f;
    CGFloat y = -1 * screenH;
    CGFloat w = screenW - x * 2;
    CGFloat h = screenH - 80.f * 2;
    CGRect topFrame = CGRectMake(x, y, w, h);
    
    // 屏幕中间：
    CGRect centerFrame = CGRectMake(x, 80.0, w, h);
    
    // 屏幕底部
    CGRect bottomFrame = CGRectMake(x, screenH + 10, w, h);  //加10是因为动画果冻效果，会露出屏幕一点
    
    if (isPresenting) {
        toView.frame = topFrame;
    }
     toView.frame = centerFrame;
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    // duration： 动画时长
    // delay： 决定了动画在延迟多久之后执行
    // damping：速度衰减比例。取值范围0 ~ 1，值越低震动越强
    // velocity：初始化速度，值越高则物品的速度越快
    // UIViewAnimationOptionCurveEaseInOut 加速，后减速
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:0.7f initialSpringVelocity:0.3f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (isPresenting)
            toView.frame = centerFrame;
        else
            fromView.frame = bottomFrame;
    } completion:^(BOOL finished) {
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!wasCancelled];
    }];
    return;
    toView.transform = CGAffineTransformMakeScale(0.0, 0.0);
    toView.alpha = 1.0;    
    CAKeyframeAnimation * scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.values = @[@0.0,@0.6,@1.0];
    scaleAnimation.keyTimes = @[@0.0,@0.155,@1.0];
    scaleAnimation.duration = 0.2;
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.timingFunction =  [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAKeyframeAnimation * alphaAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.values = @[@0.0,@0.2,@1.0];
    alphaAnimation.keyTimes = @[@0.0,@0.155,@1.0];
    alphaAnimation.duration = 0.2;
    alphaAnimation.fillMode = kCAFillModeForwards;
    alphaAnimation.removedOnCompletion = NO;
    alphaAnimation.timingFunction =  [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseOut];
    alphaAnimation.delegate = self;
    
    CAKeyframeAnimation * scaleAnimation2 = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation2.values = @[@(1.0),@(1.02),@(1.0)];
    scaleAnimation2.keyTimes = @[@(0.0),@(0.33),@(1.0)];
    scaleAnimation2.duration = 0.2;
    scaleAnimation2.beginTime = 0.2;
    scaleAnimation2.timingFunction =  [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseOut];
    scaleAnimation2.fillMode = kCAFillModeForwards;
    scaleAnimation2.removedOnCompletion = NO;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[scaleAnimation,scaleAnimation2];
    animationGroup.duration = 0.4;
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.removedOnCompletion = NO;
    animationGroup.delegate =self;
    [toView.layer addAnimation:animationGroup forKey:@"scale"];
    [toView.layer addAnimation:alphaAnimation forKey:@"alpha"];
     [transitionContext completeTransition:YES];
    
}

- (void)animationEnded:(BOOL) transitionCompleted
{
    // 动画结束...
}

@end
