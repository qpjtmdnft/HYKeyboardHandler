//
//  HYKeyboardHandler.m
//  Teshehui
//
//  Created by RayXiang on 14-9-17.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYKeyboardHandler.h"
#import "UIView+ccFinder.h"

ccInjectPropertyImpl(HYKeyboardHandler, keyboardHandler, UIViewController)

@implementation HYKeyboardHandler

- (instancetype)initWithDelegate:(id)delegate view:(UIView *)view
{
    if (self = [super init])
    {
        self.view = view;
        self.delegate = delegate;
        
        _editTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editTapAction:)];
        _editTap.delegate = self;
        if (self.view) {
            [self.view addGestureRecognizer:_editTap];
        }
        self.tapToDismiss = YES;
    }
    return self;
}

- (void)startListen
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChanged:) name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)stopListen
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardChanged:(NSNotification *)notification
{
    NSValue *frameData = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect frame = [frameData CGRectValue];
    
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(keyboardChangeFrame:)])
    {
        [self.delegate keyboardChangeFrame:frame];
    }
}

- (void)keyboardWillChange:(NSNotification *)notification
{
    NSValue *frameData = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect frame = [frameData CGRectValue];
    self.keyboardFrame = frame;
    
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(keyboardWillChangeFrame:)])
    {
        [self.delegate keyboardWillChangeFrame:frame];
    }
    
    UIView *inputView = [self.view cc_findEditingInputView];
    
    if (inputView)
    {
        CGRect frameInTable = [self.view convertRect:inputView.frame
                                                   fromView:inputView.superview];
        CGFloat offset = CGRectGetMaxY(frameInTable) + CGRectGetMinY(self.view.frame) - CGRectGetMinY(_keyboardFrame);
        if (offset > 0
            &&self.delegate
            &&[self.delegate respondsToSelector:@selector(inputView:willCoveredWithOffset:)])
        {
            [self.delegate inputView:inputView willCoveredWithOffset:offset];
        }
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(keyboardWillHide)])
    {
        [self.delegate keyboardHide];
    }
}

- (void)keyboardShow:(NSNotification *)notification
{
    _edit = YES;
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(keyboardShow)]) {
        [self.delegate keyboardShow];
    }
}

- (void)keyboardHide:(NSNotification *)notification
{
    _edit = NO;
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(keyboardHide)])
    {
        [self.delegate keyboardHide];
    }
    
    self.keyboardFrame = CGRectZero;
    self.inputView = nil;
}

- (void)editTapAction:(UITapGestureRecognizer *)tap
{
    if (_edit) {
        [self.view endEditing:YES];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return _edit && self.tapToDismiss;
}
@end
