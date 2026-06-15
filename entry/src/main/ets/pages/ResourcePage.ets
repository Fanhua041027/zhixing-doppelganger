import { AgentTask, ImportedResource, ResourceSearchResult } from '../models/AgentModels';
import { ResourceLibraryService } from '../services/ResourceLibraryService';

const defaultResources: ImportedResource[] = ResourceLibraryService.getResources();
const defaultResults: ResourceSearchResult[] = ResourceLibraryService.search('演示');
const defaultResourceTasks: AgentTask[] = ResourceLibraryService.createTasksFromResource(defaultResources[0]);

@Entry
@Component
struct ResourcePage {
  @State title: string = '鸿蒙智能体资料';
  @State content: string = '把资料粘贴到这里，知行会把它加入本地资料库，并在对话检索中使用。';
  @State query: string = '演示';
  @State resources: ImportedResource[] = defaultResources;
  @State results: ResourceSearchResult[] = defaultResults;
  @State resourceTasks: AgentTask[] = defaultResourceTasks;
  @State importTip: string = '支持先用文本粘贴导入，后续可接入系统文件选择器。';

  build() {
    Scroll() {
      Column({ space: 16 }) {
        this.TopBar()
        this.ImportPanel()
        this.SearchPanel()
        this.GeneratedTaskPanel()
        this.ResourceList()
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
      Text('资料库')
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .fontColor('#17201A')
    }
    .width('100%')
  }

  @Builder
  ImportPanel() {
    Column({ space: 12 }) {
      Text('导入学习资料')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#17201A')
        .width('100%')
      TextInput({ text: this.title, placeholder: '资料标题' })
        .inputStyle()
        .onChange((value: string) => {
          this.title = value;
        })
      TextInput({ text: this.content, placeholder: '粘贴资料内容' })
        .height(88)
        .fontSize(14)
        .fontColor('#17201A')
        .placeholderColor('#8B958D')
        .backgroundColor('#FFFFFF')
        .borderRadius(8)
        .padding({ left: 12, right: 12 })
        .onChange((value: string) => {
          this.content = value;
        })
      Text(this.importTip)
        .fontSize(12)
        .fontColor('#8A5A12')
        .lineHeight(18)
        .width('100%')
      Button('加入资料库')
        .height(42)
        .width('100%')
        .fontSize(14)
        .fontColor('#FFFFFF')
        .backgroundColor('#1F4E3A')
        .borderRadius(8)
        .onClick(() => {
          ResourceLibraryService.importText(this.title, this.content).then((items: ImportedResource[]) => {
            this.resources = items;
            this.results = ResourceLibraryService.search(this.query);
            this.resourceTasks = ResourceLibraryService.createTasksFromResource(items[0]);
            this.importTip = '已导入，本地检索和对话依据会优先使用这份资料。';
          });
        })
    }
    .pagePanel()
  }

  @Builder
  GeneratedTaskPanel() {
    Column({ space: 12 }) {
      Row() {
        Text('资料生成任务')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#17201A')
        Blank()
        Text('可执行')
          .fontSize(12)
          .fontColor('#1F4E3A')
          .padding({ left: 8, right: 8, top: 4, bottom: 4 })
          .backgroundColor('#DDEDDD')
          .borderRadius(6)
      }
      .width('100%')
      ForEach(this.resourceTasks, (task: AgentTask) => {
        Column({ space: 6 }) {
          Row() {
            Text(task.title)
              .fontSize(15)
              .fontWeight(FontWeight.Medium)
              .fontColor('#17201A')
            Blank()
            Text(task.device)
              .fontSize(12)
              .fontColor('#8A5A12')
          }
          .width('100%')
          Text(task.detail)
            .fontSize(13)
            .fontColor('#5F6B61')
            .lineHeight(20)
            .width('100%')
          Text(`${task.priority} / ${task.time}`)
            .fontSize(12)
            .fontColor('#1F4E3A')
        }
        .width('100%')
        .padding(12)
        .backgroundColor('#FFFFFF')
        .borderRadius(8)
      }, (task: AgentTask) => task.id)
    }
    .pagePanel()
  }

  @Builder
  SearchPanel() {
    Column({ space: 12 }) {
      Text('资料检索')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#17201A')
        .width('100%')
      TextInput({ text: this.query, placeholder: '输入关键词' })
        .inputStyle()
        .onChange((value: string) => {
          this.query = value;
        })
      Button('检索资料')
        .height(40)
        .width('100%')
        .fontSize(14)
        .fontColor('#FFFFFF')
        .backgroundColor('#1F4E3A')
        .borderRadius(8)
        .onClick(() => {
          this.results = ResourceLibraryService.search(this.query);
        })
      ForEach(this.results, (item: ResourceSearchResult) => {
        Column({ space: 5 }) {
          Row() {
            Text(item.title)
              .fontSize(15)
              .fontWeight(FontWeight.Medium)
              .fontColor('#17201A')
            Blank()
            Text(`${Math.round(item.score * 100)}%`)
              .fontSize(12)
              .fontColor('#1F4E3A')
          }
          .width('100%')
          Text(item.excerpt)
            .fontSize(13)
            .fontColor('#5F6B61')
            .lineHeight(20)
            .width('100%')
        }
        .width('100%')
        .padding(12)
        .backgroundColor('#FFFFFF')
        .borderRadius(8)
      }, (item: ResourceSearchResult) => item.id)
    }
    .pagePanel()
  }

  @Builder
  ResourceList() {
    Column({ space: 12 }) {
      Text('已导入资料')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#17201A')
        .width('100%')
      ForEach(this.resources, (item: ImportedResource) => {
        Column({ space: 5 }) {
          Text(item.title)
            .fontSize(15)
            .fontWeight(FontWeight.Medium)
            .fontColor('#17201A')
          Text(item.source)
            .fontSize(12)
            .fontColor('#8A5A12')
          Text(item.content)
            .fontSize(13)
            .fontColor('#5F6B61')
            .lineHeight(20)
            .width('100%')
        }
        .width('100%')
        .padding(12)
        .backgroundColor('#FFFFFF')
        .borderRadius(8)
      }, (item: ImportedResource) => item.id)
    }
    .pagePanel()
  }
}

@Extend(TextInput)
function inputStyle() {
  .height(44)
  .fontSize(14)
  .fontColor('#17201A')
  .placeholderColor('#8B958D')
  .backgroundColor('#FFFFFF')
  .borderRadius(8)
  .padding({ left: 12, right: 12 })
}

@Extend(Column)
function pagePanel() {
  .width('100%')
  .padding(16)
  .backgroundColor('#EEF2EA')
  .borderRadius(8)
  .border({ width: 1, color: '#D7DFD2' })
}
