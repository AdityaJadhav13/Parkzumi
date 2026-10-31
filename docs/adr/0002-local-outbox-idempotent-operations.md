# ADR 0002 — Local-first outbox with stable operation ids

Status: accepted · 31 Oct 2026

## Context
Riders report from basements, compounds and moving trains. A request can fail before reaching the server,
fail on the server, or **succeed on the server while the reply is lost**. Retrying blindly then creates a
duplicate tip and a duplicate reward; not retrying loses the tip. A photo and its report can also fail
separately.

## Decision
* A tip and its outbox operations are written to the device SQLite database **in one transaction**.
* Every operation has a client-generated id kept across retries. The server stores the result per id
  (`srv_operations`) and returns it on a repeat (`deduplicated: true`). Tips also have client ids, and
  rewards have the tip id as primary key — a second grant is impossible.
* `SyncEngine` drains due operations in order, respects `dependsOn` (photo before report), retries
  transient failures with backoff (2–60 s), and stops retrying permanent ones with a visible reason.
* At launch, operations left `inFlight` by a crash become `pending` again — safe because of the ids.

## Alternative considered
Call the server directly from the screen and let the user press "retry". Rejected: duplicates on lost
replies, lost tips on app kill, and the rider stuck on a spinner while offline.

## Consequences
* "Saved on your phone. We'll retry when connected." is a true statement, demonstrated by
  `recovery_test.dart` with real database files closed and reopened.
* **Limitation:** eventual consistency — a tip may take time to reach review, and the device mirror of a
  tip's status lags until the next pull. The server here is simulated in-app (own database file);
  transport, authentication and multi-device sync are not yet real.
