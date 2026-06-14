import { AgentPlan } from '../models/AgentModels';

export interface EvaluationMetric {
  label: string;
  value: string;
  detail: string;
}

export class EvaluationService {
  static evaluatePlan(plan: AgentPlan): EvaluationMetric[] {
    const metrics: EvaluationMetric[] = [
      {
        label: 'Intent confidence',
        value: `${plan.confidence}%`,
        detail: 'Rule-based baseline before model integration.'
      },
      {
        label: 'Task coverage',
        value: `${plan.tasks.length} cards`,
        detail: 'Goal, execution, and review stages are all visible.'
      },
      {
        label: 'Device roles',
        value: EvaluationService.countDevices(plan).toString(),
        detail: 'Phone, tablet, and wearable are separated by workflow role.'
      }
    ];
    return metrics;
  }

  private static countDevices(plan: AgentPlan): number {
    const devices: string[] = [];
    plan.tasks.forEach((task) => {
      if (!devices.includes(task.device)) {
        devices.push(task.device);
      }
    });
    return devices.length;
  }
}
