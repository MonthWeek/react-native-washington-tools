#import "RNWashingtonLocation.h"
#import <React/RCTUIManager.h>
#import "RNWashingtonLocationHelper.h"

@implementation RNWashingtonLocation

RCT_EXPORT_MODULE(LocationManager);

RCT_EXPORT_METHOD(getStartLocation)
{
  [[RNWashingtonLocationHelper a10Month15Day_initializeManager] a10Month15Day_startLocation];
}

RCT_EXPORT_METHOD(getAddressNameWithcallback:(RCTResponseSenderBlock)callback)
{
  callback(@[[NSNull null],[RNWashingtonLocationHelper a10Month15Day_initializeManager].addressName]);
}

RCT_EXPORT_METHOD(checkOpenLocation:(RCTResponseSenderBlock)callback)
{
  callback(@[[NSNull null],[RNWashingtonLocationHelper a10Month15Day_isOpenLocation],[RNWashingtonLocationHelper a10Month15Day_getLocationStatus]]);
}

RCT_EXPORT_METHOD(checkFileExistsWithVideoPath:(NSString *)videoPath ImagePath:(NSString *)imagePath callback:(RCTResponseSenderBlock)callback)
{
  callback(@[[NSNull null],[RNWashingtonLocationHelper a10Month15Day_checkFileExists:videoPath],[RNWashingtonLocationHelper a10Month15Day_checkFileExists:imagePath]]);
}

@end
