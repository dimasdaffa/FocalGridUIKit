# FocalGrid: SwiftUI → UIKit Migration Notes

A learning log of how the SwiftUI FocalGrid app was rewritten in UIKit.
Read this alongside the two codebases side by side — every section maps a
SwiftUI file to its UIKit counterpart and explains what actually changed.

> **Stack:** UIKit, programmatic layout with **SnapKit**, no storyboards, forced dark mode.

---

## 0. Project-level changes

| Thing | SwiftUI | UIKit (this project) |
|---|---|---|
| App entry | `@main struct FocalGridApp: App` | `AppDelegate` + `SceneDelegate` |
| First screen | `WindowGroup { MainTabView() }` | `SceneDelegate` sets `window.rootViewController` |
| Storyboard | none | **deleted** `Main.storyboard` + its Info.plist / build-setting refs |
| Layout engine | declarative view tree | Auto Layout via SnapKit (`snp.makeConstraints`) |
| Dark mode | follows system | forced: `window.overrideUserInterfaceStyle = .dark` |

**Killing the storyboard** (3 edits):
1. Delete `Main.storyboard`.
2. Remove `UISceneStoryboardFile` from `Info.plist` → scene manifest.
3. Remove `INFOPLIST_KEY_UIMainStoryboardFile` from the build settings.
4. Set the root VC in code (`SceneDelegate.scene(_:willConnectTo:)`).

---

## 1. The mental-model shift

SwiftUI describes **what** the UI is for a given state; the framework diffs and
redraws. UIKit is **imperative** — you build a view tree once, then mutate it.

| SwiftUI reflex | UIKit reality |
|---|---|
| `body` recomputes on state change | you mutate views by hand (`label.text = …`) |
| `@State` / `@Observable` auto-redraw | store values; call an `update()` yourself |
| modifiers return **new** views | you set **properties** on one view |
| layout is implicit in the view tree | layout is explicit **constraints** |
| `ForEach` | `UITableView` / `UICollectionView` data source, or a loop adding to a `UIStackView` |

The single biggest habit change: **there is no automatic re-render.** When data
changes, nothing happens until you push it into a view.

---

## 2. View primitives

| SwiftUI | UIKit |
|---|---|
| `Text` | `UILabel` |
| `Image` | `UIImageView` |
| `Button` | `UIButton` + `addTarget(_:action:for:)` |
| `VStack` / `HStack` | `UIStackView` (`.axis = .vertical` / `.horizontal`) |
| `ZStack` | overlapping `addSubview` (draw order = add order) |
| `Spacer()` | a plain `UIView` or stack distribution / hugging priorities |
| `ScrollView` | `UIScrollView` (+ a content view pinned inside) |
| `Divider()` | a 1pt-tall `UIView` with a background color |
| `ProgressView(value:)` | `UIProgressView` |

### Modifiers → properties

| SwiftUI modifier | UIKit |
|---|---|
| `.padding(24)` | constraint insets / `stack.layoutMargins` |
| `.background(color)` | `view.backgroundColor = color` |
| `.foregroundColor` | `label.textColor` / `button.tintColor` |
| `.font(.system(size:weight:))` | `label.font = .systemFont(ofSize:weight:)` |
| `.frame(width:height:)` | width/height constraints |
| `.frame(maxWidth: .infinity)` | pin leading+trailing, or `distribution = .fill` |
| `.opacity(x)` | `view.alpha` **or** `color.withAlphaComponent(x)` |
| `.cornerRadius(r)` | `view.layer.cornerRadius = r` |
| `.shadow(radius:x:y:)` | `layer.shadow*` **or** an offset background view (see §7) |

---

## 3. Navigation

| SwiftUI | UIKit |
|---|---|
| `TabView` | `UITabBarController` (`MainTabBarController`) |
| `NavigationStack(path:)` | `UINavigationController` |
| `.navigationDestination(for:)` | `navigationController?.pushViewController(_:animated:)` |
| `.navigationDestination(item:)` | push when the selected item changes |
| `@Environment(\.dismiss)` | `navigationController?.popViewController(animated:)` |
| `.toolbar { ToolbarItem }` | `navigationItem.leftBarButtonItem` / `rightBarButtonItem` |
| `.navigationTitle` | `navigationItem.title` |
| `.toolbar(.hidden, for: .navigationBar)` | `setNavigationBarHidden(true, animated:)` in `viewWillAppear` |
| `.toolbar(.hidden, for: .tabBar)` | `hidesBottomBarWhenPushed = true` |

**Gotcha we hit:** the Dashboard hides the nav bar, but Detail needs it. Since
`setNavigationBarHidden` is on the *shared* `UINavigationController`, each screen
sets it in `viewWillAppear` — Dashboard hides, Detail shows. Otherwise the bar
state leaks between screens.

---

## 4. State & view models

The SwiftUI app uses the **Observation framework** (`@Observable`). In UIKit:

| SwiftUI | UIKit choice made here |
|---|---|
| `@Observable class VM` (auto-binds) | plain class; the VC reads it and updates views manually |
| `@State private var viewModel` | a stored `let viewModel` property |
| `$viewModel.selectedRoute` binding drives navigation | the **VC** decides when to push |

Because FocalGrid's screens are **static once shown** (no live-updating data),
we did **not** need Combine or `@Published` at all — `DetailCardViewModel` and
`MechanicDetailViewModel` became plain classes exposing computed properties.

> If a screen had changing data, you'd use `@Published` + `.sink` (Combine) or
> `NotificationCenter` / delegate callbacks to push updates into the views.

The **model layer didn't change**: `Composition`, `CompositionType`,
`GridMechanic`, `MechanicRoute`, and `CompositionMock` are pure Swift and were
copied almost verbatim. The only edit: `CompositionType.themeColor` returns
`UIColor` instead of SwiftUI `Color`.

---

## 5. Lists

SwiftUI `ScrollView { VStack { ForEach … } }` → **`UITableView`** with a data
source (`DashboardViewController`).

```swift
// SwiftUI
ForEach(CompositionType.allCases) { type in ThumbnailCardView(type: type) { … } }

// UIKit
func tableView(_:numberOfRowsInSection:) -> Int { types.count }
func tableView(_:cellForRowAt:) -> UITableViewCell { … cell.configure(with: type) … }
```

Key UIKit-isms:
- **Self-sizing cells:** `rowHeight = .automaticDimension` + `estimatedRowHeight`.
- **Cell reuse:** `register(_:forCellReuseIdentifier:)` + `dequeueReusableCell`.
- A cell is a **container** — we wrap the reusable `ThumbnailCardView` inside
  `ThumbnailCardCell` and forward the tap closure.

The mechanic list in Detail was small and fixed, so instead of a table we just
**looped and added rows to a `UIStackView`** — simpler than a table for a
handful of static rows.

---

## 6. Passing data & actions

SwiftUI components take value params + closures; **UIKit is the same idea**,
just wired manually:

```swift
// SwiftUI
ThumbnailCardView(type: type, onLearnTapped: { path.append(type) })

// UIKit
let card = ThumbnailCardView()
card.configure(with: type)
card.onLearnTapped = { [weak self] in self?.showDetail(for: type) }
```

Note `[weak self]` — UIKit closures that a view **stores** can create retain
cycles. SwiftUI's value-type views mostly sidestep this; in UIKit it's on you.

---

## 7. Neo-brutalist offset shadow (the tricky visual)

SwiftUI: `.shadow(color: .themeHardShadow, radius: 0, x: 0, y: 6)` — a hard
(non-blurred) shadow shifted straight down. Two UIKit ways, both used here:

- **Background rectangle** (`ThumbnailCardView`): a second `UIView` in
  `themeHardShadow`, same width, pinned 6pt lower, added *behind* the card.
- **Layer shadow** (`DetailCTAView` buttons):
  ```swift
  layer.shadowColor = UIColor.black.cgColor
  layer.shadowOffset = CGSize(width: 0, height: 6)
  layer.shadowRadius = 0      // 0 = hard edge, no blur
  layer.shadowOpacity = 1
  layer.masksToBounds = false // required, or the shadow is clipped
  ```

---

## 8. Markdown text

SwiftUI renders `**bold**` / `*italic*` for free via `Text(LocalizedStringKey(s))`.
UIKit has **no equivalent** — `UILabel` shows the literal asterisks.

Solution: `Extensions/Markdown.swift` parses the string into an
`NSAttributedString`, mapping markdown intents to real bold/italic fonts:

```swift
label.attributedText = Markdown.attributed(text, font: base, color: .white, lineSpacing: 7)
```

It uses Foundation's `AttributedString(markdown:)`, then walks the runs and
applies `UIFontDescriptor.SymbolicTraits` (`.traitBold` / `.traitItalic`).
`lineSpacing` (SwiftUI's `.lineSpacing`) is added via `NSParagraphStyle`.

---

## 9. The paged reader — hardest migration

SwiftUI leaned on modifiers that **have no UIKit equivalent**:

| SwiftUI | What it did | UIKit replacement |
|---|---|---|
| `.scrollTargetBehavior(.viewAligned(limitBehavior: .always))` | one-card snap paging | custom `scrollViewWillEndDragging` snapping to card tops, one card per swipe |
| `.containerRelativeFrame(.vertical) { h in h - 80 }` | text cards shorter → next peeks 80pt | explicit height constraints: text = `viewport − 80`, image = `viewport` |
| `.scrollPosition(id:)` | current page binding | tracked `currentIndex`, updated on snap |
| `.zIndex` on current card for the scrim | dim the peek without dimming incoming pages | **one** scrim view kept on top via `bringSubviewToFront`, repositioned to the current card |

This is where UIKit is *more* code but *more* control: the snapping logic is
~15 explicit lines, but you can see and tune exactly how a flick resolves.

**Carried-over limitation:** the long breakdown card needs inner scroll inside
the outer pager. This nested-scroll conflict is unsolved in SwiftUI too (see the
SwiftUI repo's CLAUDE.md) — the UIKit version has the same wart: drag scrolls the
breakdown, a hard flick can be eaten by the pager.

---

## 10. File-by-file map

| SwiftUI | UIKit |
|---|---|
| `FocalGridApp.swift` | `App/AppDelegate.swift` + `App/SceneDelegate.swift` |
| `MainTabView.swift` | `ViewControllers/MainTabBarController.swift` |
| `DashboardView.swift` | `ViewControllers/DashboardViewController.swift` |
| `DetailCardView.swift` | `ViewControllers/DetailCardViewController.swift` |
| `MechanicDetailView.swift` | `ViewControllers/MechanicDetailViewController.swift` |
| `GalleryView.swift` | `ViewControllers/GalleryViewController.swift` (stub) |
| `Components/ThumbnailCardView.swift` | `Views/Components/ThumbnailCardView.swift` + `Views/Cells/ThumbnailCardCell.swift` |
| `Components/DetailCTAView.swift` | `Views/Components/DetailCTAView.swift` |
| `Components/MechanicRowView.swift` | inlined into `DetailCardViewController` |
| `Components/ProgressBarView.swift` | inlined `UIProgressView` in the reader |
| `Views/MechanicDetailView` page | `Views/Components/MechanicCardView.swift` |
| `ViewModels/*` | `ViewModels/*` (plain classes, no `@Observable`) |
| `Models/*`, `Extensions/ColorTheme.swift` | copied; `Color` → `UIColor` |

---

## 11. Intentional differences from the SwiftUI app

Not everything is pixel-identical — some things were deliberately simplified:

- **Detail header image** uses a fixed 200pt slot (SwiftUI used intrinsic sizing).
- **ThumbnailCard image** is hidden when its asset is missing (SwiftUI showed a blank).
- **CTA bar** is edge-to-edge (SwiftUI had 16pt side margins) with a top border
  only (SwiftUI stroked all four sides).
- `MechanicRowView` and `ProgressBarView` were inlined instead of kept as
  separate component files.

---

## 12. What to study next (UIKit fundamentals used here)

1. **Auto Layout** — constraints, priorities (hugging/compression), safe areas.
2. **`UIScrollView`** — content vs frame layout guides, `contentOffset`, delegate.
3. **`UITableView`** — data source, reuse, self-sizing cells.
4. **`UINavigationController` / `UITabBarController`** — push/pop, bar items.
5. **View lifecycle** — `viewDidLoad` vs `viewWillAppear` vs `viewDidLayoutSubviews`
   (layout-dependent work, like the reader's card sizing, must wait for
   `viewDidLayoutSubviews`).
6. **`NSAttributedString`** — the UIKit way to do rich text.
7. **Retain cycles** — `[weak self]` in stored closures.
