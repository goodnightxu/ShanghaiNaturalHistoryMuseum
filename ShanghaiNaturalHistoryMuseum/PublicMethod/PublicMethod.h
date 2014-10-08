/********************************************************************
 文件名称 : PublicMethod.h 文件
 作 者   :
 创建时间 : 2012-00-00
 文件描述 : 公共方法类
 *********************************************************************/

#import <Foundation/Foundation.h>
#import <MBProgressHUD.h>

@interface PublicMethod : NSObject

+ (void)HUDForView:(UIView *)view withMessage:(NSString *)message;
+ (void)HUDOnlyLabelForView:(UIView *)view withMessage:(NSString *)message;
+ (void)HUDHideForView:(UIView *)view animated:(BOOL)flag;
+ (void)resignKeyBoardInView:(UIView *)view;

@end












