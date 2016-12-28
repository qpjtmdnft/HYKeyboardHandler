//
//  HYKeyboardHandler.h
//  Teshehui
//
//  Created by RayXiang on 14-9-17.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cc_PropertyInject.h"

/**
 *  键盘处理器
 */

@protocol HYKeyboardHandlerDelegate <NSObject>
@optional
- (void)keyboardShow;
- (void)keyboardChangeFrame:(CGRect)kFrame;
- (void)keyboardWillChangeFrame:(CGRect)kFrame;
- (void)keyboardHide;
- (void)keyboardWillHide;

///键盘出现时触发, 自动寻找当前界面被盖住的输入框
- (void)inputView:(UIView *)inputView willCoveredWithOffset:(CGFloat)offset;

@end

@interface HYKeyboardHandler : NSObject
<UIGestureRecognizerDelegate>
{
    BOOL _edit;
    UITapGestureRecognizer *_editTap;
}
- (instancetype)initWithDelegate:(id<HYKeyboardHandlerDelegate>)delegate view:(UIView *)view;

@property (nonatomic, weak) id<HYKeyboardHandlerDelegate> delegate;
@property (nonatomic, weak) UIView *view;
@property (nonatomic, assign) BOOL tapToDismiss;

/***/
@property (nonatomic, assign) CGRect keyboardFrame;
@property (nonatomic, weak) UIView *inputView;

- (void)startListen;
- (void)stopListen;

@end

ccInjectPropertyWithClass(HYKeyboardHandler, keyboardHandler, UIViewController)


