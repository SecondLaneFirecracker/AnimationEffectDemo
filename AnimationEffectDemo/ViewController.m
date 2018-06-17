//
//  ViewController.m
//  AnimationEffectDemo
//
//  Created by marksong on 4/27/16.
//  Copyright © 2016 S.R. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 去掉导航栏的阴影横线
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setShadowImage:[UIImage new]];
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
}

- (void)dealloc {
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([object isEqual:self.scrollView] && [keyPath isEqualToString:@"contentOffset"]) {
        [self refreshNavigationBar];
    }
}

- (void)refreshNavigationBar {
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    CGPoint contentOffset = self.scrollView.contentOffset;
    CGFloat baseHeight = CGRectGetWidth([UIScreen mainScreen].bounds) - [self topLayoutHeight];
    CGFloat alpha = MIN(1, contentOffset.y / baseHeight);
    
    if (alpha < 0 || alpha > 0.99) {
        return;
    }
    
    UIColor *color = [UIColor colorWithRed:1 green:1 blue:1 alpha:alpha];
    UIImage *image = [self imageWithColor:color size:CGSizeMake(1, 1)];
    [navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    navigationBar.translucent = alpha < 0.99;
    navigationBar.tintColor = alpha > 0.5 ? [UIColor colorWithRed:0 green:0 blue:0 alpha:alpha] : [UIColor colorWithRed:1 green:1 blue:1 alpha:1 - alpha];
}

- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [color set];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (CGFloat)topLayoutHeight {
    CGFloat statusBarHeight = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    CGFloat navigationBarHeight = CGRectGetHeight(self.navigationController.navigationBar.frame);
    
    return statusBarHeight + navigationBarHeight;
}

@end
