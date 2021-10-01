import * as React from 'react';

import { StyleSheet, View, Text, TouchableOpacity } from 'react-native';
import ReactNativeCache from '@lowkey/react-native-cache';

import Video from 'react-native-video';

const URL =
  'https://file-examples-com.github.io/uploads/2017/04/file_example_MP4_1920_18MG.mp41';

export default function App() {
  const [url, setUrl] = React.useState<string | undefined>();
  const [showVideos, setShowVideos] = React.useState<boolean>(false);

  React.useEffect(() => {
    ReactNativeCache.init();
    console.log('Init');
    ReactNativeCache.getCachedData(URL)
      .then((a) => {
        console.log('Got: ', a);
        setUrl(a);
      })
      .catch((e) => console.log(e));
  }, []);
  return (
    <View style={styles.container}>
      <TouchableOpacity
        onPress={() => setShowVideos(!showVideos)}
        style={styles.button}
      >
        {showVideos ? <Text>Hide videos</Text> : <Text>Render videos</Text>}
      </TouchableOpacity>

      {showVideos && (
        <Video
          source={{
            uri: url,
            headers: {
              Range: 'bytes=0-2',
            },
          }}
          bufferConfig={{
            minBufferMs: 1,
            maxBufferMs: 10,
            bufferForPlaybackMs: 1,
            bufferForPlaybackAfterRebufferMs: 1,
          }}
          style={styles.backgroundVideo}
          muted
          automaticallyWaitsToMinimizeStalling={false}
          onError={(e) => console.log(e)}
        />
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
  backgroundVideo: {
    width: 400,
    height: 300,
    backgroundColor: 'red',
  },
  button: {
    paddingVertical: 15,
    paddingHorizontal: 20,
    backgroundColor: '#f1f1f1',
    borderRadius: 10,
    marginVertical: 20,
  },
});
