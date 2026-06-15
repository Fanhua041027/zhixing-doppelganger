import { ReviewPoint } from '../models/AgentModels';

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
        detail: '页面、模型、仓储、服务分层清晰，已预留 RAG、系统能力和持久化接口。',
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
}
