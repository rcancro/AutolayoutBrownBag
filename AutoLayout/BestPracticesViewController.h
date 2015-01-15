//
//  BestPracticesViewController.h
//  AutoLayout
//
//  Created by Ricky Cancro on 1/14/15.
//  Copyright (c) 2015 Ricky Cancro. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FancyImageView : UIImageView
@property (nonatomic, assign) CGFloat width;
- (instancetype)initWithImage:(UIImage *)image andWidth:(CGFloat)width;
@end

@interface BestPracticesViewController : UIViewController

@end
