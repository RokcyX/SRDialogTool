//
//  SRDialogTool.h
//  Replicator
//
//  Created by 周家民 on 2017/2/20.
//  Copyright © 2017年 StarRain. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,SRDialogViewAnimateType) {
    SRDialogViewAnimateTypeWait=0,
    SRDialogViewAnimateTypeSuccess,
    SRDialogViewAnimateTypeFailure
};

@interface SRDialogView : UIView

@property(nonatomic,weak)UILabel *titleLb;

@property(nonatomic,weak)UILabel *messageLb;

@property(nonatomic,strong)UIView *pointView;

@property(nonatomic,assign)SRDialogViewAnimateType animateType;

@end

@interface SRDialogTool : NSObject


/**
 标题文字颜色
 */
@property(nonatomic,strong)UIColor *titleColor;


/**
 内容文字颜色
 */
@property(nonatomic,strong)UIColor *messageColor;


/**
 持续时间
 */
@property(nonatomic,assign)CFTimeInterval duration;


/**
 是否为模态
 */
@property(nonatomic,assign,getter=isModal)BOOL modal;


/**
 标题文字字体
 */
@property(nonatomic,strong)UIFont *titleFont;


/**
 内容文字字体
 */
@property(nonatomic,strong)UIFont *messageFont;

/**
 应用场景：向用户提示一段成功消息，并在默认或设置时间内消失

 @param message 提示内容
 @param title 提示标题
 @param duration 持续时间
 @param isModal 是否为模态
 */
+(void)showSuccessWithMessage:(NSString*)message title:(NSString*)title duration:(CFTimeInterval)duration isModal:(BOOL)isModal;

/**
 应用场景：向用户提示一段失败消息，并在默认或设置时间内消失
 
 @param message 提示内容
 @param title 提示标题
 @param duration 持续时间
 @param isModal 是否为模态
 */
+(void)showFailureWithMessage:(NSString*)message title:(NSString*)title duration:(CFTimeInterval)duration isModal:(BOOL)isModal;

/**
 应用场景：向用户提示一段等待消息，并在默认或设置时间内消失
 
 @param message 提示内容
 @param title 提示标题
 */
+(void)showWaitWithMessage:(NSString*)message title:(NSString*)title;


@end
