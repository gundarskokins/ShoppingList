# ShoppingList

ShoppinList is application written in Swift and SwiftUI which purpouse is to store and delete items using Firebase platform.

## Instalation

To install required dependencies use `pod install` command in your terminal.
To find more information about cocoapods and how to install use [click here](https://cocoapods.org/)

## Tests

Tests are using network calls from Firebase framework. To run be able to run tests properly, open project by using xcode and run them manually.

## Architecture 

Application business logic is handeled in `RealtimeDatabase` class
There are two models: `Basket` and `ShoppingItem` to decode stored items and save them.
There are three views in application:
- `ContentView` Main application view
- `ItemView` Item adding view
- `BasketView` Basket adding view

## TODO

- Add basket deletion logic
- Add image adding logic to the application and online storage handling
