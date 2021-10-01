import { NativeModules } from 'react-native';

type ReactNativeCacheType = {
  init: () => void;
  getCachedData: (url: string) => Promise<string>;
};

const { ReactNativeCacheManager } = NativeModules;

const ReactNativeCache = {
  init: () => ReactNativeCacheManager.init(),
  getCachedData: (url: string) => ReactNativeCacheManager.getCachedData(url),
};

export default ReactNativeCache as ReactNativeCacheType;
