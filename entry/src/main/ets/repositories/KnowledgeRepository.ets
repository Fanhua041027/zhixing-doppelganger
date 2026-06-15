import { ConflictNote, KnowledgeItem } from '../models/AgentModels';
import { LocalStore } from './LocalStore';

export class KnowledgeRepository {
  static getKnowledgeItems(): KnowledgeItem[] {
    const items: KnowledgeItem[] = [
      {
        id: 'knowledge-mvp',
        title: '最小闭环原则',
        content: '第一版演示必须完整展示从目标输入到意图识别、再到任务执行的路径。',
        tags: ['最小闭环', '智能体', '演示']
      },
      {
        id: 'knowledge-harmony',
        title: '鸿蒙特色得分点',
        content: '跨设备价值不是复制同一界面，而是让不同设备在同一流程中承担不同角色。',
        tags: ['鸿蒙', '跨设备']
      },
      {
        id: 'knowledge-rag',
        title: '检索增强约束',
        content: '涉及个人事实时，回答应基于检索到的个人上下文，避免凭空编造。',
        tags: ['检索', '约束']
      }
    ];
    LocalStore.saveKnowledge(items);
    return items;
  }

  static getConflictNotes(): ConflictNote[] {
    const items: ConflictNote[] = [
      {
        id: 'conflict-speed-quality',
        topic: '速度与打磨',
        leftClaim: '先快速完成一个可见演示。',
        rightClaim: '也要给界面质量和稳定展示留出时间。',
        handling: '先做确定性最小闭环，再打磨最影响评审感知的界面。'
      }
    ];
    LocalStore.saveConflicts(items);
    return items;
  }
}
