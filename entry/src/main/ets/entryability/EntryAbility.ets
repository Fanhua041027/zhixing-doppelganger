import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { PersistentStoreService } from '../services/PersistentStoreService';

const DOMAIN = 0x0000;

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    try {
      this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
      PersistentStoreService.init(this.context);
    } catch (err) {
      hilog.error(DOMAIN, 'testTag', '设置颜色模式失败。原因：%{public}s', JSON.stringify(err));
    }
    hilog.info(DOMAIN, 'testTag', '%{public}s', '应用创建');
  }

  onDestroy(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', '应用销毁');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // 主窗口创建后加载首页。
    hilog.info(DOMAIN, 'testTag', '%{public}s', '窗口创建');

    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(DOMAIN, 'testTag', '加载首页失败。原因：%{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(DOMAIN, 'testTag', '首页加载成功。');
    });
  }

  onWindowStageDestroy(): void {
    // 主窗口销毁后释放界面相关资源。
    hilog.info(DOMAIN, 'testTag', '%{public}s', '窗口销毁');
  }

  onForeground(): void {
    // 应用进入前台。
    hilog.info(DOMAIN, 'testTag', '%{public}s', '应用进入前台');
  }

  onBackground(): void {
    // 应用进入后台。
    hilog.info(DOMAIN, 'testTag', '%{public}s', '应用进入后台');
  }
}
