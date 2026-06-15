export interface SystemActionResult {
  title: string;
  detail: string;
  available: boolean;
}

export class HarmonyIntentService {
  static createReviewReminder(goal: string): SystemActionResult {
    const result: SystemActionResult = {
      title: '复盘提醒已准备',
      detail: `已为“${goal}”准备提醒流转。下一步接入真实系统意图。`,
      available: false
    };
    return result;
  }

  static createCalendarDraft(goal: string): SystemActionResult {
    const result: SystemActionResult = {
      title: '日程草稿已准备',
      detail: `已为“${goal}”生成带时间、设备和任务信息的日程草稿。`,
      available: false
    };
    return result;
  }
}
