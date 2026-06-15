import { AgentPlan, AgentTask, DeviceFlowStep, ExecutionSnapshot, TaskHistoryItem } from '../models/AgentModels';
import { AgentService } from '../services/AgentService';
import { DeviceFlowService } from '../services/DeviceFlowService';
import { EvaluationMetric, EvaluationService } from '../services/EvaluationService';
import { ExecutionService } from '../services/ExecutionService';
import { TaskHistoryService } from '../services/TaskHistoryService';
import { TaskPersistenceService } from '../services/TaskPersistenceService';

const defaultTaskPlan: AgentPlan = AgentService.createPlan('准备第一版稳定竞赛演示');
const defaultTaskMetrics: EvaluationMetric[] = EvaluationService.evaluatePlan(defaultTaskPlan);
const defaultTaskFlow: DeviceFlowStep[] = DeviceFlowService.createFlowFromTasks(defaultTaskPlan.tasks);
const defaultTaskHistory: TaskHistoryItem[] = TaskHistoryService.getHistory();
const defaultSnapshot: ExecutionSnapshot = ExecutionService.getInitialSnapshot(defaultTaskPlan);

@Entry
@Component
struct TasksPage {
  @State plan: AgentPlan = defaultTaskPlan;
  @State metrics: EvaluationMetric[] = defaultTaskMetrics;
  @State history: TaskHistoryItem[] = defaultTaskHistory;
  @State deviceFlow: DeviceFlowStep[] = defaultTaskFlow;
  @State snapshot: ExecutionSnapshot = defaultSnapshot;

  build() {
    Scroll() {
      Column({ space: 16 }) {
        this.TopBar()
        this.ProgressPanel()
        this.MetricsPanel()
        this.DeviceFlowPanel()
        this.TaskList()
        this.HistoryPanel()
      }
      .width('100%')
      .padding({ left: 20, right: 20, top: 24, bottom: 32 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F7F2')
  }

  @Builder
  TopBar() {
    Row() {
      Button('返回')
        .height(36)
        .fontSize(13)
        .fontColor('#1F4E3A')
        .backgroundColor('#E3EADF')
        .borderRadius(8)
        .onClick(() => this.getUIContext().getRouter().back())
      Blank()
      Text('任务看板')
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .fontColor('#17201A')
    }
    .width('100%')
  }

  @Builder
  ProgressPanel() {
    Column({ space: 10 }) {
      Text('执行进度')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#17201A')
        .width('100%')
      Text(this.snapshot.summary)
        .fontSize(13)
        .fontColor('#5F6B61')
        .lineHeight(20)
        .width('100%')
      Row() {
        Text(this.snapshot.stage)
          .fontSize(13)
          .fontColor('#1F4E3A')
        Blank()
        Text(`${this.snapshot.progress}%`)
          .fontSize(13)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1F4E3A')
      }
      .width('100%')
      Progress({ value: this.snapshot.progress, total: 100, type: ProgressType.Linear })
        .width('100%')
        .height(8)
        .color('#1F4E3A')
        .backgroundColor('#DDEDDD')
      Text(this.snapshot.nextStep)
        .fontSize(13)
        .fontColor('#8A5A12')
        .lineHeight(20)
        .width('100%')
      Button('推进一次执行')
        .height(40)
        .width('100%')
        .fontSize(14)
        .fontColor('#FFFFFF')
        .backgroundColor('#1F4E3A')
        .borderRadius(8)
        .onClick(() => {
          this.plan = ExecutionService.advancePlan(this.plan);
          this.metrics = EvaluationService.evaluatePlan(this.plan);
          this.deviceFlow = DeviceFlowService.createFlowFromTasks(this.plan.tasks);
          this.snapshot = ExecutionService.createSnapshot(this.plan);
          this.history = TaskHistoryService.getHistory();
        })
      Button('查看复盘沉淀')
        .height(40)
        .width('100%')
        .fontSize(14)
        .fontColor('#1F4E3A')
        .backgroundColor('#E3EADF')
        .borderRadius(8)
        .onClick(() => this.getUIContext().getRouter().pushUrl({ url: 'pages/ProfilePage' }))
      Button('恢复本地状态')
        .height(40)
        .width('100%')
        .fontSize(14)
        .fontColor('#1F4E3A')
        .backgroundColor('#FFFFFF')
        .borderRadius(8)
        .onClick(() => {
          TaskPersistenceService.restoreExtraTasks().then(() => {
            const mergedPlan: AgentPlan = TaskPersistenceService.mergeExtraTasks(this.plan);
            TaskPersistenceService.restoreTaskStatuses(mergedPlan).then((plan: AgentPlan) => {
              this.plan = plan;
              this.metrics = EvaluationService.evaluatePlan(this.plan);
              this.deviceFlow = DeviceFlowService.createFlowFromTasks(this.plan.tasks);
              this.snapshot = ExecutionService.createSnapshot(this.plan);
            });
          });
        })
    }
    .pagePanel()
  }

  @Builder
  TaskList() {
    Column({ space: 12 }) {
      ForEach(this.plan.tasks, (task: AgentTask) => {
        Row({ space: 12 }) {
          Column({ space: 6 }) {
            Text(task.priority)
              .fontSize(13)
              .fontWeight(FontWeight.Bold)
              .fontColor('#FFFFFF')
              .padding({ left: 8, right: 8, top: 4, bottom: 4 })
              .backgroundColor('#1F4E3A')
              .borderRadius(6)
            Text(task.device)
              .fontSize(12)
              .fontColor('#667067')
          }
          .width(70)
          .alignItems(HorizontalAlign.Start)

          Column({ space: 6 }) {
            Text(task.title)
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .fontColor('#17201A')
            Text(task.detail)
              .fontSize(13)
              .fontColor('#5F6B61')
              .lineHeight(20)
            Row() {
              Text(task.time)
                .fontSize(12)
                .fontColor('#667067')
              Blank()
              Text(task.status)
                .fontSize(12)
                .fontColor(this.statusColor(task.status))
            }
            .width('100%')
            Button(task.status === '已完成' ? '已完成' : '标记完成')
              .height(34)
              .width('100%')
              .fontSize(13)
              .fontColor(task.status === '已完成' ? '#667067' : '#FFFFFF')
              .backgroundColor(task.status === '已完成' ? '#E3EADF' : '#1F4E3A')
              .borderRadius(8)
              .onClick(() => {
                this.plan = TaskPersistenceService.markTaskDone(this.plan, task.id);
                this.metrics = EvaluationService.evaluatePlan(this.plan);
                this.deviceFlow = DeviceFlowService.createFlowFromTasks(this.plan.tasks);
                this.snapshot = ExecutionService.createSnapshot(this.plan);
              })
          }
          .layoutWeight(1)
          .alignItems(HorizontalAlign.Start)
        }
        .width('100%')
        .padding(14)
        .backgroundColor('#FFFFFF')
        .borderRadius(8)
      }, (task: AgentTask) => task.id)
    }
    .width('100%')
  }

  @Builder
  MetricsPanel() {
    Row({ space: 10 }) {
      ForEach(this.metrics, (metric: EvaluationMetric) => {
        Column({ space: 4 }) {
          Text(metric.value)
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1F4E3A')
          Text(metric.label)
            .fontSize(11)
            .fontColor('#667067')
            .textAlign(TextAlign.Center)
        }
        .layoutWeight(1)
        .height(78)
        .justifyContent(FlexAlign.Center)
        .backgroundColor('#FFFFFF')
        .borderRadius(8)
      }, (metric: EvaluationMetric) => metric.label)
    }
    .width('100%')
  }

  @Builder
  DeviceFlowPanel() {
    Column({ space: 12 }) {
      Text('设备分工')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#17201A')
        .width('100%')
      ForEach(this.deviceFlow, (step: DeviceFlowStep) => {
        Row({ space: 10 }) {
          Text(step.device)
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .fontColor('#FFFFFF')
            .width(72)
            .height(48)
            .textAlign(TextAlign.Center)
            .backgroundColor('#1F4E3A')
            .borderRadius(8)
          Column({ space: 4 }) {
            Text(step.role)
              .fontSize(14)
              .fontWeight(FontWeight.Medium)
              .fontColor('#17201A')
            Text(step.handoff)
              .fontSize(12)
              .fontColor('#5F6B61')
              .lineHeight(18)
          }
          .layoutWeight(1)
          .alignItems(HorizontalAlign.Start)
        }
        .width('100%')
        .padding(12)
        .backgroundColor('#FFFFFF')
        .borderRadius(8)
      }, (step: DeviceFlowStep) => step.id)
    }
    .pagePanel()
  }

  @Builder
  HistoryPanel() {
    Column({ space: 12 }) {
      Text('历史执行记录')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#17201A')
        .width('100%')
      ForEach(this.history, (item: TaskHistoryItem) => {
        Column({ space: 6 }) {
          Row() {
            Text(item.intent)
              .fontSize(15)
              .fontWeight(FontWeight.Medium)
              .fontColor('#17201A')
            Blank()
            Text(item.createdAt)
              .fontSize(12)
              .fontColor('#8A5A12')
          }
          .width('100%')
          Text(item.goal)
            .fontSize(13)
            .fontColor('#5F6B61')
            .lineHeight(20)
            .width('100%')
          Text(`${item.taskCount} 个任务 / ${item.deviceCount} 类设备`)
            .fontSize(12)
            .fontColor('#1F4E3A')
        }
        .width('100%')
        .padding(12)
        .backgroundColor('#FFFFFF')
        .borderRadius(8)
      }, (item: TaskHistoryItem) => item.id)
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#EEF2EA')
    .borderRadius(8)
  }

  private statusColor(status: string): string {
    if (status === '已完成') {
      return '#1F4E3A';
    }
    if (status === '进行中') {
      return '#2D5D46';
    }
    if (status === '待同步') {
      return '#8A5A12';
    }
    return '#667067';
  }
}

@Extend(Column)
function pagePanel() {
  .width('100%')
  .padding(16)
  .backgroundColor('#EEF2EA')
  .borderRadius(8)
}
