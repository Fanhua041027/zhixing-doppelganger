import { router } from '@kit.ArkUI';
import { ConflictNote, KnowledgeItem, MemoryItem, ProfileSignal, ReflectionItem } from '../models/AgentModels';
import { KnowledgeRepository } from '../repositories/KnowledgeRepository';
import { ProfileRepository } from '../repositories/ProfileRepository';
import { ExecutionService } from '../services/ExecutionService';

@Entry
@Component
struct ProfilePage {
  private signals: ProfileSignal[] = ProfileRepository.getProfileSignals();
  private memories: MemoryItem[] = ProfileRepository.getMemories();
  private knowledgeItems: KnowledgeItem[] = KnowledgeRepository.getKnowledgeItems();
  private conflicts: ConflictNote[] = KnowledgeRepository.getConflictNotes();
  private reflections: ReflectionItem[] = ExecutionService.getReflections();

  build() {
    Scroll() {
      Column({ space: 16 }) {
        this.TopBar()
        this.SignalPanel()
        this.ReflectionPanel()
        this.MemoryPanel()
        this.KnowledgePanel()
        this.ConflictPanel()
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
      Text('个人画像')
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .fontColor('#17201A')
    }
    .width('100%')
  }

  @Builder
  SignalPanel() {
    Column({ space: 12 }) {
      Text('分身信号')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#17201A')
        .width('100%')

      ForEach(this.signals, (signal: ProfileSignal) => {
        Column({ space: 5 }) {
          Text(signal.label)
            .fontSize(13)
            .fontColor('#667067')
          Text(signal.value)
            .fontSize(15)
            .fontColor('#17201A')
            .lineHeight(22)
        }
        .width('100%')
        .padding(12)
        .backgroundColor('#FFFFFF')
        .borderRadius(8)
      }, (signal: ProfileSignal) => signal.label)
    }
    .pagePanel()
  }

  @Builder
  ReflectionPanel() {
    Column({ space: 12 }) {
      Row() {
        Text('执行复盘')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#17201A')
        Blank()
        Text('动态沉淀')
          .fontSize(12)
          .fontColor('#1F4E3A')
          .padding({ left: 8, right: 8, top: 4, bottom: 4 })
          .backgroundColor('#DDEDDD')
          .borderRadius(6)
      }
      .width('100%')

      ForEach(this.reflections, (item: ReflectionItem) => {
        Column({ space: 6 }) {
          Row() {
            Text(item.title)
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .fontColor('#17201A')
            Blank()
            Text(item.createdAt)
              .fontSize(12)
              .fontColor('#8A5A12')
          }
          .width('100%')
          Text(item.insight)
            .fontSize(13)
            .fontColor('#5F6B61')
            .lineHeight(20)
            .width('100%')
          Text(item.action)
            .fontSize(13)
            .fontColor('#1F4E3A')
            .lineHeight(20)
            .width('100%')
        }
        .width('100%')
        .padding(12)
        .backgroundColor('#FFFFFF')
        .borderRadius(8)
      }, (item: ReflectionItem) => item.id)
    }
    .pagePanel()
  }

  @Builder
  MemoryPanel() {
    Column({ space: 12 }) {
      Text('记忆库')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#17201A')
        .width('100%')

      ForEach(this.memories, (memory: MemoryItem) => {
        Column({ space: 6 }) {
          Text(memory.title)
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor('#17201A')
          Text(memory.content)
            .fontSize(13)
            .fontColor('#5F6B61')
            .lineHeight(20)
          Text(memory.source)
            .fontSize(12)
            .fontColor('#8A5A12')
        }
        .width('100%')
        .padding(12)
        .backgroundColor('#FFFFFF')
        .borderRadius(8)
      }, (memory: MemoryItem) => memory.id)
    }
    .pagePanel()
  }

  @Builder
  KnowledgePanel() {
    Column({ space: 12 }) {
      Text('知识库')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#17201A')
        .width('100%')

      ForEach(this.knowledgeItems, (item: KnowledgeItem) => {
        Column({ space: 6 }) {
          Text(item.title)
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor('#17201A')
          Text(item.content)
            .fontSize(13)
            .fontColor('#5F6B61')
            .lineHeight(20)
          Text(formatKnowledgeTags(item.tags))
            .fontSize(12)
            .fontColor('#8A5A12')
        }
        .width('100%')
        .padding(12)
        .backgroundColor('#FFFFFF')
        .borderRadius(8)
      }, (item: KnowledgeItem) => item.id)
    }
    .pagePanel()
  }

  @Builder
  ConflictPanel() {
    Column({ space: 12 }) {
      Text('冲突记录')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#17201A')
        .width('100%')

      ForEach(this.conflicts, (note: ConflictNote) => {
        Column({ space: 6 }) {
          Text(note.topic)
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor('#17201A')
          Text(note.leftClaim)
            .conflictText()
          Text(note.rightClaim)
            .conflictText()
          Text(note.handling)
            .fontSize(13)
            .fontColor('#1F4E3A')
            .lineHeight(20)
        }
        .width('100%')
        .padding(12)
        .backgroundColor('#FFFFFF')
        .borderRadius(8)
      }, (note: ConflictNote) => note.id)
    }
    .pagePanel()
  }

}

function formatKnowledgeTags(tags: string[]): string {
  let value: string = '';
  tags.forEach((tag: string) => {
    if (value.length === 0) {
      value = tag;
    } else {
      value = `${value} / ${tag}`;
    }
  });
  return value;
}

@Extend(Text)
function conflictText() {
  .fontSize(13)
  .fontColor('#5F6B61')
  .lineHeight(20)
  .width('100%')
}

@Extend(Column)
function pagePanel() {
  .width('100%')
  .padding(16)
  .backgroundColor('#EEF2EA')
  .borderRadius(8)
}
