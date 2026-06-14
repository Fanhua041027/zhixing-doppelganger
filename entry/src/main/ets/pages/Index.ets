import { router } from '@kit.ArkUI';
import { AgentPlan, AgentTask, ProfileSignal } from '../models/AgentModels';
import { ProfileRepository } from '../repositories/ProfileRepository';
import { AgentService } from '../services/AgentService';
import { EvaluationMetric, EvaluationService } from '../services/EvaluationService';

const defaultIndexGoal: string = 'Finish the HarmonyOS Agent contest MVP in three days';
const defaultIndexPlan: AgentPlan = AgentService.createPlan(defaultIndexGoal);
const defaultIndexMetrics: EvaluationMetric[] = EvaluationService.evaluatePlan(defaultIndexPlan);

@Entry
@Component
struct Index {
  @State goal: string = defaultIndexGoal;
  @State plan: AgentPlan = defaultIndexPlan;
  @State metrics: EvaluationMetric[] = defaultIndexMetrics;
  private profileSignals: ProfileSignal[] = ProfileRepository.getProfileSignals();

  build() {
    Scroll() {
      Column({ space: 18 }) {
        this.Header()
        this.GoalPanel()
        this.AgentPanel()
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
          Text('Zhixing Agent')
            .fontSize(34)
            .fontWeight(FontWeight.Bold)
            .fontColor('#162018')
          Text('Intent-driven learning execution for HarmonyOS')
            .fontSize(15)
            .fontColor('#59665C')
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)

        Text('Alpha')
          .fontSize(12)
          .fontColor('#F6F1DA')
          .padding({ left: 10, right: 10, top: 5, bottom: 5 })
          .backgroundColor('#1F4E3A')
          .borderRadius(8)
      }
      .width('100%')

      Row({ space: 8 }) {
        this.SignalPill('Intent')
        this.SignalPill('Tasks')
        this.SignalPill('Profile')
        this.SignalPill('Handoff')
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
        Text('Learning goal')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#17201A')
        Blank()
        Text('MVP')
          .fontSize(12)
          .fontColor('#2D5D46')
          .padding({ left: 10, right: 10, top: 4, bottom: 4 })
          .backgroundColor('#DDEDDD')
          .borderRadius(6)
      }
      .width('100%')

      TextInput({ text: this.goal, placeholder: 'Enter a learning or contest goal' })
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
        })

      Button('Generate execution plan')
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
        })
    }
    .featurePanelStyle()
  }

  @Builder
  AgentPanel() {
    Column({ space: 12 }) {
      Row({ space: 12 }) {
        Column({ space: 6 }) {
          Text('Detected intent')
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
          Text('Confidence')
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
      Text('Cross-device task flow')
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
  ProfilePanel() {
    Column({ space: 12 }) {
      Text('Personal profile signals')
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
      Text('Evaluation snapshot')
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
    Row({ space: 10 }) {
      Button('Tasks')
        .navButtonStyle()
        .onClick(() => router.pushUrl({ url: 'pages/TasksPage' }))
      Button('Profile')
        .navButtonStyle()
        .onClick(() => router.pushUrl({ url: 'pages/ProfilePage' }))
      Button('Settings')
        .navButtonStyle()
        .onClick(() => router.pushUrl({ url: 'pages/SettingsPage' }))
    }
    .width('100%')
    .padding({ top: 4 })
  }

  private statusColor(status: string): string {
    if (status === 'Active') {
      return '#1F4E3A';
    }
    if (status === 'Pending sync') {
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
