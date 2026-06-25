# Repository Guidelines

## Project Structure & Module Organization

This is an iOS SwiftUI project centered on `RickAndMorty.xcodeproj`. App source lives in `RickAndMorty/` and is organized by role:

- `views/`, `components/`, and `coordinator/` contain SwiftUI screens, reusable UI, and navigation flow.
- `viewModel/`, `services/`, `repository/`, and `api/` contain state, networking, persistence-facing logic, and REST helpers.
- `model/` contains app data types, while `utils/` contains Core Data, keychain, defaults, points, and reward helpers.
- `res/Assets.xcassets` and `res/fonts` hold image and font assets.
- Unit tests live in `RickAndMortyTests/`; UI tests live in `RickAndMortyUITests/`.

## Build, Test, and Development Commands

Open locally with:

```sh
open RickAndMorty.xcodeproj
```

List schemes and targets:

```sh
xcodebuild -list -project RickAndMorty.xcodeproj
```

Build from the command line:

```sh
xcodebuild -project RickAndMorty.xcodeproj -scheme RickAndMorty -configuration Debug build
```

Run tests with an available iOS simulator destination:

```sh
xcodebuild test -project RickAndMorty.xcodeproj -scheme RickAndMorty -destination 'platform=iOS Simulator,name=iPhone 16'
```

## Coding Style & Naming Conventions

Use Swift API Design Guidelines and the existing project style: 4-space indentation, one primary type per file, `PascalCase` for types (`CharactersViewModel`), and `camelCase` for properties, methods, and local variables. Keep SwiftUI views small and compose shared UI in `components/`. Prefer dependency boundaries already present in the repo: API helpers in `api/`, remote calls in `services/`, and app state in `viewModel/`.

## Testing Guidelines

The unit test target uses Swift Testing (`import Testing`) with `@Test` functions and `#expect(...)` assertions. Name tests after behavior, for example `@Test func awardsDailyRewardOncePerDay()`. Put view model, service, repository, and utility tests in `RickAndMortyTests/`; reserve launch and interaction flows for `RickAndMortyUITests/`. Run the full test command before opening a pull request when simulator access is available.

## Commit & Pull Request Guidelines

No Git history is present in this workspace, so use clear imperative commit messages such as `Add daily reward tests` or `Fix sticker trade payload decoding`. Pull requests should include a short summary, test results, linked issue or task context, and screenshots or screen recordings for UI changes. Call out changes to assets, Core Data models, permissions, or networking behavior because they affect review and release risk.

## Security & Configuration Tips

Do not commit secrets, API keys, provisioning profiles, or personal Xcode user data. Keep sensitive storage changes inside `KeychainManager` and user preference changes inside `UserDefaultsManager`. When editing Bluetooth, networking, or Info.plist permissions, document why the permission is needed and verify the affected flow on device or simulator.
