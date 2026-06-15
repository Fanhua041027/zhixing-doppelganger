import { AgentTask, ImportedResource, KnowledgeItem, ResourceSearchResult } from '../models/AgentModels';
import { LocalStore } from '../repositories/LocalStore';
import { KnowledgeRepository } from '../repositories/KnowledgeRepository';
import { PersistentStoreService } from './PersistentStoreService';

const RESOURCE_KEY: string = 'imported_resources';

export class ResourceLibraryService {
  static async importText(title: string, content: string): Promise<ImportedResource[]> {
    const normalizedTitle: string = title.trim().length > 0 ? title.trim() : '未命名资料';
    const normalizedContent: string = content.trim().length > 0 ? content.trim() : '暂无内容';
    const item: ImportedResource = {
      id: `resource-${normalizedTitle.length}-${normalizedContent.length}`,
      title: normalizedTitle,
      content: normalizedContent,
      source: '手动导入',
      createdAt: '刚刚'
    };
    const resources: ImportedResource[] = ResourceLibraryService.getResources();
    const nextResources: ImportedResource[] = [item];
    resources.forEach((resource: ImportedResource) => {
      if (resource.title !== item.title) {
        nextResources.push(resource);
      }
    });
    const limitedResources: ImportedResource[] = nextResources.slice(0, 8);
    LocalStore.saveResources(limitedResources);
    await PersistentStoreService.putString(RESOURCE_KEY, JSON.stringify(limitedResources));
    return limitedResources;
  }

  static getResources(): ImportedResource[] {
    const resources: ImportedResource[] = LocalStore.getResources();
    if (resources.length > 0) {
      return resources;
    }
    const fallback: ImportedResource[] = [
      {
        id: 'resource-demo',
        title: '竞赛演示资料',
        content: '作品需要优先展示输入目标、意图识别、任务执行、跨设备流转和复盘沉淀。',
        source: '内置资料',
        createdAt: '演示数据'
      }
    ];
    return fallback;
  }

  static search(query: string): ResourceSearchResult[] {
    const normalizedQuery: string = query.trim().length > 0 ? query.trim() : '演示';
    const resources: ImportedResource[] = ResourceLibraryService.getResources();
    const results: ResourceSearchResult[] = resources.map((item: ImportedResource): ResourceSearchResult => {
      const result: ResourceSearchResult = {
        id: item.id,
        title: item.title,
        excerpt: item.content,
        score: ResourceLibraryService.score(normalizedQuery, item.content)
      };
      return result;
    });
    return results.sort((left: ResourceSearchResult, right: ResourceSearchResult): number => right.score - left.score).slice(0, 5);
  }

  static toKnowledgeItems(): KnowledgeItem[] {
    const importedItems: ImportedResource[] = ResourceLibraryService.getResources();
    const items: KnowledgeItem[] = KnowledgeRepository.getKnowledgeItems();
    importedItems.forEach((resource: ImportedResource) => {
      const item: KnowledgeItem = {
        id: resource.id,
        title: resource.title,
        content: resource.content,
        tags: ['用户资料', '导入']
      };
      items.push(item);
    });
    return items;
  }

  static createTasksFromResource(resource: ImportedResource): AgentTask[] {
    const tasks: AgentTask[] = [
      {
        id: `resource-task-read-${resource.id}`,
        title: '提炼资料重点',
        detail: `阅读“${resource.title}”，整理三个最重要的概念或结论。`,
        device: '平板',
        time: '今天',
        status: '待执行',
        priority: '最高'
      },
      {
        id: `resource-task-card-${resource.id}`,
        title: '生成学习卡片',
        detail: '把资料内容转成可复述的学习卡片，并标注不理解的问题。',
        device: '手机',
        time: '30 分钟后',
        status: '待执行',
        priority: '重要'
      },
      {
        id: `resource-task-review-${resource.id}`,
        title: '安排资料复盘',
        detail: '复盘资料是否能支撑当前学习目标，必要时回到对话页追问。',
        device: '穿戴设备',
        time: '今晚',
        status: '待同步',
        priority: '重要'
      }
    ];
    return tasks;
  }

  private static score(query: string, content: string): number {
    let score: number = 0.5;
    if (content.includes(query)) {
      score += 0.35;
    }
    if (query.includes('演示') && content.includes('演示')) {
      score += 0.1;
    }
    if (query.includes('复盘') && content.includes('复盘')) {
      score += 0.1;
    }
    return Math.min(score, 0.96);
  }
}
