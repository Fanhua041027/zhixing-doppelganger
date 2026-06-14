# Development Plan

## Phase 1: MVP Workspace

- Replace the template page with the Zhixing dashboard.
- Keep the first implementation local and deterministic.
- Provide goal input, intent recognition, task cards, and profile signals.
- Verify the project opens and builds inside DevEco Studio 26.0.0 Beta1.

## Phase 2: Agent Core

- Move intent recognition into a dedicated service.
- Add task decomposition models and execution states.
- Persist task history locally.
- Add fallback responses for unsupported or ambiguous goals.
- Keep evaluation metrics visible in the product UI from the first demo.

## Phase 3: Personal Doppelganger Data

- Model user preferences, learning habits, memories, and conflict notes.
- Add import-friendly structured data files.
- Prepare RAG interfaces without coupling the UI to a specific model vendor.

## Phase 4: HarmonyOS Native Capabilities

- Add system intent invocation for schedule and reminder scenarios.
- Prototype cross-device task display for phone and tablet.
- Add permission and capability checks with graceful fallback.

## Phase 5: Competition Delivery

- Prepare a stable demo path.
- Write project abstract, innovation points, and architecture description.
- Add measurable evaluation metrics for intent accuracy, task completion, and personalization.
