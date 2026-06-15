export interface AgentTask {
  id: string;
  title: string;
  detail: string;
  device: string;
  time: string;
  status: string;
  priority: string;
}

export interface ExecutionSnapshot {
  progress: number;
  stage: string;
  summary: string;
  nextStep: string;
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

export interface ReflectionItem {
  id: string;
  title: string;
  insight: string;
  action: string;
  createdAt: string;
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

export interface GoalTemplate {
  id: string;
  title: string;
  goal: string;
  scenario: string;
}

export interface StudyPreference {
  id: string;
  label: string;
  value: string;
}

export interface StudyPlanConfig {
  goal: string;
  deadline: string;
  dailyMinutes: string;
  weakPoint: string;
  preferredDevice: string;
}

export interface TodayAction {
  id: string;
  timeBox: string;
  title: string;
  detail: string;
  output: string;
}
