# basic-step-indoor-location-provider-ios
Concept of provider using the gyroscope and accelerometer to determine your location.

## Use

Instantiate the provider with Sensor System Service
```
ILBasicStepProvider = [[ILBasicStepLocationProvider alloc] init];
```

Set/Move provider's location:

```
[ILBasicStepProvider setIndoorLocation:indoorLocation];     
```

Set the provider in your Mapwize SDK:

```
[mapwizePlugin setIndoorLocationProvider:ILBasicStepProvider];
```

## Demo
Tap on the screen to set your location.

## Contribute

Contributions are welcome. We will be happy to review your PR.

## Support

For any support with this provider, please do not hesitate to contact [support@mapwize.io](mailto:support@mapwize.io)

## License

MIT