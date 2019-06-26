//
//  WYHeartFlyView.h
//  FloatingHeartsView
//
//  Created by Highden on 2019/6/19.
//  Copyright © 2019 Highden. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WYHeartFlyView : UIView

- (void)animateInView:(UIView *)view;
@end

@interface UIColor (FlyHeartsView)

+ (instancetype)colorWithHex:(NSInteger)hex;
@end

NS_ASSUME_NONNULL_END
