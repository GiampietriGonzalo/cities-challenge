# Cities - Ualá Mobile Challenge (iOS)

This is an iOS solution to the Ualá Mobile Challenge, implemented in **Swift** using **SwiftUI**, **SwiftData**, **Clean Architecture** and SOLID principles.

---

## 🧱 Architecture

The app follows a layered Clean Architecture design with MVVM for the Presentation layer.
Each layer is isolated and communicates only through protocols, which enables testability and clear separation of concerns.

### Architecture Overview

```
[ Presentation Layer (SwiftUI Views + ViewModels (MVVM)) ]
        ⇅
[ Domain Layer (UseCases + Entities + Protocols) ]
        ⇅
[ Data Layer (Repositories + DTOs + Networking + SwiftData) ]
```

### Design Choices

- **Clean Architecture** separates the app by responsibility, enabling scalable and testable code.
- **MVVM + SwiftUI** for modern declarative UI binding.
- **Protocol-Oriented Programming** enables mocking and swapping implementations easily.
- **Manual Dependency Injection** via `AppContainer`.
- **SwiftData** persists favorite cities between launches.
- **NetworkingClient** abstracts URLSession and is injected into repositories.

---

## 📁 Folder Structure

```
Cities/
├── App/                     # App entry point & DI
│   └── DependencyInjection/
│       └── AppContainer.swift

├── Presentation/            # SwiftUI Views + ViewModels
│   ├── CityList/
│   │   ├── Views/
│   │   ├── ViewModels/
│   ├── CityDetail/
│   │   ├── Views/
│   │   ├── ViewModels/
│   └── Shared/UIComponents/

├── Domain/                  # Business logic & interfaces
│   ├── Entities/
│   ├── UseCases/

├── Data/                    # Implementations, persistence & parsing
│   ├── Repositories/
│   ├── Networking/
│   ├── DTOs/
│   └── Models/              # SwiftData models

├── Resources/               # Assets
├── CitiesTests/             # Unit tests
├── CitiesUITests/           # UI tests

└── README.md
```

---

## 💡 Dependency Injection

- `AppContainer` is the composition root and builds all dependencies.
- Initialises and injects all dependencies incluiding Repositories and UseCases.
- ViewModels are injected into views at the root level.

---

## 🧪 Testing

- **Unit tests** validate search correctness and data logic
- **UI tests** ensure filtering, favorites, and navigation behave correctly

---

## 🔧 Project Build Requirements

- Xcode 16+
- iOS 18+

---

## 🗂 Assumptions & Decisions

- Favorite status is persisted only by `cityID`
- City details screen may include static or mock data beyond coordinates [Decision Pending]
- Map screen uses native MapKit integration

---

## 📬 Contact

For any questions related to the implementation, feel free to reach out to giampietri.gonzalo@gmail.com
