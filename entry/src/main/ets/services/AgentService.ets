import { AgentPlan, AgentTask, KnowledgeHit, KnowledgeItem } from '../models/AgentModels';
import { LocalStore } from '../repositories/LocalStore';
import { KnowledgeRepository } from '../repositories/KnowledgeRepository';

export class AgentService {
  static createPlan(goal: string): AgentPlan {
    const normalizedGoal = goal.trim().length > 0 ? goal.trim() : 'Build the HarmonyOS Agent MVP';
    const intent = AgentService.inferIntent(normalizedGoal);
    const hits = AgentService.retrieveKnowledge(normalizedGoal);

    const plan = {
      goal: normalizedGoal,
      intent,
      confidence: normalizedGoal.length > 12 ? 92 : 78,
      suggestion: AgentService.createSuggestion(intent, hits),
      tasks: AgentService.createTasks(normalizedGoal, intent),
      systemAction: AgentService.selectSystemAction(intent)
    };
    LocalStore.savePlan(plan);
    LocalStore.saveKnowledge(KnowledgeRepository.getKnowledgeItems());
    return plan;
  }

  private static inferIntent(goal: string): string {
    const lowerGoal = goal.toLowerCase();
    if (lowerGoal.includes('contest') || lowerGoal.includes('competition') || lowerGoal.includes('demo')) {
      return 'Competition execution';
    }
    if (lowerGoal.includes('exam') || lowerGoal.includes('review')) {
      return 'Review scheduling';
    }
    if (lowerGoal.includes('paper') || lowerGoal.includes('reading') || lowerGoal.includes('research')) {
      return 'Research digest';
    }
    return 'Learning execution';
  }

  private static createTasks(goal: string, intent: string): AgentTask[] {
    return [
      {
        id: 'task-define',
        title: 'Define the outcome',
        detail: `Clarify acceptance criteria for "${goal}" and keep the demo path narrow.`,
        device: 'Phone',
        time: 'Now',
        status: 'Active',
        priority: 'P0'
      },
      {
        id: 'task-plan',
        title: 'Build execution cards',
        detail: `Convert the ${intent.toLowerCase()} intent into tasks, checkpoints, and fallback steps.`,
        device: 'Tablet',
        time: '30 min',
        status: 'Queued',
        priority: 'P0'
      },
      {
        id: 'task-review',
        title: 'Schedule a review',
        detail: 'Trigger a recap after execution and feed the result back into the personal profile.',
        device: 'Wearable',
        time: 'Tonight',
        status: 'Pending sync',
        priority: 'P1'
      }
    ];
  }

  private static retrieveKnowledge(goal: string): KnowledgeHit[] {
    const lowerGoal = goal.toLowerCase();
    const items = KnowledgeRepository.getKnowledgeItems();
    const hits = items.map((item: KnowledgeItem) => {
      return {
        title: item.title,
        excerpt: item.content,
        score: AgentService.scoreKnowledge(lowerGoal, item)
      };
    });
    return hits.sort((left: KnowledgeHit, right: KnowledgeHit) => right.score - left.score).slice(0, 3);
  }

  private static createSuggestion(intent: string, hits: KnowledgeHit[]): string {
    const strongestHit = hits.length > 0 ? hits[0].excerpt : 'Keep the execution path explicit and measurable.';
    return `${intent}: ${strongestHit}`;
  }

  private static selectSystemAction(intent: string): string {
    if (intent === 'Competition execution') {
      return 'Calendar draft + review reminder';
    }
    if (intent === 'Review scheduling') {
      return 'Review reminder';
    }
    return 'Task handoff';
  }

  private static scoreKnowledge(goal: string, item: KnowledgeItem): number {
    let score = 0.62;
    item.tags.forEach((tag: string) => {
      if (goal.includes(tag)) {
        score += 0.12;
      }
    });
    if (goal.includes('contest') || goal.includes('demo')) {
      score += item.tags.includes('demo') ? 0.15 : 0.04;
    }
    return Math.min(score, 0.95);
  }
}
