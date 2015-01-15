//
//  FirstViewController.m
//  AutoLayout
//
//  Created by Ricky Cancro on 1/14/15.
//  Copyright (c) 2015 Ricky Cancro. All rights reserved.
//

#import "BasicsViewController.h"
#import "Masonry.h"

@interface AutoLayoutContainer : UIView

@end

@implementation AutoLayoutContainer

@end

@interface BasicsViewController ()
@property (nonatomic, strong) UILabel *autoLayoutLabel1;
@property (nonatomic, strong) UILabel *autoLayoutLabel2;
@end

@implementation BasicsViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"basics";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 3. This is created with a rect of zero. What?!? (go into tent example)
    AutoLayoutContainer *autolayoutContainerView = [[AutoLayoutContainer alloc] initWithFrame:CGRectZero];
    [self.view addSubview:autolayoutContainerView];
    
    autolayoutContainerView.backgroundColor = [UIColor lightGrayColor];
    [autolayoutContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        // 4. notice there is no height constraint. What is happening? intrinsicContentSize is happening
        //    labels have an intrinsic content size. that height + the offset constraints are used to compute
        //    this guys' height.
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(CGRectGetHeight(self.navigationController.navigationBar.frame) +  20);
    }];
    
    self.autoLayoutLabel1 = [[UILabel alloc] initWithFrame:CGRectZero];
    self.autoLayoutLabel1.backgroundColor = [UIColor yellowColor];
    self.autoLayoutLabel1.text = @"this is some text";
    [autolayoutContainerView addSubview:self.autoLayoutLabel1];
    
    self.autoLayoutLabel2 = [[UILabel alloc] initWithFrame:CGRectZero];
    self.autoLayoutLabel2.backgroundColor = [UIColor purpleColor];
    self.autoLayoutLabel2.text = @"this is some more important text";
    [autolayoutContainerView addSubview:self.autoLayoutLabel2];
    
    
    // 5. The constraints so far have been made with the help of Masonry. This is what it looks like to use the built in constraint creation:
    //    The visual ascii art isn't too bad, but unfortunately you can't do everything with it. Sometimes you have to use the much much more verbose
    //    method that creates a single constraint.
//    NSDictionary *views = NSDictionaryOfVariableBindings(_autoLayoutLabel1, _autoLayoutLabel2);
//    self.autoLayoutLabel1.translatesAutoresizingMaskIntoConstraints = self.autoLayoutLabel2.translatesAutoresizingMaskIntoConstraints = NO;
//    [autolayoutContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_autoLayoutLabel1]-[_autoLayoutLabel2]-|" options:NSLayoutFormatAlignAllTop metrics:nil views:views]];
//    [autolayoutContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_autoLayoutLabel1]-|" options:0 metrics:nil views:views]];
//    
//    // This constraint is not needed if we change the first visual constraint above to @"H:|-[_autoLayoutLabel1]-[_autoLayoutLabel2]-|"
//    [autolayoutContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.autoLayoutLabel1
//                                                                        attribute:NSLayoutAttributeLeft
//                                                                        relatedBy:NSLayoutRelationEqual
//                                                                           toItem:autolayoutContainerView
//                                                                        attribute:NSLayoutAttributeLeft
//                                                                       multiplier:1.f
//                                                                         constant:10.f]];
    
    
    // 1. Create the constraints so that the two labels fit for the given width of the view
    // 2. Uncomment these compression resistances and see how we can do more than springs/struts
    //[self.autoLayoutLabel1 setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.autoLayoutLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(autolayoutContainerView).offset(10);
        make.left.equalTo(autolayoutContainerView).offset(10);
        make.bottom.equalTo(autolayoutContainerView).offset(-10);
        make.right.equalTo(self.autoLayoutLabel2.mas_left).offset(-10);
    }];
    
    //[self.autoLayoutLabel2 setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.autoLayoutLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.autoLayoutLabel1);
        make.bottom.equalTo(self.autoLayoutLabel1);
        make.right.equalTo(autolayoutContainerView).offset(-10);
    }];
}

@end
