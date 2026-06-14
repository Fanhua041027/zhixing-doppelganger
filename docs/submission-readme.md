# Zhixing Agent Submission Notes

## Project title

Zhixing Agent: Intent-driven HarmonyOS cross-device learning execution agent.

## Problem

Students often turn broad goals into scattered reminders, notes, and messages. Existing assistants answer questions, but they rarely turn intent into an executable workflow that stays visible across devices.

## Solution

Zhixing Agent recognizes a learning or contest goal, retrieves local personal context, creates task cards, assigns device roles, and exposes measurable execution signals. The first MVP is deterministic and local-first so the demo remains stable.

## Innovation points

- Intent-to-execution loop: the product shows intent recognition, task decomposition, and next action in one flow.
- Personal doppelganger data model: profile signals, memories, knowledge items, and conflict notes are structured from the start.
- RAG-ready architecture: knowledge retrieval and scoring are isolated in services, ready for rerank and model integration.
- HarmonyOS-oriented design: the task flow assigns phone, tablet, and wearable roles for later cross-device handoff.
- Evaluation built in: confidence, task coverage, and device roles are visible in the UI.

## Implemented MVP

- Main dashboard with goal input and execution plan generation.
- Task Board page for task progress and task cards.
- Profile page for personal signals, memories, knowledge, and conflict notes.
- Settings page for Agent controls and system capability placeholders.
- Service layer for Agent planning, local store, knowledge retrieval, system action preparation, and evaluation.

## Next build targets

- Replace in-memory `LocalStore` with HarmonyOS persistent storage.
- Connect real system calendar/reminder ability through Want or Intent Framework.
- Prototype phone-tablet state transfer and graceful fallback.
- Add real model/RAG API behind `AgentService` without changing page code.

## Demo path

1. Open the dashboard.
2. Enter `Prepare the HarmonyOS Agent innovation contest demo`.
3. Generate the plan.
4. Show intent, task flow, and evaluation metrics.
5. Open Profile to show the personal doppelganger data model.
6. Open Settings to show system capability and future HarmonyOS integration.
