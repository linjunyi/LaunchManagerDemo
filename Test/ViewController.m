//
//  ViewController.m
//  Test
//
//  Created by 林君毅 on 2023/1/4.
//

#import "ViewController.h"
#import "FBLaunchManager.h"
#import "TestLazyLoadModule.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-100, 120, 200, 80)];
    btn.backgroundColor = [UIColor yellowColor];
    [btn setTitle:@"注册LazyLoad模块" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)clickBtn {
    [[FBLaunchManager sharedInstance] getModuleByName:NSStringFromClass([TestLazyLoadModule class])];
}

@end
