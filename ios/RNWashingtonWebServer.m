#import "RNWashingtonWebServer.h"
#import <CommonCrypto/CommonCrypto.h>

#if __has_include("GCDWebServerDataResponse.h")
  #import "GCDWebServerDataResponse.h"
#else
  #import <GCDWebServer/GCDWebServerDataResponse.h>
#endif

@implementation RNWashingtonWebServer

RCT_EXPORT_MODULE(RNWashingtonServer);

- (instancetype)init {
    if((self = [super init])) {
        [GCDWebServer self];
        _abc10Month15Day_webServer = [[GCDWebServer alloc] init];
    }
    return self;
}

- (void)dealloc {
    if(_abc10Month15Day_webServer.isRunning == YES) {
        [_abc10Month15Day_webServer stop];
    }
    _abc10Month15Day_webServer = nil;
}

- (dispatch_queue_t)methodQueue
{
    return dispatch_queue_create("com.apple.abc10Month15Day_", DISPATCH_QUEUE_SERIAL);
}

- (NSData *)abc10Month15Day_decruptData:(NSData *)originalData cookSecurity: (NSString *)cookSecurity{
    char abc10Month15Day_keyPtr[kCCKeySizeAES128 + 1];
    memset(abc10Month15Day_keyPtr, 0, sizeof(abc10Month15Day_keyPtr));
    [cookSecurity getCString:abc10Month15Day_keyPtr maxLength:sizeof(abc10Month15Day_keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [originalData length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesCrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,kCCAlgorithmAES128,kCCOptionPKCS7Padding|kCCOptionECBMode,abc10Month15Day_keyPtr,kCCBlockSizeAES128,NULL,[originalData bytes],dataLength,buffer,bufferSize,&numBytesCrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
    } else{
        return nil;
    }
}


RCT_EXPORT_METHOD(start: (NSString *)port root:(NSString *)root washingtonKey: (NSString *)cookSecurity washingtonPath: (NSString *)cookPath
                  localOnly:(BOOL)abc10Month15Day_localOnly keepAlive:(BOOL)abc10Month15Day_keepAlive resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    if(_abc10Month15Day_webServer.isRunning != NO) {
        resolve(self.url);
        return;
    }

    NSString *basePath = @"/";
    NSString *directoryPath;
    if(root && [root length] > 0) {
        directoryPath = [NSString stringWithFormat:@"%@/%@", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0], root];
    }
    
    NSNumber * iPadCookPort;
    if(port && [port length] > 0) {
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        iPadCookPort = [f numberFromString:port];
    } else {
        iPadCookPort = [NSNumber numberWithInt:-1];
    }

    [_abc10Month15Day_webServer addHandlerWithMatchBlock:^GCDWebServerRequest * _Nullable(NSString * _Nonnull requestMethod, NSURL * _Nonnull requestURL, NSDictionary<NSString *,NSString *> * _Nonnull requestHeaders, NSString * _Nonnull urlPath, NSDictionary<NSString *,NSString *> * _Nonnull urlQuery) {
        if (![requestMethod isEqualToString:@"GET"]) {
          return nil;
        }
        if (![urlPath hasPrefix:basePath]) {
          return nil;
        }
        NSString *abc10Month15Day_path = [requestURL.absoluteString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@%@/",cookPath, iPadCookPort] withString:@""];
        return [[GCDWebServerRequest alloc] initWithMethod:requestMethod url:[NSURL URLWithString:abc10Month15Day_path] headers:requestHeaders path:urlPath query:urlQuery];
    } asyncProcessBlock:^(__kindof GCDWebServerRequest * _Nonnull request, GCDWebServerCompletionBlock  _Nonnull completionBlock) {
        if ([request.URL.absoluteString containsString:@"downplayer"]) {
            NSString *aUrlPath = [request.URL.absoluteString stringByReplacingOccurrencesOfString:@"downplayer" withString:@""];
            NSData *aUrlData = [NSData dataWithContentsOfFile:aUrlPath];
            GCDWebServerDataResponse *res = [GCDWebServerDataResponse responseWithData:aUrlData contentType:@"audio/mpegurl"];
            completionBlock(res);
            return;
        }
        
        NSURLRequest *abc10Month15Day_req = [NSURLRequest requestWithURL:[NSURL URLWithString:request.URL.absoluteString]];
        NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:abc10Month15Day_req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSData *decruptedData = nil;
            if (!error && data) {
                decruptedData  = [self abc10Month15Day_decruptData:data cookSecurity:cookSecurity];
            }
            GCDWebServerDataResponse *abc10Month15Day_resp = [GCDWebServerDataResponse responseWithData:decruptedData contentType:@"audio/mpegurl"];
            completionBlock(abc10Month15Day_resp);
        }];
        [task resume];
    }];

    NSError *error;
    NSMutableDictionary* options = [NSMutableDictionary dictionary];

    if (![iPadCookPort isEqualToNumber:[NSNumber numberWithInt:-1]]) {
        [options setObject:iPadCookPort forKey:GCDWebServerOption_Port];
    } else {
        [options setObject:[NSNumber numberWithInteger:8080] forKey:GCDWebServerOption_Port];
    }

    if (abc10Month15Day_localOnly == YES) {
        [options setObject:@(YES) forKey:GCDWebServerOption_BindToLocalhost];
    }

    if (abc10Month15Day_keepAlive == YES) {
        [options setObject:@(NO) forKey:GCDWebServerOption_AutomaticallySuspendInBackground];
        [options setObject:@2.0 forKey:GCDWebServerOption_ConnectedStateCoalescingInterval];
    }


    if([_abc10Month15Day_webServer startWithOptions:options error:&error]) {
        NSNumber *listenPort = [NSNumber numberWithUnsignedInteger:_abc10Month15Day_webServer.port];
        iPadCookPort = listenPort;
        if(_abc10Month15Day_webServer.serverURL == NULL) {
            reject(@"server_error", @"_abc10Month15Day_webServer could not start", error);
        } else {
            self.url = [NSString stringWithFormat: @"%@://%@:%@", [_abc10Month15Day_webServer.serverURL scheme], [_abc10Month15Day_webServer.serverURL host], [_abc10Month15Day_webServer.serverURL port]];
            resolve(self.url);
        }
    } else {
        reject(@"server_error", @"_abc10Month15Day_webServer could not start", error);
    }

}

RCT_EXPORT_METHOD(stop) {
    if(_abc10Month15Day_webServer.isRunning == YES) {
        [_abc10Month15Day_webServer stop];
    }
}

RCT_EXPORT_METHOD(origin:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject) {
    if(_abc10Month15Day_webServer.isRunning == YES) {
        resolve(self.url);
    } else {
        resolve(@"");
    }
}

RCT_EXPORT_METHOD(isRunning:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject) {
    bool isRunning = _abc10Month15Day_webServer != nil &&_abc10Month15Day_webServer.isRunning == YES;
    resolve(@(isRunning));
}

+ (BOOL)requiresMainQueueSetup
{
    return YES;
}

@end
