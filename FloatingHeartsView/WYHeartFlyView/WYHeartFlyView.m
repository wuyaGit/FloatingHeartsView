//
//  WYHeartFlyView.m
//  FloatingHeartsView
//
//  Created by Highden on 2019/6/19.
//  Copyright © 2019 Highden. All rights reserved.
//

#import "WYHeartFlyView.h"

typedef NS_ENUM(NSInteger, RotationDirection) {
    Left = -1,
    Right = 1
};

@implementation WYHeartFlyView {
    NSTimeInterval full;
    NSTimeInterval bloom;
    
    NSArray *fillColors;
    UIColor *strokeColor;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.layer.anchorPoint = CGPointMake(0.5, 1);
        
        full = 4.0;
        bloom = 0.5;
        strokeColor = [UIColor colorWithWhite:1.0 alpha:0.8];
        fillColors = @[[UIColor colorWithHex:0xe66f5e],
                       [UIColor colorWithHex:0x6a69a0],
                       [UIColor colorWithHex:0x81cc88],
                       [UIColor colorWithHex:0xfd3870],
                       [UIColor colorWithHex:0x6ecff6],
                       [UIColor colorWithHex:0xc0aaf7],
                       [UIColor colorWithHex:0xf7603b],
                       [UIColor colorWithHex:0x39d3d3],
                       [UIColor colorWithHex:0xfed301]];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.layer.anchorPoint = CGPointMake(0.5, 1);
    }
    return self;
}

- (void)animateInView:(UIView *)view {
    NSInteger random = arc4random_uniform(2);
    RotationDirection rotationDirection = 1 - 2 * random;
    
    [self prepareForAnimation];
    [self performBloomAnimation];
    [self performSlightRotationAnimation:rotationDirection];
    [self addPathAnimationInView:view];
}

- (void)prepareForAnimation {
    self.transform = CGAffineTransformMakeScale(0, 0);
    self.alpha = 0.0;
}

- (void)performBloomAnimation {
    [UIView animateWithDuration:bloom delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.transform = CGAffineTransformIdentity;
        self.alpha = 0.9;
    } completion:nil];
}

- (void)performSlightRotationAnimation:(RotationDirection)direction {
    CGFloat rotationFraction = arc4random_uniform(10);
    [UIView animateWithDuration:full animations:^{
        self.transform = CGAffineTransformMakeRotation(direction * M_PI / (16 + rotationFraction * 0.2));
    }];
}

- (UIBezierPath *)travelPathInView:(UIView *)view {
    NSInteger random = arc4random_uniform(2);
    RotationDirection endPointDirection = 1 - 2 * random; // -1 OR 1
    
    CGFloat heartCenterX = self.center.x;
    CGFloat heartSize = self.bounds.size.width;
    CGFloat viewHeight = view.bounds.size.height;
    
    //random end point
    CGFloat endPointX = heartCenterX + (endPointDirection * arc4random_uniform(2 * heartSize));
    CGFloat endPointY = viewHeight / 8.0 + arc4random_uniform(viewHeight / 4.0);
    CGPoint endPoint = CGPointMake(endPointX, endPointY);
    
    //random Control Points
    random = arc4random_uniform(2);
    CGFloat travelDirection = 1 - 2 * random;
    CGFloat xDelta = (heartSize / 2.0 + arc4random_uniform(2 * heartSize)) * travelDirection;
    CGFloat yDelta = MAX(endPoint.y ,MAX(arc4random_uniform(8 * heartSize), heartSize));
    CGPoint controlPoint1 = CGPointMake(heartCenterX + xDelta, viewHeight - yDelta);
    CGPoint controlPoint2 = CGPointMake(heartCenterX - 2 * xDelta, yDelta);
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:self.center];
    [path addCurveToPoint:endPoint controlPoint1:controlPoint1 controlPoint2:controlPoint2];

    return path;
}

- (void)addPathAnimationInView:(UIView *)view {
    UIBezierPath *heartTravelPath = [self travelPathInView:view];
    if (heartTravelPath == nil) {
        return;
    }
    
    CGFloat durationAdjustment = 4 * heartTravelPath.bounds.size.height / view.bounds.size.height;
    NSTimeInterval duration = full + durationAdjustment;

    CAKeyframeAnimation *keyFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    keyFrameAnimation.path = heartTravelPath.CGPath;
    keyFrameAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    keyFrameAnimation.duration = duration;

    [self.layer addAnimation:keyFrameAnimation forKey:@"positionOnPath"];
    
    [UIView animateWithDuration:duration animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)drawRect:(CGRect)rect {
#if true
    UIColor *fillColor = (UIColor *)[fillColors objectAtIndex:arc4random_uniform((uint32_t)fillColors.count)];

    UIImage *heartImage = [UIImage imageNamed:@"heart"];
    UIImage *heartImageBorder = [UIImage imageNamed:@"heartBorder"];

    //Draw background image (mimics border)
    //获取画布
    UIGraphicsBeginImageContextWithOptions(heartImageBorder.size, NO, 0.0f);
    //画笔沾取颜色
    [strokeColor setFill];
    
    CGRect bounds = (CGRect){{0, 0}, heartImageBorder.size};
    UIRectFill(bounds);
    //绘制一次
    [heartImageBorder drawInRect:bounds blendMode:kCGBlendModeOverlay alpha:1.0f];
    //再绘制一次
    [heartImageBorder drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    //获取图片
    heartImageBorder = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [heartImageBorder drawInRect:rect blendMode:kCGBlendModeNormal alpha:1.0];

    //Draw foreground heart image
    UIGraphicsBeginImageContextWithOptions(heartImage.size, NO, 0.0f);
    [fillColor setFill];
    bounds = (CGRect){{0, 0}, heartImage.size};
    UIRectFill(bounds);
    [heartImage drawInRect:bounds blendMode:kCGBlendModeOverlay alpha:1.0f];
    [heartImage drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    heartImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [heartImage drawInRect:rect blendMode:kCGBlendModeNormal alpha:1.0];
#else
    [self drawHeartInRect:rect];
#endif
}

- (void)drawHeartInRect:(CGRect)rect {
    UIColor *fillColor = (UIColor *)[fillColors objectAtIndex:arc4random_uniform((uint32_t)fillColors.count)];
    
    [strokeColor setStroke];
    [fillColor setFill];
    
    CGFloat drawingPadding = 4.0;
    CGFloat curveRadius = floor((CGRectGetWidth(rect) - 2*drawingPadding) / 4.0);
    
    //Creat path
    UIBezierPath *heartPath = [UIBezierPath bezierPath];
    
    //Start at bottom heart tip
    CGPoint tipLocation = CGPointMake(floor(CGRectGetWidth(rect) / 2.0), CGRectGetHeight(rect) - drawingPadding);
    [heartPath moveToPoint:tipLocation];
    
    //Move to top left start of curve
    CGPoint topLeftCurveStart = CGPointMake(drawingPadding, floor(CGRectGetHeight(rect) / 2.4));
    
    [heartPath addQuadCurveToPoint:topLeftCurveStart controlPoint:CGPointMake(topLeftCurveStart.x, topLeftCurveStart.y + curveRadius)];
    
    //Create top left curve
    [heartPath addArcWithCenter:CGPointMake(topLeftCurveStart.x + curveRadius, topLeftCurveStart.y) radius:curveRadius startAngle:M_PI endAngle:0 clockwise:YES];
    
    //Create top right curve
    CGPoint topRightCurveStart = CGPointMake(topLeftCurveStart.x + 2*curveRadius, topLeftCurveStart.y);
    [heartPath addArcWithCenter:CGPointMake(topRightCurveStart.x + curveRadius, topRightCurveStart.y) radius:curveRadius startAngle:M_PI endAngle:0 clockwise:YES];
    
    //Final curve to bottom heart tip
    CGPoint topRightCurveEnd = CGPointMake(topLeftCurveStart.x + 4*curveRadius, topRightCurveStart.y);
    [heartPath addQuadCurveToPoint:tipLocation controlPoint:CGPointMake(topRightCurveEnd.x, topRightCurveEnd.y + curveRadius)];
    
    [heartPath fill];
    
    heartPath.lineWidth = 1;
    heartPath.lineCapStyle = kCGLineCapRound;
    heartPath.lineJoinStyle = kCGLineCapRound;
    [heartPath stroke];
}

@end


@implementation UIColor (FlyHeartsView)

+ (instancetype)initWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue {
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0];
}

+ (instancetype)colorWithHex:(NSInteger)hex {
    return [UIColor initWithRed:((hex >> 16) & 0xFF) green:((hex >> 8) & 0xFF) blue:(hex & 0xFF)];
}

@end
