//
//  SecondViewController.m
//  AutoLayout
//
//  Created by Ricky Cancro on 1/14/15.
//  Copyright (c) 2015 Ricky Cancro. All rights reserved.
//

#import "AdvancedViewController.h"
#import "Masonry.h"
#import "BestPracticesViewController.h"

@interface FancyCell : UITableViewCell
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *leftImageView;

@property (nonatomic, strong) MASConstraint *labelBottomConstraint;
@property (nonatomic, strong) MASConstraint *imageBottomConstraint;
@end

#define USE_INEQUALITIES 1

@implementation FancyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _label = [[UILabel alloc] initWithFrame:CGRectZero];
        _label.backgroundColor = [UIColor redColor];
        _label.numberOfLines = 0;
        
        _leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"kids"]];
        [self.contentView addSubview:_label];
        [self.contentView addSubview:_leftImageView];
        
        // Note that these constriants MUST be on the cell's contentView. The cell's .view gets its mind blown if you try to put constraints on it.
        [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.top.equalTo(self.contentView).offset(10);
            make.right.equalTo(_label.mas_left).offset(-10);
            
            // OMG WHAT ARE YOU DOING?!?!?!? It is common (probably more common that the case of the FancyImageView) that design has decided they want an imageView of a certain dimension
            // especially in a cell. So we can constrain the w/h to fit what they want. If we know that ALL images that go into this type of cell are the size that design wants
            // then we wouldn't have to do this, but I'm using an image that is bigger than my 30x30 size.
            make.height.equalTo(@30);
            make.width.equalTo(@30);
            
#if USE_INEQUALITIES
            make.bottom.lessThanOrEqualTo(self.contentView.mas_bottom).offset(-10);;
#endif
        }];
        
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_leftImageView);
            make.right.equalTo(self.contentView).offset(-10);
            
#if USE_INEQUALITIES == 0
            // We need to fully constraint this cell -- so it has poles from the top to the bottom. So we need to make either the image or the label connect to the bottom
            // of the contentView. Problem is, we don't know which one will be taller. There are many ways to get around this. The first is to make the label's height greater
            // than or equal to the imageView. That works, but in the case where the image is larger the text will not be aligned at the top of the image, but at the center.
            make.height.greaterThanOrEqualTo(_leftImageView);
            make.bottom.equalTo(self.contentView).offset(-10);
#else
            // we can also do it with inequalities.
            // and probably dynamically or with priorities.
            make.bottom.lessThanOrEqualTo(self.contentView.mas_bottom).offset(-10);;
#endif
        }];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.label.preferredMaxLayoutWidth = CGRectGetWidth(self.label.frame);
}

@end

@interface AdvancedViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) FancyCell *sizingCell;
@end

@implementation AdvancedViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"advanced";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.tableView registerClass:[FancyCell class] forCellReuseIdentifier:@"cell"];
    
    self.data = @[@"As much a concept as a band, the Olivia Tremor Control ",
                  @"Bands of the Elephant 6 collective usually fall into two categories: those who function simply as rock historians recreating the sounds of the '60s (Of Montreal anyone?) and those who are able to extrapolate those influences into originality (the brilliant Olivia Tremor Control, Elf Power). From the first song on the EP, the effervescent \"Fabulous Day,\" the Essex Green firmly place themselves into the second group.",
                  @"EP California Demise"
                  ];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    FancyCell *cell = (FancyCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.label.text = self.data[indexPath.row];
    cell.leftImageView.image = [UIImage imageNamed:@"kids"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.sizingCell == nil) {
        self.sizingCell = [[FancyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        self.sizingCell.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    }
    
    self.sizingCell.label.text = self.data[indexPath.row];
    self.sizingCell.leftImageView.image = [UIImage imageNamed:@"kids"];
    [self.sizingCell.label setPreferredMaxLayoutWidth:CGRectGetWidth(self.view.bounds) - 30 - 30];
    
    [self.sizingCell setNeedsUpdateConstraints];
    [self.sizingCell updateConstraintsIfNeeded];

    self.sizingCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.sizingCell.frame));

    [self.sizingCell setNeedsLayout];
    [self.sizingCell layoutIfNeeded];
    
    CGFloat height = [self.sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    // this is a blight on society, but without it the labels will be clipped.
    height += 1;
    return ceilf(height);

}

@end
