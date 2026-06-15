import { GoalTemplate } from '../models/AgentModels';

export class GoalTemplateService {
  static getTemplates(): GoalTemplate[] {
    const templates: GoalTemplate[] = [
      {
        id: 'template-contest',
        title: '竞赛冲刺',
        goal: '三天内完成鸿蒙智能体竞赛演示',
        scenario: '适合答辩现场展示完整闭环。'
      },
      {
        id: 'template-exam',
        title: '考试复习',
        goal: '两周内完成操作系统课程复习并形成错题复盘',
        scenario: '展示学习计划、提醒和复盘价值。'
      },
      {
        id: 'template-reading',
        title: '资料研读',
        goal: '本周读完三篇智能体论文并整理成汇报卡片',
        scenario: '展示资料研读、知识检索和任务拆解。'
      }
    ];
    return templates;
  }
}
