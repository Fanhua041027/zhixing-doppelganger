import { AgentPlan, AgentTask, ConflictNote, KnowledgeItem, MemoryItem, ProfileSignal } from '../models/AgentModels';

export class LocalStore {
  private static plan: AgentPlan | null = null;
  private static tasks: AgentTask[] = [];
  private static signals: ProfileSignal[] = [];
  private static memories: MemoryItem[] = [];
  private static knowledge: KnowledgeItem[] = [];
  private static conflicts: ConflictNote[] = [];

  static savePlan(plan: AgentPlan): void {
    this.plan = plan;
    this.tasks = plan.tasks;
  }

  static getPlan(): AgentPlan | null {
    return this.plan;
  }

  static getTasks(): AgentTask[] {
    return this.tasks;
  }

  static saveSignals(signals: ProfileSignal[]): void {
    this.signals = signals;
  }

  static getSignals(): ProfileSignal[] {
    return this.signals;
  }

  static saveMemories(memories: MemoryItem[]): void {
    this.memories = memories;
  }

  static getMemories(): MemoryItem[] {
    return this.memories;
  }

  static saveKnowledge(items: KnowledgeItem[]): void {
    this.knowledge = items;
  }

  static getKnowledge(): KnowledgeItem[] {
    return this.knowledge;
  }

  static saveConflicts(items: ConflictNote[]): void {
    this.conflicts = items;
  }

  static getConflicts(): ConflictNote[] {
    return this.conflicts;
  }
}
