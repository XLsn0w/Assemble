//
//  RCReloadView.m
//  RCReloadView
//
//  Created by Wangyefa on 2017/8/25.
//  Copyright © 2017年 血族. All rights reserved.
//

#import "ErrorView.h"

@interface ErrorView()

/**
 样式
 */
@property (nonatomic, assign) ReloadStyle style;

@property (nonatomic, copy) ReloadBlock block;

@property (nonatomic, strong) UIImageView *icon;

@property (nonatomic, strong) UILabel *descLabel;

@property (nonatomic, strong) UITapGestureRecognizer *tapGes;

@end

@implementation ErrorView

- (void)dealloc {
	NSLog(@"RCReloadView dealloc");
}

- (instancetype)initWithType:(ReloadStyle)style desc:(NSString *)desc clickBlock:(ReloadBlock)block {
	if (self = [super initWithFrame:CGRectZero]) {
		self.style = style;
		self.desc = desc;
		self.block = block;
		[self setup];
	}
	return self;
}

- (void)setup {
	NSString *imgPath = [self iamgeOfStyle:self.style];
	UIImage *img = [UIImage imageWithContentsOfFile:imgPath];
	_icon = [[UIImageView alloc]initWithImage:img];
	[self addSubview:_icon];
	_descLabel = [[UILabel alloc]init];
	_descLabel.textAlignment = NSTextAlignmentCenter;
	_descLabel.numberOfLines = 0;
	_descLabel.font = [UIFont systemFontOfSize:15];
	_descLabel.textColor = [UIColor colorWithWhite:0.8 alpha:1];
	_descLabel.text = self.desc;
	[self addSubview:_descLabel];
	_tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
	[self addGestureRecognizer: _tapGes];
}

- (void)layoutSubviews {
	_icon.center = self.center;
	CGRect bounds = [self.desc boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.frame), 999.0f) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]} context:nil];
	_descLabel.frame = CGRectMake(0, CGRectGetMaxY(_icon.frame) + 8, CGRectGetWidth(self.frame), bounds.size.height);
}

// 自定义

- (void)setDesc:(NSString *)desc {
	_desc = nil;
	_desc = [desc copy];
	if (_descLabel) {
		_descLabel.text = desc;
		[_descLabel sizeToFit];
		[self setNeedsLayout];
	}
}

- (void)setCustomIcon:(NSString *)customIcon {
	_customIcon = nil;
	_customIcon = [customIcon copy];
	UIImage *img = [UIImage imageNamed:customIcon];
	_icon.image = img;
	_icon.frame = CGRectMake(0, 0, img.size.width, img.size.height);
	[self setNeedsLayout];
}

/**
 tap 事件

 @param ges tap 手势
 */
- (void)tap:(UITapGestureRecognizer *)ges {
	if (self.block) {
		self.userInteractionEnabled = NO;
		self.block();
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			self.userInteractionEnabled = YES;
		});
	}
}

- (NSString *)iamgeOfStyle:(ReloadStyle)style {
	NSString *imgName;
	switch (style) {
		case ReloadStyleCry:
			imgName = @"cry";
			break;
		case ReloadStyleCryCube:
			imgName = @"cry_cube";
			break;
		case ReloadStyleSad:
			imgName = @"sad";
			break;
		case ReloadStyleCryDrop:
			imgName = @"cry_drop";
			break;
		case ReloadStyleCryPage:
			imgName = @"cry_page";
			break;
		case ReloadStyleError:
			imgName = @"error";
			break;
		case ReloadStyleWifi:
			imgName = @"wifi";
			break;
		case ReloadStyleEdginess:
			imgName = @"edginess";
			break;
		case ReloadStylePop:
			imgName = @"pop";
			break;
		case ReloadStyleCross:
			imgName = @"cross_sad";
			break;
			
		default:
			imgName = @"cry_page";
			break;
	}
	NSString * path = [[NSBundle mainBundle] pathForResource:@"RCReloadResouce" ofType:@"bundle"];
	NSString *fullPath = [path stringByAppendingPathComponent:imgName];
	return fullPath;
}


@end
