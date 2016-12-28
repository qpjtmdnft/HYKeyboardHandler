使用说明：
界面截入时初始化：
self.keyboardHandler = [[HYKeyboardHandler alloc] initWithDelegate:self view:self.view];
[self.keyboardHandler startListen];

健盘被触发时，回调方法：- inputView:willCoveredWithOffset:方法将被调用，告知delegate当前使用键盘的控制以及该控件被键盘复盖的范围。
