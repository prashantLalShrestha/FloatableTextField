# FloatableTextField

[![CI Status](http://img.shields.io/travis/prashantLalShrestha/FloatableTextField.svg?style=flat)](https://travis-ci.org/prashantLalShrestha/FloatableTextField)
[![Version](https://img.shields.io/cocoapods/v/FloatableTextField.svg?style=flat)](http://cocoapods.org/pods/FloatableTextField)
[![License](https://img.shields.io/cocoapods/l/FloatableTextField.svg?style=flat)](http://cocoapods.org/pods/FloatableTextField)
[![Platform](https://img.shields.io/cocoapods/p/FloatableTextField.svg?style=flat)](http://cocoapods.org/pods/FloatableTextField)

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

### Set State message
```ruby
func setState(_ state: State, with message: String = "")
```

For Default Message
```ruby
floatTextField.setState(.DEFAULT, with: "Default State Message")
```

## Author

prashantLalShrestha, prashantlurvs@gmail.com

## License

FloatableTextField is available under the MIT license. See the LICENSE file for more info.
