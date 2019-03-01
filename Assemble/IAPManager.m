//
//  IAPManager.m
//  Assemble
//
//  Created by XLsn0w on 2019/3/1.
//  Copyright © 2019 TimeForest. All rights reserved.
//

#import "IAPManager.h"
#import <StoreKit/StoreKit.h>

@interface IAPManager () <SKPaymentTransactionObserver, SKProductsRequestDelegate>
// 所有商品
@property (nonatomic, strong)NSArray *products;
@property (nonatomic, strong)SKProductsRequest *request;


@end

@implementation IAPManager

static IAPManager *manager = nil;
+ (instancetype)shareIAPManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [self new];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:manager];
    });
    return manager;
}

// 请求可卖的商品
- (void)requestProducts
{
    if (![SKPaymentQueue canMakePayments]) {
        // 您的手机没有打开程序内付费购买
        return;
    }
    
    // 1.请求所有的商品ID
    NSString *productFilePath = [[NSBundle mainBundle] pathForResource:@"iapdemo.plist" ofType:nil];
    NSArray *products = [NSArray arrayWithContentsOfFile:productFilePath];
    
    // 2.获取所有的productid
    NSArray *productIds = [products valueForKeyPath:@"productId"];
    
    // 3.获取productid的set(集合中)
    NSSet *set = [NSSet setWithArray:productIds];
    
    // 4.向苹果发送请求,请求可卖商品
    _request = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    _request.delegate = self;
    [_request start];
}

/**
 *  当请求到可卖商品的结果会执行该方法
 *
 *  @param response response中存储了可卖商品的结果
 */
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    for (SKProduct *product in response.products) {
        
        // 用来保存价格
        NSMutableDictionary *priceDic = @{}.mutableCopy;
        // 货币单位
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [numberFormatter setLocale:product.priceLocale];
        // 带有货币单位的价格
        NSString *formattedPrice = [numberFormatter stringFromNumber:product.price];
        [priceDic setObject:formattedPrice forKey:product.productIdentifier];
        
        NSLog(@"价格:%@", product.price);
        NSLog(@"标题:%@", product.localizedTitle);
        NSLog(@"秒速:%@", product.localizedDescription);
        NSLog(@"productid:%@", product.productIdentifier);
    }
    
    NSDictionary* priceDic = @{};
    // 保存价格列表
    [[NSUserDefaults standardUserDefaults] setObject:priceDic forKey:@"priceDic"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // 1.存储所有的数据
    self.products = response.products;
    self.products = [self.products sortedArrayWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(SKProduct *obj1, SKProduct *obj2) {
        return [obj1.price compare:obj2.price];
    }];
}

#pragma mark - 购买商品
- (void)buyProduct:(SKProduct *)product
{
    // 1.创建票据
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    NSLog(@"productIdentifier----%@", payment.productIdentifier);
    
    // 2.将票据加入到交易队列中
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

#pragma mark - 实现观察者回调的方法
/**
 *  当交易队列中的交易状态发生改变的时候会执行该方法
 *
 *  @param transactions 数组中存放了所有的交易
 */
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    /*
     SKPaymentTransactionStatePurchasing, 正在购买
     SKPaymentTransactionStatePurchased, 购买完成(销毁交易)
     SKPaymentTransactionStateFailed, 购买失败(销毁交易)
     SKPaymentTransactionStateRestored, 恢复购买(销毁交易)
     SKPaymentTransactionStateDeferred 最终状态未确定
     */
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"用户正在购买");
                break;
                
            case SKPaymentTransactionStatePurchased:
                NSLog(@"productIdentifier----->%@", transaction.payment.productIdentifier);
                [self buySuccessWithPaymentQueue:queue Transaction:transaction];
                break;
                
            case SKPaymentTransactionStateFailed:
                NSLog(@"购买失败");
                [queue finishTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateRestored:
                NSLog(@"恢复购买");
                [queue finishTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateDeferred:
                NSLog(@"最终状态未确定");
                break;
                
            default:
                break;
        }
    }
}

- (void)buySuccessWithPaymentQueue:(SKPaymentQueue *)queue Transaction:(SKPaymentTransaction *)transaction {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{@"user_id":@"user_id",
                             // 获取商品
                             @"goods":[self goodsWithProductIdentifier:transaction.payment.productIdentifier]};
    
    [manager POST:@"url" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject[@"code"] intValue] == 200) {
            
            // 防止丢单, 必须在服务器确定后从交易队列删除交易
            // 如果不从交易队列上删除交易, 下次调用addTransactionObserver:, 仍然会回调'updatedTransactions'方法, 以此处理丢单
            
            WELog(@"购买成功");
            [queue finishTransaction:transaction];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

// 商品列表 也可以使用从苹果请求的数据, 具体细节自己视情况处理
// goods1 是商品的ID
- (NSString *)goodsWithProductIdentifier:(NSString *)productIdentifier {
    NSDictionary *goodsDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"priceDic"];
    return goodsDic[productIdentifier];
}

// 恢复购买
- (void)restore
{
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
    // 恢复失败
    NSLog(@"恢复失败");
}

// 取消请求商品信息
- (void)dealloc {
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    [_request cancel];
}

@end
