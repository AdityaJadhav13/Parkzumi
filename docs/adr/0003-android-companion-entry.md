# ADR 0003 — Android companion: user-toggled bubble + "Share" from Google Maps

Status: accepted for the prototype · 31 Oct 2026

## Context
The founder wants parking help available *while using Google Maps*, without opening a separate app from
the launcher. Overlay permission lets an app draw its own view over others; it does not reveal which app is
in front or what place Maps is showing.

## Decision
* A **user-enabled floating Zumi bubble** (`CompanionService`, `TYPE_APPLICATION_OVERLAY`, foreground
  service of type `specialUse` with a visible notification and a "Turn off" action). Tapping it opens
  Parkzumi straight into "check where I am" with a fresh location fix.
* **Share from Google Maps** (`ACTION_SEND text/plain`) as a second entry. Maps shares a name and link,
  not coordinates, so the app shows it as a destination name and never substitutes it for the rider's
  position or a parking entrance.
* No screen reading, no Accessibility service, no background location.

## Alternatives considered
* Detect Maps in the foreground with Usage Access and show the bubble only then — more permissions and
  battery/OEM lifecycle risks; not proven on real devices yet.
* An Accessibility service reading the Maps screen — invasive and subject to Play policy review.

## Consequences
* Verified on the Android 16 (API 36) emulator: the bubble floats over other apps, hides while Parkzumi
  itself is open, and a tap opens the nearest spot after a fresh fix; "Share" from Maps lists
  "Parkzumi — Check parking". Denied permission keeps the normal app fully usable.
* **Limitation:** the bubble stays until turned off; it is not shown *only* over Maps. Auto-activation
  and OEM battery managers remain to be validated on real devices. iOS has no equivalent overlay; there
  the app is opened normally.
