# Mumbai Parking Companion: Coding Agent Brief

Prepared: 31 October 2026  
Status: Product and engineering handoff, not a final specification  
Initial market: Mumbai, India  
Initial priority: Two-wheeler owners on Android  
Working name: Not decided

## 1. Instructions to the receiving agent

Read this entire brief before deciding what to build. It consolidates a brainstorming conversation, including ideas that are still exploratory.

**Think independently. Do not rely entirely on this document.** Challenge assumptions, research current platform capabilities and local data, identify missing requirements, and propose ideas of your own. Improve or replace a proposed solution when you can explain why it better serves the owner of the vehicle. The goal is a useful, defensible product, not literal implementation of every suggestion below.

In particular:

- Apply first-principles reasoning to the real causes of parking uncertainty and towing.
- Distinguish the founder's requirements from implementation suggestions and stretch ideas.
- Check the actual repository and available infrastructure before choosing a stack or adding dependencies.
- Verify Android capabilities and restrictions on the devices and OS versions being targeted.
- Verify legal and operational claims against current primary sources. A community anecdote, an old circular, and a current notification have different evidentiary value.
- Document important assumptions and trade-offs. Do not invent APIs, live data, venue permissions, towing probabilities, or guarantees.
- Recommend a small, coherent first implementation. The complete feature list is a direction for the product, not an instruction to build everything at once.
- Keep this work focused on product behaviour, data, engineering, and feasibility. **Visual design, screen layouts, themes, mockups, and other UI design decisions are outside this brief.** References to a Maps companion or floating entry point describe an integration requirement, not a prescribed visual treatment.

## 2. The problem and personal motivation

The founder rides a bike in Mumbai and reports that it has been towed approximately five times. They have also experienced increasing amounts payable across incidents. The recurring problem is uncertainty before leaving a vehicle: an apparently usable space may have no obvious parking sign, unclear access conditions, or a restriction the rider does not know about.

The product should help answer:

1. Can this specific vehicle reasonably be parked at this exact spot for the intended duration?
2. What evidence supports that assessment, and what remains unknown?
3. What nearby alternatives actually work for people, including local and unofficial options?
4. Will the owner be able to enter, leave the premises, and retrieve the vehicle at their return time?
5. Can someone reach the owner if the vehicle needs moving?
6. What should the owner do if the vehicle is missing or has been towed?

The first-principles problem is a combination of location, duration, permission, physical conditions, changing information, and the owner's absence from the vehicle. A parking map alone does not resolve all of these.

## 3. Product definition

Build a mobile parking companion that combines:

- Current device location and the exact intended parking position.
- A photograph or photographs of the surroundings when relevant.
- Applicable parking rules and location-specific restrictions.
- Vehicle type, arrival time, intended return time, and relevant eligibility conditions.
- Venue and property access information.
- Recent community experiences, including tolerated unofficial parking.
- Personal parking history and active parking sessions.

The intended value is practical parking guidance before and during a visit, supported by explanations and local knowledge. It should help people make a better decision without requiring them to start every trip by opening a separate app from their launcher.

Do not reduce the product to sign recognition, generic slot booking, or housing-society visitor management. Those are components or adjacent ideas. The core is helping an individual vehicle owner decide where to leave their vehicle and manage what happens afterwards.

Do not promise that a vehicle will or will not be towed. The system can identify restrictions, report observed experiences, explain uncertainty, and support timely interventions. Predicting an individual enforcement action is a different problem requiring evidence that has not been established.

## 4. Requirements clearly expressed by the founder

### 4.1 Combine evidence, rather than relying on a photo alone

The founder wants to photograph the surroundings and obtain parking guidance. They explicitly clarified that the app should also use location and other relevant information. This is not an image-only classifier.

An assessment should consider the exact road side, the intended parking space, vehicle type, duration, local restrictions, venue access conditions, and available community evidence.

### 4.2 Work when signs are missing or unclear

Missing signs are a central use case. The absence of a detected sign cannot be the basis for declaring a spot permitted. Location-based rules, physical obstruction, and other evidence must still be considered.

### 4.3 Help before travelling as well as after arrival

Before a visit, the owner should be able to establish whether a destination offers parking, whether outside visitors can use it, and whether it is suitable for their vehicle and stay.

The founder used attending an event at a Paytm office as an example. The precise building and its parking policies were not verified. Treat that as a scenario, not an established venue listing.

### 4.4 Include real-world parking jugaads

The founder does not want the app to exclude useful local knowledge merely because a place is not formally advertised as public parking. Examples include people using a bank compound while visiting a nearby event, office visitor spaces with casual checks, or mall parking while visiting somewhere outside the mall.

Preserve practical observations such as:

- Outsiders have parked here and left the premises.
- No customer check was reported during a particular visit.
- A token, purchase, payment, or host confirmation was required.
- A bike was accepted but a car was refused.
- Short stays worked, but longer stays caused objections.
- Access depended on the time, day, staff, or gate closing.
- Other drivers experienced refusal, a request to move, a confrontation, or vehicle removal.

These observations are useful even when formal permission is unknown. Do not turn the product into a lecture about rules. Equally, do not transform successful anecdotes into claims of legal permission or guaranteed acceptance.

### 4.5 Support community contributions and benefits

People using the app can contribute parking information and receive benefits. The incentive mechanism is not final. Prefer useful, corroborated contributions over rewarding raw response counts.

### 4.6 Be available from the user's existing Google Maps activity

The founder's intended behaviour is a companion entry point available while Google Maps is being used, analogous to an assistant that is accessible in the context where help is needed.

The user should be able to invoke parking help, have their location resolved, and immediately obtain nearby options or begin a spot assessment. Do not require a fresh destination search when the relevant context can be obtained legitimately.

## 5. Android and Google Maps integration

### Intended functional behaviour

After installation and setup, the app should provide a user-invoked parking companion while Google Maps is in use. Invoking it should bring the owner directly into location-aware parking functionality, not a generic starting experience.

The existing proposal is an Android application overlay. The overlay belongs to this app; it is not an official extension inserted into Google's own interface.

### Capabilities that must be kept separate

| Capability | Engineering consideration |
| --- | --- |
| Display an application overlay | Android supports application overlays with user-granted special permission. |
| Make it appear specifically when Maps opens | Requires a separately validated app-state detection and service-lifecycle approach. Usage Access is one candidate, not a guaranteed implementation. |
| Determine current physical location | Use the app's own location permission and location provider. |
| Know the place or route currently selected in Maps | Overlay permission does not expose this. Use an explicit handoff, such as a shared place, where needed. |
| Assess a photographed space | Obtain the relevant photo and exact intended position, then combine observations with other evidence. |
| Return navigation to the chosen parking entrance | Use supported Maps links or intents. |

Prefer obtaining a fresh location after the user invokes parking help and the app is visible, if that satisfies the requirement. Do not assume continuous background location is necessary for the first version.

Current location, the centre of the map being viewed, the destination selected in Maps, and the actual parking entrance are different pieces of information. Do not silently substitute one for another.

Background services, app-state detection, permission revocation, process death, and manufacturer battery management require real-device testing. Do not claim that Maps-only activation works reliably until it has been demonstrated. An overlay permission alone is insufficient.

Receiving a place through Google Maps sharing is a useful fallback and a separate entry route. It should not replace the requested companion integration without an explicit, explained trade-off.

If considering Accessibility services or screen capture, first determine whether a narrower mechanism is sufficient. Such capabilities require their own current platform and distribution-policy assessment. Do not make undeclared screen reading a hidden dependency of the product.

Android is the initial implementation priority. Do not assume that the same integration is available on other mobile platforms.

## 6. Functional scenarios

### A. Checking a destination before leaving

An owner provides a destination, vehicle, and planned stay. The system compares venue parking and alternatives. It distinguishes visitor eligibility, whether the owner can leave the premises, operating hours, charges, and separately reported space availability.

The result may include a venue's own parking, a designated public lot, or a community-reported local option.

### B. Checking an exact spot after arrival

The owner invokes the companion, confirms the physical location if necessary, identifies the intended parking position, and provides relevant surroundings photos. The system combines physical observations, mapped rules, time conditions, and community reports.

If a specific uncertainty can be resolved with another observation, request that observation. Otherwise explain the missing evidence and offer alternatives.

### C. Using an unofficial local option

A bank or office compound has recent reports of outsiders parking successfully. The system exposes those observations, their conditions, contradictory reports, and whether formal permission is known. The owner can compare it with other options for the actual length of the visit.

An open gate, a successful ATM transaction, or the absence of a customer check should not silently become an entitlement to park for an unrelated multi-hour visit.

### D. Managing an active parking session

The owner saves where the vehicle is parked and their intended return. Reminders account for any known deadline and the time needed to get back. Important session information survives an app restart.

### E. Reaching the owner or recovering a vehicle

Someone beside a vehicle can use an optional contact mechanism to alert its owner. If the owner discovers the vehicle is missing, the app gathers their saved parking context and directs them to appropriate official assistance and recovery resources.

A user report of removal, an unexplained disappearance, and confirmed towing must remain distinguishable.

## 7. Assessment model and evidence

Keep these dimensions separate:

| Dimension | Examples |
| --- | --- |
| Applicable restrictions | A prohibition, time window, vehicle category, or temporary order. |
| Property access | Public access, customer-only, guest-only, host approval, or unknown. |
| Observed acceptance | Outsiders admitted, checks reported, mixed experiences, or no observations. |
| Ability to leave and return | Offsite visits allowed or observed, maximum stay, gate closing, retrieval restrictions. |
| Physical suitability | Possible obstruction, blocked entrance, narrow access, unstable surface, or insufficient evidence. |
| Capacity | A recent available-space report, confirmed occupancy where supported, or unknown. |
| Evidence quality | Source, spatial match, timestamp, verification, contradictions, and coverage gaps. |

A rules assessment may conclude that a restriction applies, that parking is permitted under identified conditions, or that it cannot be verified. Independently, a community assessment may describe tolerated use, refusals, or mixed experience.

Do not collapse these into one unexplained safe/unsafe score. Do not generate numerical towing probabilities without a validated dataset and method. Repeated successful reports can support a claim about observed experiences, not a precise probability of avoiding towing.

Consider the entire intended stay, including changes of time window, midnight, day of week, gate hours, and temporary restrictions. Use the appropriate local time zone, initially Asia/Kolkata.

Explicit prohibitions, physical concerns, and conflicting reports should not disappear because a spot is popular. At the same time, uncertainty about formal permission should not erase useful firsthand observations.

### Photo interpretation

Photographs can help identify signs, markings, entrances, crossings, road edges, possible fire equipment, and possible obstruction. The owner must identify the intended space; a general scene alone can be ambiguous.

The founder mentioned pillars and red boxes as examples. **Do not hardcode a rule that every pillar or red object makes parking prohibited.** Establish what the object appears to be, what access or visibility may be affected, and whether there is enough evidence to apply a relevant rule.

An image model should return structured observations and uncertainties. A deterministic or otherwise explainable assessment layer should combine them with sourced rules. The model must not invent local notifications or grant parking permission from appearance alone.

## 8. Parking supply and local knowledge to investigate

The following are candidate sources of parking. Each actual location needs its own evidence and conditions.

| Category | Information worth collecting |
| --- | --- |
| Bank compounds | Customer checks, outsider experiences, duration, business hours, permission to leave. |
| Hotels and restaurants | Visitor access, valet terms, costs, validation, offsite visits, overnight restrictions. |
| Malls, cinemas, supermarkets | Public access, receipts or validation, maximum stay, exit hours. |
| Office and coworking properties | Visitor eligibility, host confirmation, after-hours or weekend arrangements. |
| Housing societies | Guest access, society approval, host eligibility, retrieval and vehicle conditions. |
| Driveways and suitable private plots | Authority of the person offering the space, access conditions, costs and time windows. |
| Schools, community halls, religious premises | Specific arrangements for parking during particular hours or events. |
| Designated public parking within developments | Public-parking status, actual entrance, current operation, rates, hours. |
| Municipal, railway, and metro facilities | Actual designated parking, vehicle eligibility, operating hours, any commuter conditions. |
| Roadside spaces | Exact road side, applicable restrictions, timings, duration, and recent conditions. |
| Event overflow arrangements | Organiser confirmation, attendee eligibility, entrance, cost, capacity evidence. |

BMC documentation establishes that some developer-built public parking lots were handed over to the corporation. This is a useful discovery category; it does not establish current access or availability at every development.

Some hotels publish visitor-parking benefits. Those benefits do not automatically include leaving the vehicle for an unrelated visit elsewhere. Shared-parking platforms also have varying access scopes; for example, an intra-society arrangement is not the same as allowing general outside drivers.

Preserve practical descriptions of what happened on a visit. Avoid presenting guesses as confirmed property policies.

## 9. Community information and incentives

Useful report fields include:

- Location and exact entrance or road side, where relevant.
- Observation time, vehicle category, and stay duration.
- Whether the contributor entered, parked, and later retrieved the vehicle.
- Whether they left the premises during the stay.
- Whether staff asked about customer status, destination, host, or appointment.
- Payments, receipts, purchase requirements, tokens, and stated deadlines.
- Admission refusal, requests to move, closure, or removal.
- Optional supporting photos and source references.

Separate the time an event happened from the time someone submitted it. An old visit reported today is still an old observation.

Use freshness policies appropriate to the fact: temporary capacity and gate conditions age differently from an entrance photograph or a documented property policy. Preserve provenance and contrary evidence. Report expiry should mean loss of confidence in the observation's current relevance, not proof that the opposite is true.

Potential incentives include accepted-contribution points, badges, verified local expertise, or partner benefits. Benefits are not final commercial commitments. Reward useful coverage, recent confirmations, and corrected misinformation. Raw contribution counts alone invite spam and should not determine trust.

Keep contribution and verification distinct. A suggested parking policy can remain pending until reviewed. Community consensus cannot rewrite an applicable official restriction.

## 10. Additional product ideas to evaluate independently

These came from the discussion. They are optional extensions, not equal-priority requirements.

| Idea | Intended benefit | Dependency or limitation |
| --- | --- | --- |
| Return-time-aware parking | Assess the complete visit and remind early enough to walk back. | Requires known conditions and the user's return estimate. |
| Cost and walking trade-off | Compare practical alternatives by total cost, distance, eligibility, and evidence. | Unknown prices must remain unknown, not become zero. |
| Ask someone already nearby | Obtain a fresh answer about entry or capacity before travelling. | Depends on voluntary participation; no response is not a negative answer. |
| QR contact for the owner | Let someone request movement or report possible removal without exposing a phone number. | Requires a scan and a reachable delivery channel; it does not itself detect towing. |
| Community parking watch | Notify relevant active sessions of a recent closure, removal report, or changed condition. | Reports need timestamps, expiry, abuse handling, and appropriate confidence. |
| Departure handoff | Share a newly vacated space with an arriving driver. | A public-space observation is not a guaranteed reservation. |
| Personal parking memory | Learn which places worked or failed for this vehicle and visit pattern. | Personal history is contextual evidence, not proof of permission. |
| Parking record | Keep condition photos, location, ticket, receipt, and relevant instructions together. | Retention and sharing should remain under the owner's control. |
| Missing-vehicle recovery | Make saved context and official assistance easy to access. | No live police or towing-yard API has been established. |
| Bike-specific suitability | Track slope, stand stability, flooding reports, blocked exits, lighting, helmet storage. | Photos and reports have limited coverage and certainty. |
| Event parking coordination | Share venue arrangements, current attendee experiences, and overflow options. | Requires current organiser or attendee evidence. |
| Personal cost history | Understand past fines, towing charges, other charges, and time lost. | Use actual receipts and applicable offence details. |
| Optional vehicle hardware | Detect vehicle movement or tilt while the owner is elsewhere. | Requires a device on the vehicle and a suitable communication path; the owner's distant phone cannot sense it by itself. |

For QR contact, consider an opaque, revocable identifier with limited message actions and delivery rate limits. Someone scanning should not need the full app merely to send a basic alert. Do not expose the owner's account, plate history, contact details, or live location through a public token.

The receiving agent should add its own ideas and discard weak ones. Evaluate each against the founder's actual towing and parking pain, implementation effort, data availability, and whether it improves a decision or intervention.

## 11. Data sources and factual cautions

Potential evidence sources:

- National driving regulations and applicable state or local rules.
- Mumbai Traffic Police parking and temporary traffic notifications.
- BMC parking-facility information and documents.
- Published venue policies and authorised operator confirmations.
- Dated community observations and parking outcomes.
- Owner-provided parking history and receipts.

No complete, maintained, machine-readable Mumbai parking-restriction dataset has been established in this conversation. Do not assume that one exists, that it is free, or that publication of a notice gives exact usable road geometry. Confirm access, rights, coverage, and maintenance requirements before depending on a supplier or scraping a site.

Do not assume access to Google Maps review text, the user's Maps destination, official challan history, or towing records. Each would need a supported, authorised integration or explicit user input.

### Charges and repeat offences

The founder reports escalating amounts across roughly five towing incidents. That is personal experience, not a verified universal tariff formula.

The offence table linked from Mumbai Traffic Police lists a towing-related obstruction entry under Sections 122/177 read with 127 with a fine of INR 500 and a repeat fine of INR 1,500. This does not establish that the amount increases after every successive tow. Towing costs are separately recoverable under the Act. Other offence codes, charges, or local provisions may affect a particular total.

If estimating cost, identify the applicable offence, retain the source and date, separate the components, and use the actual receipt when available. Do not claim a fixed fifth-tow charge.

### Misinterpretations to avoid

- No visible sign is not equivalent to permission to park.
- The regulations' reference to three minutes is not a universal parking grace period.
- The Act's ten-hour unattended-vehicle provision is not protection from removal where parking is prohibited.
- A person remaining in a vehicle or using hazard lights does not itself make prohibited stopping permissible. Any separate towing procedure requires its own current verification.
- A payment, token, successful visit, or lack of checks is evidence about a particular arrangement or experience, not a general exemption.

These facts should support a useful explanation, not dominate the product with legal commentary.

## 12. Architecture direction

No final technology stack has been chosen. Flutter is a reasonable candidate because the founder has existing experience, but native Android integration may be required for the companion capability. Inspect the actual project and choose deliberately.

Suggested responsibility boundaries:

1. **Android integration:** invocation, permissions, app-state detection where used, lifecycle, supported sharing and navigation handoff.
2. **Parking domain:** locations, access conditions, time and vehicle eligibility, assessments, sessions, and contribution rules.
3. **Evidence ingestion:** source records, community observations, moderation, revisions, and freshness.
4. **Image interpretation:** structured observations, confidence and uncertainty, bounded requests, and failure handling.
5. **Persistence and synchronisation:** local durability, remote authoritative records where needed, pending operations, retries, and conflicts.
6. **Notification and contact:** reminders, targeted alerts, QR contact tokens, deduplication, and delivery status.

Use the smallest number of components that makes these responsibilities clear. Do not introduce microservices, excessive layers, or a large agent framework simply to appear sophisticated.

### Suggested core records

| Record | Important information |
| --- | --- |
| Parking location or street segment | Geometry or position, road side where relevant, entrances, venue relationship, supported vehicles. |
| Restriction | Source, applicability, effective interval, schedule, vehicle conditions, spatial scope, revision. |
| Access condition | Visitor/customer/public eligibility, offsite visits, purchase or host requirements, gate and retrieval times. |
| Observation or contribution | Author or actor, event time, submission time, relevant conditions, evidence, review status. |
| Assessment | Inputs, evidence IDs and versions, observations, applicable rules, result, unknowns, evaluation time. |
| Parking session | Vehicle reference, actual position, start, planned return, deadlines, state, reminder identifiers. |
| Pending operation | Stable operation ID, payload reference, attempts, state, last failure, retry eligibility. |
| Contact token and alert | Revocable token, limited purpose, target session or vehicle, event ID, delivery state. |
| Reward entry | Contribution reference, provisional or accepted status, granted benefit, reversal if necessary. |

This is conceptual modelling, not a mandatory database schema. Reduce it for the prototype and explain which guarantees remain simulated.

### Sources of truth and state

Identify an authoritative source for each fact. For example, the remote service may own reviewed policies while a local store owns a draft and a session not yet synchronised. The image model is not a source of legal authority.

Preserve the distinction between local pending work, server acceptance, reviewer acceptance, rejected contributions, superseded information, and expired observations. A successful network request is not necessarily verified information.

Use stable identifiers for operations that may be retried. Uploading an image and submitting its report may fail separately. Handle partial completion without duplicate reports, reward grants, or notifications.

For shared records, use revision checks or another explicit conflict policy. Do not silently overwrite a newer reviewed parking condition with an older offline edit.

### AI integration

Useful AI work includes identifying scene elements, extracting sign text, structuring a community report, and explaining the evidence behind an assessment.

Keep model output constrained and inspectable. Validate its structure, represent uncertainty, bound latency, handle unsuitable responses, and preserve the rest of the app when AI is unavailable. Treat uploaded signs and comments as input data, not instructions to the system.

Keep production service credentials out of the distributed mobile application. Decide what image or location data needs to leave the device and document that boundary.

## 13. Failure and recovery requirements

| Failure | Desired behaviour |
| --- | --- |
| Overlay or app-usage permission is denied or revoked | Preserve the core parking capability through supported alternate invocation. Explain which companion capability is unavailable. |
| The companion service stops | Do not pretend it is still monitoring. Support an understandable restart path and retain sessions. |
| Location is unavailable or inaccurate | Obtain a user-confirmed position or use an explicit manual alternative; do not assign the wrong road side confidently. |
| No network | Retain drafts and active sessions. Use cached evidence only with its age and limits preserved. |
| Evidence is missing, stale, or conflicting | Represent uncertainty and preserve useful contrary observations. Do not manufacture a permission result. |
| A report reaches the service but its response is lost | Retrying the same operation must not create a second report or reward. |
| Photo upload is interrupted | Preserve progress or a recoverable pending state and avoid inconsistent report metadata. |
| AI times out, returns malformed output, or cannot identify an object | Keep non-AI functionality working and request useful evidence only if it can resolve the uncertainty. |
| App is closed or killed during a parking session | Restore the session and reconcile reminders without duplicates. |
| Another actor updates a condition during an assessment | Retain version information and re-evaluate or identify the changed evidence. |
| A notification is delayed or never delivered | Do not describe the owner as successfully warned merely because an alert was queued. |
| Community demand has no response | Keep the answer unknown instead of interpreting silence as no parking. |

For time-sensitive behaviour, distinguish when an event occurred, when the service learned about it, and when the owner received it. Offline durability does not imply immediate delivery.

## 14. Hackathon context and recommended scope

The original context is MAL Hackathon, Architects in AI ERA, scheduled for 1 November 2026 at Paytm, Mumbai, with teams of one to three. The published brief allocates 60% to architecture, 15% to testing and observability, 15% to a working journey, and 10% to architecture defence.

The intended track is Proptech, framed around reliable Mumbai parking and property-access information. Keep the connection concrete. The published Proptech journey includes a user discovering or reporting a need, taking action, another role or service responding, and tracking the outcome.

The brief permits sample data, simulated services, and role switching. Authentication is optional. Core records must survive restarts. A recoverable failure and meaningful automated tests are required. Clearly label simulated behaviour and its limitations.

### Candidate minimum implementation

- One neighbourhood and approximately ten curated demonstration locations, rather than a citywide claim.
- Vehicle and intended-duration context.
- Current-location and surroundings-photo assessment with explicit evidence and uncertainty.
- Designated parking and practical community alternatives, including an unofficial option.
- A durable contribution, review/service response, and traceable outcome.
- A durable active parking session and a meaningful recovery demonstration.
- A demonstrated Android companion entry point, with automatic Maps-only activation accurately described as proven or still incomplete.

Select a coherent subset. If scope is too large, reduce integrations or data coverage while preserving the complete journey. An optional QR alert is valuable, but should not displace core correctness and recovery.

### Candidate demonstration cases

1. A visible possible obstruction that triggers an explainable concern.
2. No visible sign, but a matching location-specific restriction.
3. A bank or office option with community outsider experiences and unverified formal permission.
4. Insufficient location or image evidence that produces an honest unknown.
5. A contribution accepted by the service just before connectivity fails, then retried after restart without duplication.

Choose enough cases to demonstrate the design; do not present every case as a separate product.

### Useful business rules to defend

- Unreviewed community reports cannot replace an authoritative restriction.
- Retrying a contribution cannot create duplicate contributions or reward grants.
- A permission assessment must match the relevant vehicle, place, and intended time interval.
- A past success or missing report cannot silently become permission.
- A session's local persistence and an alert's remote delivery are different guarantees.

### Expected engineering evidence

- A runnable mobile build or reproducible setup.
- Source and clear setup/test instructions.
- An architecture diagram matching the implemented responsibilities and data flow.
- Two short decision records, each including an alternative and a consequence.
- Tests of a business rule and failure/recovery behaviour.
- Diagnostic events sufficient to reconstruct an assessment, retry, conflict, or delivery failure without unnecessarily logging sensitive data.
- One credible future requirement and an explanation of which parts would change.

Measure SDK performance evidence is an optional enhancement. The event also advertises an optional in-app Gemini 4 Argon feature. Verify the model's actual availability, identifier, credentials, and documentation before committing to it; the event advertisement alone is not proof of access. Complete the core journey before pursuing bonus integrations.

## 15. Competitor references and research status

The conversation identified the following products as relevant references. These are discovery leads based on published descriptions, not independently tested accuracy, verified Mumbai coverage, or evidence that any proposed feature is unique.

| Product | Reference value |
| --- | --- |
| Maps for Parking / ParkourAI, Mumbai | Local restrictions, community parking knowledge, towing reports. |
| SpotAngels | Community contributions and parking reminders. |
| Parky.AI | Photo-based sign interpretation and uncertain results. |
| Park+ | Listed parking discovery, access and reservation. |
| AppyParking+ | Time-sensitive street restrictions and operating conditions. |
| ParkUsher | Combining parking guidance, sign interpretation, and reminders. |
| Parky, Stockholm | Street rules, cleaning conditions, duration, and open-data maintenance. |
| Seety | Parking conditions, prices, schedules, and concise explanations. |
| Parknav | Curb restrictions and availability data. |
| UbiPark | Facility access, entrance information, navigation, and payment. |
| canUpark | Photo interpretation of signs and conditional restrictions. |
| 311 Montréal | Parked-location context and changing street-status alerts. |
| INRIX Can I Park Here | Location-to-parking-segment assessment and uncertainty. |
| CurbIQ | Digitised curb regulations and data infrastructure. |
| Parkopedia | Parking-data supplier category; local suitability must be verified. |
| Modii / formerly Spot Parking | Time, duration, permit, and event-sensitive parking conditions. |

The broad concept already has competition. Dependable Mumbai coverage, two-wheeler relevance, exact road-side context, sourced reasoning, practical outsider-parking experiences, and reliable recovery are candidate strengths to validate, not established exclusive differentiators.

## 16. Decisions still open

- Product name and identity.
- Final first-release feature subset.
- Exact Android companion mechanism and its distribution feasibility.
- Framework, local persistence, remote service, and deployment choices.
- Supply and maintenance of location-specific Mumbai data.
- How operator confirmations and community verification work.
- Contribution incentives and any eventual commercial model.
- Whether AI processing is local, remote, or hybrid.
- Whether QR contact and external notification delivery belong in the first build.
- Specific hardware direction, if a later version detects movement directly.

Do not interpret an earlier suggestion as a binding decision. Propose a better answer where justified.

## 17. Sources and starting links

These sources were consulted or identified during the discussion. Recheck dates, scope, applicability, and availability before implementing a factual dependency. A source being listed does not establish that it provides an API or permits reuse of its data.

### Event

- MAL participant brief: <https://mobilearchitecturelab.com/mal4/>

### Rules and official information

- Mumbai Traffic Police acts and fine documents: <https://trafficpolicemumbai.maharashtra.gov.in/en/document-category/acts-fine/>
- Driving Regulations 2017, copy published by Mumbai Traffic Police, especially definitions and regulation 22: <https://cdnbbsr.s3waas.gov.in/s3d827f12e35eae370ba9c65b7f6026695/uploads/2025/01/20250113901406803.pdf>
- Motor Vehicles Act, India Code, including sections 122 and 127: <https://www.indiacode.nic.in/bitstream/123456789/9460/1/a1988-59.pdf>
- Mumbai-published offence table, including entry 161: <https://cdnbbsr.s3waas.gov.in/s3d827f12e35eae370ba9c65b7f6026695/uploads/2025/01/202501041665079600.pdf>
- Mumbai traffic notifications: <https://mtperp.mahatrafficechallan.gov.in/PublicNotice.htm>
- BMC parking-facility discovery: <https://portal.mcgm.gov.in/irj/portal/anonymous/BMC-on-Map-Facilities-ParkingLots?guest_user=english>
- BMC public-parking operation document with developer-built PPL background: <https://r3app.mcgm.gov.in/irj/go/km/docs/documents/Tenders/ETH/ETH_7000025769_171122.pdf>
- Maharashtra e-challan portal and grievance entry: <https://mahatrafficechallan.gov.in/payechallan/ChallanReceipt.htm>
- Mumbai Traffic Police description of towing information submitted to its helpline: <https://trafficpolicemumbai.maharashtra.gov.in/en/initiative/>

### Access and shared-parking examples

- Hyatt Centric Juhu policies, a property-specific visitor-parking example: <https://www.hyatt.com/hyatt-centric/en-US/mumct-hyatt-centric-juhu-mumbai/policies>
- Mygate intra-community parking-rental description: <https://help.mygate.in/articles/129396-what-is-rent-a-parking-feature-on-the-mygate-app>
- ParkingNearby owner-authority and local-permission terms: <https://parkingnearby.in/legal/owner-agreement>
- Mumbai Metro One FAQ, including limited designated parking: <https://www.reliancemumbaimetro.com/metro-faq>

### Android and Maps

- Overlay permission and Settings reference: <https://developer.android.com/reference/android/provider/Settings>
- Application overlay window reference: <https://developer.android.com/reference/android/view/WindowManager.LayoutParams>
- UsageStatsManager: <https://developer.android.com/reference/android/app/usage/UsageStatsManager>
- Foreground-service changes: <https://developer.android.com/develop/background-work/services/fgs/changes>
- Foreground-service types: <https://developer.android.com/develop/background-work/services/fgs/service-types>
- Location permission categories: <https://developer.android.com/develop/sensors-and-location/location/permissions>
- Receiving shared content: <https://developer.android.com/develop/ui/compose/sharing/receive>
- Google Maps sharing: <https://support.google.com/maps/answer/7101463?co=GENIE.Platform%3DAndroid&hl=en>
- Supported Maps launching and intents: <https://developers.google.com/maps/documentation/android-sdk/intents>
- Maps URLs: <https://developers.google.com/maps/documentation/urls/get-started>
- Accessibility API distribution requirements, if that approach is evaluated: <https://support.google.com/googleplay/android-developer/answer/10964491?hl=en>

### Product research leads

- <https://www.parkourai.com/>
- <https://www.spotangels.com/>
- <https://www.parky.ai/>
- <https://parkplus.io/parking>
- <https://appyparking.com/>
- <https://www.parkusher.app/>
- <https://www.parky.se/en/>
- <https://seety.co/>
- <https://parknav.com/>
- <https://canupark.app/>
- <https://montreal.ca/en/311-montreal-mobile-app>
- <https://docs.inrix.com/parking/can_i_park_here_v1/>
- <https://www.curbiq.io/>
- <https://business.parkopedia.com/analytics>
- <https://www.spotparking.com.au/spot-pi>

## 18. What to do next

First explain your understanding of the real problem, identify the most consequential unknowns, inspect the available project, and recommend a feasible implementation slice. Justify the Android integration and data assumptions before building dependencies around them.

Then, when implementation is requested, deliver a complete, testable journey with persistence and a demonstrated recovery case. Keep the architecture and claims consistent with what actually runs.

**Bring your own judgement and creativity. This brief is accumulated context, not the limit of the idea and not an instruction to stop thinking.**
