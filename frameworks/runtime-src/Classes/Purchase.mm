//
//  Purchase.m
//  God
//
//  Created by antz on 15/5/15.
//
//

#import "Purchase.h"


#include "cocos2d.h"
#include "CCLuaEngine.h"
#include "CCLuaBridge.h"


using namespace cocos2d;


#define IAP_GOLD_1 @"com.gold.g1"
#define IAP_GOLD_2 @"com.gold.g2"
#define IAP_GOLD_3 @"com.gold.g3"
#define IAP_GOLD_4 @"com.gold.g4"
#define IAP_GOLD_5 @"com.gold.g5"
#define IAP_GOLD_6 @"com.gold.g6"

#import "TalkingData.h"

@implementation Purchase

static Purchase* s_instance = nil;

+ (Purchase*) getInstance
{
    if (!s_instance)
    {
        s_instance = [Purchase alloc];
        [s_instance init];
    }
    
    return s_instance;
}

+ (void) destroyInstance
{
    [s_instance release];
}


- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //[self release];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    purchaseCache = transactions;
    //[self release];
    for (SKPaymentTransaction *transaction in transactions)
    {
        NSString* id = transaction.transactionIdentifier;
        
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
            {
                //购买成功，在这写入后续代码
                
                NSData* nd = transaction.transactionReceipt;
                NSString* ns =  [nd base64EncodedStringWithOptions:0];
                
                //NSString* ns = [[NSString alloc] initWithData:nd encoding:NSUTF8StringEncoding];
                
                NSLog(@"购买成功,验证。。。: %@", ns);
                [self buyHandler:ns];
                
//                NSMutableArray *arrayData = [[NSMutableArray alloc] init];
//                NSMutableDictionary *dlist = [[NSMutableDictionary alloc] init];
//                [dlist setObject:@"receipt-data" forKey:ns];
//                [arrayData addObject:dlist];
//                
//                
//                
//                NSData* postData = [NSJSONSerialization dataWithJSONObject:arrayData options:NSJSONWritingPrettyPrinted error:nil];
//
//                NSString *reqData = @"Data=";
//                NSString *str = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
//                reqData = [reqData stringByAppendingString:str];
//                postData = [NSData dataWithBytes:[reqData UTF8String] length:[reqData length]];
//
//
//
//                NSURL *url = [[NSURL alloc]initWithString:@"https://sandbox.itunes.apple.com/verifyReceipt"];
//                NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//                [request setURL:url];
//                [request setHTTPMethod:@"POST"];
//                [request setHTTPBody:postData];
//                
//                
//                NSURLConnection *conn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
                
               
                // 释放对象
                //[request release];



                                
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                
                
                //[[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
                
                
                break;
            }
                
            case SKPaymentTransactionStateFailed:
                //购买失败，在这写入后续代码
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                //[self release];
                [Purchase callErrorScriptHandler];

                break;
            case SKPaymentTransactionStateRestored:
            {
                SKPaymentTransaction* originalTrans =  [transaction originalTransaction];
                
                NSData* nd = originalTrans.transactionReceipt;
                NSString* ns = [[NSString alloc] initWithData:nd encoding:NSUTF8StringEncoding];
                //在这写入恢复内购买的代码
                
                [self buyHandler:ns];

                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                
                break;
            }
                
            case SKPaymentTransactionStatePurchasing:
            {
                NSLog(@"正在购买%@", id);
            }
            default:
                [Purchase callErrorScriptHandler];
                break;
        }
    }
    
}

-(void)test
{
    
}

- (void) buyHandler:(NSString *)ns
{
    [Purchase callbackScriptHandler:ns];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)responseData
{
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"get %@",responseString);
}


-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    //[self release];
    NSArray *products = response.products;
    
    SKProduct* _product;
    
    if (products.count != 0)
    {
        _product = products[0];//_product是一个SKProduct变量
    } else {
        NSLog(@"Product not found");
    }
    
    products = response.invalidProductIdentifiers;
    
    for (SKProduct *product in products)
    {
        NSLog(@"Product not found: %@", product);
    }
    
    //NSLog(@"%@", _product.price);
    
    
    SKPayment *payment = [SKPayment paymentWithProduct:_product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];

}


//---------------------------------------------
- (void) setScriptHandler:(int)scriptHandler
{
    if (_scriptHandler)
    {
        LuaBridge::releaseLuaFunctionById(_scriptHandler);
        _scriptHandler = 0;
    }
    _scriptHandler = scriptHandler;
}

- (void) setErrorHandler:(int)scriptHandler
{
    if (_errorHandler)
    {
        LuaBridge::releaseLuaFunctionById(_errorHandler);
        _errorHandler = 0;
    }
    _errorHandler = scriptHandler;
}

- (int) getScriptHandler
{
    return _scriptHandler;
}


- (int) getErrorHandler
{
    return _errorHandler;
}




+(void) registerScriptHandler:(NSDictionary *)dict
{
    [[Purchase getInstance] setScriptHandler:[[dict objectForKey:@"scriptHandler"] intValue]];
    [[Purchase getInstance] setErrorHandler:[[dict objectForKey:@"errorHandler"] intValue]];

}


+ (void) unregisterScriptHandler
{
    [[Purchase getInstance] setScriptHandler:0];
}

+ (void) finish
{
    
    //[[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

+ (void) restore
{
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];

    CCLOG("start restore.....");
    
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    CCLOG("end restore..");
    
}

+ (NSString* )getDeviceID
{
    return [TalkingData getDeviceID];
}

+ (int)  buy:(NSDictionary *)dict
{
//    UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"Alert"
//                                                       message:@"您的设备没有允许应用程序内购买, 请在设置里更改."
//                                                      delegate:nil
//                                             cancelButtonTitle:NSLocalizedString(@"Close（关闭）",nil)
//                                             otherButtonTitles:nil];
//    [alerView show];
//    [alerView release];
    
    
    int id = [[dict objectForKey:@"id"] intValue];
    
    NSString* productID;
    switch (int(id)) {
        case 1:
            productID = IAP_GOLD_1;
            break;
        case 2:
            productID = IAP_GOLD_2;
            break;
            
        case 3:
            productID = IAP_GOLD_3;
            break;
            
        case 4:
            productID = IAP_GOLD_4;
            break;
            
        case 5:
            productID = IAP_GOLD_5;
            break;
            
        case 6:
            productID = IAP_GOLD_6;
            break;
            
        default:
            productID = IAP_GOLD_1;
            break;
    }
    
//    SKProduct *prod = [[SKProduct alloc] initWithProductIdentifiers: [NSSet setWithObject:productID]];
//    SKPayment *payment = [SKPayment paymentWithProduct:prod];
//    [[SKPaymentQueue defaultQueue] addPayment:payment];
    

    //SKPayment *payment = [SKPayment paymentWithProductIdentifier: productID];
    //[[SKPaymentQueue defaultQueue] addPayment: payment];
    //SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers: [NSSet setWithObject:productID]];
    //[request start];
    //[request autorelease];
    
    
    SKProductsRequest *request = [[SKProductsRequest alloc]initWithProductIdentifiers:
                                  [NSSet setWithObject: productID]];
    
    request.delegate = [Purchase getInstance];
    [request start];
    return 1;
}

+ (void) callbackScriptHandler:(NSString* )ns
{
    int scriptHandler = [[Purchase getInstance] getScriptHandler];
    if (scriptHandler)
    {
        LuaBridge::pushLuaFunctionById(scriptHandler);
        LuaStack *stack = LuaBridge::getStack();
        stack->pushString([ns UTF8String]);
        stack->executeFunction(1);
    }
}

+ (void) callErrorScriptHandler
{
    int scriptHandler = [[Purchase getInstance] getErrorHandler];
    if (scriptHandler)
    {
        LuaBridge::pushLuaFunctionById(scriptHandler);
        LuaStack *stack = LuaBridge::getStack();
        stack->pushString("error");
        stack->executeFunction(1);
    }
}

- (id)init
{
    _scriptHandler = 0;
    return self;
}

@end