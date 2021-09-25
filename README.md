# kevin. iOS SDK

> iOS integration for kevin. account linking and bank/card in-app payments.

## Prerequisites

- iOS minimum version 9.0

## Getting Started
1. Import library with ***Swift Package Manager*** or ***Carthage***
2. Initialize plugins you will use in the App or AppDelegate:

```swift
import Kevin

Kevin.shared.theme = KevinTheme()   //  your custom theme extending KevinTheme
KevinAccountsPlugin.shared.configure(
    KevinAccountsConfiguration.Builder(
        callbackUrl: URL(string: "https://your.callback.url")!    //  callback is mandatory
    ).build()
)
KevinInAppPaymentsPlugin.shared.configure(
    KevinInAppPaymentsConfiguration.Builder(
        callbackUrl: URL(string: "https://your.callback.url")!    //  callback is mandatory
    ).build()
)
```
## Account Linking
1. Customize linking flow by tweaking our configuration:
```swift
let configuration = KevinAccountLinkingSessionConfiguration.Builder(state: state.state)
    .setPreselectedCountry(.lithuania)  //  optional option to preselect country
    .setCountryFilter([.lithuania, .latvia, .estonia])   //  optional option to supply country list
    .setDisableCountrySelection(false)  //  optional option to disable country selection
    .setPreselectedBank("SOME_BANK_ID") //  optional option to preselect bank
    .setSkipBankSelection(false)    //  optional skip of bank selection (should be used with preselectedBank)
    .build()
```
2. Implement KevinAccountLinkingSessionDelegate protocol. Make sure you show returned UIViewController somewhere:
```swift
protocol KevinAccountLinkingSessionDelegate: AnyObject {
    func onKevinAccountLinkingStarted(controller: UIViewController)
    func onKevinAccountLinkingCanceled(error: Error?)
    func onKevinAccountLinkingSucceeded(requestId: String, code: String)
}
```
3. Call KevinAccountLinkingSession and listen to delegate:
```swift
KevinAccountLinkingSession.shared.delegate = self
try KevinAccountLinkingSession.shared.initiateAccountLinking(
    configuration: configuration
)
```
## In-App Payments
1. Customize payment flow by tweaking our configuration:
```swift
let configuration = KevinPaymentSessionConfiguration.Builder(paymentId: payment.id)   
    .setPaymentType(.bank)  // set payment type (bank or card)
    .setPreselectedCountry(.lithuania)  //  optional option to preselect country
    .setCountryFilter([.lithuania, .latvia, .estonia])   //  optional option to supply country list
    .setDisableCountrySelection(false)  //  optional option to disable country selection
    .setPreselectedBank("SOME_BANK_ID") //  optional option to preselect bank
    .setSkipBankSelection(false)    //  optional skip of bank selection (should be used with preselectedBank)
    .setSkipAuthentication(false)   //  optional skip of authentication steps (payment needs to be initialized with linked account token)
    .build()
```
2. Implement KevinPaymentSessionDelegate protocol. Make sure you show returned UIViewController somewhere:
```swift
protocol KevinPaymentSessionDelegate: AnyObject {
    func onKevinPaymentInitiationStarted(controller: UIViewController)
    func onKevinPaymentCanceled(error: Error?)
    func onKevinPaymentSucceeded(paymentId: String)
}
```
3. Call KevinPaymentSession and listen to delegate:
```swift
KevinPaymentSession.shared.delegate = self
try KevinPaymentSession.shared.initiatePayment(
    configuration: configuration
)
```
## UI customization
Built-in windows can be widely customised. Override ***KevinTheme*** and control a wide array of properties:
```swift
open class KevinTheme {
    open var primaryBackgroundColor = UIColor.white
    open var secondaryBackgroundColor = UIColor.white
    
    open var selectedOnPrimaryColor = UIColor(rgb: 0xF0F5FC)
    open var selectedOnSecondaryColor = UIColor(rgb: 0xF0F5FC)
    
    open var errorTextColor = UIColor(rgb: 0xFF0020)
    open var primaryTextColor = UIColor(rgb: 0x0B1E42)
    open var secondaryTextColor = UIColor(rgb: 0x949AA3)
    
    open var navigationBarTitleColor = UIColor.white
    open var navigationBarTintColor = UIColor.white
    open var navigationBarBackgroundColor = UIColor(rgb: 0xFF0020)
    
    open var buttonBackgroundColor = UIColor(rgb: 0xFF0020)
    open var buttonLabelTextColor = UIColor.white
    open var buttonHeight: CGFloat = 50
    open var buttonCornerRadius: CGFloat = 25
    open var buttonShadowRadius: CGFloat = 2
    open var buttonShadowOpacity: Float = 0.6
    open var buttonShadowOffset = CGSize(width: 1.0, height: 1.0)
    open var buttonFont = UIFont.systemFont(ofSize: 15)
    
    open var backButtonImage = UIImage(named: "backButtonIcon", in: Bundle.module, compatibleWith: nil)
    open var closeButtonImage = UIImage(named: "closeButtonIcon", in: Bundle.module, compatibleWith: nil)
    
    open var smallFont = UIFont.systemFont(ofSize: 14)
    open var mediumFont = UIFont.systemFont(ofSize: 15)
    open var largeFont = UIFont.systemFont(ofSize: 16)
}
```

## Examples

The ./demo folder contains a project showing how kevin. can be used.
