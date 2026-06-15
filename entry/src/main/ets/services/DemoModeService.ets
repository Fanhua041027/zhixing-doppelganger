import { DemoModeState } from '../models/AgentModels';

export class DemoModeService {
  static getDefaultState(): DemoModeState {
    const state: DemoModeState = {
      title: '竞赛演示模式',
      goal: '三天内完成鸿蒙智能体竞赛演示',
      script: '首页生成计划，进入对话页展示依据，再到任务页、画像页和评审页完成答辩闭环。',
      enabled: true
    };
    return state;
  }

  static disable(): DemoModeState {
    const state: DemoModeState = {
      title: '普通使用模式',
      goal: '输入任意学习目标',
      script: '根据用户输入生成执行计划，不强制使用竞赛演示路径。',
      enabled: false
    };
    return state;
  }
}
