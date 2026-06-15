import { AgentTask, DeviceFlowStep } from '../models/AgentModels';

export class DeviceFlowService {
  static getDefaultFlow(): DeviceFlowStep[] {
    const steps: DeviceFlowStep[] = [
      {
        id: 'flow-phone',
        device: '手机',
        role: '输入目标与即时确认',
        handoff: '把学习目标转成第一张执行卡片',
        status: '当前端'
      },
      {
        id: 'flow-tablet',
        device: '平板',
        role: '展开计划与资料阅读',
        handoff: '承接任务拆解、依据查看和答辩材料整理',
        status: '协同端'
      },
      {
        id: 'flow-watch',
        device: '穿戴设备',
        role: '提醒与轻量反馈',
        handoff: '接收复盘提醒，并把完成状态同步回任务流',
        status: '提醒端'
      }
    ];
    return steps;
  }

  static createFlowFromTasks(tasks: AgentTask[]): DeviceFlowStep[] {
    const steps: DeviceFlowStep[] = [];
    tasks.forEach((task: AgentTask) => {
      if (!DeviceFlowService.hasDevice(steps, task.device)) {
        const step: DeviceFlowStep = {
          id: `flow-${task.id}`,
          device: task.device,
          role: DeviceFlowService.roleForDevice(task.device),
          handoff: task.detail,
          status: task.status
        };
        steps.push(step);
      }
    });
    if (steps.length > 0) {
      return steps;
    }
    return DeviceFlowService.getDefaultFlow();
  }

  private static hasDevice(steps: DeviceFlowStep[], device: string): boolean {
    let matched: boolean = false;
    steps.forEach((step: DeviceFlowStep) => {
      if (step.device === device) {
        matched = true;
      }
    });
    return matched;
  }

  private static roleForDevice(device: string): string {
    if (device === '手机') {
      return '输入目标与即时确认';
    }
    if (device === '平板') {
      return '展开计划与资料阅读';
    }
    if (device === '穿戴设备') {
      return '提醒与轻量反馈';
    }
    return '执行协同';
  }
}
