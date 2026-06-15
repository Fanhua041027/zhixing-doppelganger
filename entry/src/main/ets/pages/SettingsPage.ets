import { router } from '@kit.ArkUI';
import { HarmonyIntentService, SystemActionResult } from '../services/HarmonyIntentService';

const defaultSystemAction: SystemActionResult = HarmonyIntentService.createCalendarDraft('鸿蒙智能体演示');

@Entry
@Component
struct SettingsPage {
  @State ragEnabled: boolean = true;
  @State crossDeviceEnabled: boolean = true;
  @State strictMode: boolean = true;
  @State actionResult: SystemActionResult = defaultSystemAction;

  build() {
    Scroll() {
      Column({ space: 16 }) {
        this.TopBar()
        this.SwitchPanel()
        this.SystemActionPanel()
        this.RoadmapPanel()
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
        .onClick(() => router.back())
      Blank()
      Text('设置')
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .fontColor('#17201A')
    }
    .width('100%')
  }

  @Builder
  SwitchPanel() {
    Column({ space: 14 }) {
      Text('智能体控制')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#17201A')
        .width('100%')

      Row() {
        Text('检索增强约束')
          .settingLabel()
        Toggle({ type: ToggleType.Switch, isOn: this.ragEnabled })
          .selectedColor('#1F4E3A')
          .onChange((value: boolean) => {
            this.ragEnabled = value;
          })
      }
      .settingRow()

      Row() {
        Text('跨设备流转')
          .settingLabel()
        Toggle({ type: ToggleType.Switch, isOn: this.crossDeviceEnabled })
          .selectedColor('#1F4E3A')
          .onChange((value: boolean) => {
            this.crossDeviceEnabled = value;
          })
      }
      .settingRow()

      Row() {
        Text('严格上下文模式')
          .settingLabel()
        Toggle({ type: ToggleType.Switch, isOn: this.strictMode })
          .selectedColor('#1F4E3A')
          .onChange((value: boolean) => {
            this.strictMode = value;
          })
      }
      .settingRow()
    }
    .pagePanel()
  }

  @Builder
  RoadmapPanel() {
    Column({ space: 10 }) {
      Text('后续工程步骤')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#17201A')
        .width('100%')
      Text('1. 将画像和任务历史持久化到本地。')
        .roadmapText()
      Text('2. 接入真实日程和提醒系统能力。')
        .roadmapText()
      Text('3. 做手机和平板间的任务流转原型，并提供兜底方案。')
        .roadmapText()
    }
    .pagePanel()
  }

  @Builder
  SystemActionPanel() {
    Column({ space: 10 }) {
      Text('系统能力')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#17201A')
        .width('100%')
      Text(this.actionResult.title)
        .fontSize(15)
        .fontWeight(FontWeight.Medium)
        .fontColor('#17201A')
        .width('100%')
      Text(this.actionResult.detail)
        .fontSize(13)
        .fontColor('#5F6B61')
        .lineHeight(20)
        .width('100%')
      Button('准备复盘提醒')
        .height(40)
        .width('100%')
        .fontSize(14)
        .fontColor('#FFFFFF')
        .backgroundColor('#1F4E3A')
        .borderRadius(8)
        .onClick(() => {
          this.actionResult = HarmonyIntentService.createReviewReminder('鸿蒙智能体演示');
        })
    }
    .pagePanel()
  }
}

@Extend(Text)
function roadmapText() {
  .fontSize(13)
  .fontColor('#5F6B61')
  .lineHeight(20)
  .width('100%')
}

@Extend(Text)
function settingLabel() {
  .fontSize(15)
  .fontColor('#17201A')
  .layoutWeight(1)
}

@Extend(Row)
function settingRow() {
  .width('100%')
  .padding(12)
  .backgroundColor('#FFFFFF')
  .borderRadius(8)
}

@Extend(Column)
function pagePanel() {
  .width('100%')
  .padding(16)
  .backgroundColor('#EEF2EA')
  .borderRadius(8)
}
