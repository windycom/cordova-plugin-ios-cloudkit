# cordova-plugin-ios-cloudkit

iOS Cordova plugin exposing Apple's `CloudKit` framework. Main motivation was lack of communication between iOS devices belonging to the same Apple ID user.

App groups work only on the same device and `NSUbiquitousKeyValueStore` used in [Cordvoa Plugin Settings](https://github.com/dpa99c/cordova-plugin-cloud-settings) was discontinued on watchOS.

Plugin uses private database of user's iCloud and expose only minimal part of original `CloudKit` Apple framework. It works as simple key/value store, whereas stored and retrieved value is always `String` so use `JSON.parse` and `JSON.stringify` methods to store complex data.

To make plugin work, some knowledge of `xcode` is required.

## Installation

Install your cordova plugins

```sh
    # Although this plugin should be installed autimatically
    # as dependency its installation sometimes fail
    cordova plugin add cordova-plugin-add-swift-support

    cordova plugin add cordova-plugin-ios-cloudkit
```

Make sure you properly set your iCloud database in xcode for development as described [here](https://developer.apple.com/documentation/coredata/mirroring_a_core_data_store_with_cloudkit/setting_up_core_data_with_cloudkit)

Then monitor correct functionality of the plugin in [Apple iCloud dashboard](https://icloud.developer.apple.com/)

## Usage

Plugin can be found at `cordova.plugins.cloudKit` and can be used after `deviceReady` event.

```js
    // Just shortcut
    const cloudKit = cordova.plugins.cloudKit;

    // Initializes cloud credentials
    cloudKit.init(
        "iCloud.com.name.of.your.container", // Cloud ID
        "keyValueStore" // Record type. Just any string to identify stored data
    );

    // Inserts / updates key-value pair to iCloud
    cloudKit.set(
        "Hello", // key
        "World", // value (any string), use JSON.stringyfy to store complex obejcts
        succ => { /* Succcess */ },
        err => { console.error(err) }
    );

    // Retrives value
    cloudKit.get(
        "Hello", // key
        val => { console.log(val) }, // Always String. USe JSON.parse to parse stringified objects
        err => { console.error(err) }
    );

    // Deletes a record
    cloudKit.delete(
        "Hello", // key
        succ => { /* Succcess */ },
        err => { console.error(err) }
    );

```

## MIT license

Copyright (c) 2021 Windyty, S.E.

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
