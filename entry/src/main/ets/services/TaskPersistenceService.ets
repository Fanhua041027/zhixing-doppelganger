import { AgentPlan, AgentTask } from '../models/AgentModels';
import { PersistentStoreService } from './PersistentStoreService';

const TASK_STATUS_KEY: string = 'task_statuses';

export class TaskPersistenceService {
  static markTaskDone(plan: AgentPlan, taskId: string): AgentPlan {
    const nextTasks: AgentTask[] = plan.tasks.map((task: AgentTask): AgentTask => {
      const nextTask: AgentTask = {
        id: task.id,
        title: task.title,
        detail: task.detail,
        device: task.device,
        time: task.time,
        status: task.id === taskId ? '已完成' : task.status,
        priority: task.priority
      };
      return nextTask;
    });
    const nextPlan: AgentPlan = {
      goal: plan.goal,
      intent: plan.intent,
      confidence: plan.confidence,
      suggestion: plan.suggestion,
      tasks: nextTasks,
      systemAction: plan.systemAction
    };
    TaskPersistenceService.saveTaskStatuses(nextPlan);
    return nextPlan;
  }

  static saveTaskStatuses(plan: AgentPlan): void {
    const parts: string[] = [];
    plan.tasks.forEach((task: AgentTask) => {
      parts.push(`${task.id}=${task.status}`);
    });
    PersistentStoreService.putString(TASK_STATUS_KEY, parts.join('|'));
  }

  static async restoreTaskStatuses(plan: AgentPlan): Promise<AgentPlan> {
    const statusText: string = await PersistentStoreService.getString(TASK_STATUS_KEY, '');
    if (statusText.length === 0) {
      return plan;
    }
    const nextTasks: AgentTask[] = plan.tasks.map((task: AgentTask): AgentTask => {
      const nextTask: AgentTask = {
        id: task.id,
        title: task.title,
        detail: task.detail,
        device: task.device,
        time: task.time,
        status: TaskPersistenceService.findStatus(statusText, task),
        priority: task.priority
      };
      return nextTask;
    });
    const nextPlan: AgentPlan = {
      goal: plan.goal,
      intent: plan.intent,
      confidence: plan.confidence,
      suggestion: '已从本地恢复任务状态。',
      tasks: nextTasks,
      systemAction: plan.systemAction
    };
    return nextPlan;
  }

  private static findStatus(statusText: string, task: AgentTask): string {
    const parts: string[] = statusText.split('|');
    let status: string = task.status;
    parts.forEach((part: string) => {
      const pair: string[] = part.split('=');
      if (pair.length === 2 && pair[0] === task.id) {
        status = pair[1];
      }
    });
    return status;
  }
}
