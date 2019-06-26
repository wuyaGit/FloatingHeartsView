//
//  ViewController.m
//  FloatingHeartsView
//
//  Created by Highden on 2019/6/19.
//  Copyright © 2019 Highden. All rights reserved.
//

#import "ViewController.h"
#import "WYHeartFlyView.h"
#import "WYHeartsLikeView.h"

@interface ViewController () <WYHeartsLikeViewDelegate>

@end

@implementation ViewController {
    CGFloat heartSize;
    NSTimeInterval burstDelay;
    
    NSTimer *burstTimer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    heartSize = 36;
    burstDelay = 0.05;
    
    self.view.backgroundColor = [UIColor colorWithHex:0xf2f4f6];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTheLove:)];
    [self.view addGestureRecognizer:tapGesture];
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPress:)];
    longPressGesture.minimumPressDuration = 0.2;
    [self.view addGestureRecognizer:longPressGesture];
    
    
    WYHeartsLikeView *likeView = [[WYHeartsLikeView alloc] initWithFrame:CGRectMake(250, 160, 100, 500)];
    likeView.delegate = self;
    [self.view addSubview:likeView];
    
}

- (void)showTheLove:(UITapGestureRecognizer *)gesture {
    WYHeartFlyView *view = [[WYHeartFlyView alloc] initWithFrame:CGRectMake(0, 0, heartSize, heartSize)];
    [self.view addSubview:view];
    
    CGFloat fountainX = heartSize / 2.0 + 20;
    CGFloat fountainY = self.view.bounds.size.height - heartSize / 2.0 - 10;
    view.center = CGPointMake(fountainX, fountainY);
    [view animateInView:self.view];
}

- (void)didLongPress:(UILongPressGestureRecognizer *)gesture {
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            burstTimer = [NSTimer scheduledTimerWithTimeInterval:burstDelay target:self selector:@selector(showTheLove:) userInfo:nil repeats:YES];
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            [burstTimer invalidate];
            break;
        default:
            break;
    }
}

#pragma mark - delegate

- (void)likeViewSendZan:(WYHeartsLikeView *)likeView {
    
}

@end
