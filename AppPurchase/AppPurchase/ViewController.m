//
//  ViewController.m
//  AppPurchase
//
//  Created by 漆海全 on 16/5/9.
//  Copyright © 2016年 漆海全. All rights reserved.
//

#import "ViewController.h"
#import <StoreKit/StoreKit.h>

static NSString * productId = @"yd123";

@interface ViewController ()<SKProductsRequestDelegate,SKPaymentTransactionObserver>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
}

- (IBAction)buyButton:(UIButton *)sender {

    
    if ([SKPaymentQueue canMakePayments]) {
        
        [self requestProductData:productId];
        
    }else {
    
        NSLog(@"不允许程序内付费");
    }
    

}

- (void)requestProductData:(NSString *)product {

    NSLog(@"---------------请求对应的产品信息--------------");
    
    NSSet * set = [NSSet setWithObject:product];
    SKProductsRequest * productRequest = [[SKProductsRequest alloc]initWithProductIdentifiers:set];
    productRequest.delegate = self;
    [productRequest start];
    
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {

    NSLog(@"--------------收到产品反馈信息----------------");
    NSArray * product = response.products;
    if ([product count] == 0) {
        NSLog(@"没有商品");
        return;
    }
    
    NSLog(@"productID:%@",response.invalidProductIdentifiers);
    NSLog(@"产品付费数量:%ld",[product count]);
    
    SKProduct *p = nil;
    
    for (SKProduct * pro in product) {
        
        NSLog(@"%@",pro.description);
        NSLog(@"%@",pro.localizedTitle);
        NSLog(@"%@",pro.localizedDescription);
        NSLog(@"%@",pro.price);
        NSLog(@"%@",pro.productIdentifier);
        if ([pro.productIdentifier isEqualToString:productId]) {
            p = pro;
            break;
        }
    }
    
    SKPayment * payment = [SKPayment paymentWithProduct:p];
    
    NSLog(@"发送购买请求");
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
    
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {

    NSLog(@"error%@",[error localizedDescription]);
    
}

- (void)requestDidFinish:(SKRequest *)request {

    NSLog(@"反馈信息结束");
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions{

    for (SKPaymentTransaction * tran in transactions) {
        
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchased:
            {
                NSLog(@"交易结束");
            }
                break;
            case SKPaymentTransactionStatePurchasing:
            {
                NSLog(@"商品添加进列表");
            }
                break;
            case SKPaymentTransactionStateRestored:
            {
                NSLog(@"已经购买过商品");
            }
                break;
            case SKPaymentTransactionStateFailed:
            {
                NSLog(@"交易失败");
            }
                break;
            case SKPaymentTransactionStateDeferred:
            {
                NSLog(@"交易延迟");
            }
                break;
            default:
                break;
        }
        
    }
    
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {

    NSLog(@"queue 交易结束");
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
