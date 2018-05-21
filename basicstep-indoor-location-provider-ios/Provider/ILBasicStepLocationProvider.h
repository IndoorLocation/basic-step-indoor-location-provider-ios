#import <IndoorLocation/IndoorLocation.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>

@interface ILBasicStepLocationProvider : ILIndoorLocationProvider <CLLocationManagerDelegate, ILIndoorLocationProviderDelegate>

@property (nonatomic) ILIndoorLocationProvider* sourceProvider;

- (instancetype)initWithSourceProvider:(ILIndoorLocationProvider*) sourceProvider;

@end
