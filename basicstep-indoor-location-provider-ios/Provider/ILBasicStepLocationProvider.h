#import <IndoorLocation/IndoorLocation.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>

@interface ILBasicStepLocationProvider : ILIndoorLocationProvider <CLLocationManagerDelegate>

- (void) setIndoorLocation:(ILIndoorLocation*) indoorLocation;

@end
