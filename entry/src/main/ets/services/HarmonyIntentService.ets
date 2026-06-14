export interface SystemActionResult {
  title: string;
  detail: string;
  available: boolean;
}

export class HarmonyIntentService {
  static createReviewReminder(goal: string): SystemActionResult {
    return {
      title: 'Review reminder prepared',
      detail: `A reminder handoff is prepared for "${goal}". Real system intent wiring is the next milestone.`,
      available: false
    };
  }

  static createCalendarDraft(goal: string): SystemActionResult {
    return {
      title: 'Calendar draft prepared',
      detail: `A schedule draft is ready for "${goal}" with time, device, and task metadata.`,
      available: false
    };
  }
}
