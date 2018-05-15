#import "ILBasicStepLocationProvider.h"
#include <math.h>

double const LOW_PASS_TIME_CONSTANT = 0.15;
double const STEP_ACCELERATION_DEVIATION_TRESHOLD = 0.008;
double const STEP_LENGTH = 1.0;

@implementation ILBasicStepLocationProvider {
    BOOL started;
    CMMotionManager* motionManager;
    CLLocationManager* locationManager;
    double lowPassXAcceleration;
    double lowPassYAcceleration;
    double lowPassZAcceleration;
    NSMutableArray<NSNumber*>* accelerationBuffer;
    ILIndoorLocation* lastIndoorLocation;
    double heading;
    NSTimer* timer;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        started = NO;
        motionManager = [[CMMotionManager alloc] init];
        motionManager.accelerometerUpdateInterval = 0.1;
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
    }
    return self;
}

- (void) setIndoorLocation:(ILIndoorLocation*) indoorLocation {
    lastIndoorLocation = indoorLocation;
    [motionManager stopAccelerometerUpdates];
    lowPassXAcceleration = 0.0;
    lowPassYAcceleration = 0.0;
    lowPassZAcceleration = 0.0;
    accelerationBuffer = [[NSMutableArray alloc] init];
    
    [motionManager startAccelerometerUpdatesToQueue:NSOperationQueue.mainQueue withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
        if (accelerometerData != nil) {
            [self processingSingleAccelerationMeasurement: accelerometerData.acceleration];
        }
    }];
    
    [self dispatchDidUpdateLocation:indoorLocation];
}

- (void) processingSingleAccelerationMeasurement:(CMAcceleration) acceleration {
    lowPassXAcceleration = lowPassXAcceleration * LOW_PASS_TIME_CONSTANT + acceleration.x * (1-LOW_PASS_TIME_CONSTANT);
    lowPassYAcceleration = lowPassYAcceleration * LOW_PASS_TIME_CONSTANT + acceleration.y * (1-LOW_PASS_TIME_CONSTANT);
    lowPassZAcceleration = lowPassZAcceleration * LOW_PASS_TIME_CONSTANT + acceleration.z * (1-LOW_PASS_TIME_CONSTANT);
    
    double x2 = lowPassXAcceleration*lowPassXAcceleration;
    double y2 = lowPassYAcceleration*lowPassYAcceleration;
    double z2 = lowPassZAcceleration*lowPassZAcceleration;
    double lowPassAccelerationNorm = sqrt(x2 + y2 + z2);
    
    if (accelerationBuffer.count < 10) {
        [accelerationBuffer addObject:[NSNumber numberWithDouble:lowPassAccelerationNorm]];
    } else {
        [self processAccelerationOverOneSecond];
    }
}

- (void) processAccelerationOverOneSecond {
    double accelerationSum = 0.0;
    for (NSNumber* x in accelerationBuffer) {
        accelerationSum += x.doubleValue;
    }
    double accelerationMean = accelerationSum / [accelerationBuffer count];
    double accelerationSquaredDeviation = 0.0;
    for (NSNumber* x in accelerationBuffer) {
        accelerationSquaredDeviation += (x.doubleValue - accelerationMean)*(x.doubleValue - accelerationMean);
    }
    accelerationSquaredDeviation = accelerationSquaredDeviation / [accelerationBuffer count];
    
    [accelerationBuffer removeAllObjects];
    
    if (accelerationSquaredDeviation > STEP_ACCELERATION_DEVIATION_TRESHOLD) {
        [self makeAStep];
    }
}

- (void) makeAStep {
    lastIndoorLocation = [self locationWithBearing:heading distance: STEP_LENGTH origin: lastIndoorLocation];
    [self dispatchDidUpdateLocation:lastIndoorLocation];
}

- (ILIndoorLocation*) locationWithBearing:(double) bearing distance:(double) distance origin:(ILIndoorLocation*) origin {
    
    double bearingRad = bearing * M_PI / 180.0;
    double distRadians = distance / 6372797.6;
    double lat1 = origin.latitude * M_PI / 180.0;
    double lon1 = origin.longitude * M_PI / 180.0;
    
    double lat2 = asin((sin(lat1)*cos(distRadians))+(cos(lat1)*sin(distRadians)*cos(bearingRad)));
    double lon2 = lon1 + atan2(sin(bearingRad)*sin(distRadians)*cos(lat1), cos(distRadians)-sin(lat1)*sin(lat2));
    
    double targetLat = lat2 * 180.0 / M_PI;
    double targetLon = lon2 * 180.0 / M_PI;
    
    ILIndoorLocation* indoorLocation = [[ILIndoorLocation alloc] initWithProvider:self latitude:targetLat longitude:targetLon floor:origin.floor];
    
    return indoorLocation;
}

- (void) start {
    if (!started) {
        started = YES;
        [locationManager startUpdatingHeading];
        [self dispatchDidStart];
    }
}

- (void) stop {
    if (started) {
        started = NO;
        [self dispatchDidStop];
    }
}

- (BOOL) isStarted {
    return started;
}

- (BOOL) supportsFloor {
    return YES;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    heading = newHeading.magneticHeading;
}

@end
