#import <UIKit/UIKit.h>
#import <Mapbox/Mapbox.h>
#import <MapwizeForMapbox/MapwizeForMapbox.h>
#import "ILBasicStepLocationProvider.h"

@interface ViewController : UIViewController <MWZMapwizePluginDelegate>

@property (weak, nonatomic) IBOutlet MGLMapView *mglMapView;

@end

