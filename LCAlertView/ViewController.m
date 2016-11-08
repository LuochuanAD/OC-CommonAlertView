//
//  ViewController.m
//  LCAlertView
//
//  Created by care on 16/11/8.
//  Copyright © 2016年 luochuan. All rights reserved.
//

#import "ViewController.h"
#import "CommonAlertView.h"
@interface ViewController ()
{
    NSString *oriName;
    NSString *oriIdnumber;

}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    oriName=@"luochuanAD";
    oriIdnumber=@"110110110110";
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    CommonAlertView *alertView=[CommonAlertView alertViewWithCancelbtnClicked:^{
        
    } andSureBtnClicked:^(NSString *name, NSString *idnumber) {
        NSLog(@"-------确定按钮点击后 姓名和身份证号参数----%@,%@",name,idnumber);
        //保存修改后的姓名和身份证号
        oriName=name;
        oriIdnumber=idnumber;
        
    } withName:oriName withidcard:oriIdnumber];
    UIView *keywindow=[UIApplication sharedApplication].keyWindow;
    [keywindow addSubview:alertView];
}

@end
