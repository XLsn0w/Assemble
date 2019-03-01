//
//  BossSharePanel.m
//  GTSharePanel
//
//  Created by law on 2018/8/23.
//  Copyright © 2018年 Goldx4. All rights reserved.
//

#import "UmengShareView.h"
#import "UIButton+ImageTitleStyle.h"

typedef NS_ENUM(NSInteger, BossShareType) {
    BossShareTypeWXFriend,
    BossShareTypeWXTimeLine,
    BossShareTypeSM
};

static const CGFloat panelHeight = 135;

@interface UmengShareView ()
// mask
@property (nonatomic, strong) UIView *alphaMaskView;
// panel
@property (nonatomic, strong) UIVisualEffectView* shareBtnVisualEffectView;

@end

@implementation UmengShareView

- (instancetype)initWithDelegate:(id<UmengShareViewDelegate>)delegate {
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        [self addSubview:self.alphaMaskView];
        self.delegate = delegate;
    }
    return self;
}

- (void)show {
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.shareBtnVisualEffectView.frame;
        frame.origin.y = kScreenHeight - frame.size.height;
        self.shareBtnVisualEffectView.frame = frame;
        self.alphaMaskView.alpha = 0.4;
    } completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(sharePanelDidShow:)]) {
            [self.delegate sharePanelDidShow:self];
        }
        [kAppWindow addSubview:self];///show
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.shareBtnVisualEffectView.frame;
        frame.origin.y = kScreenHeight;
        self.shareBtnVisualEffectView.frame = frame;
        self.alphaMaskView.alpha = 0;
    } completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(sharePanelDidDismiss:)]) {
            [self.delegate sharePanelDidDismiss:self];
        }
        [self removeFromSuperview];
    }];
}

#pragma mark - Getters

- (UIView *)alphaMaskView {
    if (!_alphaMaskView) {
        _alphaMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-panelHeight-kHomeIndicatorH)];
        _alphaMaskView.backgroundColor = [UIColor darkGrayColor];
        _alphaMaskView.alpha = 0.f;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [_alphaMaskView addGestureRecognizer:tap];
    }
    return _alphaMaskView;
}

- (UIVisualEffectView *)shareBtnVisualEffectView {
    if (!_shareBtnVisualEffectView) {

        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _shareBtnVisualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        [self addSubview:self.shareBtnVisualEffectView];
        _shareBtnVisualEffectView.backgroundColor = AppWhiteColor;
        [_shareBtnVisualEffectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.height.mas_equalTo(panelHeight);
            make.width.mas_equalTo(kScreenWidth);
            if (@available(iOS 11.0, *)) {///底部适配X
                make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom);
            } else {
                make.bottom.equalTo(self.mas_bottom);
            }
        }];
        
        if (iPhoneX || iPhoneXr || iPhoneXs_Max) {///适配
            UIView* whiteView = [UIView new];
            [self addSubview:whiteView];
            [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.height.mas_equalTo(34);
                make.bottom.mas_equalTo(0);
            }];
            whiteView.backgroundColor = AppWhiteColor;
        }
        
        // cancel button
        UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 95, kScreenWidth, 40)];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:AppBlackTextColorAlpha forState:UIControlStateNormal];
        [cancelButton setBackgroundImage:[UIImage xlsn0w_imageWithColor:AppLineColor] forState:(UIControlStateHighlighted)];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightThin];
        [cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [_shareBtnVisualEffectView.contentView addSubview:cancelButton];
        
        // share buttons
        CGFloat btnY = 20.f;
        CGFloat btnW = 50.f;
        CGFloat btnH = 54.f;
        CGFloat margin = (kScreenWidth-btnW*3)/4-20;
        
        UIButton *wechat = [UIButton buttonWithType:UIButtonTypeCustom];
        wechat.frame = CGRectMake(margin, btnY, btnW, btnH);
        [wechat setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        wechat.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightThin];
        [wechat setTitle:@"微信" forState:UIControlStateNormal];
        [wechat setImage:[UIImage imageNamed:@"share_icon_wechat"] forState:UIControlStateNormal];
        [wechat setButtonImageTitleStyle:ButtonImageTitleStyleTop padding:8];
        wechat.tag = BossShareTypeWXFriend;
        [wechat addTarget:self action:@selector(clickShareButton:) forControlEvents:UIControlEventTouchUpInside];
        [_shareBtnVisualEffectView.contentView addSubview:wechat];
        
        UIButton *timeline = [UIButton buttonWithType:UIButtonTypeCustom];
        timeline.frame = CGRectMake(margin*2+btnW, btnY, btnW, btnH);
        [timeline setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        timeline.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightThin];
        [timeline setTitle:@"朋友圈" forState:UIControlStateNormal];
        [timeline setImage:[UIImage imageNamed:@"share_icon_wechatfriends"] forState:UIControlStateNormal];
        [timeline setButtonImageTitleStyle:ButtonImageTitleStyleTop padding:8];
        timeline.tag = BossShareTypeWXTimeLine;
        [timeline addTarget:self action:@selector(clickShareButton:) forControlEvents:UIControlEventTouchUpInside];
        [_shareBtnVisualEffectView.contentView addSubview:timeline];
        
        // seperators
        UIView *seperator1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
        seperator1.backgroundColor = AppLineColor;
        [_shareBtnVisualEffectView.contentView addSubview:seperator1];
        UIView *seperator2 = [[UIView alloc] initWithFrame:CGRectMake(0, 95, kScreenWidth, 0.5)];
        seperator2.backgroundColor = AppLineColor;
        [_shareBtnVisualEffectView.contentView addSubview:seperator2];
    }
    return _shareBtnVisualEffectView;
}

- (void)clickShareButton:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(shareFromBtnTag:btnTitle:)]) {
        [self.delegate shareFromBtnTag:button.tag btnTitle:button.currentTitle];
    }
    [self dismiss];
}

@end
