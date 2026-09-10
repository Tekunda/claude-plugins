---
name: design-discipline
description: Use BEFORE building or editing any web UI — headers, navs, cards, forms, pages, or any visual component. Installs the discipline that separates intentional, breathing interfaces from cramped "AI slop", with a pre-ship self-check. Do not trigger for backend or content-only changes.
---

# Frontend Design

You are acting as a senior product designer AND the front-end engineer. A change that satisfies the literal requirement but looks cramped, jammed, or unbalanced is **not done**. Design quality is part of correctness, not a nice-to-have.

The single most important instinct this skill installs: **when space is tight, DELETE elements — never shrink and cram them.** Whitespace is a feature. An empty region is a design decision, not wasted space.

---

## 0. The rule that would have prevented the failure

> A meeting spec said "make the mobile help-center header one line, no overflow at 768x1024." The agent crammed logo + "/" divider + "Help Center" label + back-link + language pill + "Start free" button onto one row at 390px, left-jammed, no breathing room. Technically zero overflow. Visually broken.

The literal constraint ("one line, no overflow") is a **floor, not the goal.** "No overflow" is satisfied by cramming; it is also satisfied by *removing things until what remains breathes.* Always choose the second. When a requirement can be met by cramming or by deleting, delete.

Correct answer for that header: **logo left, primary actions right, nothing in between.** Drop the redundant breadcrumb `/`, the "Help Center" text label (the logo already says where you are), and the back-link (the browser and logo already navigate back) on mobile. Keep one language control and one CTA. Result: two anchored clusters with air between them.

---

## 1. Core principles (apply every time)

These are the load-bearing rules from Refactoring UI, Apple HIG, and Material Design. Internalize them; they are not style preferences.

### Hierarchy — not everything is equally important
- Every screen has ONE primary action/message. Make it visibly dominant (size, weight, color, position). Everything else recedes.
- De-emphasize secondary content with **weight and color before size** — soften a label to gray-500 rather than shrinking it to 10px. Supporting text is not "smaller important text", it is "quieter text".
- Avoid walls of equal-weight text. If three things look equally important, none of them are.

### Spacing & rhythm — use an 8pt system
- Size and space in multiples of 4, ideally 8: `4, 8, 12, 16, 24, 32, 48, 64`. Never arbitrary `7px` / `13px` / `19px` values.
- **Whitespace inside an element groups it; whitespace between elements separates them.** The gap between two groups must be clearly larger than the gap within a group (proximity → grouping, Gestalt). If inner and outer spacing are equal, the eye can't parse structure.
- Give content room. Generous padding reads as premium and intentional; tight padding reads as cramped and cheap. When unsure, add space.
- Spacing should be *relative to element size*: a big touch target gets big padding; don't pad a 32px button with 24px.

### Alignment & balance
- Everything aligns to something. Establish a small number of alignment edges (a left column, a right column) and snap every element to one. Stray, near-but-not-quite alignments read as sloppy.
- Balance the composition: distribute visual weight. A header is typically **anchored left, anchored right, empty middle** — two clusters in tension across open space, not one blob shoved against the left margin.
- Don't center everything. Centered layouts stall on long content and signal "template". Reserve centering for genuinely short, symmetrical content (a hero headline, an empty state).

### Contrast & color
- Establish contrast intentionally: primary text near-black on white (or the inverse), secondary text a mid-gray, borders a light gray. Meet WCAG AA (4.5:1 body text, 3:1 large text and UI borders).
- Don't paint the UI in uniform gray boxes of the same value — that's the flattest, most generic look there is. Vary surface elevation with subtle value shifts and restrained shadow, not by boxing everything.
- Use one dominant color with sharp accents. Timid, evenly-distributed palettes look undesigned.

### Typography
- Use a constrained type scale (e.g. `12, 14, 16, 20, 24, 30, 36, 48`), not ad-hoc sizes. Body text 16px+ on mobile.
- Limit weights: a body weight and a bold weight is usually enough. Set line-height ~1.5 for body, tighter for headings. Constrain measure to ~45-75 characters per line.

### Restraint — delete, don't cram
- The best edit is usually a deletion. Redundant labels, duplicate navigation affordances, decorative dividers, "just in case" elements — cut them.
- Every element must earn its place. If removing it loses nothing, it was noise.
- Density is not information. A sparse screen with clear hierarchy communicates more than a dense one.

---

## 2. Responsive / mobile-first discipline

**Design the smallest screen first, then add.** Most real failures are on phones.

### Shrink is the last resort — prefer collapse / hide / relocate
When content doesn't fit a narrow viewport, in priority order:
1. **Delete** what's redundant at this size (labels the icon/logo already implies, secondary nav, breadcrumbs).
2. **Relocate**: move secondary actions into a menu (hamburger, overflow "…", bottom sheet), stack rows vertically.
3. **Collapse**: replace a text label with an icon *only if the icon is unambiguous*.
4. **Shrink** font/padding — only after the above, and never below the minimums.

Never solve "doesn't fit" by squeezing everything smaller and tighter. That's the cram anti-pattern.

### What a good mobile header looks like
- Two clusters: **brand/identity left, one-or-two primary actions right.** Open space between.
- At most ~2-3 tap targets visible; everything else lives behind a menu.
- No breadcrumbs, no secondary text labels, no "/" dividers competing for the row.
- Every target ≥ **44x44pt (Apple HIG) / 48x48dp (Material)** with spacing between targets so thumbs don't mis-hit.
- The row has vertical breathing room (comfortable top/bottom padding), not text jammed against edges.

### Test at real device widths
- Verify at **375, 390, 393, 414px** (real iPhone/Android widths) — not just "below the `md` breakpoint". A layout can pass at 767px and break at 390px.
- Check both portrait phone AND desktop. The failure above passed the tablet width (768) and broke on the phone.
- Confirm: no horizontal scroll, no overlap, no text clipped, targets are tappable, and it *breathes*.

---

## 3. AI-slop anti-patterns (name it → fix it)

| Anti-pattern | Why it's wrong | Correct alternative |
|---|---|---|
| **Cram everything on one row** | Meets "one line" by squeezing; reads as broken | Delete/relocate elements until the row breathes; push overflow into a menu |
| **Left-jam the whole cluster** | Ignores balance; leaves dead right-space and a heavy left blob | Anchor identity left, actions right; use `justify-content: space-between` |
| **Uniform gray boxes** | Flat, no hierarchy, no elevation | Vary value/elevation intentionally; let the primary element stand out |
| **No breathing room** | Everything touches everything; cheap and stressful | Apply the 8pt scale; make between-group gaps > within-group gaps |
| **Ignoring states** | hover/focus/active/disabled undefined or incoherent | Own ALL states for every interactive element (see §4) |
| **Decorative hover on non-interactive cards** | Lift/shadow on a static card = rage-click trap | Hover affordance ONLY on things that navigate or act |
| **Center everything** | Signals template; stalls on long content | Left-align body/UI; center only short symmetric content |
| **Walls of equal-weight text** | No hierarchy; nothing guides the eye | One dominant element; de-emphasize the rest by weight/color |
| **Arbitrary spacing (7/13/19px)** | Visually noisy, no rhythm | Snap to 4/8pt multiples |
| **Redundant navigation** (logo + breadcrumb + back-link all doing "go back") | Clutter; three ways to do one thing | Keep one; delete the rest, especially on mobile |

---

## 4. Interactive states — you own all of them

When you touch any link, button, card, input, or icon-button, leave `default`, `:hover`, `:focus-visible`, `:active`, and `:disabled` coherent (where each applies).

- Removing one property is not done until you confirm no *other* state depended on it. A hover that only worked because of a border you deleted is now a regression.
- `:focus-visible` must be clearly visible (keyboard users) and meet 3:1 contrast — never `outline: none` with nothing replacing it.
- Accessibility text (skip links, sr-only, aria labels) is **hidden-until-focus** — off-screen/clipped until `:focus`, never rendered as visible page text.
- Hover elevation/lift/shadow is reserved for fully-clickable elements only.

---

## 5. Pre-ship self-check (run mentally before committing UI)

Answer each honestly. A "no" is a blocker, not a note.

1. **Does it breathe?** Is there deliberate whitespace, or is everything jammed together? Are between-group gaps clearly larger than within-group gaps?
2. **Is there ONE clear focal point?** Can I name the single most important element, and does it look most important?
3. **Does it look intentional at 390px?** Rendered at a real phone width — not just "no overflow" but balanced, uncluttered, tappable? Two anchored clusters, not one left-jammed blob?
4. **Did I DELETE rather than cram?** When something didn't fit, did I remove/relocate it, or did I shrink-and-squeeze? Is every remaining element earning its place?
5. **Is spacing on the 8pt system?** Any arbitrary 7/13/19px values to fix?
6. **Is everything aligned?** Every element snapped to a shared edge; no near-misses?
7. **Are all interactive states coherent?** hover/focus-visible/active/disabled defined and consistent; no decorative hover on static cards?
8. **Contrast & legibility?** AA-passing text, 16px+ body on mobile, no illegible density?

If you cannot confidently answer yes to 1, 3, and 4, you have shipped AI slop. Revise before committing.

---

## 6. Before / after

**Header at 390px (the failure)**
- BAD: `[logo] / Help Center  ‹ Back   [EN]  [Start free]` — six elements, one row, jammed left, no air, dead space on the right. Zero overflow, fully broken.
- GOOD: `[logo]  ........................  [EN] [Start free]` — identity left, actions right, `space-between`, comfortable vertical padding. Breadcrumb, text label, and back-link deleted on mobile (the logo and browser already cover "where am I / go back").

**Card grid**
- BAD: five cards of uniform gray, equal weight, 8px gaps, each with a hover-lift though only the title links.
- GOOD: cards on a clear surface with 24px gaps and 16-20px internal padding; title dominant, meta in gray-500; hover affordance only if the *whole card* is a link.

**Section of text**
- BAD: three paragraphs of identical size/weight, centered, full-width lines.
- GOOD: a bold lead line, supporting copy in a quieter weight, left-aligned, measure capped ~65ch, generous space between blocks.

---

Design is decisions. Make them deliberately, default to less, and make what remains breathe.
