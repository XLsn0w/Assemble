
#import <UIKit/UIKit.h>
#define DEFAULT_LINE_SPACING        (int)0
#define DEFAULT_PARAGRAPH_SPACING   (int)3

typedef NS_ENUM(NSInteger, AlertStyle) {
    AlertStyleDefault = 0,
    AlertStyleSecureTextInput,
    AlertStylePlainTextInput,
    AlertStyleLoginAndPasswordInput
};
@class XLsn0wAlert;
@protocol AlertDelegate;

@interface XLsn0wAlert : UIView {
    UITextView *_messageLabel;
    UILabel *_titleLabel;
}
@property (nonatomic, retain) id object;
// delegate
@property (nonatomic, assign, readonly) id<AlertDelegate>delegate;

// alertView
@property (nonatomic, strong, readonly) UIToolbar *alertView;

// 内容文字大小
@property (nonatomic, strong) UIFont *font;

// 设置message的对齐方式
@property (nonatomic, assign) NSTextAlignment contentAlignment;

// Alert TextInput LoginInput
@property (nonatomic, strong) UITextField *textField;

// Alert PasswordInput
@property (nonatomic, strong) UITextField *passwordTextField;

@property (nonatomic, assign) CGFloat lineSpacing;        // DEFAULT_LINE_SPACING
@property (nonatomic, assign) CGFloat paragraphSpacing;   // DEFAULT_PARAGRAPH_SPACING
@property (nonatomic, assign) AlertStyle alertStyle;   // DEFAULT_PARAGRAPH_SPACING

#pragma mark - --block
typedef void (^CancelAlertBlock)(XLsn0wAlert *alertView) ;
typedef void (^ClicksAlertBlock)(XLsn0wAlert *alertView, NSInteger buttonIndex);
@property (nonatomic, copy, readonly) CancelAlertBlock cancelBlock;
@property (nonatomic, copy, readonly) ClicksAlertBlock clickBlock;
- (void)setCancelBlock:(CancelAlertBlock)cancelBlock;
- (void)setClickBlock:(ClicksAlertBlock)clickBlock;

#pragma mark - --init
/**
 *  创建alertView
 *
 *  @param title             提示标题
 *  @param message           提示详情
 *  @param delegate          协议对象
 *  @param cancelButtonTitle 取消按钮名称
 *  @param otherButtonTitles 其他按钮
 *
 *  @return Alert
 */
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id<AlertDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...NS_REQUIRES_NIL_TERMINATION;

/**
 *  显示alertView
 */
- (void)show;
@end

#pragma mark - --delegate
@protocol AlertDelegate <NSObject>

@optional
/**
 *  点击按钮协议
 *
 *  @param alertView
 *  @param buttonIndex 0,1,2...
 */
- (void)alertView:(XLsn0wAlert *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

/**
 *  取消协议
 *
 *  @param alertView
 */
- (void)alertViewCancel:(XLsn0wAlert *)alertView;

@end

























/*XLsn0w*
 
 - (IBAction)twoBtn:(id)sender {
 Alert *alert = [[Alert alloc] initWithTitle:@"央行调查：过半居民认为目前房价过高" message:@"　　面对回暖的房地产市场，央行昨日发布的2016年第一季度城镇储户问卷调查报告显示，50.7%的居民认为目前房价“高，难以接受”，较上季下降1.3个百分点，45.7%的居民认为目前房价“可以接受”，3.6%的居民认为“令人满意”。\n\n　　对于二季度房价，17.6%的居民预期“上涨”，52.1%的居民预期“基本不变”，16.1%的居民预期“下降”，14.2%的居民“看不准”。未来3个月内准备出手购买住房的居民占比为13.6%，较上季回落1.1个百分点。\n\n　　对于当期物价，52.7%的居民认为物价“高，难以接受”，较上季提高1.7 个百分点。对未来物价预期，24.8%的居民预期下季物价将“上升”，51.6%的居民预期“基本不变”，11.9%的居民预期“下降”，11.8%的居民“看不准”。\n\n　　收入方面，79.6%的居民认为当期收入“增加”或“基本不变”，较上季提高1.2个百分点。但未来收入信心指数为48.4%，较上季下降0.7个百分点。就业方面，11.4%的居民认为一季度“形势较好，就业容易”，43.5%的居民认为“一般”，45.1%的居民认为“形势严峻，就业难”或“看不准”。未来就业预期指数为44.8%，较上季下降0.5 个百分点。\n\n" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"好", nil];
 alert.contentAlignment = NSTextAlignmentLeft;
 [alert show];
 }
 - (IBAction)threeBtn:(id)sender {
 Alert *alert = [[Alert alloc] initWithTitle:@"央行调查：过半居民认为目前房价过高" message:@"　　面对回暖的房地产市场，央行昨日发布的2016年第一季度城镇储户问卷调查报告显示，50.7%的居民认为目前房价“高，难以接受”，较上季下降1.3个百分点，45.7%的居民认为目前房价“可以接受”，3.6%的居民认为“令人满意”。\n\n　　对于二季度房价，17.6%的居民预期“上涨”，52.1%的居民预期“基本不变”，16.1%的居民预期“下降”，14.2%的居民“看不准”。未来3个月内准备出手购买住房的居民占比为13.6%，较上季回落1.1个百分点。\n\n　　对于当期物价，52.7%的居民认为物价“高，难以接受”，较上季提高1.7 个百分点。对未来物价预期，24.8%的居民预期下季物价将“上升”，51.6%的居民预期“基本不变”，11.9%的居民预期“下降”，11.8%的居民“看不准”。\n\n　　收入方面，79.6%的居民认为当期收入“增加”或“基本不变”，较上季提高1.2个百分点。但未来收入信心指数为48.4%，较上季下降0.7个百分点。就业方面，11.4%的居民认为一季度“形势较好，就业容易”，43.5%的居民认为“一般”，45.1%的居民认为“形势严峻，就业难”或“看不准”。未来就业预期指数为44.8%，较上季下降0.5 个百分点。\n\n" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"好", @"去", nil];
 alert.contentAlignment = NSTextAlignmentLeft;
 [alert show];
 }
 - (IBAction)shortMessage:(id)sender {
 Alert *alert = [[Alert alloc] initWithTitle:@"央行调查：过半居民认为目前房价过高" message:@"　　面对回暖的房地产市场，央行昨日发布的2016年第一季度城镇储户问卷调查报告显示" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"好", nil];
 alert.contentAlignment = NSTextAlignmentCenter;
 [alert show];
 }
 - (IBAction)longMesage:(id)sender {
 Alert *alert = [[Alert alloc] initWithTitle:@"央行调查：过半居民认为目前房价过高" message:@"　　面对回暖的房地产市场，央行昨日发布的2016年第一季度城镇储户问卷调查报告显示，50.7%的居民认为目前房价“高，难以接受”，较上季下降1.3个百分点，45.7%的居民认为目前房价“可以接受”，3.6%的居民认为“令人满意”。\n\n　　对于二季度房价，17.6%的居民预期“上涨”，52.1%的居民预期“基本不变”，16.1%的居民预期“下降”，14.2%的居民“看不准”。未来3个月内准备出手购买住房的居民占比为13.6%，较上季回落1.1个百分点。\n\n　　对于当期物价，52.7%的居民认为物价“高，难以接受”，较上季提高1.7 个百分点。对未来物价预期，24.8%的居民预期下季物价将“上升”，51.6%的居民预期“基本不变”，11.9%的居民预期“下降”，11.8%的居民“看不准”。\n\n　　收入方面，79.6%的居民认为当期收入“增加”或“基本不变”，较上季提高1.2个百分点。但未来收入信心指数为48.4%，较上季下降0.7个百分点。就业方面，11.4%的居民认为一季度“形势较好，就业容易”，43.5%的居民认为“一般”，45.1%的居民认为“形势严峻，就业难”或“看不准”。未来就业预期指数为44.8%，较上季下降0.5 个百分点。\n\n" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"好", nil];
 alert.contentAlignment = NSTextAlignmentLeft;
 [alert show];
 }
 - (IBAction)oneTextField:(id)sender {
 Alert *alert = [[Alert alloc] initWithTitle:@"央行调查：过半居民认为目前房价过高" message:@"　　面对回暖的房地产市场，央行昨日发布的2016年第一季度城镇储户问卷调查报告显示" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"好", nil];
 [alert setAlertStyle:AlertStyleSecureTextInput];
 alert.contentAlignment = NSTextAlignmentCenter;
 [alert show];
 }
 - (IBAction)userPasswordTextField:(id)sender {
 Alert *alert = [[Alert alloc] initWithTitle:@"央行调查：过半居民认为目前房价过高" message:@"　　面对回暖的房地产市场，央行昨日发布的2016年第一季度城镇储户问卷调查报告显示" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"好", nil];
 [alert setAlertStyle:AlertStyleLoginAndPasswordInput];
 alert.contentAlignment = NSTextAlignmentCenter;
 [alert show];
 }
 
 
 */
