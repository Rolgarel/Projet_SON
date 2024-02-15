#include <Audio.h>
#include "RainSynth.h"

RainSynth rainSynth;
AudioOutputI2S out;
AudioControlSGTL5000 audioShield;
AudioConnection patchCord0(rainSynth, 0, out, 0);
AudioConnection patchCord1(rainSynth, 1, out, 1);

double V;
double G;
double volume;
double gain;

void setup() {
  AudioMemory(2);
  audioShield.enable();
  audioShield.volume(0.5);
  
  V = 5.0/1023.0;
  G = 0.4/1023.0;
  volume = 0;
  gain = 0;
  
  rainSynth.setParamValue("freq", 6000);
  rainSynth.setParamValue("gain", gain);
  rainSynth.setParamValue("volume", volume);
}

void drop() {
  int r = random(0, 1000000);
  int gate = 10;
  if (r < gate) {
    rainSynth.setParamValue("drop", 1);
    delay(25);
    rainSynth.setParamValue("drop", 0);
    delay(25);
  }
}

void loop() {
  volume = analogRead(A0)*V;
  rainSynth.setParamValue("volume", volume);
  gain = analogRead(A2)*G;
  rainSynth.setParamValue("gain", gain);

  drop();
}
