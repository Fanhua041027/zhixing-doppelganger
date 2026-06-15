import { AgentPlan, AgentTask, ConflictNote, ImportedResource, KnowledgeItem, MemoryItem, ProfileSignal, ReflectionItem, StudyPlanConfig, TaskHistoryItem } from '../models/AgentModels';

let currentPlan: AgentPlan | null = null;
let currentTasks: AgentTask[] = [];
let currentSignals: ProfileSignal[] = [];
let currentMemories: MemoryItem[] = [];
let currentKnowledge: KnowledgeItem[] = [];
let currentConflicts: ConflictNote[] = [];
let currentHistory: TaskHistoryItem[] = [];
let currentReflections: ReflectionItem[] = [];
let currentConfig: StudyPlanConfig | null = null;
let currentResources: ImportedResource[] = [];

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

  static addHistory(item: TaskHistoryItem): void {
    const nextHistory: TaskHistoryItem[] = [item];
    currentHistory.forEach((historyItem: TaskHistoryItem) => {
      if (historyItem.goal !== item.goal || historyItem.intent !== item.intent) {
        nextHistory.push(historyItem);
      }
    });
    currentHistory = nextHistory.slice(0, 5);
  }

  static getHistory(): TaskHistoryItem[] {
    return currentHistory;
  }

  static addReflection(item: ReflectionItem): void {
    const nextReflections: ReflectionItem[] = [item];
    currentReflections.forEach((reflection: ReflectionItem) => {
      if (reflection.title !== item.title || reflection.insight !== item.insight) {
        nextReflections.push(reflection);
      }
    });
    currentReflections = nextReflections.slice(0, 5);
  }

  static getReflections(): ReflectionItem[] {
    return currentReflections;
  }

  static saveStudyConfig(config: StudyPlanConfig): void {
    currentConfig = config;
  }

  static getStudyConfig(): StudyPlanConfig | null {
    return currentConfig;
  }

  static saveResources(items: ImportedResource[]): void {
    currentResources = items;
  }

  static getResources(): ImportedResource[] {
    return currentResources;
  }
}
