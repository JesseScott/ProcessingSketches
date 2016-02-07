// IMPORT
import ddf.minim.*;
import ddf.minim.analysis.*;

// DECLARATIONS
Minim minim;
AudioInput in;
BeatDetect beat;
BeatListener bl;
FFT fft;
FFT fftLin;
FFT fftLog;

// VARIABLES
float kickSize, snareSize, hatSize;

int volumeSens = 60;
int fftSens = 30;
int Sens = 25;          // Minim Sensitivity in Milliseconds
 int Avg = 1;           // Groups Frequency Bands = use 1, 2, 4, 8, 16, 32

// INIT
void initMinim() {
  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO,256);

  // Minim FFT
  fft = new FFT(in.bufferSize(), in.sampleRate()); // Fast Fourier Transform
  fftLog = new FFT(in.bufferSize(), in.sampleRate()); // Ditto
  fft.linAverages(Avg); // Groups Frequency Bands
  fftLog.logAverages(22, 3); // Low Freq and Octave Grouping

  // Minim Beat Detect
  beat = new BeatDetect(in.bufferSize(), in.sampleRate());
  beat.setSensitivity(300);  
  bl = new BeatListener(beat, in);
}

// ANALYZE
void analyzeMinim() {
  if ( beat.isKick() ) kickSize = 1;
  if ( beat.isSnare() ) snareSize = 1;
  if ( beat.isHat() ) hatSize = 1;
  kickSize = constrain(kickSize * 0.95, 0, 1);
  snareSize = constrain(snareSize * 0.95, 0, 1);
  hatSize = constrain(hatSize * 0.95, 0, 1);

  fft.forward(in.mix);
}

// STOP
void stop() {
  // always close Minim audio classes when you are finished with them
  in.close();
  // always stop Minim before exiting
  minim.stop();
  // this closes the sketch
  super.stop();
} // end stop()

// BeatListener
class BeatListener implements AudioListener {
  private BeatDetect beat;
  private AudioInput source;

  BeatListener(BeatDetect beat, AudioInput source) {
    this.source = source;
    this.source.addListener(this);
    this.beat = beat;
  }

  void samples(float[] samps) {
    beat.detect(source.mix);
  }

  void samples(float[] sampsL, float[] sampsR) {
    beat.detect(source.mix);
  }
}

