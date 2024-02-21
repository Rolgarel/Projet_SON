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
int pushed;

void setup() {
  AudioMemory(2);
  audioShield.enable();
  audioShield.volume(0.5);
  
  V = 10.0/1023.0;
  G = 0.4/1023.0;
  volume = 0;
  gain = 0;
  pushed = 0;
  
  rainSynth.setParamValue("freq", 6000);
  rainSynth.setParamValue("gain", gain);
  rainSynth.setParamValue("volume", volume);
}

void randomDrop() {
  rainSynth.setParamValue("damp", random(40, 60)*0.01);
  rainSynth.setParamValue("danp2", random(40, 60)*0.01);
  rainSynth.setParamValue("f", random(30, 50)*0.01);
  rainSynth.setParamValue("temps", random(50, 100)*0.01);
  rainSynth.setParamValue("f0", random(750, 1700));
  rainSynth.setParamValue("l_drop", random(1, 100)*0.01);
  rainSynth.setParamValue("r_drop", random(1, 100)*0.01);
}

void drop() {
  int r = random(0, 1000000);
  int gate = 25;
  if (r < gate) {
    randomDrop();
    rainSynth.setParamValue("drop", 1);
    delay(25);
    rainSynth.setParamValue("drop", 0);
    delay(50);
  }
}

void thunder() {
   rainSynth.setParamValue("l_bolt", random(30,100)*0.01);
   rainSynth.setParamValue("r_bolt", random(30,100)*0.01);
   rainSynth.setParamValue("rumble", 1);
   delay(25);
   rainSynth.setParamValue("rumble", 0);
   delay(25);
}

void loop() {
  volume = analogRead(A0)*V;
  rainSynth.setParamValue("volume", volume);
  gain = analogRead(A2)*G;
  rainSynth.setParamValue("gain", gain);

  drop();

  if ((pushed == 0) && digitalRead(0)) {
    pushed = 1;
    thunder();
  } else if (pushed == 1 && !digitalRead(0)) {
    pushed = 0;
  }
}
