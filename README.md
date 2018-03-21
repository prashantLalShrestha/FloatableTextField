# FloatableTextField

[![CI Status](http://img.shields.io/travis/prashantLalShrestha/FloatableTextField.svg?style=flat)](https://travis-ci.org/prashantLalShrestha/FloatableTextField)
[![Version](https://img.shields.io/cocoapods/v/FloatableTextField.svg?style=flat)](http://cocoapods.org/pods/FloatableTextField)
[![License](https://img.shields.io/cocoapods/l/FloatableTextField.svg?style=flat)](http://cocoapods.org/pods/FloatableTextField)
[![Platform](https://img.shields.io/cocoapods/p/FloatableTextField.svg?style=flat)](http://cocoapods.org/pods/FloatableTextField)
[![Swift 4.0](https://img.shields.io/badge/Swift-4.0-orange.svg?style=flat)](https://developer.apple.com/swift/)

## Example

![Alt Text](https://github.com/prashantLalShrestha/FloatableTextField/blob/master/Example/FloatableTextField/FloatableTextField.gif)

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

Swift version 4.0+

Xcode 9.0+

## Installation

FloatableTextField is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'FloatableTextField'
```

## Usage

1. Add a TextField in your viewcontroller view.
2. Set the class for the TextField to FloatableTextField
3. Create an outlet for the textField in your viewcontroller class

```ruby
@IBOutlet weak var floatTextField: FloatableTextField!
```

### FloatableTextFieldDelegate

FloatableTextFieldDelegate is similar as UITextFieldDelegate.

```ruby
floatTextField.floatableDelegate = self
```

### Set State Icon
In order to enable the state icon, add the Footer Image as defaultImage.png in yout Attribute Inspector.

### Set State message
```ruby
func setState(_ state: State, with message: String = "")
```

For Default Message
```ruby
floatTextField.setState(.DEFAULT, with: "Default State Message")
```

### Enable State Button Action
You can configure state button action to display your own info or popups.
```ruby
floatTextField.onStateButtonClick = {
// Action
}
```

### Enable DropDown
To enable DropDown you jst have to set the Is DropDown Enbaled to Yes in your attribute inspector And configure the dropDown Action as following in your view controller
```ruby
floatTextField.onDropdownClick = {
    // Action
}
```

## Author

prashantLalShrestha, prashantlurvs@gmail.com

## License

FloatableTextField is available under the MIT license. See the LICENSE file for more info.
