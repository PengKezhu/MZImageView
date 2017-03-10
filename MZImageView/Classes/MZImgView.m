//
//  MZImgView.m
//
//  Created by Pillian on 2017/3/9.
//  Copyright © 2017年 Pkz. All rights reserved.
//

#import "MZImgView.h"
#import "UIImageView+AFNetworking.h"

static NSTimeInterval DURATION = 0.2;
static float MAXZOOMSCALE = 1.5;
static float MINZOOMSCALE = 1.0;
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface MZImgView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *operationImgView; //操作（捏合）的图片
@property (nonatomic, strong) UIScrollView *scrollView;		 //背景滚动视图

@end

@implementation MZImgView

- (void)awakeFromNib {
  [super awakeFromNib];
  [self setUp];
}

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
	 [self setUp];
  }
  return self;
}

- (instancetype)initWithImage:(UIImage *)image
{
  self = [super initWithImage:image];
  if (self) {
	 [self setUp];
  }
  return self;
}

- (void)setUp {
  self.userInteractionEnabled = YES;
  UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
  [self addGestureRecognizer:tapGes];
  
  self.operationImgView = [[UIImageView alloc] init];
  self.operationImgView.userInteractionEnabled = NO;
  self.operationImgView.alpha = 0;
  
  _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
  _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
  _scrollView.delegate = self;
  _scrollView.alwaysBounceVertical = YES;
  _scrollView.alwaysBounceHorizontal = YES;
  _scrollView.backgroundColor = [UIColor blackColor];
  _scrollView.showsVerticalScrollIndicator = NO;
  _scrollView.showsHorizontalScrollIndicator = NO;
  
  [_scrollView addSubview:_operationImgView];
  _scrollView.maximumZoomScale = MAXZOOMSCALE;
  
  UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapped:)];
  [_scrollView addGestureRecognizer:singleTapGesture];
  
  UITapGestureRecognizer *doubleTapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapped:)];
  doubleTapGes.numberOfTapsRequired = 2;
  [_scrollView addGestureRecognizer:doubleTapGes];

  [singleTapGesture requireGestureRecognizerToFail:doubleTapGes];
}

#pragma mark -- UITapGestureRecognizer

- (void)tapped:(UITapGestureRecognizer *)tapGes {
  self.operationImgView.frame = [self.superview convertRect:self.frame toView:[[UIApplication sharedApplication].delegate window]];
  self.operationImgView.image = self.image;
  _scrollView.zoomScale = MINZOOMSCALE;
  _scrollView.contentOffset = CGPointMake(0, 0);
  [[[UIApplication sharedApplication].delegate window] addSubview:_scrollView];
  
  __weak __typeof(self) weakSelf = self;
  [UIView animateWithDuration:DURATION animations:^{
	 __strong __typeof(weakSelf) self = weakSelf;
	 self.operationImgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
	 self.operationImgView.alpha = 1;
  }];
}

- (void)singleTapped:(UITapGestureRecognizer *)tapGes {
  [self hideBigPicture];
}

- (void)doubleTapped:(UITapGestureRecognizer *)tapGes {
  if (_scrollView.zoomScale < _scrollView.maximumZoomScale) {
	 _scrollView.zoomScale = _scrollView.maximumZoomScale;
  } else {
	 _scrollView.zoomScale = _scrollView.minimumZoomScale;
  }
}

#pragma mark -- UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
  return _operationImgView;
}

- (void)hideBigPicture {
  __weak __typeof(self) weakSelf = self;
	 [UIView animateWithDuration:DURATION animations:^{
		__strong __typeof(weakSelf) self = weakSelf;
		self.scrollView.zoomScale = 1;
		self.operationImgView.frame = [self.superview convertRect:self.frame toView:[[UIApplication sharedApplication].delegate window]];
	 } completion:^(BOOL finished) {
		[self.operationImgView.superview removeFromSuperview];
	 }];
}

- (void)setImageWithUrl:(NSURL *)srcUrl placeHolderImage:(UIImage *)holderImage {
  [self setImageWithURL:srcUrl placeholderImage:holderImage];
}

@end
