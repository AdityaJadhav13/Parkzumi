# Demo script (≈ 6 minutes)

**Before:** More › Reset demo data. Location in the pilot area (README). Online. On Android, turn on
More › Companion › Floating Zumi once (grant "Display over other apps").

## 1. The problem — 20 s
"I ride a bike in Mumbai and I've been towed about five times. The hard part isn't finding a gap —
it's knowing whether *this* spot works for *my* bike for *my* whole stay, when there's no sign."

## 2. Check a spot — 60 s
* The map colours kerbs and compounds for a bike, now, 2 h. Colour never stands alone: icon + words too.
* Tap **Somani Gram Rd · West side** (today is an odd date): **Don't park here**. Open *Rules* → the
  real Mumbai Traffic Police order (No. 64/2026) with its link. No sign needed — the rule is location-based.
* Tap the plan chip → **Later** → tomorrow (even date): it flips to *Allowed with conditions — even dates only*.
* Set arrival 10 pm with a 4 h stay on the allowed side: **Restriction starts at 12 am** — the whole stay
  is checked, across midnight.

## 3. The business rule — 45 s
* Tap **Co-op bank compound**: **Can't verify** — there's no reviewed visitor policy. Below, in purple:
  *Locals have parked here* (3 reviewed reports, longest 90 min), *asked to move after a 4 h stay*,
  *1 older report not counted*. "Useful local knowledge, shown as experience — never as permission."
* Change stay to 4 h → *No reports of stays as long as yours*.

## 4. Park — 30 s
* **Two-wheeler bay** → the only plain *Permitted* (a reviewed bay with no conditions) → **Park here**.
* Parked tab: *Be back by …*, the reason, reminders set (and honest about exact alarms on Android).

## 5. Failure and recovery — 75 s (headline)
"The server accepts my tip just before connectivity fails — then the app is killed."
* More › Diagnostics › **Lose the reply to the next tip**.
* Check › bank compound › **Share a tip** → Send, then straight away Diagnostics › **Online** off.
  Tips: *Saved on your phone · 1 step waiting to send*.
* **Force-quit the app.** Reopen. Diagnostics › Online on. Within seconds: *Waiting for review*.
* Diagnostics trail (tap the tip's id): `server.tip_committed` → `network.response_lost` →
  `outbox.retry_scheduled` → (relaunch) `outbox.recovered` → `server.duplicate_ignored` →
  `outbox.acked deduplicated=true`.
  "The server had saved it. The retry carried the same operation id, so it wasn't saved twice."
  (Automated: `test/data/recovery_test.dart` and `integration_test/journey_test.dart`.)

## 6. Another role responds — 30 s
* More › **Reviewer** → Review queue → **Accept**. Try to accept again elsewhere → *Already reviewed*.
* Back to **Rider** → Tips: *Accepted · +10 points* — once.

## 7. Rules change while parked — 30 s
* Reviewer › Orders → publish a temporary order on the place you parked, starting in 30 min.
* Rider › Parked: **Conditions changed after you parked**, new deadline, reminders moved, an alert sent.
  (An order already in force says *Now: …*.) Withdraw it → the plan is restored with an *Update* note.

## 8. AI feature — 40 s (needs `GEMINI_API_KEY`)
* Spot › **Check with a photo** → mark the spot → *Checking the photo…* → observations labelled
  *AI · unverified*. A restriction sign downgrades an allowed spot to *Can't verify*; nothing upgrades.
* Diagnostics › **Photo check times out** → typed message, the rest of the answer unchanged.

## 9. Android companion — 30 s
* Open Google Maps, tap the floating Zumi → Parkzumi opens straight into "check where I am".
* Or Share a place from Maps → "From Google Maps: …" (name only — Maps doesn't share coordinates).

## 10. One future requirement — talk
"Warn riders already parked when a temporary order is published." Today it arrives on the next sync. Real
time needs a push that triggers sync, server-side sessions for fan-out, and per-alert delivery state.
The engine, evidence versioning and session re-check already exist and don't change.
