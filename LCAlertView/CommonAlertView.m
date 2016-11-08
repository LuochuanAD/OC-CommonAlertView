//
//  CommonAlertView.m
//  LCAlertView
//
//  Created by care on 16/11/8.
//  Copyright © 2016年 luochuan. All rights reserved.
//

#import "CommonAlertView.h"
#define LCWINDOWS [UIScreen mainScreen].bounds.size

@interface CommonAlertView()<UITextFieldDelegate>
@property (nonatomic, strong)UIView *blackView;//背景半透明遮罩
@property (strong,nonatomic)UIView * alertview;//弹框
@property (nonatomic, strong)UILabel *nameLable;//姓名Lable
@property (nonatomic, strong)UILabel *idcardLable;//身份证号lable
@property (nonatomic, strong)UITextField *nameTextFild;//姓名输入框
@property (nonatomic, strong)UITextField *idcardTextFild;//身份证号输入号
@property (nonatomic, strong)UIButton *cancelButton;//取消按钮
@property (nonatomic, strong)UIButton *sureButton;//确定按钮
@property (nonatomic, strong)NSString *name;//原始姓名的参数
@property (nonatomic, strong)NSString *idnumber;//原始身份证号的参数
@property (nonatomic, strong)UILabel *line1Lable;//灰色横线
@property (nonatomic, strong)UILabel *line2Lable;//灰色竖线
@end

@implementation CommonAlertView
- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        _blackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LCWINDOWS.width, LCWINDOWS.height+64)];
        _blackView.backgroundColor = [UIColor blackColor];
        _blackView.alpha = 0.5;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(blackClick)];
        tap.enabled=NO;
        [self.blackView addGestureRecognizer:tap];
        [self addSubview:_blackView];
        //创建alert
        self.alertview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 288, 183)];
        self.alertview.center = self.center;
        self.alertview.backgroundColor = [UIColor whiteColor];
        self.alertview.layer.cornerRadius=5.0f;
        [self addSubview:_alertview];
        [self animationAlert:self.alertview];
    }
    return self;
}
//在弹框的view上布局添加子view(如果想改变弹框里面的view样式布局,在此方法中修改)
- (void)layoutSubviews{
    [super layoutSubviews];
    
    _nameLable=[[UILabel alloc]initWithFrame:CGRectMake(10, 20, 68, 30)];
    _nameLable.textAlignment=NSTextAlignmentLeft;
    _nameLable.textColor=[self getColor:@"666666"];
    _nameLable.text=@"姓      名:";
    _nameLable.adjustsFontSizeToFitWidth=YES;
    [self.alertview addSubview:_nameLable];
    _nameTextFild=[[UITextField alloc]initWithFrame:CGRectMake(88, 20, 180, 30)];
    _nameTextFild.textAlignment=NSTextAlignmentLeft;
    _nameTextFild.borderStyle=UITextBorderStyleNone;
    _nameTextFild.layer.borderWidth=1.0f;
    _nameTextFild.layer.borderColor=[self getColor:@"dadada"].CGColor;
    _nameTextFild.textColor=[UIColor blackColor];
    _nameTextFild.secureTextEntry=NO;
    _nameTextFild.delegate=self;
    _nameTextFild.clearButtonMode=UITextFieldViewModeWhileEditing;
    if (self.name.length!=0) {
        _nameTextFild.text=self.name;
    }
    [self.alertview addSubview:_nameTextFild];
    
    _idcardLable=[[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_nameLable.frame)+33, 68, 30)];
    _idcardLable.textAlignment=NSTextAlignmentLeft;
    _idcardLable.textColor=[self getColor:@"666666"];
    _idcardLable.text=@"身份证号:";
    _idcardLable.adjustsFontSizeToFitWidth=YES;
    
    [self.alertview addSubview:_idcardLable];
    _idcardTextFild=[[UITextField alloc]initWithFrame:CGRectMake(88, CGRectGetMaxY(_nameTextFild.frame)+33, 180, 30)];
    _idcardTextFild.textAlignment=NSTextAlignmentLeft;
    _idcardTextFild.borderStyle=UITextBorderStyleNone;
    _idcardTextFild.layer.borderWidth=1.0f;
    _idcardTextFild.layer.borderColor=[self getColor:@"dadada"].CGColor;
    _idcardTextFild.textColor=[UIColor blackColor];
    _idcardTextFild.secureTextEntry=NO;
    _idcardTextFild.delegate=self;
    _idcardTextFild.clearButtonMode=UITextFieldViewModeWhileEditing;
    if (self.idnumber.length!=0) {
        _idcardTextFild.text=self.idnumber;
    }
    [self.alertview addSubview:_idcardTextFild];
    _line1Lable=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_idcardLable.frame)+19, self.alertview.bounds.size.width, 1)];
    _line1Lable.backgroundColor=[self getColor:@"e5e5e5"];
    [self.alertview addSubview:_line1Lable];
    _line2Lable=[[UILabel alloc]initWithFrame:CGRectMake(self.alertview.bounds.size.width/2-0.5, CGRectGetMaxY(_idcardLable.frame)+20, 1, 50)];
    _line2Lable.backgroundColor=[self getColor:@"e5e5e5"];
    [self.alertview addSubview:_line2Lable];
    
    _cancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _cancelButton.backgroundColor=[UIColor whiteColor];
    _cancelButton.frame=CGRectMake(0, CGRectGetMaxY(_idcardLable.frame)+20, self.alertview.bounds.size.width/2-0.5, 45);
    [_cancelButton setTitle:@"返  回" forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[self getColor:@"333333"] forState:UIControlStateNormal];
    [_cancelButton setBackgroundColor:[UIColor whiteColor]];
    [_cancelButton addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.alertview addSubview:_cancelButton];
    _sureButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _sureButton.backgroundColor=[UIColor whiteColor];
    _sureButton.frame=CGRectMake(self.alertview.bounds.size.width/2+0.5, CGRectGetMaxY(_idcardTextFild.frame)+20, self.alertview.bounds.size.width/2, 45);
    [_sureButton setTitle:@"修  改" forState:UIControlStateNormal];
    [_sureButton setBackgroundColor:[UIColor whiteColor]];
    [_sureButton setTitleColor:[self getColor:@"f4b249"] forState:UIControlStateNormal];
    [_sureButton addTarget:self action:@selector(sureBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.alertview addSubview:_sureButton];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}
//背景遮罩加点击手势,不做任何的处理
- (void)blackClick{
    
}
//创建
+(instancetype)alertViewWithCancelbtnClicked:(cancelBlock) cancelBlock andSureBtnClicked:(sureBlock) sureBlock withName:(NSString *)name withidcard:(NSString *)idnumber{
    CommonAlertView *alertView=[[CommonAlertView alloc]initWithFrame:CGRectMake(0, 0, LCWINDOWS.width,LCWINDOWS.height)];
    alertView.center=CGPointMake(LCWINDOWS.width/2, LCWINDOWS.height/2-64);//view的中点
    alertView.cancel_block=cancelBlock;//取消block
    alertView.sure_block=sureBlock;//确定block
    alertView.name=[NSString stringWithFormat:@"%@",name];//将传入的姓名参数接收
    alertView.idnumber=[NSString stringWithFormat:@"%@",idnumber];//将传入的身份证号参数接收
    
    return alertView;
    
}
//name字符串属性重写(注意:NSString类型的属性都要重写,不然会出现无法显示到界面的情况)
- (void)setName:(NSString *)name{
    
    _name=[NSString stringWithFormat:@"%@",name];
}
//idnumber字符串属性重写
- (void)setIdnumber:(NSString *)idnumber{
    
    _idnumber=[NSString stringWithFormat:@"%@",idnumber];
}
//取消按钮点击
- (void)cancelBtnClicked{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha=0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.alertview=nil;
        self.cancel_block();
    }];
    
    
}
//确定按钮点击
- (void)sureBtnClicked{
    //如果输入的姓名和身份证号不符合正则表达式,则return;(这里不做验证,请根据项目需求修改)
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha=0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.alertview=nil;
        //将新输入的姓名和身份证号值传出去.
        self.sure_block(_nameTextFild.text,_idcardTextFild.text);
    }];
    
}

//弹框动画自定义(可以修改参数改变动画)
- (void)animationAlert:(UIView *)view{
    CAKeyframeAnimation *popAnimation=[CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration=0.6;
    popAnimation.values=@[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],[NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes=@[@0.0f,@0.5f,@0.75f];
    popAnimation.timingFunctions=@[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [view.layer addAnimation:popAnimation forKey:nil];
    
}
//十六进制颜色转换
- (UIColor *)getColor:(NSString*)hexColor
{
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&red];
    
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&green];
    
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f)green:(float)(green / 255.0f) blue:(float)(blue / 255.0f)alpha:1.0f];
}



@end
