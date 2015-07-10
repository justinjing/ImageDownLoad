//
//  ViewController.m
//  ImageLoad
//
//  Created by justinjing on 15/7/10.
//  Copyright (c) 2015年 justinjing. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+URLImage.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSString *imageUrl=@"http://a.hiphotos.baidu.com/image/pic/item/0b46f21fbe096b638e97a0fd0f338744eaf8ac95.jpg";
    NSString *imageUrl2=@"http://h.hiphotos.baidu.com/image/pic/item/4afbfbedab64034fcf2fcb0cadc379310b551ddd.jpg";
    
    UIImageView  *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0,45.0,[UIScreen mainScreen].bounds.size.width,300)];
    [imageView setImageWithUrl:imageUrl placeholderImgName:@"no_image80" progress:^(int progress, NSError *error) {
        NSLog(@"imageView==%d",progress);
    }];
    [self.view addSubview:imageView];
 
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button1.frame = CGRectMake(0,CGRectGetMaxY(imageView.frame)+50,[UIScreen mainScreen].bounds.size.width,200);
    button1.backgroundColor = [UIColor clearColor];
    [button1 setImage:[UIImage imageNamed:@"btng.png"] forState:UIControlStateNormal];
    [button1 setBackImageWithUrl:imageUrl2 placeholderImgName:@"no_image80" progress:^(int progress, NSError *error) {
        NSLog(@"button==%d",progress);
    }];
    [button1 setTitle:@"点击" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(butClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
}

-(void)butClick:(UIButton *)sender
{
    NSLog(@"button  touched");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
