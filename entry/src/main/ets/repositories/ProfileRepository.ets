import { MemoryItem, ProfileSignal } from '../models/AgentModels';
import { LocalStore } from './LocalStore';

export class ProfileRepository {
  static getProfileSignals(): ProfileSignal[] {
    const signals: ProfileSignal[] = [
      { label: 'Execution style', value: 'Close the loop first, polish after proof.' },
      { label: 'Learning mode', value: 'Task cards, time boxes, and short reviews.' },
      { label: 'Risk control', value: 'Avoid relying on unstable APIs for the main demo.' },
      { label: 'Decision rule', value: 'Prefer visible progress over broad but thin scope.' }
    ];
    LocalStore.saveSignals(signals);
    return signals;
  }

  static getMemories(): MemoryItem[] {
    const memories: MemoryItem[] = [
      {
        id: 'memory-001',
        title: 'Competition strategy',
        content: 'The project should show Agent execution and HarmonyOS cross-device value in the first minute.',
        source: 'planning'
      },
      {
        id: 'memory-002',
        title: 'MVP boundary',
        content: 'Start with deterministic intent recognition and keep model integration behind a service boundary.',
        source: 'architecture'
      }
    ];
    LocalStore.saveMemories(memories);
    return memories;
  }
}
