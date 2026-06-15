import { AgentPlan, AgentTask } from '../models/AgentModels';
import { PersistentStoreService } from './PersistentStoreService';

const TASK_STATUS_KEY: string = 'task_statuses';
const EXTRA_TASK_KEY: string = 'extra_tasks';

let extraTasks: AgentTask[] = [];

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

  static async addExtraTasks(tasks: AgentTask[]): Promise<AgentTask[]> {
    const currentTasks: AgentTask[] = TaskPersistenceService.getExtraTasks();
    const nextTasks: AgentTask[] = [];
    currentTasks.forEach((task: AgentTask) => {
      nextTasks.push(task);
    });
    tasks.forEach((task: AgentTask) => {
      if (!TaskPersistenceService.hasTask(nextTasks, task.id)) {
        nextTasks.push(task);
      }
    });
    extraTasks = nextTasks.slice(0, 12);
    await PersistentStoreService.putString(EXTRA_TASK_KEY, JSON.stringify(extraTasks));
    return extraTasks;
  }

  static getExtraTasks(): AgentTask[] {
    return extraTasks;
  }

  static async restoreExtraTasks(): Promise<AgentTask[]> {
    const taskText: string = await PersistentStoreService.getString(EXTRA_TASK_KEY, '');
    if (taskText.length === 0) {
      return extraTasks;
    }
    try {
      const parsed = JSON.parse(taskText) as AgentTask[];
      extraTasks = parsed;
      return extraTasks;
    } catch (error) {
      return extraTasks;
    }
  }

  static mergeExtraTasks(plan: AgentPlan): AgentPlan {
    const mergedTasks: AgentTask[] = [];
    plan.tasks.forEach((task: AgentTask) => {
      mergedTasks.push(task);
    });
    extraTasks.forEach((task: AgentTask) => {
      if (!TaskPersistenceService.hasTask(mergedTasks, task.id)) {
        mergedTasks.push(task);
      }
    });
    const nextPlan: AgentPlan = {
      goal: plan.goal,
      intent: plan.intent,
      confidence: plan.confidence,
      suggestion: plan.suggestion,
      tasks: mergedTasks,
      systemAction: plan.systemAction
    };
    return nextPlan;
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

  private static hasTask(tasks: AgentTask[], taskId: string): boolean {
    let matched: boolean = false;
    tasks.forEach((task: AgentTask) => {
      if (task.id === taskId) {
        matched = true;
      }
    });
    return matched;
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
