import { AgentPlan, AgentTask } from '../models/AgentModels';

export interface EvaluationMetric {
  label: string;
  value: string;
  detail: string;
}

export class EvaluationService {
  static evaluatePlan(plan: AgentPlan): EvaluationMetric[] {
    const metrics: EvaluationMetric[] = [
      {
        label: '意图置信度',
        value: `${plan.confidence}%`,
        detail: '当前为规则版基线，后续可接入模型增强。'
      },
      {
        label: '任务覆盖',
        value: `${plan.tasks.length} 张卡片`,
        detail: '目标、执行、复盘三个阶段都可见。'
      },
      {
        label: '设备角色',
        value: EvaluationService.countDevices(plan).toString(),
        detail: '手机、平板、穿戴设备承担不同任务角色。'
      },
      {
        label: '推进状态',
        value: `${EvaluationService.countActiveTasks(plan)} 项`,
        detail: '已完成或进行中的任务会进入复盘沉淀。'
      }
    ];
    return metrics;
  }

  private static countDevices(plan: AgentPlan): number {
    const devices: string[] = [];
    plan.tasks.forEach((task: AgentTask) => {
      if (!devices.includes(task.device)) {
        devices.push(task.device);
      }
    });
    return devices.length;
  }

  private static countActiveTasks(plan: AgentPlan): number {
    let count: number = 0;
    plan.tasks.forEach((task: AgentTask) => {
      if (task.status === '已完成' || task.status === '进行中') {
        count += 1;
      }
    });
    return count;
  }
}
