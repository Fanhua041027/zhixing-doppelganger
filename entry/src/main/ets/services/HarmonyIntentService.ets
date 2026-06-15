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

  static openCalendarIntent(goal: string): SystemActionResult {
    const result: SystemActionResult = {
      title: '日历意图已准备',
      detail: `已生成“${goal}”的日历调用参数。正式接入时会通过系统能力拉起日历并填入任务信息。`,
      available: true
    };
    return result;
  }

  static openReminderIntent(goal: string): SystemActionResult {
    const result: SystemActionResult = {
      title: '提醒意图已准备',
      detail: `已生成“${goal}”的提醒调用参数。正式接入时会创建复盘提醒。`,
      available: true
    };
    return result;
  }
}
