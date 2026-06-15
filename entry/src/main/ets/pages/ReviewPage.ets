import { router } from '@kit.ArkUI';
import { ReviewPoint, RiskControlItem, SubmissionCheckItem } from '../models/AgentModels';
import { ReviewService } from '../services/ReviewService';

const defaultReviewPoints: ReviewPoint[] = ReviewService.getReviewPoints();
const defaultChecks: SubmissionCheckItem[] = ReviewService.getSubmissionChecks();
const defaultRisks: RiskControlItem[] = ReviewService.getRiskControls();

@Entry
@Component
struct ReviewPage {
  private points: ReviewPoint[] = defaultReviewPoints;
  private checks: SubmissionCheckItem[] = defaultChecks;
  private risks: RiskControlItem[] = defaultRisks;

  build() {
    Scroll() {
      Column({ space: 16 }) {
        this.TopBar()
        this.SummaryPanel()
        this.PointsPanel()
        this.CompletionPanel()
        this.RiskPanel()
        this.RoutePanel()
      }
      .width('100%')
      .padding({ left: 20, right: 20, top: 24, bottom: 32 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F3F1E8')
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
        .onClick(() => router.back())
      Blank()
      Text('评审展示')
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .fontColor('#17201A')
    }
    .width('100%')
  }

  @Builder
  SummaryPanel() {
    Column({ space: 10 }) {
      Text('一句话定位')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#17201A')
        .width('100%')
      Text('知行分身是一个能把学习意图转成跨设备执行计划的个人学习智能体。')
        .fontSize(14)
        .fontColor('#5F6B61')
        .lineHeight(22)
        .width('100%')
      Text('演示重点：输入目标、识别意图、生成任务、展示画像、给出评测。')
        .fontSize(14)
        .fontColor('#1F4E3A')
        .lineHeight(22)
        .width('100%')
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#EEF2EA')
    .borderRadius(8)
    .border({ width: 1, color: '#D7DFD2' })
  }

  @Builder
  PointsPanel() {
    Column({ space: 12 }) {
      Text('评分点映射')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#17201A')
        .width('100%')
      ForEach(this.points, (point: ReviewPoint) => {
        Column({ space: 8 }) {
          Row() {
            Text(point.title)
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#17201A')
            Blank()
            Text(point.scoreHint)
              .fontSize(12)
              .fontColor('#8A5A12')
          }
          .width('100%')
          Text(point.detail)
            .fontSize(13)
            .fontColor('#5F6B61')
            .lineHeight(20)
            .width('100%')
        }
        .width('100%')
        .padding(12)
        .backgroundColor('#FFFFFF')
        .borderRadius(8)
      }, (point: ReviewPoint) => point.id)
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#EEF2EA')
    .borderRadius(8)
    .border({ width: 1, color: '#D7DFD2' })
  }

  @Builder
  CompletionPanel() {
    Column({ space: 12 }) {
      Text('完成度证据')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#17201A')
        .width('100%')
      ForEach(this.checks, (item: SubmissionCheckItem) => {
        Row({ space: 10 }) {
          Text(item.status)
            .fontSize(12)
            .fontColor('#FFFFFF')
            .width(58)
            .height(34)
            .textAlign(TextAlign.Center)
            .backgroundColor('#1F4E3A')
            .borderRadius(8)
          Column({ space: 4 }) {
            Text(item.title)
              .fontSize(15)
              .fontWeight(FontWeight.Medium)
              .fontColor('#17201A')
            Text(item.detail)
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
      }, (item: SubmissionCheckItem) => item.id)
    }
    .reviewPanel()
  }

  @Builder
  RiskPanel() {
    Column({ space: 12 }) {
      Text('答辩兜底')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#17201A')
        .width('100%')
      ForEach(this.risks, (item: RiskControlItem) => {
        Column({ space: 5 }) {
          Text(item.risk)
            .fontSize(15)
            .fontWeight(FontWeight.Medium)
            .fontColor('#8A5A12')
          Text(item.fallback)
            .fontSize(13)
            .fontColor('#5F6B61')
            .lineHeight(20)
            .width('100%')
        }
        .width('100%')
        .padding(12)
        .backgroundColor('#FFFFFF')
        .borderRadius(8)
      }, (item: RiskControlItem) => item.id)
    }
    .reviewPanel()
  }

  @Builder
  RoutePanel() {
    Column({ space: 10 }) {
      Text('答辩演示顺序')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#17201A')
        .width('100%')
      Text('1. 首页生成执行计划')
        .routeText()
      Text('2. 对话页展示检索依据')
        .routeText()
      Text('3. 任务页解释跨设备角色')
        .routeText()
      Text('4. 画像页展示个人分身数据')
        .routeText()
      Text('5. 设置页说明系统能力扩展')
        .routeText()
    }
    .reviewPanel()
  }
}

@Extend(Text)
function routeText() {
  .fontSize(14)
  .fontColor('#5F6B61')
  .lineHeight(22)
  .width('100%')
}

@Extend(Column)
function reviewPanel() {
  .width('100%')
  .padding(16)
  .backgroundColor('#EEF2EA')
  .borderRadius(8)
  .border({ width: 1, color: '#D7DFD2' })
}
