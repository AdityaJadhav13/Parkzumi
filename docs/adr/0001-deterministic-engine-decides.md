# ADR 0001 — A deterministic engine decides; AI and the community only observe

Status: accepted · 31 Oct 2026

## Context
Riders want a fast answer to "can I leave my bike here for 2 hours?". The tempting design is to send a
photo and location to a large model and let it answer. But the costly failure is a false "yes": the
founder has been towed about five times, and Mumbai rules depend on road side, date parity, time windows
and orders that are often not visible in any photo.

## Decision
`AssessmentEngine` (pure Dart) computes the verdict from **reviewed official or operator evidence only**,
over the whole stay (split at every schedule boundary, Asia/Kolkata time). It returns a verdict plus
separate dimensions — rules, property access, rider experiences, leaving & returning, at the spot,
evidence quality — and an explicit list of unknowns.

Gemini 4 Argon returns *structured observations* (signs, objects near the marked spot, uncertainties),
validated against a schema. It can only **add** concerns (a restriction sign downgrades the verdict to
"Can't verify"); it can never grant permission. Community tips appear as dated experiences after review.

## Alternative considered
An LLM verdict from photo + location + retrieved rules. Rejected: not reproducible, hard to test, can
invent notifications, and a confident wrong answer looks identical to a right one.

## Consequences
* Every answer is explainable and covered by unit tests (27 engine tests).
* The AI feature fails safe: timeouts, malformed JSON or refusals leave the rest of the answer intact.
* **Limitation:** coverage is only as good as curated evidence, so many places honestly show "Can't verify".
  Growth depends on reviewed data (field surveys, official orders, operator confirmations), not on the model.
