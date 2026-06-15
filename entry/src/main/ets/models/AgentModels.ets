export interface AgentTask {
  id: string;
  title: string;
  detail: string;
  device: string;
  time: string;
  status: string;
  priority: string;
}

export interface AgentPlan {
  goal: string;
  intent: string;
  confidence: number;
  suggestion: string;
  tasks: AgentTask[];
  systemAction: string;
}

export interface ProfileSignal {
  label: string;
  value: string;
}

export interface MemoryItem {
  id: string;
  title: string;
  content: string;
  source: string;
}

export interface KnowledgeHit {
  title: string;
  excerpt: string;
  score: number;
}

export interface KnowledgeItem {
  id: string;
  title: string;
  content: string;
  tags: string[];
}

export interface ConflictNote {
  id: string;
  topic: string;
  leftClaim: string;
  rightClaim: string;
  handling: string;
}

export interface ChatMessage {
  id: string;
  role: string;
  content: string;
}

export interface ChatTurnResult {
  messages: ChatMessage[];
  evidence: KnowledgeHit[];
  nextAction: string;
}

export interface ReviewPoint {
  id: string;
  title: string;
  detail: string;
  scoreHint: string;
}

export interface SubmissionCheckItem {
  id: string;
  title: string;
  detail: string;
  status: string;
}

export interface RiskControlItem {
  id: string;
  risk: string;
  fallback: string;
  owner: string;
}

export interface TaskHistoryItem {
  id: string;
  goal: string;
  intent: string;
  taskCount: number;
  deviceCount: number;
  createdAt: string;
}

export interface DemoModeState {
  title: string;
  goal: string;
  script: string;
  enabled: boolean;
}

export interface DeviceFlowStep {
  id: string;
  device: string;
  role: string;
  handoff: string;
  status: string;
}
