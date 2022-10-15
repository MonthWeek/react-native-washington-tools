#import "RNWashingtonQRScanReader.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreImage/CoreImage.h>

@implementation RNWashingtonQRScanReader

RCT_EXPORT_MODULE(QRScanReader);

RCT_EXPORT_METHOD(readerQR:(NSString *)fileUrl success:(RCTPromiseResolveBlock)success failure:(RCTResponseErrorBlock)failure){
  dispatch_sync(dispatch_get_main_queue(), ^{
    NSString *result = [self b10Month15Day_readerScannerQR:fileUrl];
    if(result){
      success(result);
    }else{
      NSDictionary *userInfo = @{ NSLocalizedDescriptionKey: NSLocalizedString(@"没有相关二维码", @"") };
      NSError *error = [NSError errorWithDomain:@"com.b10Month15Day" code:404 userInfo:userInfo];
      failure(error);
    }
  });
}

-(NSString*)b10Month15Day_readerScannerQR:(NSString*)fileUrl{
  fileUrl = [fileUrl stringByReplacingOccurrencesOfString:@"file://" withString:@""];
  CIContext *b10Month15Day_context = [CIContext contextWithOptions:nil];
  CIDetector *b10Month15Day_detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:b10Month15Day_context options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
  NSData *fileData = [[NSData alloc] initWithContentsOfFile:fileUrl];
  CIImage *b10Month15Day_ciImage = [CIImage imageWithData:fileData];
  NSArray *features = [b10Month15Day_detector featuresInImage:b10Month15Day_ciImage];
  if(!features || features.count==0){
    return nil;
  }
  CIQRCodeFeature *feature = [features objectAtIndex:0];
  NSString *scannedResult = feature.messageString;
  return scannedResult;
}

@end
