//
//  BestPracticesViewController.m
//  AutoLayout
//
//  Created by Ricky Cancro on 1/14/15.
//  Copyright (c) 2015 Ricky Cancro. All rights reserved.
//

#import "BestPracticesViewController.h"
#import "Masonry.h"

@implementation FancyImageView

- (instancetype)initWithImage:(UIImage *)image andWidth:(CGFloat)width
{
    self = [super initWithImage:image];
    if (self) {
        _width = width;
    }
    return self;
}

- (void)setWidth:(CGFloat)width
{
    _width = width;
    [self invalidateIntrinsicContentSize];
}

- (CGSize)intrinsicContentSize
{
    CGFloat height = ceilf((self.width * self.image.size.height) / (self.image.size.width));
    return CGSizeMake(self.width, height);
}

@end



@interface BestPracticesViewController ()
@property (nonatomic, strong) MASConstraint *leftOffsetConstraint;
@property (nonatomic, assign) BOOL contrivedAnimateFlag;
@property (nonatomic, strong) FancyImageView *fancyImageView;
@property (nonatomic, strong) UILabel *anchorLabel;
@end

@implementation BestPracticesViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"best practices";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = self.navigationItem.title = @"best practices";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"animate" style:UIBarButtonItemStyleDone target:self action:@selector(animate:)];
    
    // 1. Try to anchor one view and base all other views off that if applicable.
    UILabel  *label1a = [[UILabel alloc] initWithFrame:CGRectZero];
    self.anchorLabel = label1a;
    label1a.backgroundColor = [UIColor yellowColor];
    label1a.text = @"this is some text";
    [self.view addSubview:label1a];
    
    UILabel *label1b = [[UILabel alloc] initWithFrame:CGRectZero];
    label1b.backgroundColor = [UIColor purpleColor];
    label1b.text = @"this is some more important text";
    [self.view addSubview:label1b];
    
    [label1a mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(CGRectGetHeight(self.navigationController.navigationBar.frame) +  20);
       self.leftOffsetConstraint = make.left.equalTo(self.view).offset(10);
        make.right.equalTo(label1b.mas_left).offset(-10);
    }];
    
    [label1b mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label1a);
        make.bottom.equalTo(label1a);
        make.right.equalTo(self.view).offset(-10);
    }];
    
    UILabel *label2a = [[UILabel alloc] initWithFrame:CGRectZero];
    label2a.backgroundColor = [UIColor yellowColor];
    label2a.text = @"this is some text";
    [self.view addSubview:label2a];
    
    UILabel *label2b = [[UILabel alloc] initWithFrame:CGRectZero];
    label2b.backgroundColor = [UIColor purpleColor];
    label2b.text = @"this is some more important text";
    [self.view addSubview:label2b];
    
    [label2a mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label1a.mas_bottom).offset(10);
        make.left.equalTo(label1a);
        make.right.equalTo(label1a);
    }];
    
    [label2b mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label2a);
        make.bottom.equalTo(label2a);
        make.right.equalTo(label1b);
        make.left.equalTo(label1b);
    }];

    // 4, Ideally you will never set the height or width of a view via a constraint. If you find yourself doing this a lot, then
    //    something is probably wrong. An exception can be an imageView. An imageView's intrinsic content size is the size of the image
    //    that it is displaying in the view's contentmode. If you don't know the size of an image coming in, then an aspectFit mode
    //    may not fit the way you want.
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"kids"]];
    
    //    This is where you can get fancy and use an intrinsic content size. But you will have to provide the image the current width:
//    FancyImageView *imageView = [[FancyImageView alloc] initWithImage:[UIImage imageNamed:@"kids"] andWidth:CGRectGetWidth(self.view.frame) - 20];
//    self.fancyImageView = imageView;
    
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.backgroundColor = [UIColor redColor];
    [self.view addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label2a.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
    }];
    
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    // since i'm using the resizeable sim i have to put this here because viewDidLoad doesn't have the proper bounds. :(
    [self.fancyImageView setWidth:CGRectGetWidth(self.view.frame) - 20];
}

- (void)animate:(id)sender
{
    self.contrivedAnimateFlag = !self.contrivedAnimateFlag;
    [self.view setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    // 2. If you need to update the value of a constraint, do it here in updateViewConstraints.
    //    A UIView has a similar method called updateConstraints.
    //    Typically you will keep a reference to the constraints that you want to update and change their values here.
    //    For the constraints to animate look above to the animate method. ^^
    
    if (self.contrivedAnimateFlag) {
        [self.leftOffsetConstraint setOffset:30.f];
        
        
        // 3. Masonry provides another way to do this via another constraint creation method called mas_updateConstraints.
        //    mas_updateConstraints will look for an existing constraint of the same type and update it to the new value.
        //
        //    Masonry also provides a method called mas_remakeConstraints that will remove all existing constraints and then
        //    readd the new ones. If possible try to use this. This will require the constraint engine to be run again to
        //    determine if the constraints are valid. If you are only updating what has already been created it is much
        //    less costly.
        
//        [self.anchorLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.view).offset(30);
//        }];
        
    } else {
        [self.leftOffsetConstraint setOffset:10.f];
        
//        [self.anchorLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.view).offset(10);
//        }];
    }
    
}

@end
