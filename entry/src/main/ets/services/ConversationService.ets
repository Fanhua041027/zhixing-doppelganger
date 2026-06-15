import { ChatMessage, ChatTurnResult, KnowledgeHit, KnowledgeItem } from '../models/AgentModels';
import { KnowledgeRepository } from '../repositories/KnowledgeRepository';

export class ConversationService {
  static startConversation(): ChatTurnResult {
    const messages: ChatMessage[] = [
      {
        id: 'msg-user-001',
        role: '用户',
        content: '我需要一个稳定的鸿蒙智能体竞赛演示路径。'
      },
      {
        id: 'msg-agent-001',
        role: '知行',
        content: '我会收窄演示路径：目标输入、意图识别、任务卡片、画像依据和系统能力流转。'
      }
    ];
    const result: ChatTurnResult = {
      messages,
      evidence: ConversationService.retrieveEvidence('竞赛演示'),
      nextAction: '打开任务看板，确认每个任务都有明确设备角色。'
    };
    return result;
  }

  static reply(input: string): ChatTurnResult {
    const normalizedInput: string = input.trim().length > 0 ? input.trim() : '帮我优化竞赛演示。';
    const evidence: KnowledgeHit[] = ConversationService.retrieveEvidence(normalizedInput);
    const messages: ChatMessage[] = [
      {
        id: 'msg-user-live',
        role: '用户',
        content: normalizedInput
      },
      {
        id: 'msg-agent-live',
        role: '知行',
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
    const strongestEvidence: string = evidence.length > 0 ? evidence[0].excerpt : '让每个智能体决策都可见。';
    if (input.toLowerCase().includes('risk') || input.includes('风险')) {
      return `风险优先建议：主演示保持确定性，不把成败押在不稳定接口上。依据：${strongestEvidence}`;
    }
    if (input.includes('进度') || input.includes('执行')) {
      return `执行建议：先推进最高优先级任务，再把完成状态同步到画像复盘。依据：${strongestEvidence}`;
    }
    if (input.includes('设备') || input.includes('流转')) {
      return `设备建议：手机负责即时确认，平板负责展开计划，穿戴设备负责提醒反馈。依据：${strongestEvidence}`;
    }
    if (input.includes('复盘') || input.includes('沉淀')) {
      return `复盘建议：每次推进后记录一条洞察，说明分身如何从执行中学习。依据：${strongestEvidence}`;
    }
    if (input.toLowerCase().includes('ui') || input.includes('界面')) {
      return `界面建议：先让执行流清晰可见，再增加视觉装饰。依据：${strongestEvidence}`;
    }
    return `执行建议：把请求转成一个可见的下一步动作。依据：${strongestEvidence}`;
  }

  private static selectNextAction(input: string): string {
    const lowerInput: string = input.toLowerCase();
    if (lowerInput.includes('profile') || input.includes('画像') || input.includes('复盘')) {
      return '打开画像页，检查信号、记忆、知识和冲突记录。';
    }
    if (lowerInput.includes('task') || lowerInput.includes('demo') || input.includes('任务') || input.includes('演示') ||
      input.includes('进度') || input.includes('执行')) {
      return '打开任务看板，确认演示路径。';
    }
    return '回到首页生成新的执行计划。';
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
