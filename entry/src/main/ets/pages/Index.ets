interface AgentTask {
  title: string;
  detail: string;
  device: string;
  time: string;
  status: string;
}

interface ProfileSignal {
  label: string;
  value: string;
}

@Entry
@Component
struct Index {
  @State goal: string = '三天内完成鸿蒙 Agent 创新赛原型';
  @State intent: string = '竞赛学习规划';
  @State confidence: number = 92;
  @State tasks: AgentTask[] = [
    {
      title: '拆解赛题材料',
      detail: '提取评分维度、作品限制和演示要求，形成一页摘要。',
      device: 'Phone',
      time: '今天 20:30',
      status: '进行中'
    },
    {
      title: '整理知识卡片',
      detail: '把意图识别、任务拆解、跨端流转整理成答辩材料。',
      device: 'Tablet',
      time: '明天 09:00',
      status: '待执行'
    },
    {
      title: '安排复盘提醒',
      detail: '在关键节点提醒检查 Demo 稳定性和讲稿一致性。',
      device: 'Wearable',
      time: '明天 21:30',
      status: '待同步'
    }
  ];
  private profileSignals: ProfileSignal[] = [
    { label: '执行风格', value: '先跑通闭环，再打磨细节' },
    { label: '学习偏好', value: '任务卡片 + 时间盒' },
    { label: '风险倾向', value: '避免押注不稳定 API' }
  ];

  build() {
    Scroll() {
      Column({ space: 18 }) {
        this.Header()
        this.GoalPanel()
        this.AgentPanel()
        this.TaskFlow()
        this.ProfilePanel()
      }
      .width('100%')
      .padding({ left: 20, right: 20, top: 24, bottom: 32 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F7F2')
  }

  @Builder
  Header() {
    Column({ space: 8 }) {
      Text('知行分身')
        .fontSize(32)
        .fontWeight(FontWeight.Bold)
        .fontColor('#17201A')
      Text('基于意图识别的鸿蒙跨设备学习执行 Agent')
        .fontSize(15)
        .fontColor('#5F6B61')
    }
    .alignItems(HorizontalAlign.Start)
    .width('100%')
  }

  @Builder
  GoalPanel() {
    Column({ space: 14 }) {
      Row() {
        Text('当前学习目标')
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

      TextInput({ text: this.goal, placeholder: '输入你的学习或竞赛目标' })
        .height(48)
        .fontSize(15)
        .fontColor('#17201A')
        .placeholderColor('#8B958D')
        .backgroundColor('#FFFFFF')
        .borderRadius(8)
        .padding({ left: 12, right: 12 })
        .onChange((value: string) => {
          this.goal = value;
          this.intent = this.inferIntent(value);
          this.confidence = value.length > 8 ? 92 : 74;
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
          this.refreshPlan();
        })
    }
    .panelStyle()
  }

  @Builder
  AgentPanel() {
    Row({ space: 12 }) {
      Column({ space: 6 }) {
        Text('识别意图')
          .fontSize(13)
          .fontColor('#667067')
        Text(this.intent)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#17201A')
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)

      Column({ space: 4 }) {
        Text(`${this.confidence}%`)
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1F4E3A')
        Text('置信度')
          .fontSize(12)
          .fontColor('#667067')
      }
      .alignItems(HorizontalAlign.End)
    }
    .panelStyle()
  }

  @Builder
  TaskFlow() {
    Column({ space: 12 }) {
      Text('跨设备任务流')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#17201A')
        .width('100%')

      ForEach(this.tasks, (task: AgentTask) => {
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
            Text(task.time)
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
      }, (task: AgentTask) => task.title)
    }
    .panelStyle()
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
            .width(88)
          Text(signal.value)
            .fontSize(14)
            .fontColor('#17201A')
            .layoutWeight(1)
        }
        .width('100%')
      }, (signal: ProfileSignal) => signal.label)
    }
    .panelStyle()
  }

  private inferIntent(value: string): string {
    if (value.includes('比赛') || value.includes('竞赛')) {
      return '竞赛学习规划';
    }
    if (value.includes('复习') || value.includes('考试')) {
      return '考试复习调度';
    }
    if (value.includes('论文') || value.includes('文献')) {
      return '资料研读整理';
    }
    return '学习任务执行';
  }

  private refreshPlan(): void {
    this.tasks = [
      {
        title: '确认目标边界',
        detail: `围绕“${this.goal}”拆出可交付成果和验收标准。`,
        device: 'Phone',
        time: '立即',
        status: '进行中'
      },
      {
        title: '生成任务卡片',
        detail: '按重要性、截止时间和设备适配度安排执行顺序。',
        device: 'Tablet',
        time: '30 分钟后',
        status: '待执行'
      },
      {
        title: '设置复盘提醒',
        detail: '在任务完成后触发复盘，沉淀到个人画像和记忆库。',
        device: 'Wearable',
        time: '今晚',
        status: '待同步'
      }
    ];
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
function panelStyle() {
  .width('100%')
  .padding(16)
  .backgroundColor('#EEF2EA')
  .borderRadius(8)
}
