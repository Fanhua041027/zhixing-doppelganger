import { AgentPlan, AgentTask, TaskHistoryItem } from '../models/AgentModels';
import { LocalStore } from '../repositories/LocalStore';

export class TaskHistoryService {
  static recordPlan(plan: AgentPlan): void {
    const historySize: number = LocalStore.getHistory().length + 1;
    const item: TaskHistoryItem = {
      id: `history-${historySize}-${plan.goal.length}-${plan.tasks.length}-${plan.confidence}`,
      goal: plan.goal,
      intent: plan.intent,
      taskCount: plan.tasks.length,
      deviceCount: TaskHistoryService.countDevices(plan.tasks),
      createdAt: '刚刚'
    };
    LocalStore.addHistory(item);
  }

  static getHistory(): TaskHistoryItem[] {
    const history: TaskHistoryItem[] = LocalStore.getHistory();
    if (history.length > 0) {
      return history;
    }
    const fallback: TaskHistoryItem[] = [
      {
        id: 'history-demo',
        goal: '准备第一版稳定竞赛演示',
        intent: '竞赛执行规划',
        taskCount: 3,
        deviceCount: 3,
        createdAt: '演示数据'
      }
    ];
    return fallback;
  }

  private static countDevices(tasks: AgentTask[]): number {
    const devices: string[] = [];
    tasks.forEach((task: AgentTask) => {
      if (!devices.includes(task.device)) {
        devices.push(task.device);
      }
    });
    return devices.length;
  }
}
