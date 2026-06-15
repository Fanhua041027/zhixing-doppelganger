import { AgentPlan, AgentTask, KnowledgeHit, KnowledgeItem } from '../models/AgentModels';
import { LocalStore } from '../repositories/LocalStore';
import { KnowledgeRepository } from '../repositories/KnowledgeRepository';
import { TaskHistoryService } from './TaskHistoryService';

export class AgentService {
  static createPlan(goal: string): AgentPlan {
    const normalizedGoal = goal.trim().length > 0 ? goal.trim() : '完成鸿蒙智能体竞赛演示';
    const intent = AgentService.inferIntent(normalizedGoal);
    const hits = AgentService.retrieveKnowledge(normalizedGoal);

    const plan: AgentPlan = {
      goal: normalizedGoal,
      intent,
      confidence: normalizedGoal.length > 12 ? 92 : 78,
      suggestion: AgentService.createSuggestion(intent, hits),
      tasks: AgentService.createTasks(normalizedGoal, intent),
      systemAction: AgentService.selectSystemAction(intent)
    };
    LocalStore.savePlan(plan);
    LocalStore.saveKnowledge(KnowledgeRepository.getKnowledgeItems());
    TaskHistoryService.recordPlan(plan);
    return plan;
  }

  private static inferIntent(goal: string): string {
    const lowerGoal = goal.toLowerCase();
    if (lowerGoal.includes('contest') || lowerGoal.includes('competition') || lowerGoal.includes('demo') ||
      goal.includes('比赛') || goal.includes('竞赛') || goal.includes('演示')) {
      return '竞赛执行规划';
    }
    if (lowerGoal.includes('exam') || lowerGoal.includes('review') || goal.includes('考试') || goal.includes('复习')) {
      return '复习调度';
    }
    if (lowerGoal.includes('paper') || lowerGoal.includes('reading') || lowerGoal.includes('research') ||
      goal.includes('论文') || goal.includes('文献') || goal.includes('资料')) {
      return '资料研读整理';
    }
    return '学习执行规划';
  }

  private static createTasks(goal: string, intent: string): AgentTask[] {
    const tasks: AgentTask[] = [
      {
        id: 'task-define',
        title: '明确交付结果',
        detail: `围绕“${goal}”确认验收标准，保证演示路径聚焦稳定。`,
        device: '手机',
        time: '立即',
        status: '进行中',
        priority: '最高'
      },
      {
        id: 'task-plan',
        title: '生成执行卡片',
        detail: `把“${intent}”拆成任务、检查点和兜底步骤。`,
        device: '平板',
        time: '30 分钟后',
        status: '待执行',
        priority: '最高'
      },
      {
        id: 'task-review',
        title: '安排复盘提醒',
        detail: '任务完成后触发复盘，并把结果沉淀到个人画像。',
        device: '穿戴设备',
        time: '今晚',
        status: '待同步',
        priority: '重要'
      }
    ];
    return tasks;
  }

  private static retrieveKnowledge(goal: string): KnowledgeHit[] {
    const lowerGoal = goal.toLowerCase();
    const items = KnowledgeRepository.getKnowledgeItems();
    const hits: KnowledgeHit[] = items.map((item: KnowledgeItem): KnowledgeHit => {
      const hit: KnowledgeHit = {
        title: item.title,
        excerpt: item.content,
        score: AgentService.scoreKnowledge(lowerGoal, item)
      };
      return hit;
    });
    return hits.sort((left: KnowledgeHit, right: KnowledgeHit) => right.score - left.score).slice(0, 3);
  }

  private static createSuggestion(intent: string, hits: KnowledgeHit[]): string {
    const strongestHit = hits.length > 0 ? hits[0].excerpt : '保持执行路径清晰、可见、可衡量。';
    return `${intent}: ${strongestHit}`;
  }

  private static selectSystemAction(intent: string): string {
    if (intent === '竞赛执行规划') {
      return '日程草稿 + 复盘提醒';
    }
    if (intent === '复习调度') {
      return '复习提醒';
    }
    return '任务流转';
  }

  private static scoreKnowledge(goal: string, item: KnowledgeItem): number {
    let score = 0.62;
    item.tags.forEach((tag: string) => {
      if (goal.includes(tag)) {
        score += 0.12;
      }
    });
    if (goal.includes('contest') || goal.includes('demo')) {
      score += item.tags.includes('demo') ? 0.15 : 0.04;
    }
    return Math.min(score, 0.95);
  }
}
