
#import "BaseTableView.h"
#import "FBKVOController.h"

@interface BaseTableView ()

@property (nonatomic, strong) FBKVOController *kvoController;

@end

@implementation BaseTableView

/**
 同时识别多个手势

 @param gestureRecognizer gestureRecognizer description
 @param otherGestureRecognizer otherGestureRecognizer description
 @return return value description
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self){
        //默认无数据高度
        self.nullHeight = 20;
        self.isNull = YES;
        self.isShowNullButton = NO;
        [self drawSubviews];
        [self initFBKVO];
    }
    return self;
}

//可以自定义的view,可以添加图片按钮等，这里只是简单的显示个label
- (void)drawSubviews {
    _nullImageView = [[UIImageView alloc] init];
    [self addSubview:_nullImageView];
    [_nullImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(130);
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(130);
        make.height.mas_equalTo(130);
    }];
    _nullImageView.image = [UIImage imageNamed:@"NullDataView"];
    
    _nullLabel = [[UILabel alloc] init];
    _nullLabel.center = self.center;
    _nullLabel.font = [UIFont systemFontOfSize:14];
    _nullLabel.textAlignment = NSTextAlignmentCenter;
    _nullLabel.textColor = AppGrayTextColor;
    [self addSubview:_nullLabel];
    [_nullLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self->_nullImageView.mas_bottom).offset(15);
        make.centerX.mas_equalTo(self);
    }];
    
    _nullButton = [UIButton new];
    [self addSubview:_nullButton];
    [_nullButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self->_nullLabel.mas_bottom).offset(30);
        make.width.mas_equalTo(95);
        make.height.mas_equalTo(42);
        make.centerX.mas_equalTo(self);
    }];
    [_nullButton setTitle:@"去逛逛" forState:(UIControlStateNormal)];
    _nullButton.backgroundColor = AppThemeColor;
    [_nullButton setTitleColor:AppWhiteColor forState:(UIControlStateNormal)];
    _nullButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_nullButton addTarget:self action:@selector(nullButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    _nullButton.hidden = YES;
    [_nullButton xlsn0w_addCornerRadius:20];
}

- (void)nullButtonAction:(UIButton*)nullButton {
    if (self.nullButtonAction) {
        self.nullButtonAction();
    }
}

- (void)setIsShowNullButton:(BOOL)isShowNullButton {
    _isShowNullButton = isShowNullButton;
    if (isShowNullButton == YES) {
        self.nullButton.hidden = NO;
    } else {
        self.nullButton.hidden = YES;
    }
}

//关键代码
- (void)initFBKVO {
    //KVO
    __weak typeof (self) weakSelf = self;
    self.kvoController = [FBKVOController controllerWithObserver:self];
    @WeakObj(self);
    [self.kvoController observe:self keyPath:@"contentSize" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        // contentSize有了变化即会走这里
        CGFloat height =  weakSelf.contentSize.height;
        XLsn0wLog(@"BaseTableView.contentSize.height = %f", height);
        //如果高度大于我们规定的无数据时的高度则隐藏无数据界面，否则展示
        if (height > weakSelf.nullHeight){
            selfWeak.nullLabel.hidden = YES;
            selfWeak.nullImageView.hidden = YES;
            selfWeak.nullButton.hidden = YES;
        } else { /// <= nullHeight
            selfWeak.nullLabel.hidden = NO;
            selfWeak.nullImageView.hidden = NO;
            if (selfWeak.isShowNullButton == YES) {
                selfWeak.nullButton.hidden = NO;
            }
        }
        
    }];
    
    
    [self.kvoController observe:self keyPath:@"isNull" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        
        if (self.isNull == YES){
            selfWeak.nullLabel.hidden = NO;
            selfWeak.nullImageView.hidden = NO;
        }else {
            selfWeak.nullLabel.hidden = YES;
            selfWeak.nullImageView.hidden = YES;
        }
        
    }];
}

@end
