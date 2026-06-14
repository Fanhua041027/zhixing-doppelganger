import { router } from '@kit.ArkUI';
import { HarmonyIntentService, SystemActionResult } from '../services/HarmonyIntentService';

@Entry
@Component
struct SettingsPage {
  @State ragEnabled: boolean = true;
  @State crossDeviceEnabled: boolean = true;
  @State strictMode: boolean = true;
  @State actionResult: SystemActionResult = HarmonyIntentService.createCalendarDraft('HarmonyOS Agent MVP');

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
      Button('Back')
        .height(36)
        .fontSize(13)
        .fontColor('#1F4E3A')
        .backgroundColor('#E3EADF')
        .borderRadius(8)
        .onClick(() => router.back())
      Blank()
      Text('Settings')
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .fontColor('#17201A')
    }
    .width('100%')
  }

  @Builder
  SwitchPanel() {
    Column({ space: 14 }) {
      Text('Agent controls')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#17201A')
        .width('100%')

      Row() {
        Text('RAG guardrail')
          .settingLabel()
        Toggle({ type: ToggleType.Switch, isOn: this.ragEnabled })
          .selectedColor('#1F4E3A')
          .onChange((value: boolean) => {
            this.ragEnabled = value;
          })
      }
      .settingRow()

      Row() {
        Text('Cross-device flow')
          .settingLabel()
        Toggle({ type: ToggleType.Switch, isOn: this.crossDeviceEnabled })
          .selectedColor('#1F4E3A')
          .onChange((value: boolean) => {
            this.crossDeviceEnabled = value;
          })
      }
      .settingRow()

      Row() {
        Text('Strict context mode')
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
      Text('Next engineering steps')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#17201A')
        .width('100%')
      Text('1. Persist profile and task history locally.')
        .roadmapText()
      Text('2. Add real system intent invocation for schedule and reminder scenarios.')
        .roadmapText()
      Text('3. Prototype phone-tablet task handoff with graceful fallback.')
        .roadmapText()
    }
    .pagePanel()
  }

  @Builder
  SystemActionPanel() {
    Column({ space: 10 }) {
      Text('System capability')
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
      Button('Prepare review reminder')
        .height(40)
        .width('100%')
        .fontSize(14)
        .fontColor('#FFFFFF')
        .backgroundColor('#1F4E3A')
        .borderRadius(8)
        .onClick(() => {
          this.actionResult = HarmonyIntentService.createReviewReminder('HarmonyOS Agent MVP');
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
