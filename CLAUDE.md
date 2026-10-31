# Parkzumi — MAL4 Hackathon app

Event: Mobile Architecture Lab 04, 1 Nov 2026, Paytm Mumbai. Rules: https://mobilearchitecturelab.com/mal4/
Product briefs: `docs/briefs/` (agent brief, design system, blueprint). Architecture: `docs/architecture.md`. ADRs: `docs/adr/`.

## Scoring (optimise for this, not feature count)
- Architecture 60%: problem framing 10, structure/boundaries 15, data & state 15, failure & recovery 10, trade-offs 10
- Testing & observability 15% · Working journey 15% · Architecture defence 10%
- Bonus: Measure SDK (measure.sh) perf data from a real journey; `gemini-4-argon` feature with loading + failure states
- Judges check that diagrams, decision records, code and demo agree — keep docs in sync with code.

## The business rule (never weaken it)
Only reviewed official/operator evidence covering the whole stay can make a spot **Permitted**. Community tips and
AI photo readings may add concerns, never permission. Enforced in `lib/domain/engine.dart`, tested in `test/domain/`.

## Stack
- Flutter (Dart 3.13), one codebase for Android and iOS, **iOS look and feel on both** (Cupertino widgets,
  `platform: TargetPlatform.iOS`, Cupertino page transitions, haptics). Brand tokens in `lib/app/theme.dart`.
- Riverpod 3 (providers in `lib/app/providers.dart`), drift/SQLite (device DB + separate simulated server DB),
  flutter_map (OSM tiles), flutter_local_notifications, geolocator, image_picker, http (Gemini REST).
- Layers: `lib/domain` (pure Dart, no Flutter) ← `lib/data` ← `lib/app` ← `lib/ui`. `lib/platform` = OS adapters.
- Android companion: `android/app/src/main/kotlin/.../CompanionService.kt` + `MainActivity.kt` (MethodChannel `parkzumi/companion`).

## Commands
- `dart run build_runner build --delete-conflicting-outputs` after editing drift tables
- `flutter test` · `flutter analyze`
- Run with AI: `flutter run --dart-define-from-file=config/dart_defines.json` (git-ignored; see the `.example`)
- Full device journey + screenshots: `scripts/journey.sh <device-id>`

## Design principles (Apple HIG + Parkzumi design system)
- Clarity, deference, depth. Content first. Every touch gets feedback (press state + haptic where meaningful)
- Motion 120/180/240 ms, curve (0.2, 0.8, 0.2, 1); respect Reduce Motion
- Targets ≥ 48 dp, Dynamic Type, screen-reader labels, contrast ≥ 4.5:1; colour never carries meaning alone
- Design loading, empty, error, offline and pending states for every screen

## Tooling available to Claude
- Plugins: ui-ux-pro-max, frontend-design, swift-lsp, figma, context7 (library docs), supabase
- MCPs (`.mcp.json`): dart (Dart/Flutter MCP: analyze, test, hot reload, pub), mobile-mcp (drive simulator/emulator),
  XcodeBuildMCP, apple-docs (Apple docs + HIG)
- Devices: iOS Simulator (Xcode 26.2); Android emulator AVD `Medium_Phone_API_36.0` (SDK at `~/Library/Android/sdk`)
