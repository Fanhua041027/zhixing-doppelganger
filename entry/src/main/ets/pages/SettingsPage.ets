import common from '@ohos.app.ability.common';
import Want from '@ohos.app.ability.Want';
import { DemoModeState } from '../models/AgentModels';
import { DemoModeService } from '../services/DemoModeService';
import { HarmonyIntentService, SystemActionResult } from '../services/HarmonyIntentService';

const defaultSystemAction: SystemActionResult = HarmonyIntentService.createCalendarDraft('鸿蒙智能体演示');
const defaultDemoMode: DemoModeState = DemoModeService.getDefaultState();

@Entry
@Component
struct SettingsPage {
  @State ragEnabled: boolean = true;
  @State crossDeviceEnabled: boolean = true;
  @State strictMode: boolean = true;
  @State actionResult: SystemActionResult = defaultSystemAction;
  @State demoMode: DemoModeState = defaultDemoMode;
  @State launchTip: string = '系统能力会优先尝试拉起系统应用，失败时保留调用参数。';

  build() {
    Scroll() {
      Column({ space: 16 }) {
        this.TopBar()
        this.SwitchPanel()
        this.DemoModePanel()
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
        .onClick(() => this.getUIContext().getRouter().back())
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
      Text('1. 将画像、任务历史和设备流转记录持久化到本地。')
        .roadmapText()
      Text('2. 接入真实日程和提醒系统能力。')
        .roadmapText()
      Text('3. 做手机、平板和穿戴设备间的任务流转原型，并提供兜底方案。')
        .roadmapText()
    }
    .pagePanel()
  }

  @Builder
  DemoModePanel() {
    Column({ space: 10 }) {
      Row() {
        Text(this.demoMode.title)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#17201A')
        Blank()
        Text(this.demoMode.enabled ? '已开启' : '已关闭')
          .fontSize(12)
          .fontColor(this.demoMode.enabled ? '#1F4E3A' : '#8A5A12')
      }
      .width('100%')
      Text(this.demoMode.goal)
        .fontSize(14)
        .fontColor('#17201A')
        .width('100%')
      Text(this.demoMode.script)
        .fontSize(13)
        .fontColor('#5F6B61')
        .lineHeight(20)
        .width('100%')
      Button(this.demoMode.enabled ? '切换普通模式' : '开启演示模式')
        .height(40)
        .width('100%')
        .fontSize(14)
        .fontColor('#FFFFFF')
        .backgroundColor('#1F4E3A')
        .borderRadius(8)
        .onClick(() => {
          this.demoMode = this.demoMode.enabled ? DemoModeService.disable() : DemoModeService.getDefaultState();
        })
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#EEF2EA')
    .borderRadius(8)
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
      Text(this.launchTip)
        .fontSize(12)
        .fontColor('#8A5A12')
        .lineHeight(18)
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
      Button('准备日历调用')
        .height(40)
        .width('100%')
        .fontSize(14)
        .fontColor('#1F4E3A')
        .backgroundColor('#E3EADF')
        .borderRadius(8)
        .onClick(() => {
          this.actionResult = HarmonyIntentService.openCalendarIntent('鸿蒙智能体演示');
          this.tryStartSystemAbility('日历');
        })
      Button('准备提醒调用')
        .height(40)
        .width('100%')
        .fontSize(14)
        .fontColor('#1F4E3A')
        .backgroundColor('#FFFFFF')
        .borderRadius(8)
        .onClick(() => {
          this.actionResult = HarmonyIntentService.openReminderIntent('鸿蒙智能体演示');
          this.tryStartSystemAbility('提醒');
        })
    }
    .pagePanel()
  }

  private tryStartSystemAbility(type: string): void {
    const hostContext = this.getUIContext().getHostContext();
    if (hostContext === undefined) {
      this.launchTip = '当前页面上下文不可用，已保留系统调用参数。';
      return;
    }
    const context = hostContext as common.UIAbilityContext;
    const want: Want = {
      action: 'ohos.want.action.viewData',
      parameters: {
        title: type === '日历' ? '鸿蒙智能体演示' : '复盘提醒',
        description: '知行分身生成的学习执行安排'
      }
    };
    context.startAbility(want).then(() => {
      this.launchTip = `已尝试拉起系统${type}能力。`;
    }).catch(() => {
      this.launchTip = `当前设备未响应系统${type}意图，已保留调用参数用于正式接入。`;
    });
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
