
#import "UIViewController+AlertSheet.h"

#ifdef kSystemVersion_iOS8_Later
#else
static click clickIndex = nil;
static clickHaveField clickIncludeFields = nil;
static click clickDestructive = nil;
#endif
static NSMutableArray *fields = nil;

@implementation UIViewController (AlertSheet)

#pragma mark - *****  alert view
- (void)pushAlertWithTitle:(NSString *)title
                   message:(NSString *)message
                   buttons:(NSArray<NSString *> *)buttons
                  animated:(BOOL)animated
                    action:(click)click {
#ifdef kSystemVersion_iOS8_Later
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    NSMutableAttributedString *alertMsgStr = [[NSMutableAttributedString alloc] initWithString:message];
    [alertMsgStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, alertMsgStr.length)];
    [alertMsgStr addAttribute:NSForegroundColorAttributeName value:AppGrayTextColor range:NSMakeRange(0, alertMsgStr.length)];
    [alertController setValue:alertMsgStr forKey:@"attributedMessage"];
    [buttons enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:obj style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                if (action && click) {
                    click(idx);
                }
            }];
            [cancelAction setValue:AppBlackTextColor forKey:@"_titleTextColor"];
            [alertController addAction:cancelAction];
        } else {
            UIAlertAction* okAction = [UIAlertAction actionWithTitle:obj style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (action && click) {
                    click(idx);
                }
            }];
            [okAction setValue:AppThemeColor forKey:@"_titleTextColor"];
            [alertController addAction:okAction];
        }
    }];

    [self.view.window.rootViewController presentViewController:alertController animated:YES completion:nil];
#else
    UIAlertView *alertView = nil;
    if (others.count > 0) {
        alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:others[0] otherButtonTitles: nil];
    } else {
        alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
    }
    [others enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx != 0) {
            [alertView addButtonWithTitle:obj];
        }
    }];
    clickIndex = click;
    [alertView show];
#endif
}

#pragma mark - *****  alertView delegate

#ifdef kSystemVersion_iOS8_Later

#else
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (clickIndex) {
        clickIndex(buttonIndex);
    } else if (clickIncludeFields) {
        clickIncludeFields(fields,buttonIndex);
    }
    clickIndex = nil;
    clickIncludeFields = nil;
}
#endif

#pragma mark - *****  sheet
- (void)pushSheetWithTitle:(NSString *)title
                   message:(NSString *)message
               subtitle:(NSString *)subtitle
         subtitleAction:(click)subtitleAction
                   buttons:(NSArray<NSString *> *)buttons
                  animated:(BOOL)animated action:(click)click {
#ifdef kSystemVersion_iOS8_Later
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    if (subtitle) {
        [alertController addAction:[UIAlertAction actionWithTitle:subtitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            if (action) {
                subtitleAction(NO_USE);
            }
        }]];
    }
    [buttons enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:obj style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                if (action && click) {
                    click(idx);
                }
            }];
            [cancelAction setValue:[UIColor redColor] forKey:@"_titleTextColor"];
            [alertController addAction:cancelAction];
        } else {
            [alertController addAction:[UIAlertAction actionWithTitle:obj style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (action && click)
                {
                    click(idx);
                }
            }]];
        }
        
    }];
    [self presentViewController:alertController animated:animated completion:nil];
#else
    UIActionSheet *sheet = nil;
    if (others.count > 0 && destructive) {
        sheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:others[0] destructiveButtonTitle:destructive otherButtonTitles:nil];
    } else {
        sheet = [[UIActionSheet alloc] initWithTitle:title delegate:nil cancelButtonTitle:nil destructiveButtonTitle:destructive otherButtonTitles:nil];
    }
    [others enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx != 0) {
            [sheet addButtonWithTitle:obj];
        }
    }];
    clickIndex = click;
    clickDestructive = destructiveAction;
    [sheet showInView:self.view];
#endif
}

#ifdef kSystemVersion_iOS8_Later

#else
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        if (clickDestructive) {
            clickDestructive(NO_USE);
        }
    } else {
        if (clickIndex) {
            clickIndex(buttonIndex - 1);
        }
    }
}
#endif

#pragma mark - *****  textField
- (void)pushAlertWithTitle:(NSString *)title
                   message:(NSString *)message
                   buttons:(NSArray<NSString *> *)buttons
            textFieldCount:(NSInteger)count
             configuration:(configuration)configuration
                  animated:(BOOL)animated
                    action:(clickHaveField)click {
    if (fields == nil) {
        fields = [NSMutableArray array];
    } else {
        [fields removeAllObjects];
    }
    
#ifdef kSystemVersion_iOS8_Later
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    // textfield
    for (NSInteger i = 0; i < count; i++) {
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            [fields addObject:textField];
            configuration(textField,i);
        }];
    }
    // button
    [buttons enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            [alertController addAction:[UIAlertAction actionWithTitle:obj style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                if (action && click)
                {
                    click(fields,idx);
                }
            }]];
        }
        else {
            [alertController addAction:[UIAlertAction actionWithTitle:obj style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (action && click) {
                    click(fields,idx);
                }
            }]];
        }
    }];
    [self presentViewController:alertController animated:animated completion:nil];
#else
    UIAlertView *alertView = nil;
    if (buttons.count > 0) {
        alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:buttons[0] otherButtonTitles:nil];
    } else {
        alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    }
    // field
    if (number == 1) {
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    } else if (number > 2) {
        alertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    }
    // configuration field
    if (alertView.alertViewStyle == UIAlertViewStyleLoginAndPasswordInput) {
        [fields addObject:[alertView textFieldAtIndex:0]];
        [fields addObject:[alertView textFieldAtIndex:1]];
        
        configuration([alertView textFieldAtIndex:0],0);
        configuration([alertView textFieldAtIndex:1],1);
    } else if(alertView.alertViewStyle == UIAlertViewStylePlainTextInput || alertView.alertViewStyle == UIAlertViewStyleSecureTextInput) {
        [fields addObject:[alertView textFieldAtIndex:0]];
        configuration([alertView textFieldAtIndex:0],0);
    }
    // other button
    [buttons enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx != 0) {
            [alertView addButtonWithTitle:obj];
        }
    }];
    clickIncludeFields = click;
    [alertView show];
#endif
}
@end
