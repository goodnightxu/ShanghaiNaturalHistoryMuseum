/********************************************************************
 文件名称 : PublicMethod.h 文件
 作 者   :
 创建时间 : 2012-00-00
 文件描述 : 公共方法类
 *********************************************************************/

#import "PublicMethod.h"
#import <MBProgressHUD.h>

@implementation PublicMethod

+ (void)HUDForView:(UIView *)view withMessage:(NSString *)message {
    if (view) {
        [MBProgressHUD hideAllHUDsForView:view animated:NO];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        if (message.length>0) {
            hud.detailsLabelText = message;
            //        hud.margin = 10.f;
            //        hud.yOffset = 150.f;
            hud.removeFromSuperViewOnHide = YES;
        } else {
            hud.removeFromSuperViewOnHide = YES;
        }
    }
    
}

+ (void)HUDOnlyLabelForView:(UIView *)view withMessage:(NSString *)message {
    if (view) {
        [MBProgressHUD hideAllHUDsForView:view animated:NO];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = message;
        //	hud.margin = 10.f;
        //	hud.yOffset = 150.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:2];
    }
    
}

+ (void)HUDHideForView:(UIView *)view animated:(BOOL)flag {
    if (view) {
        [MBProgressHUD hideAllHUDsForView:view animated:flag];
    }
}


+ (void)resignKeyBoardInView:(UIView *)view
{
    for (UIView *v in view.subviews) {
        if ([v.subviews count] > 0) {
            [self resignKeyBoardInView:v];
        }
        
        if ([v isKindOfClass:[UITextView class]] || [v isKindOfClass:[UITextField class]]) {
            [v resignFirstResponder];
        }
    }
}


@end





