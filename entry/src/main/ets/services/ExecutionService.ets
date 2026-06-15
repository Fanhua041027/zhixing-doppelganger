import { AgentPlan, AgentTask, ExecutionSnapshot, ReflectionItem } from '../models/AgentModels';
import { LocalStore } from '../repositories/LocalStore';
import { TaskPersistenceService } from './TaskPersistenceService';

export class ExecutionService {
  static getInitialSnapshot(plan: AgentPlan): ExecutionSnapshot {
    const snapshot: ExecutionSnapshot = {
      progress: 42,
      stage: '计划已生成',
      summary: `已围绕“${plan.goal}”生成任务卡片，等待推进执行。`,
      nextStep: '先完成目标确认，再同步到平板展开资料。'
    };
    return snapshot;
  }

  static advancePlan(plan: AgentPlan): AgentPlan {
    const nextTasks: AgentTask[] = plan.tasks.map((task: AgentTask, index: number): AgentTask => {
      const nextTask: AgentTask = {
        id: task.id,
        title: task.title,
        detail: task.detail,
        device: task.device,
        time: task.time,
        status: ExecutionService.nextStatus(task.status, index),
        priority: task.priority
      };
      return nextTask;
    });
    const nextPlan: AgentPlan = {
      goal: plan.goal,
      intent: plan.intent,
      confidence: plan.confidence,
      suggestion: '执行推进后，知行会把完成情况沉淀为复盘洞察，并更新下一步行动。',
      tasks: nextTasks,
      systemAction: plan.systemAction
    };
    LocalStore.savePlan(nextPlan);
    TaskPersistenceService.saveTaskStatuses(nextPlan);
    ExecutionService.recordReflection(nextPlan);
    return nextPlan;
  }

  static createSnapshot(plan: AgentPlan): ExecutionSnapshot {
    const doneCount: number = ExecutionService.countDone(plan.tasks);
    const progress: number = Math.min(42 + doneCount * 18, 96);
    const allDone: boolean = doneCount >= plan.tasks.length;
    const snapshot: ExecutionSnapshot = {
      progress: allDone ? 100 : progress,
      stage: allDone ? '闭环已完成' : '执行已推进',
      summary: allDone ? '任务已经完成一轮闭环，复盘洞察已沉淀到个人画像。' :
        `${doneCount} 个任务已进入完成或同步状态，当前重点是保持演示链路稳定。`,
      nextStep: allDone ? '进入画像页查看分身如何沉淀经验。' :
        doneCount >= 2 ? '进入画像页查看复盘沉淀。' : '继续推进任务并检查设备分工。'
    };
    return snapshot;
  }

  static getReflections(): ReflectionItem[] {
    const reflections: ReflectionItem[] = LocalStore.getReflections();
    if (reflections.length > 0) {
      return reflections;
    }
    const fallback: ReflectionItem[] = [
      {
        id: 'reflection-demo',
        title: '演示节奏复盘',
        insight: '稳定演示比一次性展示所有扩展能力更重要。',
        action: '答辩时先跑主链路，再解释可扩展接口。',
        createdAt: '演示数据'
      }
    ];
    return fallback;
  }

  private static nextStatus(status: string, index: number): string {
    if (status === '已完成') {
      return '已完成';
    }
    if (status === '进行中') {
      return '已完成';
    }
    if (status === '待同步') {
      return index === 2 ? '已完成' : '进行中';
    }
    if (index === 0) {
      return '已完成';
    }
    if (index === 1) {
      return '进行中';
    }
    return '待同步';
  }

  private static countDone(tasks: AgentTask[]): number {
    let count: number = 0;
    tasks.forEach((task: AgentTask) => {
      if (task.status === '已完成' || task.status === '进行中') {
        count += 1;
      }
    });
    return count;
  }

  private static recordReflection(plan: AgentPlan): void {
    const item: ReflectionItem = {
      id: `reflection-${plan.goal.length}-${plan.tasks.length}`,
      title: '执行推进复盘',
      insight: `围绕“${plan.goal}”的执行已经从计划进入推进阶段，分身需要继续压缩不确定性。`,
      action: '优先确认主演示路径，再补充系统能力和跨设备同步说明。',
      createdAt: '刚刚'
    };
    LocalStore.addReflection(item);
  }
}
