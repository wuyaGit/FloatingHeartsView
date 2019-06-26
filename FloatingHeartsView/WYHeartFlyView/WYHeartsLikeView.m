//
//  WYHeartsLikeView.m
//  FloatingHeartsView
//
//  Created by Highden on 2019/6/21.
//  Copyright © 2019 Highden. All rights reserved.
//

#import "WYHeartsLikeView.h"
#import "WYHeartFlyView.h"

@interface WYHeartsLikeView ()

@property (nonatomic, strong) UIButton *like_button;
@end

@implementation WYHeartsLikeView

- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self customInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self customInit];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.like_button.frame = CGRectMake(0, self.frame.size.height - 40.0, 40, 40);
}

- (void)customInit {
    self.clipsToBounds = NO;
    
    [self addSubview:self.like_button];
}

#pragma mark - public

- (void)fireLike {
    WYHeartFlyView *view = [[WYHeartFlyView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
    [self addSubview:view];

    view.center = self.like_button.center;
    [view animateInView:self];
}

- (void)hiddenButton:(BOOL)isHidden {
    self.like_button.hidden = isHidden;
    self.userInteractionEnabled = !isHidden;
}

#pragma mark - action

- (void)btnAction:(id)sender {
    [self fireLike];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(likeViewSendZan:)]) {
        [self.delegate likeViewSendZan:self];
    }
    
    self.like_button.enabled = NO;
    
    //一秒之后允许点击
    [self performSelector:@selector(enableBtn:) withObject:self.like_button afterDelay:1.0];
}

- (void)enableBtn:(id)sender {
    UIButton *btn = (UIButton *)sender;
    btn.enabled = YES;
}

#pragma mark - getter

- (UIButton *)like_button {
    if (!_like_button) {
        _like_button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_like_button setImage:[UIImage imageNamed:@"like_btn_n"] forState:UIControlStateNormal];
        [_like_button setImage:[UIImage imageNamed:@"like_btn_p"] forState:UIControlStateHighlighted];
        [_like_button addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _like_button;
}

@end
