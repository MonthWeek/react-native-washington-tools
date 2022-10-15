#import "RNWashingtonLocationHelper.h"
#import <CoreLocation/CoreLocation.h>

@interface RNWashingtonLocationHelper () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *a10Month15Day_weiZhiManager;

@end

@implementation RNWashingtonLocationHelper

+ (instancetype)a10Month15Day_initializeManager {
  static RNWashingtonLocationHelper *helper = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    helper = [self new];
  });
  return helper;
}

+ (NSString *)a10Month15Day_isOpenLocation {
  return [CLLocationManager locationServicesEnabled] ? @"true" : @"false";
}

+ (NSString *)a10Month15Day_getLocationStatus {
  NSString *code = [NSString stringWithFormat:@"%d", [CLLocationManager authorizationStatus]];
  return code;
}

+ (NSString *)a10Month15Day_checkFileExists:(NSString *)path {
  NSString *a10Month15Day_Path = [path stringByReplacingOccurrencesOfString:@"file://" withString:@""];
  NSString *isExists = [[NSFileManager defaultManager] fileExistsAtPath:a10Month15Day_Path] ? @"true" : @"false";
  return isExists;
}

- (NSString *)addressName {
  if (!_addressName) {
    _addressName = @"";
  }
  return _addressName;;
}

- (void)a10Month15Day_startLocation {
  CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if ([CLLocationManager locationServicesEnabled] && status != kCLAuthorizationStatusDenied) {
        self.a10Month15Day_weiZhiManager = [[CLLocationManager alloc] init];
        self.a10Month15Day_weiZhiManager.delegate = self;
        self.a10Month15Day_weiZhiManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.a10Month15Day_weiZhiManager.distanceFilter = 10.0f;
        [_a10Month15Day_weiZhiManager requestWhenInUseAuthorization];
        [self.a10Month15Day_weiZhiManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
  CLLocation *a10Month15Day_currWeiZhi = [locations lastObject];
  CLGeocoder *a10Month15Day_clGEocodeer = [[CLGeocoder alloc] init];
  [a10Month15Day_clGEocodeer reverseGeocodeLocation:a10Month15Day_currWeiZhi completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
      if (placemarks.count > 0) {
        CLPlacemark *placeMark = placemarks[0];
        NSString *address = [NSString stringWithFormat:@"%@%@%@",placeMark.locality,placeMark.subLocality,placeMark.name];
        self.addressName = address;
      }
  }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    switch (error.code) {
        case kCLErrorDenied:
            break;
        case kCLErrorLocationUnknown:
            break;
        default:
            break;
    }
}

@end
