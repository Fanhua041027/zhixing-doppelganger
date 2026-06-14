import { ConflictNote, KnowledgeItem } from '../models/AgentModels';
import { LocalStore } from './LocalStore';

export class KnowledgeRepository {
  static getKnowledgeItems(): KnowledgeItem[] {
    const items: KnowledgeItem[] = [
      {
        id: 'knowledge-mvp',
        title: 'MVP execution rule',
        content: 'The first demo must show the full path from goal input to intent recognition and task execution.',
        tags: ['mvp', 'agent', 'demo']
      },
      {
        id: 'knowledge-harmony',
        title: 'HarmonyOS scoring signal',
        content: 'Cross-device value is strongest when different devices play different roles in the same workflow.',
        tags: ['harmonyos', 'cross-device']
      },
      {
        id: 'knowledge-rag',
        title: 'RAG guardrail',
        content: 'Answers should cite retrieved personal context when the user asks for factual personal information.',
        tags: ['rag', 'guardrail']
      }
    ];
    LocalStore.saveKnowledge(items);
    return items;
  }

  static getConflictNotes(): ConflictNote[] {
    const items: ConflictNote[] = [
      {
        id: 'conflict-speed-quality',
        topic: 'Speed versus polish',
        leftClaim: 'Move fast to complete a visible demo.',
        rightClaim: 'Leave enough time for UI quality and stable presentation.',
        handling: 'Use deterministic MVP first, then improve the highest impact surfaces.'
      }
    ];
    LocalStore.saveConflicts(items);
    return items;
  }
}
