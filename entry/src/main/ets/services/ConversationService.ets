import { ChatMessage, ChatTurnResult, KnowledgeHit, KnowledgeItem } from '../models/AgentModels';
import { KnowledgeRepository } from '../repositories/KnowledgeRepository';

export class ConversationService {
  static startConversation(): ChatTurnResult {
    const messages: ChatMessage[] = [
      {
        id: 'msg-user-001',
        role: 'User',
        content: 'I need a stable demo path for the HarmonyOS Agent competition.'
      },
      {
        id: 'msg-agent-001',
        role: 'Zhixing',
        content: 'I will keep the demo narrow: goal input, intent detection, task cards, profile evidence, and system capability handoff.'
      }
    ];
    const result: ChatTurnResult = {
      messages,
      evidence: ConversationService.retrieveEvidence('competition demo'),
      nextAction: 'Open Task Board and verify every task has a device role.'
    };
    return result;
  }

  static reply(input: string): ChatTurnResult {
    const normalizedInput: string = input.trim().length > 0 ? input.trim() : 'Help me improve the contest demo.';
    const evidence: KnowledgeHit[] = ConversationService.retrieveEvidence(normalizedInput);
    const messages: ChatMessage[] = [
      {
        id: 'msg-user-live',
        role: 'User',
        content: normalizedInput
      },
      {
        id: 'msg-agent-live',
        role: 'Zhixing',
        content: ConversationService.composeReply(normalizedInput, evidence)
      }
    ];
    const result: ChatTurnResult = {
      messages,
      evidence,
      nextAction: ConversationService.selectNextAction(normalizedInput)
    };
    return result;
  }

  private static retrieveEvidence(input: string): KnowledgeHit[] {
    const lowerInput: string = input.toLowerCase();
    const items: KnowledgeItem[] = KnowledgeRepository.getKnowledgeItems();
    const hits: KnowledgeHit[] = items.map((item: KnowledgeItem): KnowledgeHit => {
      const hit: KnowledgeHit = {
        title: item.title,
        excerpt: item.content,
        score: ConversationService.scoreItem(lowerInput, item)
      };
      return hit;
    });
    return hits.sort((left: KnowledgeHit, right: KnowledgeHit): number => right.score - left.score).slice(0, 2);
  }

  private static composeReply(input: string, evidence: KnowledgeHit[]): string {
    const strongestEvidence: string = evidence.length > 0 ? evidence[0].excerpt : 'Keep every Agent decision visible.';
    if (input.toLowerCase().includes('risk')) {
      return `Risk-first answer: keep the main demo deterministic. Evidence: ${strongestEvidence}`;
    }
    if (input.toLowerCase().includes('ui')) {
      return `UI answer: make the execution flow visible before adding decoration. Evidence: ${strongestEvidence}`;
    }
    return `Execution answer: turn the request into one visible next step. Evidence: ${strongestEvidence}`;
  }

  private static selectNextAction(input: string): string {
    const lowerInput: string = input.toLowerCase();
    if (lowerInput.includes('profile')) {
      return 'Open Profile and check signals, memories, knowledge, and conflict notes.';
    }
    if (lowerInput.includes('task') || lowerInput.includes('demo')) {
      return 'Open Task Board and confirm the demo path.';
    }
    return 'Generate a fresh execution plan on the dashboard.';
  }

  private static scoreItem(input: string, item: KnowledgeItem): number {
    let score: number = 0.55;
    item.tags.forEach((tag: string) => {
      if (input.includes(tag)) {
        score += 0.16;
      }
    });
    if (input.includes('competition') || input.includes('demo')) {
      score += item.tags.includes('demo') ? 0.18 : 0.05;
    }
    return Math.min(score, 0.96);
  }
}
