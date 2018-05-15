#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController {
    MapwizePlugin* mapwizePlugin;
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
    basicStepProvider = [[ILBasicStepLocationProvider alloc] init];
    [mapwizePlugin setIndoorLocationProvider:basicStepProvider];
}

- (void)plugin:(MapwizePlugin *)plugin didTapOnMap:(MWZLatLngFloor *)latLngFloor {
    ILIndoorLocation* indoorLocation = [[ILIndoorLocation alloc] init];
    indoorLocation.latitude = latLngFloor.coordinates.latitude;
    indoorLocation.longitude = latLngFloor.coordinates.longitude;
    indoorLocation.floor = latLngFloor.floor;
    [basicStepProvider setIndoorLocation:indoorLocation];
}

@end
