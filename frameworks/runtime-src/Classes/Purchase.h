//
//  Purchase.h
//  God
//
//  Created by antz on 15/5/15.
//
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>


@interface Purchase : NSObject<UIAlertViewDelegate, SKPaymentTransactionObserver, SKProductsRequestDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate> {
    int _scriptHandler;
    int _errorHandler;
    NSArray* purchaseCache;
}
+ (Purchase*) getInstance;

+ (void) destroyInstance;

+ (void) registerScriptHandler:(NSDictionary *)dict;
+ (void) unregisterScriptHandler;

+ (void) finish;

+ (int)  buy:(NSDictionary *)dict;
+ (void) callbackScriptHandler;
+ (void) callErrorScriptHandler;

+ (NSString*) getDeviceID;

- (id) init;

@end
