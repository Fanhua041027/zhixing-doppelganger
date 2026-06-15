import preferences from '@ohos.data.preferences';
import common from '@ohos.app.ability.common';

const STORE_NAME: string = 'zhixing_store';

export class PersistentStoreService {
  private static context: common.Context | null = null;

  static init(context: common.Context): void {
    PersistentStoreService.context = context;
  }

  static async putString(key: string, value: string): Promise<boolean> {
    if (PersistentStoreService.context === null) {
      return false;
    }
    try {
      const store = await preferences.getPreferences(PersistentStoreService.context, { name: STORE_NAME });
      await store.put(key, value);
      await store.flush();
      return true;
    } catch (error) {
      return false;
    }
  }

  static async getString(key: string, defaultValue: string): Promise<string> {
    if (PersistentStoreService.context === null) {
      return defaultValue;
    }
    try {
      const store = await preferences.getPreferences(PersistentStoreService.context, { name: STORE_NAME });
      const value = await store.get(key, defaultValue);
      if (typeof value === 'string') {
        return value;
      }
      return defaultValue;
    } catch (error) {
      return defaultValue;
    }
  }
}
