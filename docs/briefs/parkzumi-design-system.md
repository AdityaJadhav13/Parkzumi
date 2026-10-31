# Parkzumi: Design System, Mascot and Logo

Version: 0.1  
Date: 31 October 2026  
Status: Proposed design baseline  
Working brand: Parkzumi  
Brand wordmark: parkzumi  
Mascot: Zumi  
Tagline: Know the spot.

This is a companion to the product and engineering brief. It defines the identity and reusable design decisions; it does not replace the product's evidence, privacy, permission, and recovery requirements.

## 1. Brand direction

**Street-smart parking, with a local friend looking out for you.**

Parkzumi should feel observant, playful, direct, and dependable. Personality comes from the character, memorable typography, a distinctive lime accent, and concise language. Parking information and urgent messages remain easy to understand.

The intended audience initially includes Mumbai bike owners, with support for other vehicles. Gen Z is the stylistic direction, not a reason to make the information cryptic.

Use mostly neutral backgrounds, concentrated lime accents, and occasional purple for community information. A useful starting balance is approximately 80% neutrals, 15% lime, and 5% secondary accents, excluding necessary status colors.

## 2. Mascot: Zumi

Zumi is a small, lime neighbourhood street cat: curious, alert, slightly cheeky, and familiar with the area's hidden parking options.

### Character identity

- Broad rounded head with short triangular ears.
- One small notch in the cat's left ear, on the viewer's right in a front-facing pose.
- Almond-shaped eyes with a sideways, observant glance.
- Small dark nose and minimal facial detail.
- Compact body, short paws, and one large curled tail.
- The tail's upright loop subtly suggests a lowercase p.
- Lime body with ink outlines; purple may appear as a small supporting accent.
- No required clothes, helmet, collar, accessories, or detailed fur.

Maintain the head shape, ear identity, eye language, body proportions, and tail motif across expressions. Do not mirror an exported character mechanically if that moves the identifying ear notch to the wrong ear.

### Expressions and behaviour

| State | Character behaviour | Communication intent |
| --- | --- | --- |
| Neutral | Alert sideways glance | Available and paying attention. |
| Checking | Small eye or tail movement | Looking for relevant information. |
| Helpful result | Small nod or relaxed expression | A useful result is ready. |
| Uncertain | Curious head tilt | More evidence is needed. |
| Offline or interrupted | Calm waiting pose | Progress is preserved; recovery is possible. |
| Important alert | Focused eyes and raised ears | Pay attention to a concrete concern. |

Use the full character sparingly in explanatory or supportive moments. Do not let decorative animation delay access to parking information. An alert should state the concern even if the mascot image never loads.

Zumi does not mock a user who has been fined or towed. Expressions must not imply that unknown parking is safe or that community approval provides legal permission.

## 3. Logo system

### Primary lockup

Use the simplified Zumi head beside the lowercase wordmark parkzumi. The wordmark should be bold, rounded, tightly but clearly spaced, and optically balanced. It is custom lettering; the generated concept is a reference rather than a claim of an exact production font.

The tagline is optional supporting text. It is not part of the smallest logo asset.

### Asset variants

| Variant | Purpose |
| --- | --- |
| Head plus wordmark | Main brand identification and larger placements. |
| Head only | App identity, floating companion, small branding. |
| Ink monochrome | Printing and restrained light-background use. |
| Paper monochrome | Dark-background use. |
| Full-body Zumi | Character illustration, not the smallest logo. |

At small sizes, simplify the face and ear detail while retaining recognition. Never depend on a tiny ear notch to identify the app. Test the mark at 24, 32, and 48 pixels and within the actual Android icon masks before final production.

Suggested minimums: a head mark at least 24 logical pixels, a full lockup at least 140 logical pixels wide, and clear space of one quarter of the head's height around the lockup. These are initial design constraints to validate, not guarantees that every rendering passes.

Use a stable wordmark and stable head silhouette across the app. Do not change the permanent app icon's facial expression to convey transient parking status.

The concept board is a raster exploration. Production still requires a refined vector master, consistent illustration assets, Android adaptive-icon exports, and small-size verification. Do not automatically trace every image-generation imperfection into the final logo.

## 4. Color foundations

| Token | Value | Role |
| --- | --- | --- |
| brand.lime | #C5FF45 | Primary brand accent and selected primary actions. |
| brand.ink | #171917 | Main text, outlines, and strong contrast. |
| brand.paper | #F5F4EE | Warm default background. |
| brand.community | #6B46C1 | Community-origin information and selected secondary accents. |
| light.surface | #FFFFFF | Light surfaces above paper. |
| light.textSecondary | #62675F | Secondary text on paper or white. |
| light.border | #D9DDD3 | Decorative separators and nonessential boundaries. |

Lime is a brand accent, not a blanket declaration that parking is allowed. Purple indicates community context, not verification. Essential field boundaries, focus indicators, and state icons need stronger contrast than the decorative border token where their shape communicates function.

### Semantic status colors

| Meaning | Light text/icon | Light background | Dark text/icon | Dark background |
| --- | --- | --- | --- | --- |
| Restriction found / error | #B42318 | #FEE4E2 | #FFA79F | #401D1B |
| Caution / changing condition | #8A4B08 | #FFF0C2 | #FFD98A | #352B14 |
| Permitted under recorded conditions | #176B45 | #DCFCE7 | #86E0B0 | #153425 |
| Cannot verify / neutral uncertainty | #4B5563 | #EEF1F4 | #CBD5E1 | #252C35 |
| Community observation | #6B46C1 | #F0EAFE | #D2BCFF | #2D2241 |

Every meaningful status also needs text and an appropriate symbol. Color alone must not carry the answer. A positive community report must not receive the same meaning as a sourced permission result.

### Dark foundations

| Token | Value |
| --- | --- |
| dark.background | #121512 |
| dark.surface | #1C211C |
| dark.surfaceRaised | #252C25 |
| dark.textPrimary | #F5F4EE |
| dark.textSecondary | #AFB8AC |
| dark.border | #404A40 |

Keep the lime accent and core mascot identity stable. Adjust semantic surfaces and text deliberately; do not invert illustrations or photographs automatically.

## 5. Typography

Use **Space Grotesk** for headings and prominent short values, and **DM Sans** for body text, labels, and explanations. Obtain font files from their official sources, retain the applicable license files, and bundle the selected weights so ordinary text does not depend on network font loading.

| Role | Family | Size / line height | Weight |
| --- | --- | --- | --- |
| Display | Space Grotesk | 32 / 38 | 700 |
| Main heading | Space Grotesk | 24 / 30 | 700 |
| Section heading | Space Grotesk | 20 / 26 | 600 |
| Body | DM Sans | 16 / 24 | 400 |
| Supporting body | DM Sans | 14 / 20 | 400 |
| Action label | DM Sans | 16 / 20 | 700 |
| Small supporting label | DM Sans | 12 / 16 | 500 |

Sizes are scalable text units in a native app. Support system text scaling and wrapping. Do not make critical warnings or conditions depend on the smallest supporting style.

Use tabular numerals where the chosen font supports them for prices, durations, counts, and changing times. Preserve readable currency and vehicle-registration formatting. Add a tested script-appropriate fallback when Hindi or Marathi is introduced; the Latin brand fonts alone do not define the multilingual typography system.

## 6. Shape, spacing and iconography

- Spacing scale: 4, 8, 12, 16, 20, 24, 32, 40, 48 logical pixels.
- Standard action height: 52 logical pixels, allowed to grow with text.
- Minimum interactive target: 48 by 48 dp on Android.
- Initial corner radii: 12 for inputs and actions, 16 for cards, 24 for larger containers, fully rounded for compact tags and the companion identity.
- Use a consistent 24-unit icon grid with approximately 2-unit rounded strokes.
- Use simple, recognisable symbols for vehicles, time, walking, photos, sources, and uncertainty.
- Restrict heavy ink outlines to character art, brand moments, and selected emphasis. Keep data-heavy content calm and readable.
- Prefer borders and surface contrast for grouping; use elevation only when it communicates layering.

The floating identity may be visually compact, but its touch region must remain usable. It must be movable and dismissible and avoid obscuring essential navigation information. These are functional constraints, not an instruction to imitate Google's own branding.

## 7. Reusable component rules

| Component | Design rule |
| --- | --- |
| Primary action | Ink text on lime, clear action wording, visible pressed/focus states. |
| Secondary action | Neutral surface, ink text, a sufficiently visible boundary when needed. |
| Important or destructive action | Explicit verb, semantic treatment, no joke that obscures the consequence. |
| Assessment result | A clear outcome plus reason, relevant conditions, and evidence access. |
| Community report | Purple context, observation time, vehicle and stay context, review status separately identified. |
| Evidence label | Explicit source class such as official, operator, community, or pending; avoid a generic verified badge covering several meanings. |
| Parking option | Distinguish access conditions, available capacity, price, stay limits, and evidence freshness. |
| Loading state | State what is being checked; progress must not imply a decision has already been reached. |
| Offline/pending state | Say what was saved, what remains unsent, and what action is available. |
| Alert | Concrete event and time first; distinguish a community report from confirmed information. |

Define default, pressed, focused, disabled, loading, pending, error, and recovered states for applicable components. Disabled actions must not look like successful completion. Recovered operations should not generate duplicate success messages or repeated reward celebrations.

## 8. Voice and language

Use short, natural English with occasional character in low-stakes moments. Keep action labels and important results explicit. Humor should come from the brand, not from ambiguous instructions.

| Situation | Example wording |
| --- | --- |
| Brand introduction | Know the spot. |
| Finding options | Checking nearby spots. |
| Community knowledge | Locals have parked here. |
| Missing detail | Need a clearer view of that entrance. |
| Uncertainty | Can't verify this spot yet. |
| Pending upload | Saved on your phone. We'll retry when connected. |
| Reported change | Someone reported the gate closed at 6:10 pm. |
| Important action | Check another spot. |
| Contribution accepted | Good tip. That helps the next rider. |

Do not use guaranteed-safe wording or invented percentages. Communicate community tolerance as an observed experience. Avoid excessive slang, shaming, and fake urgency.

## 9. Motion

- Quick feedback: 120 ms.
- Standard transition: 180 ms.
- Larger contextual transition: 240 ms.
- Default easing: cubic-bezier(0.2, 0.8, 0.2, 1).
- Character motion: occasional blink, small head tilt, or tail movement.
- Essential status and alerts appear immediately; animation is optional support.
- Respect reduced-motion preferences and avoid perpetual bouncing or flashing.

## 10. Contrast validation and accessibility

The initial text/background token pairs were checked using the WCAG relative-luminance formula. The figures below describe the specified solid colors, not proof that the complete app meets accessibility requirements.

| Pair | Contrast |
| --- | --- |
| Ink on lime | 14.95:1 |
| Ink on paper | 16.04:1 |
| Secondary text on paper | 5.26:1 |
| White on community purple | 6.42:1 |
| Community text on its light surface | 5.47:1 |
| Restriction text on its light surface | 5.45:1 |
| Caution text on its light surface | 5.98:1 |
| Permitted text on its light surface | 5.93:1 |
| Unknown text on its light surface | 6.67:1 |

The defined dark primary, secondary, and semantic text/background pairs also passed 4.5:1 in the token calculation. Recheck actual rendered components, focus indicators, font scaling, image backgrounds, and any new color combination. Lime against paper is not an adequate text or essential-icon pairing without an appropriate contrasting treatment.

Provide accessible labels for actions and meaningful status icons. Hide purely decorative mascot art from assistive reading. Do not require a user to distinguish the same shape by color alone. Preserve readable contrast and target sizes in both themes.

## 11. Implementation tokens

The following is a framework-neutral starting token object. Use semantic aliases in components; do not scatter literal values through a codebase.

```json
{
  "brand": {
    "name": "Parkzumi",
    "wordmark": "parkzumi",
    "mascot": "Zumi",
    "tagline": "Know the spot.",
    "lime": "#C5FF45",
    "ink": "#171917",
    "paper": "#F5F4EE",
    "community": "#6B46C1"
  },
  "themes": {
    "light": {
      "background": "#F5F4EE",
      "surface": "#FFFFFF",
      "textPrimary": "#171917",
      "textSecondary": "#62675F",
      "borderDecorative": "#D9DDD3",
      "actionBackground": "#C5FF45",
      "actionForeground": "#171917",
      "restriction": {"foreground": "#B42318", "background": "#FEE4E2"},
      "caution": {"foreground": "#8A4B08", "background": "#FFF0C2"},
      "permitted": {"foreground": "#176B45", "background": "#DCFCE7"},
      "unknown": {"foreground": "#4B5563", "background": "#EEF1F4"},
      "community": {"foreground": "#6B46C1", "background": "#F0EAFE"}
    },
    "dark": {
      "background": "#121512",
      "surface": "#1C211C",
      "surfaceRaised": "#252C25",
      "textPrimary": "#F5F4EE",
      "textSecondary": "#AFB8AC",
      "borderDecorative": "#404A40",
      "actionBackground": "#C5FF45",
      "actionForeground": "#171917",
      "restriction": {"foreground": "#FFA79F", "background": "#401D1B"},
      "caution": {"foreground": "#FFD98A", "background": "#352B14"},
      "permitted": {"foreground": "#86E0B0", "background": "#153425"},
      "unknown": {"foreground": "#CBD5E1", "background": "#252C35"},
      "community": {"foreground": "#D2BCFF", "background": "#2D2241"}
    }
  },
  "typography": {
    "headingFamily": "Space Grotesk",
    "bodyFamily": "DM Sans",
    "display": {"size": 32, "lineHeight": 38, "weight": 700},
    "heading": {"size": 24, "lineHeight": 30, "weight": 700},
    "section": {"size": 20, "lineHeight": 26, "weight": 600},
    "body": {"size": 16, "lineHeight": 24, "weight": 400},
    "supporting": {"size": 14, "lineHeight": 20, "weight": 400},
    "action": {"size": 16, "lineHeight": 20, "weight": 700},
    "small": {"size": 12, "lineHeight": 16, "weight": 500}
  },
  "spacing": [4, 8, 12, 16, 20, 24, 32, 40, 48],
  "radius": {"control": 12, "card": 16, "container": 24, "pill": 999},
  "sizing": {"touchTargetMin": 48, "actionHeight": 52, "iconGrid": 24},
  "motion": {"quickMs": 120, "standardMs": 180, "contextMs": 240, "easing": [0.2, 0.8, 0.2, 1]}
}
```

## 12. Asset production and next decisions

The generated visual is a concept board, not a complete exported component or illustration library. Before shipping:

1. Refine one canonical vector head mark and wordmark.
2. Produce a consistent full-body character master and agreed expressions.
3. Verify small-size, monochrome, light/dark, and Android adaptive-icon treatments.
4. Convert semantic tokens into the actual app's theme and reusable components.
5. Test readability outdoors, text scaling, and touch interactions on real devices.

Keep the receiving coding agent's independent judgement: challenge a token or treatment that fails in implementation, explain the change, and preserve the core identity rather than copying the concept mechanically.

## References

- Space Grotesk, official designer specimen: <https://floriankarsten.github.io/space-grotesk/>
- Space Grotesk on Google Fonts: <https://fonts.google.com/specimen/Space+Grotesk>
- DM Sans on Google Fonts: <https://fonts.google.com/specimen/DM+Sans>
- W3C contrast minimum guidance: <https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html>
- Android touch-target guidance: <https://support.google.com/accessibility/android/answer/7101858?hl=en>
