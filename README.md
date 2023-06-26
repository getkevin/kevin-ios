![kevin.](./images/logo.png)

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://shields.io/badge/license-MIT-blue)](https://github.com/getkevin/kevin-ios/blob/master/LICENSE)

The kevin. iOS SDK enables to easily integrate AIS and PIS services in your mobile application. We provide neat, customisable UI screens so integration would be as quick as possible. We also expose the low-level APIs that power those UIs so that you can build fully custom experiences.

If you're a developer:

- Get started with our [SDK reference](https://developer.kevin.eu/home/mobile-sdk/getting-started)
- Get started with our [Developer Portal](https://developer.kevin.eu/home/mobile-sdk/ios)
- Check out our [Samples](https://github.com/getkevin/kevin-ios/tree/master/sample) for an example of how you can easily integrate kevin. iOS SDK for the most common cases

Optionally:

- Visit our [Demo App](https://github.com/getkevin/kevin-ios-demo) for a showcase of a fully featured iOS app utilising kevin. iOS SDK

## Features

- **Account linking** - we provide an easy solution to authenticate and manage user bank accounts.
- **Bank payments** - we provide a possibility to integrate bank payments in your app with both SCA and non-SCA options.
- **Card payments** - we also provide card payments with a hybrid payment support, so the payment would be performed via bank if we detect that the card belongs to one of our supported banks.

## Installation
- **Swift Package Manager** - kevin. iOS SDK supports [Swift Package Manager](https://www.swift.org/package-manager/), which is the recommended option. Add a dependency to your project with: `.package(url: "https://github.com/getkevin/kevin-ios", from: "2.2.12")`
- **CocoaPods:** - add `pod 'kevin-ios'` to your `Podfile`

## Usage example

### Initiate payment

```
import Kevin

let paymentID = "UUID" // Put your actual payment's ID here

let configuration = try KevinPaymentSessionConfiguration.Builder(paymentId: paymentID)
    .setPaymentType(.bank)
    .build()

KevinPaymentSession.shared.delegate = self #  Set the delegate to obtain payment  session result
KevinPaymentSession.shared.initiatePayment(configuration: configuration)
```

See more [samples](https://github.com/getkevin/kevin-ios/tree/master/sample) to check the most common use cases.

## Documentation

- iOS SDK documentation can be found [here](https://developer.kevin.eu/home/mobile-sdk/ios)
- The API reference is located [here](https://api-reference.kevin.eu/public/platform/v0.3)

## Cross-platform support

At the moment [Flutter](https://developer.kevin.eu/home/mobile-sdk/flutter) and [React Native](https://developer.kevin.eu/home/mobile-sdk/react-native) integrations are supported. Please check respective cross-platform documentation for a tutorial on how to do it.

## Contributing

We welcome contributions of any kind including new features, bug fixes, and documentation improvements. Please first open an issue describing what you want to build if it is a major change so that we can discuss how to move forward. Otherwise, go ahead and open a pull request for minor changes such as typo fixes and one liners.
