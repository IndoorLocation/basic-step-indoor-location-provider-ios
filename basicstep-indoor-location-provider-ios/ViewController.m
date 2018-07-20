#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController {
    MapwizePlugin* mapwizePlugin;
    ILManualIndoorLocationProvider* sourceProvider;
    ILBasicStepLocationProvider* basicStepProvider;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    mapwizePlugin = [[MapwizePlugin alloc] initWith:_mglMapView options:[[MWZOptions alloc] init]];
    mapwizePlugin.delegate = self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)mapwizePluginDidLoad:(MapwizePlugin *)mapwizePlugin {
    sourceProvider = [[ILManualIndoorLocationProvider alloc] init];
    basicStepProvider = [[ILBasicStepLocationProvider alloc] initWithSourceProvider:sourceProvider];
    
    [mapwizePlugin setIndoorLocationProvider:basicStepProvider];
    
    [sourceProvider start];
}

- (void)plugin:(MapwizePlugin *)plugin didTapOnMap:(MWZLatLngFloor *)latLngFloor {
    ILIndoorLocation* location = [[ILIndoorLocation alloc] initWithProvider:basicStepProvider latitude:latLngFloor.coordinates.latitude longitude:latLngFloor.coordinates.longitude floor:latLngFloor.floor];
    [sourceProvider setIndoorLocation:location];
}

@end
