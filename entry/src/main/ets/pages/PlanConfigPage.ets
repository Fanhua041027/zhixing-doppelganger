import { StudyPlanConfig } from '../models/AgentModels';
import { StudyPlanService } from '../services/StudyPlanService';

const defaultConfig: StudyPlanConfig = StudyPlanService.getDefaultConfig();

@Entry
@Component
struct PlanConfigPage {
  @State goal: string = defaultConfig.goal;
  @State deadline: string = defaultConfig.deadline;
  @State dailyMinutes: string = defaultConfig.dailyMinutes;
  @State weakPoint: string = defaultConfig.weakPoint;
  @State preferredDevice: string = defaultConfig.preferredDevice;
  @State resultText: string = '填写后会生成更贴近你的学习执行计划。';

  build() {
    Scroll() {
      Column({ space: 16 }) {
        this.TopBar()
        this.FormPanel()
        this.ResultPanel()
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
      Text('计划配置')
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .fontColor('#17201A')
    }
    .width('100%')
  }

  @Builder
  FormPanel() {
    Column({ space: 12 }) {
      Text('把真实约束交给分身')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#17201A')
        .width('100%')
      this.InputBlock('学习目标', this.goal, '输入你真正想完成的目标', 'goal')
      this.InputBlock('截止时间', this.deadline, '例如：三天后、下周五', 'deadline')
      this.InputBlock('每日可用时间', this.dailyMinutes, '例如：90', 'daily')
      this.InputBlock('当前难点', this.weakPoint, '例如：资料太散、演示不稳', 'weak')
      this.InputBlock('偏好设备', this.preferredDevice, '例如：手机和平板', 'device')
      Button('生成个性化计划')
        .height(44)
        .width('100%')
        .fontSize(15)
        .fontColor('#FFFFFF')
        .backgroundColor('#1F4E3A')
        .borderRadius(8)
        .onClick(() => this.saveConfig())
    }
    .pagePanel()
  }

  @Builder
  InputBlock(label: string, value: string, placeholder: string, field: string) {
    Column({ space: 6 }) {
      Text(label)
        .fontSize(13)
        .fontColor('#667067')
        .width('100%')
      TextInput({ text: value, placeholder: placeholder })
        .height(44)
        .fontSize(14)
        .fontColor('#17201A')
        .placeholderColor('#8B958D')
        .backgroundColor('#FFFFFF')
        .borderRadius(8)
        .padding({ left: 12, right: 12 })
        .onChange((input: string) => this.updateField(field, input))
    }
    .width('100%')
  }

  @Builder
  ResultPanel() {
    Column({ space: 10 }) {
      Text('生成结果')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#17201A')
        .width('100%')
      Text(this.resultText)
        .fontSize(14)
        .fontColor('#5F6B61')
        .lineHeight(22)
        .width('100%')
      Button('回首页查看计划')
        .height(40)
        .width('100%')
        .fontSize(14)
        .fontColor('#1F4E3A')
        .backgroundColor('#E3EADF')
        .borderRadius(8)
        .onClick(() => this.getUIContext().getRouter().back())
    }
    .pagePanel()
  }

  private updateField(field: string, input: string): void {
    if (field === 'goal') {
      this.goal = input;
    } else if (field === 'deadline') {
      this.deadline = input;
    } else if (field === 'daily') {
      this.dailyMinutes = input;
    } else if (field === 'weak') {
      this.weakPoint = input;
    } else {
      this.preferredDevice = input;
    }
  }

  private saveConfig(): void {
    const config: StudyPlanConfig = {
      goal: this.goal,
      deadline: this.deadline,
      dailyMinutes: this.dailyMinutes,
      weakPoint: this.weakPoint,
      preferredDevice: this.preferredDevice
    };
    const plan = StudyPlanService.saveConfig(config);
    this.resultText = `已生成“${plan.intent}”：每天 ${this.dailyMinutes} 分钟，优先解决“${this.weakPoint}”。`;
  }
}

@Extend(Column)
function pagePanel() {
  .width('100%')
  .padding(16)
  .backgroundColor('#EEF2EA')
  .borderRadius(8)
  .border({ width: 1, color: '#D7DFD2' })
}
