## Introduction

This is a mobile technical test for an iOS position made for [Axa](https://www.axa.com/en) in june 2022. The explanation and requisites for the technical test are attached to this repository too in a PDF file called ["Brastlewark_mobile_test"](https://github.com/jaimearanaz/Brastlewark/blob/main/Brastlewark_mobile_test.pdf)

<p align="center">
  <img src="brastlewark.gif" alt="animated" />
</p>

## Basic architecture

The archictural decisions made for this project are based in the following:
- the **[SOLID](https://en.wikipedia.org/wiki/SOLID) principles**, the general and basic rules that every code project should follow: one single responsibility for each element, encourage extension over modification, protocols to communicate elements, where you expose just what you need, etc.
- the **MVVM pattern**, to build the relations between views, user interactions, data and its logic. Although other patterns like VIPER are more often in the iOS ecosystem, I personally feel more comfortable with this pattern as it fits better to how I think about layers and data flow. 
- the **Clean Architecture** basis, nicely described by our loved [Uncle Bob](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html), where all the elements that build up a software system are divided in three basic layers (**presentation**, **domain** and **data**), and where the communication and knowledge of each other is clearly limited. Although the Xcode folder structure is not setup exactly like that, all project elements follow the criteria for the layer they belong to.


## Views and View Models

To follow the MVVM pattern we must implement its two basic actors: **Views** and **View Models**. This poject uses a custom class called `Box` to represent those types in View Model that can be subscribed by the View using the method `bind()`. In this way, View just reacts when the data changes in View Model.

The View Models are plain classes called `ViewModel` that are defined through the protocols:
- `ViewModelOutput`, declares what data the View can subscribe to
- `ViewModelInput`, defines the view events that the View can communicate to the View Model.
- `ViewModel`, lists the use cases that are needed to achieve the View Model purpose

View Models work with classes named `UseCases` to manipulate domain data, use domain logic and achieve any other goal needed for Views. View Models are never injected with data, instead they always use the classes `UseCases` to get de data they need.

The Views are both `UIViewControllers` and `UIViews`. A View receive by injection its View Model and subscribe to the desired data throught the method `binds()`, where they implement what to do when the data change (usually, the action is to update its own view or their associated ones). Views are only responsible for showing the data that is updated from its own View Model, and to communicate user interaction events to the same View Model.


```swift

class MyViewController: UIViewController {

      var viewModel: MyViewModel?

      override func viewDidLoad() {
        super.viewDidLoad()
        binds()
      }

      func binds() { 
        viewModel?.data.bind({ data in
            DispatchQueue.main.async {
                // update view using data
            }
        })
      }
}

```

## Models and mappers

Models are just structs or classes to represent plain data with its basic logic associated. Models are used to communicate data between elements and layers, but **they don't implement** any domain or bussines logic.

To keep layers independent between each other, usually models are different and not shared between layers. Instead, each layer defines its own models, and the translation between them are made by extensions called `Mappers`.

For example, Views use its own kind of models (named with `Ui` suffix) in order to be absolutely independent for the rest of the app system. In this way, we could change the UI without affect other system models, just the `Ui` ones; or we could redefine the domain or logic models, but if the UI keeps the same, the `Ui` models will be kept too.


## Use cases

The use cases define the bussines or domain logic, those what is considered the core of our system and what defines our bussines intention. They obtain data from different sources called repositories, manipulate the data, apply its logic to it, and return it to the View Models or send it to a particular repository.

Use cases are defined in plain classes named after `UseCases`. They define a method `execute()` that triggers the action they were defined for, clearly expressed in its own class name. This method is always defined as an asynchronous method, because the clients of the use cases do not know anything about **where data is coming from** (network, data bases, system, etc.), and thus they don't even know how long the execution is going to take. 

For this asynchronous nature we use the new Swift feature `async/await`.

```swift

protocol MyUseCase {
    
    var repository: RepositoryProtocol { get set }
    func execute() async throws
}

class DefaultMyUseCase: MyUseCase {

    var repository: RepositoryProtocol
    
    init(repository: RepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws {
        do {
            try await repository.doStuff()
        } catch let error {
            throw error
        }
    }
}

```


## Repositories

The repositories are the sources of data used across the app. In this project are defined two main data sources:
- `NetworkRepository` is the repository that fetchs the data from its original remote source. 
- `NonPersistentRepository` is the one used for temporary allocated data, that is, data that is only available during the life cycle of the app, or until it's intentionally invalidated.

In the middle of those repositories, we have a cache manager called `CachedRepository`. This manager retrieves data from network only when it's not available in the non persistent state, then stores it there, and retrieves it from non persistent again in the folling requests.

For networking operations the app uses the new Swift framework `Combine`.


## Dependency injections

This is a basic tecnhique where every actor receives during its initialization the other actors they need to perform its responsability, instead of create them by its own. Besides this, these elements **depend always on protocols or interfaces**, instead of a particular element.

Dependency injections are handled with a third party library called [SwinjectStoryboard](https://github.com/Swinject/SwinjectStoryboard). When a new `UIViewController` is going to be presented from a segue in the storyboard, it starts the injection process through a method called `setup` in the `DependencyInjection` file. All the needed injections (View Controllers, View Models, Use Cases, Repositories) are declared in their corresponding `DI` files.


## Navigation

The app navigation is primary based in the use of **scenes in a storyboard**, and the defined **segues** to represent the avialable transitions between these scenes.

In one hand, the View Model defines an observable enumerated property named `transitionTo`, whose values correspond to the **same segues** declared in the storyboard for this scene. When `transitionTo` changes, the subscribed View Controller reacts to this change and starts the navigation process.

```swift

enum MyViewModelTransitions: String {

    case toSceneOne
    case toSceneTwo
}

protocol MyViewModelOutput {
    var transitionTo: Box<MyViewModelTransitions?> { get set }
}

protocol MyViewModelInput {
    func didSelectSomeButton()
}

class MyViewModel: MyViewModelOutput, MyViewModelInput {

    var transitionTo = Box<MyViewModelTransitions?>(nil)

    func didSelectSomeButton() {
        transitionTo.value = .toSceneOne
    }
}

```

In the other hand, as the View Controller subscribes to `transitionTo` in its `binds()` method, it can detect and handle the desired transition using a custom method called `performTransition(to:)`. This method will trigger the associated segue with the native `perfomSegue(withIdentifier):`, and will do any additional operations that are needed for the next View Controller to show.

```swift

class MyViewController: UIViewController {

    var viewModel: MyViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        binds()
    }

    func binds() { 
        viewModel?.transitionTo.bind({ data in
            DispatchQueue.main.async {
                self.perfomTransition(to: transitionTo)
            }
        })
    }

    @IBAction func didSelectSomeButton() {
        viewModel?.didSelectSomeButton()
    }

    private func perfomTransition(to transitionTo: FilterTransitions) {
        
        switch transitionTo {
        case .toSceneOne:
            performSegue(withIdentifier: transitionTo.rawValue, sender: self)
        case .toSceneTwo:
            performSegue(withIdentifier: transitionTo.rawValue, sender: self)
        }
    }
}

```

## Third party libraries

The following third party libraries are used via Cocoapods in this project:

- [SwinjectStoryboard](https://github.com/Swinject/SwinjectStoryboard), a library to handle the dependecy injections when using view controller instantiated from storyboards. 
- [SDWebImage](https://github.com/SDWebImage/SDWebImage), a well known library to handle with the image downloading and cache.
- [MultiSlider](https://github.com/yonat/MultiSlider), an useful double slider control used to pick a range of values.
- [Mockingjay](https://github.com/kylef/Mockingjay), an elegant library to mock HTTP responses and used during unit testing.


## What's next...

There are some improvements and new features that could be included in future releases...
- expect the **city name** in the JSON file as a dynamic property, not always set to the given `brastlewark`, and keeping the rest of JSON structure the same as now.
- following the later, to **select a different city** from a menu when the app starts for first time, not always "Brastlewark".
- implement the details UI inside of a `UIScrollView`, so if there are more character data in the future, or more friends per character, the user could scroll down to see all of it.
- implement the filter UI with a `UITableViewController`, and implement different `UITableViewCell` objects for every type of indivudal filter that is needed (i.e., a cell for sliders, a cell for one-single-option tables, a cell for multi-option tables, etc,).
- include **UI testing**, using the framework `XCUITest` or even **snapshot testing**.
- more tests in general, not thinking of 100% of coverage (that's not necessarily useful, it's just a number!), but instead useful unit tests and functional tests to coverage the real core of the app.
- rethink the whole UI/UX like icons, fonts, colors, interactions, CTAs... I'm trying to be a good developer, not a good designer 😜
