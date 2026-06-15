import { MemoryItem, ProfileSignal } from '../models/AgentModels';
import { LocalStore } from './LocalStore';

export class ProfileRepository {
  static getProfileSignals(): ProfileSignal[] {
    const signals: ProfileSignal[] = [
      { label: '执行风格', value: '先跑通闭环，再打磨体验。' },
      { label: '学习方式', value: '任务卡片、时间盒、短复盘。' },
      { label: '风险控制', value: '主演示不依赖不稳定接口。' },
      { label: '决策规则', value: '优先可见进展，避免范围过散。' }
    ];
    LocalStore.saveSignals(signals);
    return signals;
  }

  static getMemories(): MemoryItem[] {
    const memories: MemoryItem[] = [
      {
        id: 'memory-001',
        title: '竞赛策略',
        content: '作品应在第一分钟展示智能体执行能力和鸿蒙跨设备价值。',
        source: '规划'
      },
      {
        id: 'memory-002',
        title: '最小版本边界',
        content: '先使用确定性的意图识别，把模型接入隔离在服务层之后。',
        source: '架构'
      }
    ];
    LocalStore.saveMemories(memories);
    return memories;
  }
}
