import { router } from '@kit.ArkUI';
import { ChatMessage, ChatTurnResult, KnowledgeHit } from '../models/AgentModels';
import { ConversationService } from '../services/ConversationService';

const defaultChatTurn: ChatTurnResult = ConversationService.startConversation();

@Entry
@Component
struct ChatPage {
  @State prompt: string = '如何降低演示风险？';
  @State turn: ChatTurnResult = defaultChatTurn;

  build() {
    Scroll() {
      Column({ space: 16 }) {
        this.TopBar()
        this.InputPanel()
        this.MessagePanel()
        this.EvidencePanel()
        this.NextActionPanel()
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
      Text('智能体对话')
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .fontColor('#17201A')
    }
    .width('100%')
  }

  @Builder
  InputPanel() {
    Column({ space: 12 }) {
      Text('询问执行建议')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#17201A')
        .width('100%')
      TextInput({ text: this.prompt, placeholder: '询问风险、界面、任务、画像或演示' })
        .height(48)
        .fontSize(15)
        .fontColor('#17201A')
        .placeholderColor('#8B958D')
        .backgroundColor('#FFFFFF')
        .borderRadius(8)
        .padding({ left: 12, right: 12 })
        .onChange((value: string) => {
          this.prompt = value;
        })
      Button('询问知行')
        .height(42)
        .width('100%')
        .fontSize(14)
        .fontColor('#FFFFFF')
        .backgroundColor('#1F4E3A')
        .borderRadius(8)
        .onClick(() => {
          this.turn = ConversationService.reply(this.prompt);
        })
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#EEF2EA')
    .borderRadius(8)
    .border({ width: 1, color: '#D7DFD2' })
  }

  @Builder
  MessagePanel() {
    Column({ space: 12 }) {
      Text('对话记录')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#17201A')
        .width('100%')
      ForEach(this.turn.messages, (message: ChatMessage) => {
        Column({ space: 6 }) {
          Text(message.role)
            .fontSize(12)
            .fontWeight(FontWeight.Bold)
            .fontColor(message.role === '知行' ? '#1F4E3A' : '#8A5A12')
          Text(message.content)
            .fontSize(14)
            .fontColor('#17201A')
            .lineHeight(21)
            .width('100%')
        }
        .width('100%')
        .padding(12)
        .backgroundColor(message.role === '知行' ? '#FFFFFF' : '#F7EFD3')
        .borderRadius(8)
      }, (message: ChatMessage) => message.id)
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#EEF2EA')
    .borderRadius(8)
    .border({ width: 1, color: '#D7DFD2' })
  }

  @Builder
  EvidencePanel() {
    Column({ space: 12 }) {
      Text('检索依据')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#17201A')
        .width('100%')
      ForEach(this.turn.evidence, (hit: KnowledgeHit) => {
        Column({ space: 5 }) {
          Text(`${hit.title} (${Math.round(hit.score * 100)}%)`)
            .fontSize(14)
            .fontWeight(FontWeight.Medium)
            .fontColor('#17201A')
          Text(hit.excerpt)
            .fontSize(13)
            .fontColor('#5F6B61')
            .lineHeight(20)
        }
        .width('100%')
        .padding(12)
        .backgroundColor('#FFFFFF')
        .borderRadius(8)
      }, (hit: KnowledgeHit) => hit.title)
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#EEF2EA')
    .borderRadius(8)
    .border({ width: 1, color: '#D7DFD2' })
  }

  @Builder
  NextActionPanel() {
    Column({ space: 8 }) {
      Text('下一步动作')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#17201A')
        .width('100%')
      Text(this.turn.nextAction)
        .fontSize(14)
        .fontColor('#1F4E3A')
        .lineHeight(21)
        .width('100%')
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#EEF2EA')
    .borderRadius(8)
    .border({ width: 1, color: '#D7DFD2' })
  }
}
