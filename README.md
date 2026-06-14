# Zhixing Agent

Intent-driven HarmonyOS cross-device learning execution agent.

## Overview

Zhixing Agent turns a broad learning or contest goal into an executable plan. It detects the user's intent, retrieves local personal context, generates task cards, assigns device roles, and shows evaluation indicators that make the Agent's decisions explainable.

The project targets the Agent innovation direction of the HarmonyOS college innovation competition. The MVP is intentionally local-first and deterministic so the first demo is stable, while the architecture is ready for RAG, rerank, model APIs, and HarmonyOS system capability integration.

## Implemented Features

- Goal input and intent recognition.
- Execution plan generation with task cards.
- Cross-device role modeling for phone, tablet, and wearable.
- Personal profile signals, memories, knowledge items, and conflict notes.
- Evaluation metrics for confidence, task coverage, and device roles.
- Settings page with RAG, cross-device, and strict-context controls.
- System capability boundary for future calendar/reminder integration.

## Architecture

- `entry/src/main/ets/pages`: ArkUI pages.
- `entry/src/main/ets/models`: shared data models.
- `entry/src/main/ets/services`: Agent, evaluation, and system capability services.
- `entry/src/main/ets/repositories`: profile, knowledge, and local store repositories.
- `docs`: development plan, demo script, scoring map, and submission notes.

## Demo Flow

1. Open the dashboard.
2. Enter `Prepare the HarmonyOS Agent innovation contest demo`.
3. Generate the execution plan.
4. Show detected intent, confidence, task cards, and evaluation metrics.
5. Open Profile to show personal data and conflict notes.
6. Open Settings to show the system capability extension point.

## Development Environment

- DevEco Studio 26.0.0 Beta1.
- HarmonyOS application.
- Device types: Phone and Tablet.
- Language: ArkTS.

## Next Milestones

- Persist `LocalStore` with HarmonyOS local storage.
- Connect real calendar/reminder system invocation.
- Prototype phone-tablet task handoff.
- Add model-backed RAG behind `AgentService`.
