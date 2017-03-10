//
//  MZImgView.h
//
//  Created by Pillian on 2017/3/9.
//  Copyright © 2017年 Pkz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MZImgView : UIImageView

- (void)setImageWithUrl:(NSURL *)srcUrl placeHolderImage:(UIImage *)holderImage;

@end
