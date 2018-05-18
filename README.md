# Basic Step IndoorLocation Provider for iOS

This is a very very basic relative motion provider to illustrate how motion can be used to update a phone location from an inital location. It basically counts the steps you are making and makes the location to move of a fixed distance in the direction given by the compass.

This provider is built for education purpose and is not intended to be used in critical applications. For a more precise and robust solution, we advise to have a look at the [Navisens IndoorLocation Provider](https://github.com/IndoorLocation/navisens-indoor-location-provider-ios).

## Use

Instantiate the provider with an IndoorLocationProvider as source provider.
```
ILBasicStepLocationProvider basicStepProvider = [[ILBasicStepLocationProvider alloc] initWithSourceProvider:sourceIndoorLocationProvider];
```

Set the provider in your Mapwize SDK:

```
[mapwizePlugin setIndoorLocationProvider:basicStepProvider];
```

## Demo
Tap on the screen to set your location.

## Contribute

Contributions are welcome. We will be happy to review your PR.

## Support

For any support with this provider, please do not hesitate to contact [support@mapwize.io](mailto:support@mapwize.io)

## License

MIT