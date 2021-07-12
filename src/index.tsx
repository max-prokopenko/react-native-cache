import { NativeModules } from 'react-native';

type ReactNativeCacheType = {
  multiply(a: number, b: number): Promise<number>;
};

const { ReactNativeCache } = NativeModules;

export default ReactNativeCache as ReactNativeCacheType;
