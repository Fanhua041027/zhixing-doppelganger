import { RiskControlItem, SubmissionCheckItem } from '../models/AgentModels';
import { ReviewService } from '../services/ReviewService';

const defaultSubmissionChecks: SubmissionCheckItem[] = ReviewService.getSubmissionChecks();
const defaultRiskControls: RiskControlItem[] = ReviewService.getRiskControls();

@Entry
@Component
struct SubmissionPage {
  private checks: SubmissionCheckItem[] = defaultSubmissionChecks;
  private risks: RiskControlItem[] = defaultRiskControls;

  build() {
    Scroll() {
      Column({ space: 16 }) {
        this.TopBar()
        this.HeroPanel()
        this.CheckPanel()
        this.RiskPanel()
        this.PackagePanel()
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
        .onClick(() => this.getUIContext().getRouter().back())
      Blank()
      Text('提交总览')
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .fontColor('#17201A')
    }
    .width('100%')
  }

  @Builder
  HeroPanel() {
    Column({ space: 10 }) {
      Text('作品完成度')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#17201A')
        .width('100%')
      Text('当前版本已经具备可演示主链路：输入学习目标，生成跨设备执行计划，展示个人画像依据，并映射到评审评分点。')
        .fontSize(14)
        .fontColor('#5F6B61')
        .lineHeight(22)
        .width('100%')
      Row({ space: 10 }) {
        this.ScoreCard('主链路', '完成')
        this.ScoreCard('中文界面', '完成')
        this.ScoreCard('答辩材料', '完成')
      }
      .width('100%')
    }
    .pagePanel()
  }

  @Builder
  ScoreCard(label: string, value: string) {
    Column({ space: 4 }) {
      Text(value)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1F4E3A')
      Text(label)
        .fontSize(12)
        .fontColor('#667067')
    }
    .layoutWeight(1)
    .height(72)
    .justifyContent(FlexAlign.Center)
    .backgroundColor('#FFFFFF')
    .borderRadius(8)
  }

  @Builder
  CheckPanel() {
    Column({ space: 12 }) {
      Text('提交检查')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#17201A')
        .width('100%')
      ForEach(this.checks, (item: SubmissionCheckItem) => {
        Column({ space: 6 }) {
          Row() {
            Text(item.title)
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .fontColor('#17201A')
            Blank()
            Text(item.status)
              .fontSize(12)
              .fontColor('#1F4E3A')
          }
          .width('100%')
          Text(item.detail)
            .fontSize(13)
            .fontColor('#5F6B61')
            .lineHeight(20)
            .width('100%')
        }
        .width('100%')
        .padding(12)
        .backgroundColor('#FFFFFF')
        .borderRadius(8)
      }, (item: SubmissionCheckItem) => item.id)
    }
    .pagePanel()
  }

  @Builder
  RiskPanel() {
    Column({ space: 12 }) {
      Text('风险兜底')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#17201A')
        .width('100%')
      ForEach(this.risks, (item: RiskControlItem) => {
        Column({ space: 6 }) {
          Text(item.risk)
            .fontSize(15)
            .fontWeight(FontWeight.Medium)
            .fontColor('#8A5A12')
          Text(item.fallback)
            .fontSize(13)
            .fontColor('#5F6B61')
            .lineHeight(20)
          Text(item.owner)
            .fontSize(12)
            .fontColor('#1F4E3A')
        }
        .width('100%')
        .padding(12)
        .backgroundColor('#FFFFFF')
        .borderRadius(8)
      }, (item: RiskControlItem) => item.id)
    }
    .pagePanel()
  }

  @Builder
  PackagePanel() {
    Column({ space: 8 }) {
      Text('建议提交材料')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#17201A')
        .width('100%')
      Text('1. 项目源码仓库。')
        .packageText()
      Text('2. 应用运行截图或录屏。')
        .packageText()
      Text('3. 作品说明文档和演示脚本。')
        .packageText()
      Text('4. 一页式架构图：意图识别、任务拆解、画像记忆、跨设备流转。')
        .packageText()
    }
    .pagePanel()
  }
}

@Extend(Text)
function packageText() {
  .fontSize(14)
  .fontColor('#5F6B61')
  .lineHeight(22)
  .width('100%')
}

@Extend(Column)
function pagePanel() {
  .width('100%')
  .padding(16)
  .backgroundColor('#EEF2EA')
  .borderRadius(8)
  .border({ width: 1, color: '#D7DFD2' })
}
