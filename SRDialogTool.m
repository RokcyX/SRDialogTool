//
//  SRDialogTool.m
//  Replicator
//
//  Created by 周家民 on 2017/2/20.
//  Copyright © 2017年 StarRain. All rights reserved.
//

#import "SRDialogTool.h"

@implementation SRDialogView{
    CGFloat circleRadius;
    CGFloat padding;
    CGFloat dialogMaxWidth;
    CGFloat dialogMaxHeight;
    CGFloat titleMaxHeight;
    CGRect screenBounds;
    CGFloat realDialogWidth;
    CALayer *animateLayer;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    screenBounds=[[UIScreen mainScreen] bounds];
    dialogMaxWidth=screenBounds.size.width*0.6;
    dialogMaxHeight=screenBounds.size.height*0.8;
    titleMaxHeight=50;
    circleRadius=20;
    padding=10;
    
    CGSize titleSize=[self textSizeWithText:_titleLb.text maxSize:CGSizeMake(dialogMaxWidth-2*padding, titleMaxHeight) font:_titleLb.font];
    _titleLb.frame=CGRectMake(padding, padding, titleSize.width, titleSize.height);
    
    CGFloat messageMaxHeight=dialogMaxHeight-titleSize.height-2*circleRadius-4*padding;
    CGSize messageSize=[self textSizeWithText:_messageLb.text maxSize:CGSizeMake(dialogMaxWidth-2*padding, messageMaxHeight) font:_messageLb.font];
    _messageLb.frame=CGRectMake(padding, CGRectGetMaxY(_titleLb.frame)+padding, messageSize.width, messageSize.height);
    
    realDialogWidth=fmaxf(fmaxf(titleSize.width, messageSize.width)+2*padding, 80) ;
    CGFloat maxHeight=CGRectGetMaxY(_messageLb.frame)+padding;
    
    _titleLb.center=CGPointMake(0.5*realDialogWidth, _titleLb.center.y);
    _messageLb.center=CGPointMake(0.5*realDialogWidth, _messageLb.center.y);
    

    CGFloat realDialogHeight=maxHeight+2*padding+2*circleRadius;
    
    self.frame=CGRectMake(0.5*(screenBounds.size.width-realDialogWidth), 0.5*(screenBounds.size.height-realDialogHeight), realDialogWidth, realDialogHeight);
    
}

-(void)setHidden:(BOOL)hidden{
    [super setHidden:hidden];
    if (!hidden) {
        [self layoutSubviews];
        [animateLayer removeFromSuperlayer];
        switch (self.animateType) {
            case SRDialogViewAnimateTypeWait:
                [self doWaitAnimate];
                break;
            case SRDialogViewAnimateTypeSuccess:
                [self doSuccessAnimate];
                break;
            case SRDialogViewAnimateTypeFailure:
                [self doFailureAnimate];
                break;
        }
    }
}

-(void)doWaitAnimate{
    _pointView.frame=CGRectMake(0, 0, 2, 2);
    _pointView.center=CGPointMake(0.5*realDialogWidth, CGRectGetMaxY(_messageLb.frame)+padding);
    [_pointView.layer setCornerRadius:0.5*_pointView.frame.size.width];
    
    CGPoint startPoint=_pointView.center;
    UIBezierPath *circlePath=[UIBezierPath bezierPath];
    [circlePath moveToPoint:startPoint];
    [circlePath addArcWithCenter:CGPointMake(startPoint.x, startPoint.y+circleRadius) radius:circleRadius startAngle:-M_PI_2 endAngle:M_PI*1.5 clockwise:YES];
    
    CAKeyframeAnimation *animate=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    animate.path=[circlePath CGPath];
    animate.duration=1.7;
    animate.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animate.repeatCount=MAXFLOAT;
    [_pointView.layer addAnimation:animate forKey:@"waitAnimate"];
    
    CABasicAnimation *bigAnimate=[CABasicAnimation animationWithKeyPath:@"transform"];
    bigAnimate.duration=1.7;
    bigAnimate.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    bigAnimate.repeatCount=MAXFLOAT;
    bigAnimate.toValue=[NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
    bigAnimate.toValue=[NSValue valueWithCATransform3D:CATransform3DScale(_pointView.layer.transform, 5, 5, 1)];
    [_pointView.layer addAnimation:bigAnimate forKey:@"bigAnimate"];
    
    CAReplicatorLayer *replicatorLayer=[CAReplicatorLayer layer];
    replicatorLayer.instanceColor=[_pointView.backgroundColor CGColor];
    replicatorLayer.instanceAlphaOffset=-0.16;
    replicatorLayer.instanceDelay=0.1;
    replicatorLayer.instanceCount=6;
    [replicatorLayer addSublayer:_pointView.layer];
    
    [self.layer addSublayer:replicatorLayer];
    animateLayer=replicatorLayer;
}

-(void)doSuccessAnimate{
    CGPoint flagSecondPoint=CGPointMake(realDialogWidth*0.5-5, CGRectGetMaxY(_messageLb.frame)+2*circleRadius);
    UIBezierPath *flagPath=[UIBezierPath bezierPath];
    [flagPath moveToPoint:CGPointMake(flagSecondPoint.x-15, flagSecondPoint.y-15)];
    [flagPath addLineToPoint:flagSecondPoint];
    [flagPath addLineToPoint:CGPointMake(flagSecondPoint.x+28, flagSecondPoint.y-25)];
    
    CAShapeLayer *flagLayer=[CAShapeLayer layer];
    animateLayer=flagLayer;
    flagLayer.path=flagPath.CGPath;
    flagLayer.lineWidth=2;
    flagLayer.lineCap=kCALineCapRound;
    flagLayer.lineJoin=kCALineJoinRound;
    flagLayer.strokeColor=[[UIColor greenColor] CGColor];
    flagLayer.fillColor=[[UIColor clearColor] CGColor];
    [self.layer addSublayer:flagLayer];

    CABasicAnimation *flagAnimate=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    flagAnimate.fromValue=@(0);
    flagAnimate.toValue=@(1);
    flagAnimate.duration=0.2;
    flagAnimate.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [flagLayer addAnimation:flagAnimate forKey:@"flagAnimate"];
    
    
}

-(void)doFailureAnimate{
    CGPoint centerPoint=CGPointMake(realDialogWidth*0.5, CGRectGetMaxY(_messageLb.frame)+circleRadius+padding);
    UIBezierPath *flagPath=[UIBezierPath bezierPath];
    [flagPath moveToPoint:CGPointMake(centerPoint.x-circleRadius, centerPoint.y-circleRadius)];
    [flagPath addLineToPoint:CGPointMake(centerPoint.x+circleRadius, centerPoint.y+circleRadius)];
    [flagPath moveToPoint:CGPointMake(centerPoint.x+circleRadius, centerPoint.y-circleRadius)];
    [flagPath addLineToPoint:CGPointMake(centerPoint.x-circleRadius, centerPoint.y+circleRadius)];
    
    CAShapeLayer *flagLayer=[CAShapeLayer layer];
    animateLayer=flagLayer;
    flagLayer.path=flagPath.CGPath;
    flagLayer.lineWidth=2;
    flagLayer.lineCap=kCALineCapRound;
    flagLayer.lineJoin=kCALineJoinRound;
    flagLayer.strokeColor=[[UIColor redColor] CGColor];
    flagLayer.fillColor=[[UIColor clearColor] CGColor];
    [self.layer addSublayer:flagLayer];
    
    CABasicAnimation *flagAnimate=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    flagAnimate.fromValue=@(0);
    flagAnimate.toValue=@(1);
    flagAnimate.duration=0.2;
    flagAnimate.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [flagLayer addAnimation:flagAnimate forKey:@"flagAnimate"];
}

-(void)setupUI{
    [self setBackgroundColor:[UIColor whiteColor]];
    [self.layer setCornerRadius:10];
    
    UILabel *titleLb=[[UILabel alloc] init];
    [self addSubview:titleLb];
    _titleLb=titleLb;
    [titleLb setFont:[UIFont systemFontOfSize:15]];
    [titleLb setTextColor:[UIColor blackColor]];
    titleLb.numberOfLines=0;
    [titleLb setTextAlignment:NSTextAlignmentCenter];
    
    UILabel *messageLb=[[UILabel alloc] init];
    [self addSubview:messageLb];
    _messageLb=messageLb;
    [messageLb setFont:[UIFont systemFontOfSize:13]];
    [messageLb setTextColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    messageLb.numberOfLines=0;
    [messageLb setTextAlignment:NSTextAlignmentCenter];
    
    _pointView=[[UIView alloc] init];
    [_pointView setBackgroundColor:[UIColor blackColor]];
}

-(CGSize)textSizeWithText:(NSString*)text maxSize:(CGSize)maxSize font:(UIFont*)font{
    NSStringDrawingOptions opts = NSStringDrawingUsesLineFragmentOrigin |
    NSStringDrawingUsesFontLeading;
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineBreakMode:NSLineBreakByCharWrapping];
    
    NSDictionary *attributes = @{ NSFontAttributeName : font, NSParagraphStyleAttributeName : style };
    
    CGRect rect = [text boundingRectWithSize:maxSize
                                            options:opts
                                         attributes:attributes
                                            context:nil];
   return rect.size;
}

@end

@implementation SRDialogTool

static UIView *modalView;

static SRDialogView *dialogView;

+(void)initialize{
    modalView=[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [modalView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]];
    
    dialogView=[[SRDialogView alloc] init];
}

-(instancetype)init{
    if (self=[super init]) {
        
        _titleColor=[UIColor blackColor];
        
        _messageColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        
        _duration=2;
        
        _modal=YES;
        
        _titleFont=[UIFont systemFontOfSize:15];
        
        _messageFont=[UIFont systemFontOfSize:13];
        
    }
    return self;
}

+(void)showWaitWithMessage:(NSString *)message title:(NSString *)title{
    [SRDialogTool showWithTitle:title message:message animateType:SRDialogViewAnimateTypeWait isModal:YES duration:0];
}

+(void)showSuccessWithMessage:(NSString *)message title:(NSString *)title duration:(CFTimeInterval)duration isModal:(BOOL)isModal{
    [SRDialogTool showWithTitle:title message:message animateType:SRDialogViewAnimateTypeSuccess isModal:isModal duration:duration];
}

+(void)showFailureWithMessage:(NSString *)message title:(NSString *)title duration:(CFTimeInterval)duration isModal:(BOOL)isModal{
    [SRDialogTool showWithTitle:title message:message animateType:SRDialogViewAnimateTypeFailure isModal:isModal duration:duration];
}

+(void)showWithTitle:(NSString*)title message:(NSString*)message animateType:(SRDialogViewAnimateType)animateType isModal:(BOOL)isModal duration:(CFTimeInterval)duration{
    
    [modalView removeFromSuperview];
    [dialogView removeFromSuperview];
    dialogView.titleLb.text=title;
    dialogView.messageLb.text=message;
    dialogView.animateType=animateType;
    UIView *topView=[SRDialogTool getTopView];
    if (isModal) {
        [topView addSubview:modalView];
    }
    [topView addSubview:dialogView];
    [modalView setHidden:YES];
    
    [dialogView setHidden:NO];
    [dialogView setTransform:CGAffineTransformScale(dialogView.transform, 1.3, 1.3)];
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [modalView setHidden:NO];
        [dialogView setTransform:CGAffineTransformIdentity];
    } completion:^(BOOL finished) {
        if (duration>0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration)*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [SRDialogTool hide];
            });
        }
    }];
    
}

+(void)hide{
    [UIView animateWithDuration:0.5 animations:^{
        [modalView setHidden:YES];
        [dialogView setHidden:YES];
    } completion:^(BOOL finished) {
        [modalView removeFromSuperview];
        [dialogView removeFromSuperview];
    }];
}

+(UIView*)getTopView{
    UIView *topView=[[UIApplication sharedApplication].keyWindow.subviews lastObject];
    return topView;
}

@end
