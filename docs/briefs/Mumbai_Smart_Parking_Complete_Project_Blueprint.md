# Mumbai Smart Parking — Complete Project Blueprint

> **Status:** Planning / product specification (not a deployed app)  
> **Location:** Mumbai, Maharashtra, India  
> **Prepared:** 31 October 2026  
> **Proposed product:** AI- and GIS-powered smart parking compliance, discovery, and management platform  
> **Primary users:** Drivers, residents, parking operators; later civic stakeholders  
> **Initial release:** Mobile-first pilot, not a citywide guaranteed parking service

---

## Document purpose and scope

This single-file Markdown document consolidates the previously discussed **160 Mumbai parking problems**, the proposed **12-module solution**, road-level legality mapping, source validation, AI features, user experience, technical stack, phased development, governance, security and product metrics. It is ready for use as a repository planning document or input to Claude Code.

**Important evidence caveat:** The 160 items are a combined *research and product-discovery inventory*, **not 160 independently measured or verified citywide deficiencies**. They include documented local problems, general parking pain points, and testable product hypotheses. Counts and news examples mentioned below should be reverified against current primary sources before external publication. Likewise, a prototype is not an authoritative source of parking permission.

## Executive summary

Build a **Parking Decision Platform**, not another generic parking finder. Every user should get answers to five questions:

1. **Can I park here?** Exact curb or bay and road side.
2. **Can I park here now?** Time, date, duration, vehicle class, permit, temporary order.
3. **Where else should I park?** Verified authorized alternatives, directions, prices and availability *when confirmed*.
4. **What happens after I park?** Session timer, restriction-change reminders and return navigation.
5. **What if something goes wrong?** Official towing/challan guidance, tariff checking and reporting channels.

**Core differentiation:** A source-linked, time-aware **parking legality and geospatial rule engine**. Start with a small precisely verified pilot, not a blanket green/red classification of all Mumbai roads.

### Product principles

- **No evidence ≠ parking permitted.** Unknown/unsupported = **grey**.
- All decisions must have an explanation, source, validity period, and verification status.
- Classify **roadside curb segments or parking bays**, not indiscriminately entire roads.
- Separate **legal permission** from **physical space availability**.
- Separate **official facts** from reports, predictions, and AI guesses.
- Use manual road-side confirmation whenever GPS cannot reliably resolve the curb.
- Never imply an official BMC/Traffic Police partnership without authorization.
- AI assists extraction and explanation; a deterministic engine applies approved structured rules.
- Design for privacy, accessibility, low distraction, and offline-friendly viewing of recently verified data.

## 1. Problem context — Mumbai parking

Mumbai parking issues include fragmented rules, side-specific or date-specific restrictions, unclear signage, unpredictable discovery, towing and challan friction, overcharging, partly underutilized formal lots, road obstructions, monsoon risks, residential disputes, and poor coordination of data.

Previously surfaced background indicators (verify before presentation):

| Reported indicator | Previously cited figure | Interpretation / caution |
|---|---:|---|
| Illegal-parking e-challans reported for 2025 | ~10.47 lakh | Reported in Maharashtra legislative coverage; confirm scope/period |
| New Mumbai vehicle registrations reported for 2025 | ~3.02 lakh | Annual new registrations, not vehicle stock |
| Public parking lot capacity discussed in June 2026 coverage | 30,000+ spaces | Confirm which facilities and capacity definition |
| Occupancy of *some* municipal parking lots | At or below 50% | **Not** a citywide average |
| Authorized pay-and-park locations reportedly added to Google Maps on 30 Oct 2026 | 43 | Check current listings and official status |

**Key observation:** The city can have parking scarcity on busy streets alongside available capacity in poorly discovered or inconvenient formal facilities. The app must address legality **and** discovery.

## 2. Full parking problem inventory — 160 items

The numbering below is preserved for issue-to-feature traceability. Categories are organizational, and issues may overlap.

### 01. Rules, legality and confusion (Problems 1–18)

1. Drivers cannot easily determine where parking is legally permitted.
2. Drivers cannot easily determine where parking is prohibited.
3. No comprehensive, publicly available road-by-road parking legality map has been established in the material reviewed.
4. Missing no-parking signboards.
5. Faded, damaged or obstructed parking signs.
6. Parking restrictions that change according to time of day.
7. Parking restrictions that change according to the day of the week.
8. Odd-even date-based parking restrictions.
9. Confusion over which side of a road permits parking.
10. Confusion between no-parking and no-stopping restrictions.
11. Temporary no-parking orders during festivals, events or VIP movements.
12. Restrictions introduced because of construction or road repairs.
13. Different parking permissions for cars, motorcycles, goods vehicles and buses.
14. Unclear restrictions near junctions and road corners.
15. Unclear parking restrictions near building entrances.
16. Confusion over whether parking is permitted on service roads and internal lanes.
17. Parking restrictions that change without drivers being aware of the new notification.
18. Difficulty finding the legal basis for a restriction or violation.

### 02. Parking discovery and availability (Problems 19–34)

19. Not knowing the nearest legal parking space.
20. Driving around repeatedly looking for parking.
21. No reliable real-time view of available parking bays across operators.
22. Not knowing whether a parking lot is full.
23. No single directory covering public and participating private parking.
24. Finding parking locations in map apps that are outdated or incorrect.
25. Parking facilities without clearly marked entrances.
26. Parking facilities that are difficult to identify from the road.
27. Not knowing whether a parking location is currently operational.
28. Not knowing whether overnight parking is allowed.
29. Not knowing whether long-term parking is available.
30. Not knowing whether a parking space accommodates SUVs or larger vehicles.
31. No reliable advance booking for many roadside parking areas.
32. No guaranteed space after travelling to a listed facility.
33. Lack of convenient parking near the final destination.
34. No unified comparison of walking distance, price, safety and availability.

### 03. Fines, towing and enforcement (Problems 35–50)

35. Unexpected no-parking e-challans.
36. Challans disputed because drivers report missing or unclear signs.
37. Vehicles being towed without the owner immediately knowing.
38. Difficulty locating a towed vehicle.
39. Inconvenience travelling to the towing yard.
40. Confusion about applicable towing charges.
41. Time lost recovering a towed vehicle.
42. Concern about damage during towing.
43. Difficulty understanding a violation’s exact location.
44. Errors or disputed location evidence in e-challans.
45. Repeated parking violations by habitual offenders.
46. Difficulty obtaining photographic evidence of an offence.
47. Complicated or time-consuming challan dispute procedures.
48. Uncertainty about which authority handles parking complaints.
49. Inconsistent perceived enforcement across roads and neighborhoods.
50. Lack of an easy way to receive preventive parking-restriction alerts.

### 04. Public parking lot infrastructure (Problems 51–65)

51. Public parking lots operating below their available capacity.
52. Poor lighting inside multi-level parking facilities.
53. Water leakage and inadequate maintenance.
54. Non-functional digital occupancy boards.
55. Difficult-to-find parking entrances.
56. Inadequate directional signboards.
57. Poorly designed vehicle entry and exit routes.
58. Narrow ramps and difficult turning angles.
59. Long-term parked vehicles occupying spaces needed by short-term users.
60. Trucks and taxis obstructing facility entrances.
61. Insufficient maintenance of parking equipment.
62. Poor cleanliness and sanitation.
63. Unreliable lifts or mechanical parking systems.
64. Parking spaces that cannot comfortably accommodate larger vehicles.
65. Poor pedestrian connections between parking facilities and destinations.

### 05. Charges, payments and fraud (Problems 66–80)

66. Parking attendants demanding more than authorized tariffs.
67. Fake or unauthorized parking attendants.
68. Charges collected at locations officially designated as free parking.
69. Lack of clearly displayed parking tariffs.
70. Drivers not knowing the correct price before parking.
71. Refusal to provide valid payment receipts.
72. Reused, manipulated or suspicious parking receipts.
73. Difficulty verifying whether a payment QR code is legitimate.
74. Pressure to pay cash or use an unofficial payment channel.
75. Unclear minimum parking charges.
76. Confusing hourly versus daily parking prices.
77. Lack of transparent monthly parking subscription information.
78. Disputes over parking entry and exit times.
79. Difficulty obtaining a refund after an incorrect charge.
80. Lack of a trusted channel to report overcharging and attendant misconduct.

### 06. Residential and housing society parking (Problems 81–95)

81. Residential buildings with fewer parking spaces than vehicles.
82. Older buildings built without adequate parking provision.
83. Households owning multiple vehicles without corresponding spaces.
84. Disputes over allocation of common parking spaces.
85. Permanent parking privileges being contested by other eligible residents.
86. Lack of transparent parking allotment records.
87. Difficulties implementing rotational or lottery-based allocation.
88. Conflicts over visitor parking.
89. Unauthorized occupation of another resident’s assigned space.
90. Tension between resident and tenant parking requirements.
91. Cars occupying spaces intended for two-wheelers.
92. Unused society parking bays while nearby streets are congested.
93. Underused private parking that cannot easily be shared with outsiders.
94. Limited parking during redevelopment and construction.
95. Disputes over society parking charges and access permissions.

### 07. Illegal parking, congestion and safety (Problems 96–110)

96. Parking on footpaths and pedestrian walkways.
97. Double parking that blocks a moving traffic lane.
98. Vehicles parked at intersections, reducing visibility.
99. Parking that blocks narrow residential roads.
100. Vehicles obstructing emergency vehicle access.
101. Parking in front of fire stations or emergency exits.
102. Parking near hospital entrances and ambulance routes.
103. Vehicles blocking BEST bus stops.
104. Vehicles occupying pedestrian crossings.
105. Parking outside school gates, creating congestion.
106. Abandoned vehicles occupying public roads.
107. Parking that obstructs wheelchair movement.
108. Loading and unloading in active traffic lanes.
109. Vehicles parked too close to turning points.
110. Traffic and emissions caused by repeated circulation in search of parking.

### 08. Stations, markets and commercial districts (Problems 111–125)

111. Lack of convenient park-and-ride options near railway stations.
112. Illegal parking around metro station entrances.
113. Congested pickup and drop-off areas.
114. Autos and taxis waiting in unauthorized locations.
115. Private vehicles occupying designated taxi stands.
116. Insufficient short-stay parking near shops and markets.
117. High parking demand during festivals and shopping periods.
118. Parking shortages near offices and commercial districts.
119. Cars waiting roadside for passengers.
120. Delivery vehicles competing with private cars for curb space.
121. Inadequate designated loading and unloading zones.
122. Parking difficulties for small-business customers.
123. Insufficient short-term parking near clinics and hospitals.
124. Unclear rules around airport pickup, drop-off and parking.
125. Weak integration between parking information and public transit.

### 09. Monsoon, environment and vehicle safety (Problems 126–135)

126. Parking in flood-prone streets during the monsoon.
127. Waterlogging in basement and underground parking areas.
128. Insufficient warnings about flood risks at parking locations.
129. Vehicles being damaged by falling trees, branches or debris.
130. Inadequate drainage around parking areas.
131. Poor illumination and security monitoring at night.
132. Theft or vandalism concerns in isolated parking facilities.
133. Difficulty obtaining evidence after a parked vehicle is damaged.
134. Long-term parking near construction hazards.
135. Lack of information about covered versus open parking.

### 10. Two-wheelers, commercial vehicles, EVs and accessibility (Problems 136–145)

136. Insufficient designated motorcycle and scooter parking in high-demand areas.
137. Two-wheelers parked in narrow pedestrian passages.
138. Lack of suitable overnight parking for commercial vehicles.
139. Shortage of designated delivery-rider waiting areas.
140. Limited information about parking with operational EV chargers.
141. EV charging bays being occupied by non-charging vehicles.
142. Difficulty identifying parking reserved for persons with disabilities.
143. Accessible parking bays being obstructed or misused.
144. Poor pedestrian accessibility between parking bays and building entrances.
145. Difficulty finding parking suitable for elderly passengers or people with limited mobility.

### 11. Data, governance and planning (Problems 146–160)

146. Parking information fragmented across BMC, traffic police and private operators.
147. Traffic restrictions published as separate notifications rather than one unified map dataset.
148. Difficulty converting road restrictions into precise GPS coordinates.
149. Difficulty distinguishing restrictions applying to the left and right sides of roads.
150. No unified public data feed covering all parking operators and live occupancy.
151. Outdated or incomplete parking inventory records.
152. Difficulty distinguishing authorized parking contractors from unauthorized collectors.
153. Inconsistent reporting of capacity and utilization across facilities.
154. Limited visibility into parking-related complaints and their resolution.
155. Limited integration of parking policy with traffic and transit planning.
156. Inefficient allocation of valuable curbside road space.
157. Difficulty identifying neighborhoods with severe parking demand–supply mismatches.
158. Unclear ownership of responsibility for maintaining roadside parking data.
159. Difficulty monitoring compliance with temporary and permanent traffic orders.
160. The challenge of keeping citywide parking data accurate as roads, regulations and infrastructure change.

---

## 3. Proposed app — 12 connected product modules

| Module | Problem IDs | Core capability | Dependencies |
|---|---|---|---|
| **M01 — Parking Legality Engine** | 1–18 | Verified roadside rules, side/time/date/vehicle logic, source-linked status | Official orders, curb geometry, human review |
| **M02 — Parking Discovery** | 19–34 | Facility search, nearby alternatives, prices, walking distance | Verified parking inventory; optional operator feeds |
| **M03 — Challan & Towing Assistant** | 35–50 | Reminder, official challan handoff, vehicle recovery information, evidence organizer | Authorized official portal links and procedures |
| **M04 — Facility Intelligence** | 51–65 | Amenities, operating status, entrances, accessible access, incident reports | Surveys and operator verification |
| **M05 — Tariff & Payment Protection** | 66–80 | Official tariffs, operator verification, receipt assistance | Published tariff sources; payment partners for transactions |
| **M06 — Residential Parking** | 81–95 | Society allocation, visitor passes, waitlist and space sharing | Society permissions and property rules |
| **M07 — Safety & Obstruction Reporting** | 96–110 | Geotagged hazards, reports, verified complaint routing | Moderation; sanctioned authority integration |
| **M08 — Transit & Commercial Parking** | 111–125 | Stations, loading zones, pickup/drop-off and park-and-ride | Transport/municipal mapping and local verification |
| **M09 — Monsoon & Vehicle Safety** | 126–135 | Flood-exposure overlays, warnings, covered parking attributes | Trusted risk maps and live feeds where available |
| **M10 — Specialized Vehicle Parking** | 136–145 | Motorcycles, commercial vehicles, EV charging and accessibility filters | Verified facility attributes and operator feeds |
| **M11 — Parking Data & Governance** | 146–160 | Versioned data ingestion, review, audit, provenance, metrics | Admin tools, agreements, monitoring |
| **M12 — Central Intelligence & Personalization** | Cross-cutting | Context-aware recommendations, navigation, alerts and explanations | All verified services; consented user preferences |

**Operating model:** M11 feeds M01–M10. M01 makes legality decisions. M02 finds alternatives. M12 presents the best *eligible* options, while keeping known, estimated, and unknown values visibly separate.

## 4. Roadside parking map — four statuses

The app should use colored **curb edges/bays** with an unmistakable legend and text labels. Do not color whole streets without resolving which side and which segment the rule applies to.

| Status | Color | Display meaning | Minimum confidence requirement |
|---|---|---|---|
| **Permitted** | Green | Parking affirmatively verified for selected location, vehicle, time and duration | Current positive evidence + no applicable conflicting restrictions |
| **Conditional** | Yellow | Parking may be permitted subject to restrictions, payment, permit, odd/even date, duration, etc. | Current validated conditions; show exact limits |
| **Prohibited** | Red | A verified, currently applicable restriction prohibits selected parking | Current applicable order/sign/bay rule |
| **Unknown / not verified** | Grey | Insufficient, expired, geographically ambiguous or conflicting evidence | Default whenever the engine cannot establish a decision |

Accessibility: accompany color with icon, text, hatching/pattern and readable detail; color alone is not enough.

### 4.1 Decision inputs

- Exact geographic point or explicitly selected curb segment (not just phone GPS).
- Side of road or specific parking-bay polygon.
- Mumbai-local date and time (Asia/Kolkata) and intended duration.
- Vehicle category, dimensions if relevant, accessibility and permit eligibility.
- Permanent and temporary legal orders, road signs, exceptions and supersession.
- Facility-specific terms where the selection is an off-street lot.
- Evidence confidence, review status, effective/expiry dates, conflict status.

### 4.2 Deterministic rule evaluation

```text
INPUT: selected_road_edge, vehicle_type, date_time_IST, planned_duration, permits

1. Resolve exact curb geometry; if ambiguous, require user selection.
2. Load verified restrictions and affirmative permission evidence.
3. Apply valid temporary overrides and permanent restrictions.
4. Evaluate time windows, date parity, vehicle class, permits and duration.
5. Examine provenance, geographic accuracy, expiration and rule conflicts.

IF evidence is missing, stale, inconsistent or ambiguous:
    RETURN UNKNOWN (GREY), with reason and verification caveat
ELSE IF a current applicable rule prohibits parking:
    RETURN PROHIBITED (RED), with source and restriction explanation
ELSE IF a current permission exists with conditions:
    RETURN CONDITIONAL (YELLOW), with conditions and source
ELSE IF affirmative permission is independently verified:
    RETURN PERMITTED (GREEN), with source
ELSE:
    RETURN UNKNOWN (GREY)
```

**Rule precedence:** Derive from the actual legal instrument and effective period—not an assumed universal hierarchy. Temporary orders may override ordinary parking arrangements, but conflicts must be reviewed before publishing a definitive status.

### 4.3 Real example: odd-even parking rule

The previously discussed Mumbai Traffic Police notification dated **23 February 2026** for Somani Gram Road, Goregaon West, described western-side parking on even dates and eastern-side parking on odd dates.

- **Odd-numbered date** → east side under that specific odd-even provision.
- **Even-numbered date** → west side under that specific odd-even provision.
- This alone **does not** prove that a specific bay is otherwise legal: other restrictions may apply.
- Primary order link previously identified: <https://mumbaipolice.gov.in/files/PressRelease/3524.pdf> (verify content and continuing applicability before production).

**Demo acceptance example:** Choose 30 October 2026 + west side; show that the odd-even condition is satisfied. Choose 31 October 2026 + west side; show it is not satisfied. Do not label the first case unconditionally green without other checks.

## 5. Street and parking data model

### 5.1 Geographic entities

- `RoadSegment`: mapped centerline and stable road identifier.
- `CurbSegment`: independently mapped left/right physical curb geometry (LineString); possibly split every time rules change.
- `ParkingBay`: specific marked space/polygon, optional space identifiers and dimensions.
- `ParkingFacility`: authorized off-street lot with entrance coordinate, owner, permitted vehicle types and hours.
- `ParkingRestriction`: normalized legal rule with effective dates, time windows and exceptions.
- `RegulationSource`: scanned/PDF/HTML notification metadata, issuing body, document ID/URL, checksum.
- `Verification`: reviewer, method, timestamp, status and evidence.
- `TemporaryEvent`: roadwork, festival, closure, flood closure and other temporary interventions.
- `CommunityReport`: claimed inaccuracy or incident, moderated before influence on decision.
- `ParkingSession`: user-opted, time-limited record of where they parked and timer state.

### 5.2 Minimum curb record

```json
{
  "curb_segment_id": "MUM-000184-E",
  "road_name": "Example Road",
  "geometry": "PostGIS LINESTRING in EPSG:4326",
  "side": "E",
  "vehicle_classes": ["car", "motorcycle"],
  "permission_status": "conditional",
  "restriction_type": "odd_even",
  "time_window": "00:00-23:59 Asia/Kolkata",
  "date_condition": "odd_dates_east_only",
  "maximum_stay_minutes": null,
  "rate_schedule_ref": null,
  "permit_type": null,
  "official_source_id": "source-123",
  "effective_from": "2026-02-23",
  "effective_until": null,
  "verification_status": "reviewed",
  "last_verified_at": "2026-10-31T10:00:00+05:30"
}
```

*This is a schema illustration, not a verified real-world parking record.* In actual design, time constraints, effective intervals, exceptions and source associations should be normalized; do not store every possible rule as one text column.

### 5.3 Data engineering rules

1. Use PostGIS spatial indexes for nearby curb/facility queries.
2. Preserve all legal source files, original wording and hashes.
3. Keep publication history and an audit trail of every edited rule.
4. Distinguish `observed_sign`, `official_order`, `operator_claim` and `user_report` evidence.
5. Maintain explicit `valid_from`, `valid_to`, `reviewed_at`, and `supersedes` fields.
6. Model *both sides* of a road separately.
7. Support exceptions: vehicle class, permits, event dates, disabled bay, deliveries, holidays and max stay.
8. Never merge unknown into permitted.
9. Store geometry confidence; use manual curb selection for uncertain GPS fixes.
10. Use a documented review and rollback process for contested restrictions.

## 6. Data acquisition and verification strategy

### Layer 1 — Government / authoritative sources

- BMC authorized pay-and-park inventories, facility locations, approved charges and operator details.
- Mumbai Traffic Police traffic orders, press notes and notices.
- Official traffic diversions, temporary restrictions, planned works and event notifications.
- Government information on towing/challans and formal grievance processes.

**Do not assume an official public API exists.** Use published, permitted data; request partnership or written authorization for structured/live integrations where needed.

### Layer 2 — Geographic mapping

- OpenStreetMap road geometry with license/attribution compliance.
- Custom surveyed curb edges, facility entrance points, bays and no-stopping areas.
- QGIS spatial inspection and a web map-editing interface.
- Satellite imagery only under terms that permit the intended derived work.

### Layer 3 — Field validation

- Photograph signs and record GPS, viewing direction and timestamp.
- Observe parking markings, entrances, hazards and obstruction points.
- Cross-check sign content against source order and actual effective conditions.
- Have an independent reviewer approve each segment prior to trusted publication.

### Layer 4 — Community reports

- Users submit location, photo, category and optional description.
- Automatic deduplication, privacy redaction and abuse screening.
- Report status: submitted → triaged → evidence requested → reviewed → accepted/rejected.
- Reports trigger review; they **never by themselves** convert a segment to green.

### Layer 5 — Parking operator partnerships

- Authorized capacity and live occupancy (only if genuinely available).
- Entrance hours, tariffs, vehicle constraints and reservation inventory.
- Payment integration only when licensed/contracted and technically secure.
- Operator update and verification workflows.

### Data pipeline

```text
Official pages/docs + approved operator feeds + surveys + user reports
                               |
                     acquisition and versioning
                               |
                  OCR / vision / document parsing
                               |
                 structured candidate-rule extraction
                               |
                 geospatial match + date/time parsing
                               |
                 contradictions and provenance checks
                               |
                     HUMAN ADMIN VERIFICATION
                               |
           published PostGIS parking regulation database
                               |
                deterministic parking decision API
                               |
                       Flutter map + alerts
```

### Data quality gates

- Every published legal restriction has a source reference, geometry, validity metadata and reviewer.
- Every green segment has affirmative evidence for parking permission.
- Expired or conflicted sources trigger review or downgrade to unknown.
- No live occupancy displayed without an actual live feed and last-updated timestamp.
- Separate reports of availability from operator-confirmed space availability.
- Maintain regular source-change monitoring and manual escalation.

## 7. End-to-end user journeys

### Journey A — Find legal parking

1. Driver opens the mobile app and views a city map.
2. Enters destination or taps the road near their location.
3. App highlights verified road-edge status: green/yellow/red/grey.
4. User selects curb side; app uses actual date/time and vehicle class.
5. App explains the decision and links to supporting evidence.
6. If prohibited/unknown, app offers **verified eligible** nearby alternative facilities or segments.
7. User reviews tariff, walking distance, hours and confirmed/unknown availability.
8. Navigation is handed off to a trusted route provider or in-app navigation.

### Journey B — I have parked

1. User taps **I've Parked** after safely stopping.
2. Saves chosen location and intended session length.
3. Shows permission conditions and applicable time cutoff.
4. User opts into timer/restriction reminders.
5. App helps navigate back to vehicle later.
6. Sessions are deleted/expired according to user settings and retention policy.

### Journey C — Challan or towing incident

1. User selects **Challan help** or **Where is my vehicle?**
2. App provides current official portals/helplines and documented procedure.
3. User can organize location, time, photographs and correspondence.
4. Official authority handles payment, dispute or release; app does not adjudicate.
5. Where officially authorized integrations exist, display case status; otherwise do not invent it.

### Journey D — Incorrect map / sign

1. User taps **Report wrong status** and selects exact curb segment.
2. Captures sign photo, optional notes and safe timestamp/location.
3. AI suggests text extraction, redacts bystanders/plates where possible.
4. Admin compares official orders and survey evidence.
5. Approved updates publish as a new version and trigger relevant corrections.

### Journey E — Parking operator

1. Authorized operator signs in to a separate dashboard.
2. Claims/verifies facility and approved operator account.
3. Maintains hours, entrance, tariffs, space dimensions and constraints.
4. Uploads occupancy/booking availability only through supported verified integration.
5. System records changes and flags stale or contradictory information.

### Journey F — Society / residential parking (future)

1. Society admin configures property, slots, eligibility and governance rules.
2. Resident registers vehicles and requests a space or visitor pass.
3. Allocation supports society-approved rotation, lottery or fixed assignment.
4. Audit logs handle disputes and prevent silent allocation changes.
5. Private-space sharing is enabled only with owner and society permission.

## 8. Proposed mobile screens and navigation

**Primary navigation:** `Map` • `Find` • `Parked` • `Alerts` • `Profile`.

| Screen | User action | Essential content |
|---|---|---|
| Splash and onboarding | Set vehicle class and permissions | Value proposition, privacy, location controls |
| City parking map | Pan/zoom/tap roadside | Curb-edge statuses and legends; verified coverage only |
| Search destination | Type destination/address | Place results, walking/route alternatives |
| Curb details sheet | Tap exact side/bay | Legal status, conditions, source, timestamp, alternatives |
| Parking facility details | Tap lot | Entrance, hours, tariff, vehicle compatibility, availability confidence |
| Route to parking | Select eligible option | Safe navigation handoff + last-metre walking instructions |
| Parked session | Start/end session | Parked location, elapsed time, timers, rules |
| Scanner | Scan sign when stationary | Parsed sign, confidence, caveat, report incorrect result |
| Alerts | View relevant updates | Expiring parking duration, restriction changes and source freshness |
| Report issue | Send evidence | Category, photo, curb location, report tracking |
| Challan/towing support | Access official help | Verified official links and evidence checklist |
| Profile | Manage settings | Vehicles, accessibility options, notifications, privacy |
| Admin map editor (web) | Maintain rules | Geometry editing, source review, versioning and publication |
| Operator dashboard (web) | Maintain facility | Authorized hours, tariffs, inventory and booking data |

Design guidelines: map-first; compact bottom sheets; clear interaction states; no false precise GPS claims; large accessible touch targets; offline-warning messaging; no driver distractions; source and verification status visible on decisions.

## 9. AI and advanced-feature roadmap

| Capability | Implementation | Important safety limit |
|---|---|---|
| Parking sign scanner | Camera + OCR/vision → structured candidate restrictions | Never override official reviewed rule from AI alone |
| PDF traffic order extraction | Source retrieval → LLM extraction → human approval | Treat extraction as untrusted proposal |
| Nearby recommendation engine | Filter by legal suitability, walking distance, price, access and known capacity | No invented free spaces or prices |
| Time-aware restriction alerts | Device/session location + active rule windows | Notifications are assistance, not legal guarantee |
| Monsoon safety layer | Historical risk mapping + verified current alerts | Historical exposure is not live water depth |
| Tariff verification | Compare quoted price with verified current tariff | Do not label fraud without evidence and process |
| Society parking | Permissions, allocations and audit records | Must follow society rules and applicable law |
| EV charger parking | Partner feeds / verified charger details | Show updated time and data source |
| Accessibility routing | Verified accessible bays and pedestrian links | Avoid unsupported claims of accessibility |
| Municipal/operator analytics | Aggregated demand, reports and utilization | Restrict personal tracking and access |

## 10. Recommended technical architecture

```text
                     FLUTTER APP (ANDROID / iOS)
       MapLibre | Riverpod | Search | GPS | Notifications
                               |
                       HTTPS / JWT / API
                               |
                         FASTAPI BACKEND
   auth / geospatial search / rule evaluation / facilities / reports
                               |
      +------------------------+------------------------+
      |                        |                        |
 PostgreSQL + PostGIS     Object storage       Background workers
 roads, curb edges,       documents/photos      fetch approved data,
 rules, facilities,       with access control   detect updates, queue reviews
 versioning
      |                        |                        |
      +------------------------+------------------------+
                               |
                NEXT.JS ADMIN / OPERATOR DASHBOARDS
           verify source → draw curb → approve → publish
```

| Component | Preferred stack | Reason |
|---|---|---|
| Mobile | Flutter (Dart) | Android/iOS shared codebase |
| State | Riverpod | Testable state and dependency management |
| Map | MapLibre Flutter | Custom curb styling and vector overlays |
| Geospatial base | OSM-compliant base layers, licensed tiles | Road geometry, routing context |
| Backend | Python FastAPI | Structured APIs, validation and Python AI ecosystem |
| Spatial DB | PostgreSQL + PostGIS | Spatial indexing, line/polygon queries |
| Auth | Supabase Auth or equivalent | Roles and secure sign-in |
| Storage | S3-compatible/Supabase Storage | Orders, images, reports and versions |
| Document extraction | Python, PDF parsers, OCR and approved LLM | Candidate rule ingestion |
| Mapping admin tools | QGIS + Next.js map editor | Spatial review and source approval |
| Notifications | Firebase Cloud Messaging | Parking reminders and verified updates |
| Analytics | PostHog or equivalent | Funnel and data-quality measurement |
| CI / tests | GitHub Actions, Flutter and pytest | Repeatable validation and deployment |

**Licensing:** Attribute OSM appropriately; do not abuse public OSM tile servers; obey map tile and geocoding provider terms; do not scrape and migrate proprietary Google Maps data into a competing database. Confirm permitted use of all official documents, APIs, photos and datasets.

### 10.1 API endpoints (proposed)

```http
GET  /v1/parking/decision?lat=...&lng=...&curb_id=...&vehicle=car&at=...
GET  /v1/curbs?bbox=minLng,minLat,maxLng,maxLat
GET  /v1/facilities/nearby?lat=...&lng=...&vehicle=car
GET  /v1/facilities/{id}
GET  /v1/rules/{id}/sources
POST /v1/reports
GET  /v1/reports/{id}
POST /v1/sessions
PATCH /v1/sessions/{id}
POST /v1/admin/rules/candidates
POST /v1/admin/rules/{id}/approve
POST /v1/admin/rules/{id}/publish
```

Critical response fields for `/parking/decision`: status, matched segment ID, exact conditions, evaluation timestamp/timezone, rule IDs, source URLs, last verified timestamp, location confidence, and whether user confirmation of curb side is needed.

### 10.2 Roles

- **Guest:** Browse verified public parking decisions and facilities.
- **Driver:** Save preferences/sessions and submit reports.
- **Surveyor:** Upload bounded evidence and geospatial observations.
- **Reviewer:** Approve evidence and conflicts; cannot bypass audit.
- **Publisher/Admin:** Publish rule versions and manage records.
- **Operator:** Edit only their verified facilities and authorized inventory.
- **Authority partner (future):** Permission-scoped data workflows with a signed agreement.

## 11. Hackathon demo: realistic, testable scope

**Do not paint all Mumbai roads red/green using guesses.** Pick a short, field-verifiable Mumbai pilot corridor, ideally with a clear published traffic order. Aim for a *real* map and backend, not only static UI.

### MVP scope

1. Flutter home map of Mumbai with accurate test-area bounds.
2. Precisely mapped sample curb segments (both sides independently).
3. Four states: green, yellow, red and grey.
4. Date/time/vehicle-aware deterministic rules.
5. Source-linked decision detail bottom sheet.
6. Verified list of pilot-area facilities and navigation handoff.
7. Parked-session timer and demonstration reminder.
8. Minimal authenticated admin dashboard to enter and approve a rule.
9. Audit/version fields and tests for rule precedence, unknown and expiry.

### Suggested 9-step live demonstration

1. Search a pilot road.
2. Highlight mapped curb edges rather than road centerline.
3. Select east or west parking side.
4. Change date; odd/even rule result changes appropriately.
5. View order details, effective dates and verification metadata.
6. Select a prohibited curb; receive explanation and a verified alternative.
7. Navigate to an authorized parking lot or tagged bay.
8. Create a parking session and demonstrate a scheduled reminder.
9. Admin publishes a reviewed temporary order; app refreshes rule version.

### MVP acceptance tests

- **Rule tests:** odd/even, time of day, vehicle class, permit, duration, exceptions, temporary override, expired source and unknown.
- **Geometry tests:** parallel curb sides, road corners, GPS inaccuracy, overlapping segments, junctions.
- **UI tests:** status + explanation + source + freshness always visible; colorblind legend.
- **Safety tests:** no definitive permission on missing/contradictory evidence; no false live availability.
- **Data tests:** admin actions logged, source hash preserved, revisions reversible.
- **Security tests:** operator cannot change another operator’s facility; public cannot publish rules.

## 12. Four-stage rollout roadmap

### Stage 1 — Working hackathon prototype

- Flutter app with map and curb overlays.
- A few accurately checked roads and authorized facilities.
- Date/time/side-aware rule engine.
- Rule details, evidence and alternatives.
- Session timer, initial admin map editor and automated tests.
- **Deliverable:** Credible end-to-end technical demonstration.

### Stage 2 — One-neighborhood public pilot

- Conduct structured road survey and review.
- Expand coverage, search, reliable source monitoring and user reports.
- Add notification delivery, QA dashboards and manual corrections.
- Field-test accessibility and driver comprehension.
- **Deliverable:** Measured accuracy, freshness and usability in a defined area.

### Stage 3 — Connected parking ecosystem

- Authorized occupancy and tariff feeds.
- Operator dashboard, access and reservation integrations.
- EV, accessible, railway station and loading-zone filters.
- Official challan/towing portal handoffs.
- Residential and private-space-sharing pilots subject to permissions.
- **Deliverable:** Parking decisions linked with genuine inventory and operations.

### Stage 4 — Mumbai-scale platform

- Expand verified curb and facility coverage by priority corridors.
- Source-change monitoring and formal operational review.
- Enterprise/municipal reports and data-sharing agreements.
- Monsoon, mobility, safety and city planning analytics.
- Reliability, performance, privacy and security hardening.
- **Deliverable:** Trusted multi-operator city platform, conditional on agreements and data.

## 13. Prioritized opportunities

| # | User problem | Proposed feature | Opportunity | Implementation difficulty |
|---|---|---|---|---|
| 1 | Where can I legally park? | Street-segment, side-specific legality map | High | Hard |
| 2 | What restrictions apply now? | Dynamic date/time/vehicle rules | High | Hard |
| 3 | Where is authorized parking? | Verified location directory and route | High | Medium |
| 4 | Am I paying the correct rate? | Published tariff/operator verification | High | Medium |
| 5 | How do I avoid a violation? | Parking session and proactive alerts | High | Medium |
| 6 | Are spaces actually available? | Live feeds or IoT operator integration | High | Very hard |
| 7 | Is the parking location safe? | Verified facility and hazard attributes | Medium | Medium |
| 8 | How can I report illegal parking? | Geotagged evidence and complaint routing | Medium | Medium |
| 9 | Can private parking be shared? | Permissioned space marketplace | Medium | Hard |
| 10 | Can I avoid monsoon parking risks? | Flood exposure and verified warnings | Medium | Hard |

*Opportunity and difficulty assessments are product judgments for initial planning, not citywide research statistics.*

## 14. Success metrics

| KPI | Definition / instrument |
|---|---|
| Verified road coverage | Meters of curb with reviewed, current evidence ÷ mapped pilot curb meters |
| Decision accuracy | Agreement with current reviewed orders and field validation across sampled decisions |
| Rule freshness | % relevant rules checked within target review cadence |
| Search-to-option success | % searches resulting in an eligible verified option displayed |
| Time to find a parking option | Time from search start to user selection; measure carefully |
| Wrong-status reports | Reports per 1,000 verified curb interactions, segmented by severity |
| Operator data freshness | Age of latest capacity/tariff update per provider |
| Facility utilization | Actual occupancy for consenting integrated facilities only |
| Session reminder reliability | % scheduled user-opted reminders delivered before configured deadline |
| User trust | Comprehension test of legal explanation, source and uncertainty |

**Pilot validation target (proposed):** Review approximately 100–200 curb segments in one manageable area, retain documentary evidence, and compare rules against field observations and current orders before claiming accuracy.

## 15. Safety, legal, privacy and operational boundaries

### Legal correctness

- A map is informational assistance, **not legal authorization to park**.
- Official orders and current signs/directions control; source may change.
- Do not state a traffic fine, penalty or towing fee without current official evidence.
- Always show the selected time window and relevant vehicle type.
- Never treat missing restriction data as positive legal permission.

### Location and user safety

- GPS may not resolve which curb side the car occupies; ask the user.
- Avoid driver distraction: detailed interaction should occur only when safely stopped.
- No automatic reporting while driving.
- Clearly distinguish historical risk from live flood measurements.
- Do not infer accessibility or personal safety from incomplete evidence.

### Payments and enforcement

- Official authorities alone issue/challenge government challans.
- Use official handoffs for penalties, towing and disputes.
- Reservations and payments require contracted/authorized operators.
- No claims of government affiliation, official certification or live inventory without proof.

### Privacy and security

- Obtain appropriate consent for precise location and notifications.
- Minimize collection of number plates, bystander faces and movement history.
- Support retention limits and data deletion; restrict photo exposure.
- Implement rate limiting, abuse prevention, encryption, audit logs and role-based access.
- Assess the phased implementation and applicability of India's DPDP regime and current rules with qualified counsel before production.

### Service quality

- Display timestamps and current verification levels.
- Downgrade stale or contradictory data to unknown pending review.
- Build a process for rapid correction/retraction of published bad data.
- Log decision inputs and rule versions without unnecessarily tracking users.

## 16. Potential implementation risks and mitigation

| Risk | Mitigation |
|---|---|
| No complete authoritative parking-rule feed | Small field-verified pilot; official document intake; human review |
| Changing temporary restrictions | Source monitors, effective dates, expiry/review queues |
| Ambiguous GPS and curb-side geometry | Explicit curb-side selection, map snapping with confidence threshold |
| Contradictory sources | Mark grey, escalate to reviewer, show conflict |
| Incomplete live occupancy | Display availability unknown; never simulate as real |
| Data licensing restrictions | Obtain permission, comply with ODbL/provider licenses |
| Unreliable AI extraction | Structured schemas, citations, deterministic engine, human validation |
| Malicious or mistaken user reports | Moderation, deduplication, source verification and abuse controls |
| Inappropriate certainty about fines | Informational handoffs and current official source verification |
| Product complexity | Stage the roadmap and focus on the central decision flow |

## 17. Initial engineering backlog

### Product and design

- [ ] Lock first pilot area and vehicle class(es).
- [ ] User flow and wireframes for Map, Curb Details, Find, Parked, Alerts and Report.
- [ ] Visual status system: green/yellow/red/grey, icons, legend, uncertainty messaging.
- [ ] Define empty, offline, loading, conflict and stale-source states.

### Geospatial and data

- [ ] Create road/curb/bay/facility schemas.
- [ ] Import license-compliant base geometry.
- [ ] Draw independent curb edges for the pilot.
- [ ] Collect official orders, facility sources and survey evidence.
- [ ] Build source registry, review workflow and versioned publication.
- [ ] Define accuracy/freshness QA checks.

### Backend

- [ ] Implement PostGIS schema and spatial indexes.
- [ ] Create deterministic rule evaluator and automated tests.
- [ ] Build public parking decision, map overlay and facility APIs.
- [ ] Build admin authentication, authorization, and audit logs.
- [ ] Implement report submission and moderation queue.

### Flutter app

- [ ] MapLibre map and segmented curb overlays.
- [ ] Date/time and vehicle context controls.
- [ ] Tap-to-select exact curb side.
- [ ] Decision detail + official source rendering.
- [ ] Nearby facilities and navigation handoff.
- [ ] Parking sessions/reminders and clear permission boundaries.

### Validation

- [ ] Compare real rules with primary legal orders.
- [ ] Field test GPS ambiguity and navigation.
- [ ] Verify that unknown is never shown as permitted.
- [ ] Ensure app does not show fictional live parking capacity.
- [ ] Conduct usability and accessibility test with pilot users.

## 18. Evidence and external source checklist

The following are **starting points**, not a claim that a full live data partnership or API is available.

1. **Mumbai Traffic Police:** parking restrictions, traffic orders, diversion notices and published notifications. One previously identified official notification: <https://mumbaipolice.gov.in/files/PressRelease/3524.pdf>.
2. **Brihanmumbai Municipal Corporation (BMC):** authorized public parking lists, tariff schedules, contractor details, facility inspection and geographic information. Verify the current official URL of any dataset before using it.
3. **Maharashtra traffic e-challan / grievance systems:** current official access paths and procedures; do not rely on third-party payment redirects.
4. **OpenStreetMap:** road geometry and applicable attribution/licensing requirements: <https://www.openstreetmap.org/copyright>.
5. **MapLibre:** map SDK and styling documentation: <https://maplibre.org/>.
6. **PostGIS:** spatial database reference: <https://postgis.net/>.
7. **Flutter:** mobile development documentation: <https://docs.flutter.dev/>.
8. **FastAPI:** backend framework: <https://fastapi.tiangolo.com/>.

**Items to verify before a public pitch:** the 2025 e-challan count, 2025 registrations, total BMC lot capacity, occupancy reports, Kala Ghoda overcharging incident, October 2026 mapped authorized facilities, odd-even order's ongoing applicability, any actual live municipal parking app/API, and the current legal/contractual status of each intended integration. Previous assistant messages cited news and government coverage for these claims; this document intentionally avoids fabricating source URLs where the precise URL is not recorded here.

## 19. Recommended problem statement and positioning

**Problem statement**

> Mumbai motorists lack a unified, reliable, time-aware way to determine whether parking is legal at a precise roadside location and to identify authorized alternatives when it is not.

**Proposed positioning**

> An AI-assisted, GIS-powered Smart Urban Parking Compliance and Discovery Platform that explains parking eligibility at the curb level and connects drivers to verified alternatives.

**What the first release must do exceptionally well**

1. Know the **exact curb**, **vehicle**, **time** and **rule**.
2. Clearly say **permitted**, **conditional**, **prohibited**, or **unknown**, and **why**.
3. Show a **verified authorized alternative** where available.

Everything else—payments, real-time sensors, society parking, EV integrations, towing workflows, monsoon alerts and municipal analytics—should build on that verified foundation.

---

*End of consolidated Mumbai Smart Parking project blueprint.*
