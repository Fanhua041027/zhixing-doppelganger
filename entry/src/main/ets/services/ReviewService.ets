import { ReviewPoint, RiskControlItem, SubmissionCheckItem } from '../models/AgentModels';

export class ReviewService {
  static getReviewPoints(): ReviewPoint[] {
    const points: ReviewPoint[] = [
      {
        id: 'review-innovation',
        title: '创新性',
        detail: '不是普通问答助手，而是把意图识别、任务拆解、个人画像和执行评测连成闭环。',
        scoreHint: '突出“会执行的个人分身”。'
      },
      {
        id: 'review-technical',
        title: '技术完整度',
        detail: '页面、模型、仓储、服务分层清晰，已预留检索增强、系统能力和持久化接口。',
        scoreHint: '证明不是单页演示，而是可扩展工程。'
      },
      {
        id: 'review-harmony',
        title: '鸿蒙特色',
        detail: '任务流显式区分手机、平板和穿戴设备角色，后续可接入跨设备流转。',
        scoreHint: '体现多端协同，而不是简单套壳。'
      },
      {
        id: 'review-value',
        title: '应用价值',
        detail: '聚焦高校学生的竞赛备赛、课程学习和项目推进，场景真实且容易演示。',
        scoreHint: '评委能快速理解刚需。'
      }
    ];
    return points;
  }

  static getSubmissionChecks(): SubmissionCheckItem[] {
    const items: SubmissionCheckItem[] = [
      {
        id: 'check-core',
        title: '核心闭环',
        detail: '目标输入、意图识别、任务拆解、依据展示和评测指标已形成可演示路径。',
        status: '已完成'
      },
      {
        id: 'check-harmony',
        title: '鸿蒙特色',
        detail: '首页和任务页都显式展示手机、平板、穿戴设备的协同分工。',
        status: '已完成'
      },
      {
        id: 'check-persona',
        title: '个人分身',
        detail: '画像、记忆、知识和冲突记录已结构化，后续可替换为真实个人数据。',
        status: '已完成'
      },
      {
        id: 'check-system',
        title: '系统能力',
        detail: '日程草稿和复盘提醒已封装在服务层，方便接入真实系统意图。',
        status: '可扩展'
      }
    ];
    return items;
  }

  static getRiskControls(): RiskControlItem[] {
    const items: RiskControlItem[] = [
      {
        id: 'risk-network',
        risk: '模型或网络接口不稳定',
        fallback: '主演示使用本地确定性智能体链路，保证离线也能展示完整流程。',
        owner: '演示稳定性'
      },
      {
        id: 'risk-device',
        risk: '现场多设备调试时间不足',
        fallback: '先用页面内跨设备流转图说明分工，再接入真实设备同步。',
        owner: '鸿蒙特色'
      },
      {
        id: 'risk-scope',
        risk: '功能范围过大导致主线分散',
        fallback: '答辩固定围绕“输入目标到执行卡片”讲解，不展开无关能力。',
        owner: '答辩节奏'
      }
    ];
    return items;
  }
}
