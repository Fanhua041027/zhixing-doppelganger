import { AgentPlan, StudyPlanConfig, StudyPreference, TodayAction } from '../models/AgentModels';
import { LocalStore } from '../repositories/LocalStore';
import { AgentService } from './AgentService';

export class StudyPlanService {
  static getDefaultConfig(): StudyPlanConfig {
    const config: StudyPlanConfig = {
      goal: '三天内完成鸿蒙智能体竞赛演示',
      deadline: '三天后',
      dailyMinutes: '90',
      weakPoint: '担心现场演示不稳定',
      preferredDevice: '手机和平板'
    };
    return config;
  }

  static saveConfig(config: StudyPlanConfig): AgentPlan {
    LocalStore.saveStudyConfig(config);
    const plan: AgentPlan = AgentService.createPlan(StudyPlanService.composeGoal(config));
    return plan;
  }

  static createPlanFromConfig(): AgentPlan {
    const config: StudyPlanConfig = StudyPlanService.getConfig();
    const plan: AgentPlan = AgentService.createPlan(StudyPlanService.composeGoal(config));
    return plan;
  }

  static getConfiguredGoal(): string {
    const config: StudyPlanConfig = StudyPlanService.getConfig();
    return StudyPlanService.composeGoal(config);
  }

  static getPreferences(): StudyPreference[] {
    const config: StudyPlanConfig = StudyPlanService.getConfig();
    const items: StudyPreference[] = [
      { id: 'preference-deadline', label: '截止时间', value: config.deadline },
      { id: 'preference-daily', label: '每日时间', value: `${config.dailyMinutes} 分钟` },
      { id: 'preference-weak', label: '当前难点', value: config.weakPoint },
      { id: 'preference-device', label: '偏好设备', value: config.preferredDevice }
    ];
    return items;
  }

  static getTodayActions(plan: AgentPlan): TodayAction[] {
    const config: StudyPlanConfig = StudyPlanService.getConfig();
    const actions: TodayAction[] = [
      {
        id: 'today-focus',
        timeBox: '25 分钟',
        title: '确认今日最小成果',
        detail: `围绕“${plan.goal}”只保留一个必须完成的输出。`,
        output: '一张可验收任务卡'
      },
      {
        id: 'today-deep',
        timeBox: `${config.dailyMinutes} 分钟`,
        title: '推进核心任务',
        detail: `优先处理难点：${config.weakPoint}。`,
        output: '可演示的功能片段'
      },
      {
        id: 'today-review',
        timeBox: '10 分钟',
        title: '完成复盘沉淀',
        detail: `在${config.preferredDevice}上记录完成情况和下一步。`,
        output: '一条画像复盘'
      }
    ];
    return actions;
  }

  private static getConfig(): StudyPlanConfig {
    const config = LocalStore.getStudyConfig();
    if (config !== null) {
      return config;
    }
    return StudyPlanService.getDefaultConfig();
  }

  private static composeGoal(config: StudyPlanConfig): string {
    return `${config.deadline}完成${config.goal}，每天投入${config.dailyMinutes}分钟，重点解决${config.weakPoint}`;
  }
}
