//
//  PLoadStatusView.m
//
//  Created by 任清阳 on 15/11/5.
//  Copyright © 2015年 zhongan. All rights reserved.
//

#import "PLoadStatusView.h"

#import "PLoadStatusViewSet.h"
#import "PLoadStatusViewSetSource.h"

@interface UIView (ConstraintBasedLayoutExtensions)

- (NSLayoutConstraint *)equallyRelatedConstraintWithView:(UIView *)view
                                               attribute:(NSLayoutAttribute)attribute;

@end


@interface PLoadStatusView () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *btn;

@property (nonatomic, strong) UIView *customView;

@property (nonatomic, assign) CGFloat space;

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

/// 是否显示渐入渐出
@property (nonatomic, assign) BOOL fadeInOnDisplay;

- (void)setupConstraints;

@end


@implementation PLoadStatusView

#pragma mark - ******************************************* Init and Uninit *************************

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        /// 添加收拾代理
        self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadStatusViewDidTapContentView:)];

        self.tapGesture.delegate = self;

        [self addGestureRecognizer:self.tapGesture];

        [self addSubview:self.contentView];
    }
    return self;
}

#pragma mark - 刷新布局约束

- (void)setupConstraints
{
    NSLayoutConstraint *centerXConstraint = [self equallyRelatedConstraintWithView:self.contentView attribute:NSLayoutAttributeCenterX];
    NSLayoutConstraint *centerYConstraint = [self equallyRelatedConstraintWithView:self.contentView attribute:NSLayoutAttributeCenterY];

    [self addConstraint:centerXConstraint];
    [self addConstraint:centerYConstraint];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView]|" options:0 metrics:nil views:@{ @"contentView" : _contentView }]];

    if (self.offsetY != 0 && self.constraints.count > 0)
    {
        centerYConstraint.constant = self.offsetY;
    }

    if (_customView)
    {
        [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[customView]|" options:0 metrics:nil views:@{ @"customView" : _customView }]];
        [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[customView]|" options:0 metrics:nil views:@{ @"customView" : _customView }]];
    }
    else
    {
        CGFloat width = CGRectGetWidth(self.frame) ?: CGRectGetWidth([UIScreen mainScreen].bounds);

        CGFloat padding = roundf(width / 16.0);

        CGFloat space = self.space ?: 11.0; /// 默认对象之间间距为11.0

        NSMutableArray *subviewStrings = [NSMutableArray array];
        NSMutableDictionary *views = [NSMutableDictionary dictionary];
        NSDictionary *metrics = @{ @"padding" : @(padding) };

        if (_imageView.superview)
        {
            [subviewStrings addObject:@"imageView"];
            views[[subviewStrings lastObject]] = _imageView;

            CGSize imageViewSize = [self p_imageViewSize];

            if (!CGSizeEqualToSize(imageViewSize, CGSizeZero))
            {
                NSString *stringLayoutConstraintH = [NSString stringWithFormat:@"H:|-(>=0)-[imageView(%.f)]-(>=0)-|", imageViewSize.width];
                NSString *stringLayoutConstraintV = [NSString stringWithFormat:@"V:|-(>=0)-[imageView(%.f)]-(>=0)-|", imageViewSize.height];

                [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:stringLayoutConstraintH options:0 metrics:nil views:@{ @"imageView" : _imageView }]];
                [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:stringLayoutConstraintV options:0 metrics:nil views:@{ @"imageView" : _imageView }]];
            }

            [self.contentView addConstraint:[self.contentView equallyRelatedConstraintWithView:_imageView attribute:NSLayoutAttributeCenterX]];
        }

        if ([self canShowTitle])
        {
            [subviewStrings addObject:@"titleLabel"];
            views[[subviewStrings lastObject]] = _titleLabel;

            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding)-[titleLabel(>=0)]-(padding)-|"
                                                                                     options:0
                                                                                     metrics:metrics
                                                                                       views:views]];
        }
        else
        {
            [_titleLabel removeFromSuperview];
            _titleLabel = nil;
        }

        if ([self canShowDetail])
        {
            [subviewStrings addObject:@"detailLabel"];
            views[[subviewStrings lastObject]] = _detailLabel;

            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding@750)-[detailLabel(>=0)]-(padding@750)-|"
                                                                                     options:0
                                                                                     metrics:metrics
                                                                                       views:views]];
        }
        else
        {
            [_detailLabel removeFromSuperview];
            _detailLabel = nil;
        }

        if ([self canShowButton])
        {
            [subviewStrings addObject:@"btn"];
            views[[subviewStrings lastObject]] = _btn;

            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding@750)-[btn(>=0)]-(padding@750)-|"
                                                                                     options:0
                                                                                     metrics:metrics
                                                                                       views:views]];
        }
        else
        {
            [_btn removeFromSuperview];
            _btn = nil;
        }

        NSMutableString *verticalFormat = [NSMutableString new];

        for (int i = 0; i < subviewStrings.count; i++)
        {
            NSString *string = subviewStrings[i];
            [verticalFormat appendFormat:@"[%@]", string];

            if (i < subviewStrings.count - 1)
            {
                [verticalFormat appendFormat:@"-(%.f@750)-", space];
            }
        }

        if (verticalFormat.length > 0)
        {
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|%@|", verticalFormat]
                                                                                     options:0
                                                                                     metrics:metrics
                                                                                       views:views]];
        }
    }
}

#pragma mark - ******************************************* View Lifecycle **************************

/// 将要被添加到父View
- (void)didMoveToSuperview
{
    self.frame = self.superview.bounds;

    kWeakifySelf;
    void (^fadeInBlock)(void) = ^{
        kStrongifySelf;

        if (self)
        {
            self.contentView.alpha = 1.0;
        }

    };

    if (self.fadeInOnDisplay)
    {
        [UIView animateWithDuration:0.25
                         animations:fadeInBlock
                         completion:NULL];
    }
    else
    {
        fadeInBlock();
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *hitView = [super hitTest:point withEvent:event];

    if ([hitView isKindOfClass:[UIControl class]])
    {
        return hitView;
    }

    if ([hitView isEqual:_contentView] || [hitView isEqual:_customView])
    {
        return hitView;
    }

    return nil;
}

#pragma mark - ******************************************* LoadData and cancelLoadData *************


#pragma mark - ******************************************* Net Connection Event ********************


#pragma mark - ******************************************* Touch Event *****************************

#pragma mark - Action Methods

- (void)didTapButton:(id)sender
{
    if (self.loadStatusViewSetDelegate && [self.loadStatusViewSetDelegate respondsToSelector:@selector(i_loadStatusViewSet:didTapView:)])
    {
        [self.loadStatusViewSetDelegate i_loadStatusViewSet:self didTapButton:sender];
    }
}

- (void)loadStatusViewDidTapContentView:(id)sender
{
    if (self.loadStatusViewSetDelegate && [self.loadStatusViewSetDelegate respondsToSelector:@selector(i_loadStatusViewSet:didTapView:)])
    {
        [self.loadStatusViewSetDelegate i_loadStatusViewSet:self didTapView:sender];
    }
}

#pragma mark - ******************************************* Router Event ****************************


#pragma mark - ******************************************* Delegate Event **************************


#pragma mark - ******************************************* Notification Event **********************


#pragma mark - ******************************************* 属性变量的 Set 和 Get 方法 *****************

#pragma mark - Data Source Getters
/// 获取title
- (NSAttributedString *)p_titleLabelString
{
    if (self.loadStatusViewSetSourceDelegate && [self.loadStatusViewSetSourceDelegate respondsToSelector:@selector(i_titleForLoadStatusViewSet:)])
    {
        NSAttributedString *string = [self.loadStatusViewSetSourceDelegate i_titleForLoadStatusViewSet:self];

        if (!kString_Is_Valid(string))
        {
            return nil;
        }

        return string;
    }
    return nil;
}
/// 获取detail
- (NSAttributedString *)p_detailLabelString
{
    if (self.loadStatusViewSetSourceDelegate && [self.loadStatusViewSetSourceDelegate respondsToSelector:@selector(i_descriptionForLoadStatusViewSet:)])
    {
        NSAttributedString *string = [self.loadStatusViewSetSourceDelegate i_descriptionForLoadStatusViewSet:self];

        if (!kString_Is_Valid(string.string))
        {
            return nil;
        }

        return string;
    }
    return nil;
}
/// 获取imageView加载的image
- (UIImage *)p_image
{
    if (self.loadStatusViewSetSourceDelegate && [self.loadStatusViewSetSourceDelegate respondsToSelector:@selector(i_imgForLoadStatusViewSet:)])
    {
        UIImage *img = [self.loadStatusViewSetSourceDelegate i_imgForLoadStatusViewSet:self];

        return img;
    }
    return nil;
}
/// 获取btn title
- (NSAttributedString *)p_buttonTitleForState:(UIControlState)state
{
    if (self.loadStatusViewSetSourceDelegate && [self.loadStatusViewSetSourceDelegate respondsToSelector:@selector(i_btnTitleForLoadStatusViewSet:forState:)])
    {
        NSAttributedString *string = [self.loadStatusViewSetSourceDelegate i_btnTitleForLoadStatusViewSet:self forState:state];

        if (!kString_Is_Valid(string.string))
        {
            return nil;
        }

        return string;
    }
    return nil;
}
/// 获取btn的UIControlState所对应的image
- (UIImage *)p_buttonImageForState:(UIControlState)state
{
    if (self.loadStatusViewSetSourceDelegate && [self.loadStatusViewSetSourceDelegate respondsToSelector:@selector(i_btnImgForLoadStatusViewSet:forState:)])
    {
        UIImage *image = [self.loadStatusViewSetSourceDelegate i_btnImgForLoadStatusViewSet:self forState:state];

        return image;
    }
    return nil;
}
/// 获取btn的UIControlState所对应的BackgroundImage
- (UIImage *)p_buttonBackgroundImageForState:(UIControlState)state
{
    if (self.loadStatusViewSetSourceDelegate && [self.loadStatusViewSetSourceDelegate respondsToSelector:@selector(i_btnBackgroundImageForLoadStatusViewSet:forState:)])
    {
        UIImage *image = [self.loadStatusViewSetSourceDelegate i_btnBackgroundImageForLoadStatusViewSet:self forState:state];

        return image;
    }
    return nil;
}
/// 获取loadStatus所对应的背景色
- (UIColor *)p_dataSetBackgroundColor
{
    if (self.loadStatusViewSetSourceDelegate && [self.loadStatusViewSetSourceDelegate respondsToSelector:@selector(i_backgroundColorForLoadStatusViewSet:)])
    {
        UIColor *color = [self.loadStatusViewSetSourceDelegate i_backgroundColorForLoadStatusViewSet:self];

        return color;
    }
    return [UIColor clearColor];
}
/// 加载的自定义View
- (UIView *)p_customView
{
    if (self.loadStatusViewSetSourceDelegate && [self.loadStatusViewSetSourceDelegate respondsToSelector:@selector(i_customViewForLoadStatusViewSet:)])
    {
        UIView *view = [self.loadStatusViewSetSourceDelegate i_customViewForLoadStatusViewSet:self];

        return view;
    }
    return nil;
}
/// 获取对象之间间距
- (CGFloat)p_verticalSpace
{
    if (self.loadStatusViewSetSourceDelegate && [self.loadStatusViewSetSourceDelegate respondsToSelector:@selector(i_spaceHeightForLoadStatusViewSet:)])
    {
        return [self.loadStatusViewSetSourceDelegate i_spaceHeightForLoadStatusViewSet:self];
    }
    return 0.0;
}
/// 加载视图imageView的size
- (CGSize)p_imageViewSize
{
    if (self.loadStatusViewSetSourceDelegate && [self.loadStatusViewSetSourceDelegate respondsToSelector:@selector(i_imageViewSizeForLoadStatusViewSet:)])
    {
        return [self.loadStatusViewSetSourceDelegate i_imageViewSizeForLoadStatusViewSet:self];
    }
    return CGSizeZero;
}

#pragma mark - Getters

- (UIView *)contentView
{
    if (!_contentView)
    {
        _contentView = [UIView new];
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
        _contentView.backgroundColor = [UIColor clearColor];
        _contentView.userInteractionEnabled = YES;
        _contentView.alpha = 0;
    }
    return _contentView;
}

- (UIImageView *)imageView
{
    if (!_imageView)
    {
        _imageView = [UIImageView new];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.userInteractionEnabled = NO;
        _imageView.accessibilityIdentifier = @"空数据图片";

        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.backgroundColor = [UIColor clearColor];

        _titleLabel.font = kFont_System_Regular(12.0);
        _titleLabel.textColor =  [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];

        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLabel.numberOfLines = 0;
        _titleLabel.accessibilityIdentifier = @"空数据标题";

        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel)
    {
        _detailLabel = [UILabel new];
        _detailLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _detailLabel.backgroundColor = [UIColor clearColor];

        _detailLabel.font = kFont_System_Regular(15.0);
        _detailLabel.textColor =  [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        _detailLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _detailLabel.numberOfLines = 0;
        _detailLabel.accessibilityIdentifier = @"空数据详情描述";

        [self.contentView addSubview:_detailLabel];
    }
    return _detailLabel;
}

- (UIButton *)btn
{
    if (!_btn)
    {
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];

        _btn.translatesAutoresizingMaskIntoConstraints = NO;
        _btn.backgroundColor = [UIColor clearColor];
        _btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _btn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _btn.accessibilityIdentifier = @"空数据按钮";

        [_btn addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];

        [self.contentView addSubview:_btn];
    }
    return _btn;
}
/// 是否显示图片
- (BOOL)canShowImage
{
    return (_imageView.image && _imageView.superview);
}
/// 是否显示title
- (BOOL)canShowTitle
{
    return (_titleLabel.attributedText.string.length > 0 && _titleLabel.superview);
}
/// 是否显示描述信息
- (BOOL)canShowDetail
{
    return (_detailLabel.attributedText.string.length > 0 && _detailLabel.superview);
}
/// 是否显示btn
- (BOOL)canShowButton
{
    if ([_btn attributedTitleForState:UIControlStateNormal].string.length > 0
        || [_btn imageForState:UIControlStateNormal])
    {
        return (_btn.superview != nil);
    }
    return NO;
}
/// 是否允许touch
- (BOOL)isTouchAllowed
{
    if (self.loadStatusViewSetDelegate && [self.loadStatusViewSetDelegate respondsToSelector:@selector(i_loadStatusViewSetShouldAllowTouch:)])
    {
        return [self.loadStatusViewSetDelegate i_loadStatusViewSetShouldAllowTouch:self];
    }

    return YES;
}
/// 是否显示渐变动画
- (BOOL)isShouldFadeIn
{
    if (self.loadStatusViewSetDelegate && [self.loadStatusViewSetDelegate respondsToSelector:@selector(i_loadStatusViewSetShouldFadeIn:)])
    {
        return [self.loadStatusViewSetDelegate i_loadStatusViewSetShouldFadeIn:self];
    }

    return YES;
}

#pragma mark - Setters

- (void)setCustomView:(UIView *)customView
{
    if (!customView)
    {
        return;
    }

    if (_customView)
    {
        [_customView removeFromSuperview];
        _customView = nil;
    }

    _customView = customView;
    _customView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_customView];
}

#pragma mark - ******************************************* 基类方法 **********************************


#pragma mark - ******************************************* 私有方法 **********************************
/// 移除不拘约束
- (void)removeAllConstraints
{
    [self removeConstraints:self.constraints];
    [_contentView removeConstraints:_contentView.constraints];
}

#pragma mark - ******************************************* 对外方法 **********************************
/// 重置数据
- (void)prepareForReuse
{
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    _titleLabel = nil;
    _detailLabel = nil;
    _imageView = nil;
    _btn = nil;
    _customView = nil;

    [self removeAllConstraints];
}

/// 刷新数据
- (void)reloadLoadStatusView
{
    UIView *customView = [self p_customView];

    if (customView)
    {
        self.customView = customView;
    }
    else
    {
        NSAttributedString *titleLabelString = [self p_titleLabelString];
        NSAttributedString *detailLabelString = [self p_detailLabelString];

        UIImage *imgBtn = [self p_buttonImageForState:UIControlStateNormal];
        NSAttributedString *buttonTitle = [self p_buttonTitleForState:UIControlStateNormal];

        UIImage *img = [self p_image];

        self.space = [self p_verticalSpace];

        if (img)
        {
            self.imageView.image = img;
        }

        if (titleLabelString)
        {
            self.titleLabel.attributedText = titleLabelString;
        }

        if (detailLabelString)
        {
            self.detailLabel.attributedText = detailLabelString;
        }

        if (imgBtn)
        {
            [self.btn setImage:imgBtn forState:UIControlStateNormal];
            [self.btn setImage:[self p_buttonImageForState:UIControlStateHighlighted] forState:UIControlStateHighlighted];
        }
        else if (buttonTitle)
        {
            [self.btn setAttributedTitle:buttonTitle forState:UIControlStateNormal];
            [self.btn setAttributedTitle:[self p_buttonTitleForState:UIControlStateHighlighted] forState:UIControlStateHighlighted];
            [self.btn setBackgroundImage:[self p_buttonBackgroundImageForState:UIControlStateNormal] forState:UIControlStateNormal];
            [self.btn setBackgroundImage:[self p_buttonBackgroundImageForState:UIControlStateHighlighted] forState:UIControlStateHighlighted];
        }
    }

    self.backgroundColor = [self p_dataSetBackgroundColor];
    self.hidden = NO;
    self.clipsToBounds = YES;

    /// 是否允许点击事件
    self.userInteractionEnabled = [self isTouchAllowed];

    /// 是否允许渐入动画
    self.fadeInOnDisplay = [self isShouldFadeIn];

    [self setupConstraints];
}

#pragma mark - ******************************************* 类方法 ***********************************

@end


@implementation UIView (ConstraintBasedLayoutExtensions)

- (NSLayoutConstraint *)equallyRelatedConstraintWithView:(UIView *)view attribute:(NSLayoutAttribute)attribute
{
    return [NSLayoutConstraint constraintWithItem:view
                                        attribute:attribute
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:self
                                        attribute:attribute
                                       multiplier:1.0
                                         constant:0.0];
}

@end
