# Design System Specification: High-Tech Tactical Interface

## 1. Overview & Creative North Star: "The Obsidian Command"
The Creative North Star for this design system is **"The Obsidian Command."** We are moving away from the "neon-clutter" tropes of low-budget cyberpunk. Instead, we are building a high-end, military-grade tactical interface designed for the precision control of the 'Ironclaw' and 'Openclaw' AI entities.

The aesthetic is defined by **Extreme Brutalism** meets **Digital Luxury**. We achieve this through:
*   **Total Angularity:** A strict 0px radius policy. Curves are forbidden; they represent weakness in the machine logic.
*   **Void-Space Depth:** Using the deep `#131313` background not as a "dark mode," but as an infinite canvas where UI elements materialize through light and shadow.
*   **Intentional Asymmetry:** Breaking the traditional centered grid to create a "heads-up display" (HUD) feel, where data is prioritized in unbalanced, high-contrast layouts.

---

## 2. Colors: The Neon Pulse
Color is not used for decoration; it is used for **System Status**.

*   **Primary (Neon Pink - `#ffb1c4` / `#ff4a8d`):** Used exclusively for high-priority interactive elements and critical AI feedback. This is the "soul" of the Ironclaw interface.
*   **Secondary (Cyber Cyan - `#d3fbff` / `#00eefc`):** Reserved for data readouts, technical telemetry, and 'Openclaw' specific sub-routines.
*   **Surface Hierarchy (The Void):** 
    *   `surface_container_lowest` (`#0e0e0e`): Used for the deepest "recessed" areas like the chat input gutter.
    *   `surface` (`#131313`): The standard ground.
    *   `surface_bright` (`#3a3939`): Used for elevated tactical overlays.

**The "No-Line" Rule:** 
Standard 1px solid borders are strictly prohibited for layout sectioning. Separation must be achieved via background shifts (e.g., a `surface_container_low` message bubble against a `surface` background).

**The "Glass & Gradient" Rule:** 
Use `surface_variant` at 40% opacity with a `backdrop-blur: 20px` for floating terminal windows. Apply a subtle linear gradient from `primary` to `primary_container` (at 15% opacity) to give CTAs a "powered-on" energy.

---

## 3. Typography: Machine-Readable Precision
We utilize a dual-font system to balance high-tech flavor with readability.

*   **Display & Headlines (Space Grotesk):** This is our "command" typeface. It is wide, tech-focused, and aggressive. Use `display-lg` (3.5rem) for AI entity names ('IRONCLAW') with `letter-spacing: -0.05em`.
*   **Body & Titles (Manrope):** A high-performance sans-serif used for chat logs and technical descriptions. It provides the necessary legibility for long-form AI responses.
*   **Labels (Space Grotesk):** Used for micro-data (timestamps, status codes). Always uppercase with `letter-spacing: 0.1rem`.

---

## 4. Elevation & Depth: Tonal Layering
In a cyberpunk void, depth is created by light emission, not physical shadows.

*   **The Layering Principle:** Stack `surface_container` tiers to create hierarchy. A tactical map should sit on `surface_container_highest`, while the background remains `surface_dim`.
*   **The "Glow" Fallback:** Instead of traditional drop shadows, use `box-shadow` with the `primary` color at 10-15% opacity and a large blur (20px+) to simulate the neon glow reflecting off the dark surface.
*   **The "Ghost Border" Rule:** If a container requires definition, use the `outline_variant` token at 20% opacity. It should look like a faint scan-line, not a structural box.
*   **Signature Element (The "Hard Edge"):** All "elevated" elements must feature a 45-degree corner cut (achieved via CSS `clip-path`) rather than a rounded corner to maintain the "Ironclaw" weaponized aesthetic.

---

## 5. Components: Tactical Modules

### Buttons (Command Triggers)
*   **Primary:** Background: `primary_container`. Text: `on_primary_container`. Shape: 0px radius with a `primary` 2px "Glow Border" on hover.
*   **Tertiary:** Ghost style. No background. Border: 1px `outline_variant` (20% opacity). Text: `primary`.

### Input Fields (Data Entry)
*   **Style:** `surface_container_lowest` background. No top, left, or right borders—only a 2px bottom border in `outline`. On focus, the bottom border "charges up" to `primary` with a subtle neon glow.

### Cards & Chat Bubbles
*   **Rule:** Forbid divider lines. 
*   **Execution:** User messages use `surface_container_high`. AI responses use `surface_container_low` with a subtle left-hand vertical accent bar in `primary` (Ironclaw) or `secondary` (Openclaw).

### Chips (Status Tags)
*   **Selection:** Sharp rectangular boxes. Background: `surface_variant`. Text: `label-sm`. When active, background becomes `secondary` and text becomes `on_secondary`.

### Additional Component: "The Pulse Meter"
*   A custom progress bar for AI processing. Use a stepped gradient (CSS `repeating-linear-gradient`) to create a "segmented" charging look using the `primary_fixed` and `primary` tokens.

---

## 6. Do's and Don'ts

### Do:
*   **DO** use monospaced numbers for data readouts to ensure vertical alignment.
*   **DO** use "glitch" transitions for loading states (subtle 1px X-axis shifts).
*   **DO** lean into high-contrast ratios. If it's not bright neon, it should be deep obsidian.

### Don't:
*   **DON'T** use 1px solid borders for layout containers. It looks like a template.
*   **DON'T** use any border-radius. Even 2px is too "soft" for this system.
*   **DON'T** use standard grey shadows. Shadows should be non-existent or tinted with the `surface_tint`.
*   **DON'T** center-align body text. Keep it left-aligned to mimic a terminal readout.