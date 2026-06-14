import { AgentPlan, AgentTask, ConflictNote, KnowledgeItem, MemoryItem, ProfileSignal } from '../models/AgentModels';

let currentPlan: AgentPlan | null = null;
let currentTasks: AgentTask[] = [];
let currentSignals: ProfileSignal[] = [];
let currentMemories: MemoryItem[] = [];
let currentKnowledge: KnowledgeItem[] = [];
let currentConflicts: ConflictNote[] = [];

export class LocalStore {
  static savePlan(plan: AgentPlan): void {
    currentPlan = plan;
    currentTasks = plan.tasks;
  }

  static getPlan(): AgentPlan | null {
    return currentPlan;
  }

  static getTasks(): AgentTask[] {
    return currentTasks;
  }

  static saveSignals(signals: ProfileSignal[]): void {
    currentSignals = signals;
  }

  static getSignals(): ProfileSignal[] {
    return currentSignals;
  }

  static saveMemories(memories: MemoryItem[]): void {
    currentMemories = memories;
  }

  static getMemories(): MemoryItem[] {
    return currentMemories;
  }

  static saveKnowledge(items: KnowledgeItem[]): void {
    currentKnowledge = items;
  }

  static getKnowledge(): KnowledgeItem[] {
    return currentKnowledge;
  }

  static saveConflicts(items: ConflictNote[]): void {
    currentConflicts = items;
  }

  static getConflicts(): ConflictNote[] {
    return currentConflicts;
  }
}
