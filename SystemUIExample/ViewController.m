//
//  ViewController.m
//  SystemUIExample
//
//  Created by huihuadeng on 2018/4/16.
//  Copyright © 2018年 huihuadeng. All rights reserved.
//

#import "ViewController.h"
#import "SHIAlertView.h"
#import "SHIPresentBottomVC.h"

@interface ViewController (){
    UIWindow *_window;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:button];
    button. backgroundColor = [UIColor blueColor];
    button.frame = CGRectMake(0, 100, 300, 300);
    [self.view addSubview:button];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)buttonAction:(UIButton *)button{
    
//    SHIPresentBottomVC *vc = [[SHIPresentBottomVC alloc] init];
//      vc.modalPresentationStyle = UIModalPresentationCustom ;
//    [self presentViewController:vc animated:YES completion:^{
//        
//    }];
//    return;
//    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"titl" message:@"message" preferredStyle:UIAlertControllerStyleActionSheet];
//    UIAlertAction *action = [UIAlertAction actionWithTitle:@"默认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//    }];
//    [vc addAction:action];
//    [self presentViewController:vc animated:YES completion:^{
//        
//    }];
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"message" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:nil];
//    [alert show];
    
//    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"提示" delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:@"destructive" otherButtonTitles:@"a",@"b",@"c",nil];
//    [actionSheet showInView:actionSheet];    

    SHIAlertView *alerts = [SHIAlertView alertViewWithTitle:@"提示" message:@"我是邓会花" preferredStyle:SHIAlertControllerStyleActionSheet];
    [alerts addAction:[SHIAlertAction actionWithTitle:@"取消" style:SHIAlertActionStyleCancel handler:^(SHIAlertAction * _Nonnull action) {
        NSLog(@"cancel click");
    }]];
    [alerts addAction:[SHIAlertAction actionWithTitle:@"确定" style:SHIAlertActionStyleDefault handler:^(SHIAlertAction * _Nonnull action) {
        NSLog(@"cancel click");
    }]];
    
    [alerts addAction:[SHIAlertAction actionWithTitle:@"删除" style:SHIAlertActionStyleDestructive handler:^(SHIAlertAction * _Nonnull action) {
        NSLog(@"cancel click");
    }]];
    [alerts show];
    _window = alerts;
//    [self.view addSubview:alerts];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
