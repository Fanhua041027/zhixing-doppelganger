import { AgentTask, NextStepSuggestion, ReflectionItem } from '../models/AgentModels';
import { ExecutionService } from './ExecutionService';

export class NextStepService {
  static getSuggestions(): NextStepSuggestion[] {
    const reflections: ReflectionItem[] = ExecutionService.getReflections();
    const firstReflection: ReflectionItem = reflections[0];
    const suggestions: NextStepSuggestion[] = [
      {
        id: 'next-clarify',
        title: '补齐验收标准',
        detail: '把当前目标拆成“能被看到、能被讲清、能被复现”的三个验收点。',
        reason: firstReflection.insight
      },
      {
        id: 'next-material',
        title: '补充关键资料',
        detail: '进入资料库导入一段支撑当前目标的资料，再让对话页引用它。',
        reason: '复盘后需要把经验变成可检索依据。'
      },
      {
        id: 'next-rehearse',
        title: '进行一次演示彩排',
        detail: '按首页、资料、对话、任务、画像、评审的顺序走一遍。',
        reason: '稳定的执行路径比功能数量更重要。'
      }
    ];
    return suggestions;
  }

  static createTaskFromSuggestion(item: NextStepSuggestion): AgentTask {
    const task: AgentTask = {
      id: `next-task-${item.id}`,
      title: item.title,
      detail: item.detail,
      device: '手机',
      time: '下一步',
      status: '待执行',
      priority: '重要'
    };
    return task;
  }
}
