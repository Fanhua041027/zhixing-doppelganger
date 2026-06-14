import { router } from '@kit.ArkUI';
import { AgentPlan, AgentTask } from '../models/AgentModels';
import { AgentService } from '../services/AgentService';
import { EvaluationMetric, EvaluationService } from '../services/EvaluationService';

@Entry
@Component
struct TasksPage {
  @State plan: AgentPlan = AgentService.createPlan('Prepare the first stable demo for the contest');
  @State metrics: EvaluationMetric[] = EvaluationService.evaluatePlan(this.plan);

  build() {
    Scroll() {
      Column({ space: 16 }) {
        this.TopBar()
        this.ProgressPanel()
        this.MetricsPanel()
        this.TaskList()
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
      Button('Back')
        .height(36)
        .fontSize(13)
        .fontColor('#1F4E3A')
        .backgroundColor('#E3EADF')
        .borderRadius(8)
        .onClick(() => router.back())
      Blank()
      Text('Task Board')
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .fontColor('#17201A')
    }
    .width('100%')
  }

  @Builder
  ProgressPanel() {
    Column({ space: 10 }) {
      Text('Execution progress')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#17201A')
        .width('100%')
      Text('The current MVP focuses on making every Agent decision visible through task cards.')
        .fontSize(13)
        .fontColor('#5F6B61')
        .lineHeight(20)
        .width('100%')
      Progress({ value: 42, total: 100, type: ProgressType.Linear })
        .width('100%')
        .height(8)
        .color('#1F4E3A')
        .backgroundColor('#DDEDDD')
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
                .fontColor('#1F4E3A')
            }
            .width('100%')
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
}

@Extend(Column)
function pagePanel() {
  .width('100%')
  .padding(16)
  .backgroundColor('#EEF2EA')
  .borderRadius(8)
}
