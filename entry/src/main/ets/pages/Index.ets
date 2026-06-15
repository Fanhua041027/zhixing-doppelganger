import { router } from '@kit.ArkUI';
import { AgentPlan, AgentTask, DeviceFlowStep, ProfileSignal } from '../models/AgentModels';
import { ProfileRepository } from '../repositories/ProfileRepository';
import { AgentService } from '../services/AgentService';
import { DeviceFlowService } from '../services/DeviceFlowService';
import { EvaluationMetric, EvaluationService } from '../services/EvaluationService';

const defaultIndexGoal: string = '三天内完成鸿蒙智能体竞赛演示';
const defaultIndexPlan: AgentPlan = AgentService.createPlan(defaultIndexGoal);
const defaultIndexMetrics: EvaluationMetric[] = EvaluationService.evaluatePlan(defaultIndexPlan);
const defaultDeviceFlow: DeviceFlowStep[] = DeviceFlowService.createFlowFromTasks(defaultIndexPlan.tasks);

@Entry
@Component
struct Index {
  @State goal: string = defaultIndexGoal;
  @State plan: AgentPlan = defaultIndexPlan;
  @State metrics: EvaluationMetric[] = defaultIndexMetrics;
  @State deviceFlow: DeviceFlowStep[] = defaultDeviceFlow;
  private profileSignals: ProfileSignal[] = ProfileRepository.getProfileSignals();

  build() {
    Scroll() {
      Column({ space: 18 }) {
        this.Header()
        this.GoalPanel()
        this.AgentPanel()
        this.DeviceFlowPanel()
        this.TaskFlow()
        this.MetricsPanel()
        this.ProfilePanel()
        this.NavigationPanel()
      }
      .width('100%')
      .padding({ left: 20, right: 20, top: 24, bottom: 32 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F3F1E8')
  }

  @Builder
  Header() {
    Column({ space: 14 }) {
      Row() {
        Column({ space: 6 }) {
          Text('知行分身')
            .fontSize(34)
            .fontWeight(FontWeight.Bold)
            .fontColor('#162018')
          Text('基于意图识别的鸿蒙学习执行智能体')
            .fontSize(15)
            .fontColor('#59665C')
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)

        Text('演示版')
          .fontSize(12)
          .fontColor('#F6F1DA')
          .padding({ left: 10, right: 10, top: 5, bottom: 5 })
          .backgroundColor('#1F4E3A')
          .borderRadius(8)
      }
      .width('100%')

      Row({ space: 8 }) {
        this.SignalPill('意图')
        this.SignalPill('对话')
        this.SignalPill('任务')
        this.SignalPill('画像')
        this.SignalPill('评审')
        this.SignalPill('流转')
      }
      .width('100%')
    }
    .alignItems(HorizontalAlign.Start)
    .width('100%')
  }

  @Builder
  SignalPill(label: string) {
    Text(label)
      .fontSize(12)
      .fontColor('#344138')
      .padding({ left: 10, right: 10, top: 6, bottom: 6 })
      .backgroundColor('#E3EADF')
      .borderRadius(8)
  }

  @Builder
  GoalPanel() {
    Column({ space: 14 }) {
      Row() {
        Text('学习目标')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#17201A')
        Blank()
        Text('最小闭环')
          .fontSize(12)
          .fontColor('#2D5D46')
          .padding({ left: 10, right: 10, top: 4, bottom: 4 })
          .backgroundColor('#DDEDDD')
          .borderRadius(6)
      }
      .width('100%')

      TextInput({ text: this.goal, placeholder: '输入学习、竞赛或项目目标' })
        .height(48)
        .fontSize(15)
        .fontColor('#17201A')
        .placeholderColor('#8B958D')
        .backgroundColor('#FFFFFF')
        .borderRadius(8)
        .padding({ left: 12, right: 12 })
        .onChange((value: string) => {
          this.goal = value;
          this.plan = AgentService.createPlan(value);
          this.metrics = EvaluationService.evaluatePlan(this.plan);
          this.deviceFlow = DeviceFlowService.createFlowFromTasks(this.plan.tasks);
        })

      Button('生成执行计划')
        .height(44)
        .width('100%')
        .fontSize(15)
        .fontWeight(FontWeight.Medium)
        .fontColor('#FFFFFF')
        .backgroundColor('#1F4E3A')
        .borderRadius(8)
        .onClick(() => {
          this.plan = AgentService.createPlan(this.goal);
          this.metrics = EvaluationService.evaluatePlan(this.plan);
          this.deviceFlow = DeviceFlowService.createFlowFromTasks(this.plan.tasks);
        })
    }
    .featurePanelStyle()
  }

  @Builder
  AgentPanel() {
    Column({ space: 12 }) {
      Row({ space: 12 }) {
        Column({ space: 6 }) {
          Text('识别意图')
            .fontSize(13)
            .fontColor('#667067')
          Text(this.plan.intent)
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor('#17201A')
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)

        Column({ space: 4 }) {
          Text(`${this.plan.confidence}%`)
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1F4E3A')
          Text('置信度')
            .fontSize(12)
            .fontColor('#667067')
        }
        .alignItems(HorizontalAlign.End)
      }
      .width('100%')

      Text(this.plan.suggestion)
        .fontSize(13)
        .fontColor('#4E5B50')
        .lineHeight(20)
        .width('100%')
    }
    .featurePanelStyle()
  }

  @Builder
  TaskFlow() {
    Column({ space: 12 }) {
      Text('跨设备任务流')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#17201A')
        .width('100%')

      ForEach(this.plan.tasks, (task: AgentTask) => {
        Column({ space: 8 }) {
          Row() {
            Text(task.title)
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .fontColor('#17201A')
              .layoutWeight(1)
            Text(task.device)
              .fontSize(12)
              .fontColor('#5B4B1A')
              .padding({ left: 8, right: 8, top: 3, bottom: 3 })
              .backgroundColor('#F0E6BF')
              .borderRadius(6)
          }
          .width('100%')

          Text(task.detail)
            .fontSize(13)
            .fontColor('#5F6B61')
            .lineHeight(20)
            .width('100%')

          Row() {
            Text(`${task.priority} - ${task.time}`)
              .fontSize(12)
              .fontColor('#667067')
            Blank()
            Text(task.status)
              .fontSize(12)
              .fontColor(this.statusColor(task.status))
          }
          .width('100%')
        }
        .padding(14)
        .backgroundColor('#FFFFFF')
        .borderRadius(8)
      }, (task: AgentTask) => task.id)
    }
    .featurePanelStyle()
  }

  @Builder
  DeviceFlowPanel() {
    Column({ space: 12 }) {
      Row() {
        Text('鸿蒙跨设备流转')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#17201A')
        Blank()
        Text('三端协同')
          .fontSize(12)
          .fontColor('#2D5D46')
          .padding({ left: 10, right: 10, top: 4, bottom: 4 })
          .backgroundColor('#DDEDDD')
          .borderRadius(6)
      }
      .width('100%')

      ForEach(this.deviceFlow, (step: DeviceFlowStep) => {
        Column({ space: 6 }) {
          Row() {
            Text(step.device)
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#17201A')
            Blank()
            Text(step.status)
              .fontSize(12)
              .fontColor('#8A5A12')
          }
          .width('100%')
          Text(step.role)
            .fontSize(13)
            .fontColor('#1F4E3A')
            .width('100%')
          Text(step.handoff)
            .fontSize(13)
            .fontColor('#5F6B61')
            .lineHeight(20)
            .width('100%')
        }
        .padding(12)
        .backgroundColor('#FFFFFF')
        .borderRadius(8)
      }, (step: DeviceFlowStep) => step.id)
    }
    .featurePanelStyle()
  }

  @Builder
  ProfilePanel() {
    Column({ space: 12 }) {
      Text('个人画像信号')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#17201A')
        .width('100%')

      ForEach(this.profileSignals, (signal: ProfileSignal) => {
        Row() {
          Text(signal.label)
            .fontSize(13)
            .fontColor('#667067')
            .width(110)
          Text(signal.value)
            .fontSize(14)
            .fontColor('#17201A')
            .layoutWeight(1)
        }
        .width('100%')
      }, (signal: ProfileSignal) => signal.label)
    }
    .featurePanelStyle()
  }

  @Builder
  MetricsPanel() {
    Column({ space: 12 }) {
      Text('评测快照')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#17201A')
        .width('100%')

      ForEach(this.metrics, (metric: EvaluationMetric) => {
        Row({ space: 12 }) {
          Column({ space: 3 }) {
            Text(metric.value)
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor('#1F4E3A')
            Text(metric.label)
              .fontSize(12)
              .fontColor('#667067')
          }
          .width(110)
          .alignItems(HorizontalAlign.Start)

          Text(metric.detail)
            .fontSize(13)
            .fontColor('#5F6B61')
            .lineHeight(20)
            .layoutWeight(1)
        }
        .width('100%')
        .padding(12)
        .backgroundColor('#FFFFFF')
        .borderRadius(8)
      }, (metric: EvaluationMetric) => metric.label)
    }
    .featurePanelStyle()
  }

  @Builder
  NavigationPanel() {
    Column({ space: 10 }) {
      Row({ space: 10 }) {
        Button('对话')
          .navButtonStyle()
          .onClick(() => router.pushUrl({ url: 'pages/ChatPage' }))
        Button('任务')
          .navButtonStyle()
          .onClick(() => router.pushUrl({ url: 'pages/TasksPage' }))
        Button('画像')
          .navButtonStyle()
          .onClick(() => router.pushUrl({ url: 'pages/ProfilePage' }))
      }
      .width('100%')
      Row({ space: 10 }) {
        Button('评审')
          .navButtonStyle()
          .onClick(() => router.pushUrl({ url: 'pages/ReviewPage' }))
        Button('提交')
          .navButtonStyle()
          .onClick(() => router.pushUrl({ url: 'pages/SubmissionPage' }))
        Button('设置')
          .navButtonStyle()
          .onClick(() => router.pushUrl({ url: 'pages/SettingsPage' }))
      }
      .width('100%')
    }
    .width('100%')
    .padding({ top: 4 })
  }

  private statusColor(status: string): string {
    if (status === '进行中') {
      return '#1F4E3A';
    }
    if (status === '待同步') {
      return '#8A5A12';
    }
    return '#667067';
  }
}

@Extend(Column)
function featurePanelStyle() {
  .width('100%')
  .padding(16)
  .backgroundColor('#EEF2EA')
  .borderRadius(8)
  .border({ width: 1, color: '#D7DFD2' })
}

@Extend(Button)
function navButtonStyle() {
  .height(42)
  .layoutWeight(1)
  .fontSize(14)
  .fontColor('#1F4E3A')
  .backgroundColor('#E3EADF')
  .borderRadius(8)
}
