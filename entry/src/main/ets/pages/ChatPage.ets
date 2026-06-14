import { router } from '@kit.ArkUI';
import { ChatMessage, ChatTurnResult, KnowledgeHit } from '../models/AgentModels';
import { ConversationService } from '../services/ConversationService';

const defaultChatTurn: ChatTurnResult = ConversationService.startConversation();

@Entry
@Component
struct ChatPage {
  @State prompt: string = 'How should I reduce demo risk?';
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
      Button('Back')
        .height(36)
        .fontSize(13)
        .fontColor('#1F4E3A')
        .backgroundColor('#E3EADF')
        .borderRadius(8)
        .onClick(() => router.back())
      Blank()
      Text('Agent Chat')
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .fontColor('#17201A')
    }
    .width('100%')
  }

  @Builder
  InputPanel() {
    Column({ space: 12 }) {
      Text('Ask for execution help')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#17201A')
        .width('100%')
      TextInput({ text: this.prompt, placeholder: 'Ask about risk, UI, task, profile, or demo' })
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
      Button('Ask Zhixing')
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
      Text('Conversation')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#17201A')
        .width('100%')
      ForEach(this.turn.messages, (message: ChatMessage) => {
        Column({ space: 6 }) {
          Text(message.role)
            .fontSize(12)
            .fontWeight(FontWeight.Bold)
            .fontColor(message.role === 'Zhixing' ? '#1F4E3A' : '#8A5A12')
          Text(message.content)
            .fontSize(14)
            .fontColor('#17201A')
            .lineHeight(21)
            .width('100%')
        }
        .width('100%')
        .padding(12)
        .backgroundColor(message.role === 'Zhixing' ? '#FFFFFF' : '#F7EFD3')
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
      Text('Retrieved evidence')
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
      Text('Next action')
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
