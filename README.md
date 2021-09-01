# Headlines

## About

I have been working on an app called "Headlines". The app uses the
Guardian's news API to fetch financial articles and display them
to the user. Users can favourite articles that they like, and also
view a list of their favourite articles.

## Priorities

1. Fully functional, easy to use, stable and well-designed news reader. I
tried to match Lloyds' colour scheme (Black, Green and White), in the app
and the App Icon. I wanted to make the app friendly to new users with an
onboarding alert.
2. I added many Unit and UI tests with FIRST for business-critical features,
dependency injection and using `OHHTTPStubs` for basic request stubbing in the
UI Tests. Lots of tests make the app scalable and stable.
3. I used SwiftUI because I find the code simpler to write and easy to read.
SwiftUI is also going to become more used in production because the API is
now more stable and Apple promotes the framework for new apps.
4. I used MVC because I find the architecture maintainable. MVC is a
well-tested and common stack in live apps. I added separate services for
storage, and networking which I injected into the container `HeadlinesModel`.
This makes the `HeadlinesModel` object smaller and more testable.
5. I separated the codebase into different files and folders for the
different components in MVC. This helps to navigate the project and also
understand because each file has a single responsibility. I followed SOLID,
OOP, and POP principles to write independent classes for each function. I
used the protocols `StorageService` and `NetworkService` for mocking in
tests.
6. I used `Realm` for data persistence to improve the favouriting feature
and to reduce networking load (performance). I imported `Realm` using SPM
because Apple recommends using this solution for dependency management
wherever possible. Even though `Realm` is a third-party dependency, I believe
it's benefits of improved User Experience and performance outweigh the
disadvantages.

I used `Realm` instead of `Core Data` for a demo app because it has a simpler
API, is easier to setup and to use. `Realm` also provides faster queries,
has better performance than `Core Data`, and has mocking support for testing.
I avoided `UserDefaults` because the API is designed to only store small amounts
of user preference data.

## What I would have tackled next?

1. Add local notifications to remind users to open the app.
2. Test and improve accessibility support.
3. Add more performance tests for JSON parsing.
4. Add more unit tests for networking layer, in addition to existing UI tests.
5. Improve the onboarding process with onboarding screens instead of an alert.
Track whether an onboarding alert has been already displayed and disable it on
the next run. I didn't have time to implement this.
6. Add more features such as pull to refresh.

## Screenshots

<img src="./Headlines/Screenshots/onboarding_alert.png" width=20% height=20%/> <img src="./Headlines/Screenshots/home.png" width=20% height=20%/> <img src="./Headlines/Screenshots/favourites.png" width=20% height=20%/> <img src="./Headlines/Screenshots/error_alert.png" width=20% height=20%/>
