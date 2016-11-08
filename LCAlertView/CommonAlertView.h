//
//  CommonAlertView.h
//  LCAlertView
//
//  Created by care on 16/11/8.
//  Copyright © 2016年 luochuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^cancelBlock)();
typedef void(^sureBlock)(NSString*name,NSString*idnumber);

@interface CommonAlertView : UIView

@property(nonatomic, strong)cancelBlock cancel_block;
@property(nonatomic, strong)sureBlock sure_block;
+(instancetype)alertViewWithCancelbtnClicked:(cancelBlock) cancelBlock andSureBtnClicked:(sureBlock) sureBlock withName:(NSString *)name withidcard:(NSString *)idnumber;

@end
