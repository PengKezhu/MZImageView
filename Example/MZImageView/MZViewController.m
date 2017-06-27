//
//  MZViewController.m
//  MZImageView
//
//  Created by Pillian on 03/10/2017.
//  Copyright (c) 2017 Pillian. All rights reserved.
//

#import "MZViewController.h"
#import <MZImageView/MZImgView.h>

@interface MZViewController ()

@property (weak, nonatomic) IBOutlet MZImgView *testImageView;

@end

@implementation MZViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [_testImageView setImageWithUrl:[NSURL URLWithString:@"http://image.tianjimedia.com/uploadImages/2012/188/8SW2C7S517U4_1000x500.jpg"] placeHolderImage:[UIImage imageNamed:@"刷新"]];
}

@end
