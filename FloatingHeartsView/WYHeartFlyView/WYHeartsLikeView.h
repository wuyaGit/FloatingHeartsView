//
//  WYHeartsLikeView.h
//  FloatingHeartsView
//
//  Created by Highden on 2019/6/21.
//  Copyright © 2019 Highden. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol WYHeartsLikeViewDelegate;

@interface WYHeartsLikeView : UIView

@property (nonatomic, weak) id<WYHeartsLikeViewDelegate> delegate;

- (void)hiddenButton:(BOOL)isHidden;

- (void)fireLike;
@end

@protocol WYHeartsLikeViewDelegate <NSObject>

- (void)likeViewSendZan:(WYHeartsLikeView *)likeView;

@end

NS_ASSUME_NONNULL_END
